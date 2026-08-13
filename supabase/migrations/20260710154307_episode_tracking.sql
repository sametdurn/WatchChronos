-- WatchChronos - episode-level takip
-- Bu migration'i Supabase projende bir defaya mahsus çalıştır.
-- Önceki migration'i (initial_schema) değiştirmez, üzerine ekler.

-- ============================================================
-- watch_entries: "kaldığın yer" için hızlı erişim kolonları
-- Sadece media_type = 'tv' olduğunda dolu olabilir.
-- ============================================================

alter table public.watch_entries
  add column current_season integer check (current_season > 0),
  add column current_episode integer check (current_episode > 0);

alter table public.watch_entries
  add constraint watch_entries_current_episode_requires_season
  check ((current_season is null) = (current_episode is null));

alter table public.watch_entries
  add constraint watch_entries_current_episode_only_for_tv
  check (media_type = 'tv' or (current_season is null and current_episode is null));

-- ============================================================
-- episode_logs: hangi bölümün ne zaman izlendiği
-- ============================================================

create table public.episode_logs (
  id uuid primary key default gen_random_uuid(),
  watch_entry_id uuid not null references public.watch_entries (id) on delete cascade,
  user_id uuid not null references auth.users (id) on delete cascade,
  season_number integer not null check (season_number > 0),
  episode_number integer not null check (episode_number > 0),
  watched_at timestamptz not null default now(),
  created_at timestamptz not null default now(),
  unique (watch_entry_id, season_number, episode_number)
);

create index episode_logs_user_id_idx on public.episode_logs (user_id);
create index episode_logs_watch_entry_id_idx on public.episode_logs (watch_entry_id);

alter table public.episode_logs enable row level security;

create policy "Episode logs are viewable by owner"
  on public.episode_logs for select
  using (auth.uid() = user_id);

create policy "Episode logs are insertable by owner"
  on public.episode_logs for insert
  with check (auth.uid() = user_id);

create policy "Episode logs are deletable by owner"
  on public.episode_logs for delete
  using (auth.uid() = user_id);

-- episode_logs sadece 'tv' türündeki watch_entries'e bağlanabilir
create or replace function public.validate_episode_watch_entry()
returns trigger
language plpgsql
as $$
declare
  entry_media_type public.media_type;
begin
  select media_type into entry_media_type
  from public.watch_entries
  where id = new.watch_entry_id;

  if entry_media_type is distinct from 'tv' then
    raise exception 'episode_logs sadece media_type = tv olan watch_entries için kullanılabilir';
  end if;

  return new;
end;
$$;

create trigger validate_episode_logs_watch_entry
  before insert or update on public.episode_logs
  for each row
  execute function public.validate_episode_watch_entry();

-- Yeni bölüm kaydı eklendiğinde watch_entries.current_season/current_episode
-- kolonlarını, görülen en ileri bölüme göre otomatik günceller.
create or replace function public.sync_current_episode()
returns trigger
language plpgsql
as $$
begin
  update public.watch_entries
  set
    current_season = new.season_number,
    current_episode = new.episode_number
  where id = new.watch_entry_id
    and (
      current_season is null
      or new.season_number > current_season
      or (new.season_number = current_season and new.episode_number > current_episode)
    );

  return new;
end;
$$;

create trigger sync_watch_entries_current_episode
  after insert on public.episode_logs
  for each row
  execute function public.sync_current_episode();

-- ============================================================
-- user_watch_stats: izlenen bölüm sayısını da içerecek şekilde genişlet
-- ============================================================

create or replace view public.user_watch_stats
with (security_invoker = true) as
select
  we.user_id,
  count(*) filter (where we.status = 'completed') as completed_count,
  count(*) filter (where we.status = 'completed' and we.media_type = 'movie') as completed_movies_count,
  count(*) filter (where we.status = 'completed' and we.media_type = 'tv') as completed_tv_count,
  count(*) filter (where we.status = 'watching') as watching_count,
  count(*) filter (where we.status = 'planned') as planned_count,
  count(*) filter (where we.is_favorite) as favorites_count,
  round(avg(we.rating) filter (where we.rating is not null), 1) as average_rating,
  (
    select count(*)
    from public.episode_logs el
    where el.user_id = we.user_id
  ) as episodes_watched_count
from public.watch_entries we
group by we.user_id;