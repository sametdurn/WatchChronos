-- WatchChronos - bölüm geri alma (unmark) düzeltmesi + otomatik durum geçişi
--
-- 1) Sorun: episode_logs'tan bir kayıt silindiğinde (bölüm izlenmedi olarak
--    işaretlendiğinde) watch_entries.current_season/current_episode hiç
--    güncellenmiyordu; "en son izlenen bölüm" bilgisi yanlışlıkla ileride
--    kalıyordu. Çözüm: silme sonrası kalan en ileri bölümü yeniden hesaplayan
--    bir trigger.
--
-- 2) Otomatik durum geçişi: Bir dizi kütüphaneye eklendiğinde varsayılan
--    durum "planned" (Henüz Başlanmadı). İlk bölüm izlendi olarak
--    işaretlenince (current_season ilk kez null'dan çıkınca) durum otomatik
--    "watching" (İzleniyor) yapılır. Tüm izlenen bölümler geri alınıp
--    current_season yeniden null'a dönerse, durum "watching" ise otomatik
--    "planned"a geri döner.

create or replace function public.sync_current_episode()
returns trigger
language plpgsql
as $$
begin
  update public.watch_entries
  set
    current_season = new.season_number,
    current_episode = new.episode_number,
    status = case
      when status = 'planned' then 'watching'
      else status
    end
  where id = new.watch_entry_id
    and (
      current_season is null
      or new.season_number > current_season
      or (new.season_number = current_season and new.episode_number > current_episode)
    );

  return new;
end;
$$;

create or replace function public.resync_current_episode_on_delete()
returns trigger
language plpgsql
as $$
declare
  latest_season integer;
  latest_episode integer;
begin
  select season_number, episode_number
  into latest_season, latest_episode
  from public.episode_logs
  where watch_entry_id = old.watch_entry_id
  order by season_number desc, episode_number desc
  limit 1;

  update public.watch_entries
  set
    current_season = latest_season,
    current_episode = latest_episode,
    status = case
      when latest_season is null and status = 'watching' then 'planned'
      else status
    end
  where id = old.watch_entry_id;

  return old;
end;
$$;

create trigger resync_watch_entries_current_episode
  after delete on public.episode_logs
  for each row
  execute function public.resync_current_episode_on_delete();