-- WatchChronos - initial database schema
-- Bu migration'i Supabase projende bir defaya mahsus çalıştır.

-- ============================================================
-- Enum tipleri
-- ============================================================

create type public.media_type as enum ('movie', 'tv');

create type public.watch_status as enum (
  'planned',
  'watching',
  'completed'
);

-- ============================================================
-- Ortak yardimci: updated_at kolonunu otomatik guncelleyen trigger
-- ============================================================

create or replace function public.set_updated_at()
returns trigger
language plpgsql
as $$
begin
  new.updated_at = now();
  return new;
end;
$$;

-- ============================================================
-- profiles: auth.users ile bire bir, uygulamaya özel kullanıcı bilgisi
-- ============================================================

create table public.profiles (
  id uuid primary key references auth.users (id) on delete cascade,
  username text unique,
  avatar_url text,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

alter table public.profiles enable row level security;

create policy "Profiles are viewable by owner"
  on public.profiles for select
  using (auth.uid() = id);

create policy "Profiles are insertable by owner"
  on public.profiles for insert
  with check (auth.uid() = id);

create policy "Profiles are updatable by owner"
  on public.profiles for update
  using (auth.uid() = id);

create trigger set_profiles_updated_at
  before update on public.profiles
  for each row
  execute function public.set_updated_at();

-- Yeni auth.users kaydı oluşturulduğunda otomatik profiles satırı aç
create or replace function public.handle_new_user()
returns trigger
language plpgsql
security definer
set search_path = public
as $$
begin
  insert into public.profiles (id)
  values (new.id);
  return new;
end;
$$;

create trigger on_auth_user_created
  after insert on auth.users
  for each row
  execute function public.handle_new_user();

-- ============================================================
-- watch_entries: kullanıcının bir film/dizi ile ilişkisi
-- (izleme durumu, favori, puan)
-- ============================================================

create table public.watch_entries (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references auth.users (id) on delete cascade,
  tmdb_id integer not null check (tmdb_id > 0),
  media_type public.media_type not null,
  status public.watch_status not null default 'planned',
  is_favorite boolean not null default false,
  rating numeric(3,1) check (rating between 0 and 10),
  notes text,
  started_at timestamptz,
  finished_at timestamptz,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  unique (user_id, tmdb_id, media_type)
);

create index watch_entries_user_id_idx on public.watch_entries (user_id);
create index watch_entries_user_status_idx on public.watch_entries (user_id, status);
create index watch_entries_user_favorite_idx
  on public.watch_entries (user_id, is_favorite)
  where is_favorite;

alter table public.watch_entries enable row level security;

create policy "Watch entries are viewable by owner"
  on public.watch_entries for select
  using (auth.uid() = user_id);

create policy "Watch entries are insertable by owner"
  on public.watch_entries for insert
  with check (auth.uid() = user_id);

create policy "Watch entries are updatable by owner"
  on public.watch_entries for update
  using (auth.uid() = user_id);

create policy "Watch entries are deletable by owner"
  on public.watch_entries for delete
  using (auth.uid() = user_id);

create trigger set_watch_entries_updated_at
  before update on public.watch_entries
  for each row
  execute function public.set_updated_at();

-- ============================================================
-- watch_logs: izleme geçmişi (ilk izleme + tekrar izlemeler)
-- ============================================================

create table public.watch_logs (
  id uuid primary key default gen_random_uuid(),
  watch_entry_id uuid not null references public.watch_entries (id) on delete cascade,
  user_id uuid not null references auth.users (id) on delete cascade,
  watched_at timestamptz not null default now(),
  created_at timestamptz not null default now()
);

create index watch_logs_user_id_idx on public.watch_logs (user_id);
create index watch_logs_watch_entry_id_idx on public.watch_logs (watch_entry_id);

alter table public.watch_logs enable row level security;

create policy "Watch logs are viewable by owner"
  on public.watch_logs for select
  using (auth.uid() = user_id);

create policy "Watch logs are insertable by owner"
  on public.watch_logs for insert
  with check (auth.uid() = user_id);

create policy "Watch logs are deletable by owner"
  on public.watch_logs for delete
  using (auth.uid() = user_id);

-- ============================================================
-- user_watch_stats: istatistik ekranı için hazır özet view
-- security_invoker: view'i çalıştıran kullanıcının RLS'ine tabi olur
-- ============================================================

create view public.user_watch_stats
with (security_invoker = true) as
select
  user_id,
  count(*) filter (where status = 'completed') as completed_count,
  count(*) filter (where status = 'completed' and media_type = 'movie') as completed_movies_count,
  count(*) filter (where status = 'completed' and media_type = 'tv') as completed_tv_count,
  count(*) filter (where status = 'watching') as watching_count,
  count(*) filter (where status = 'planned') as planned_count,
  count(*) filter (where is_favorite) as favorites_count,
  round(avg(rating) filter (where rating is not null), 1) as average_rating
from public.watch_entries
group by user_id;