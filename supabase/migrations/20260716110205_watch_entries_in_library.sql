-- WatchChronos - kütüphaneden "yumuşak" kaldırma (soft-remove)
--
-- Sorun: "Kütüphaneden Kaldır" önceden watch_entries satırını TAMAMEN
-- siliyordu (episode_logs de `on delete cascade` ile birlikte gidiyordu).
-- Bu yüzden bir diziyi kütüphaneden kaldıran kullanıcı, o dizinin hangi
-- bölümlerini izlediği bilgisini de kaybediyordu.
--
-- Çözüm: satır silinmez, sadece `in_library = false` yapılır. Kütüphane
-- listeleri (Diziler/Filmler/Tamamlandı/Favoriler) artık sadece
-- `in_library = true` olan kayıtları gösterir; buna karşın Keşfet'ten
-- girilen içerik detayı (`getEntry`) bu bayraktan bağımsız çalışmaya devam
-- eder, böylece kaldırılmış bir kayda ait izlenen bölüm geçmişi hâlâ
-- görüntülenebilir.

alter table public.watch_entries
  add column in_library boolean not null default true;

create index watch_entries_user_in_library_idx
  on public.watch_entries (user_id, in_library);

-- user_watch_stats: kütüphane bileşimini yansıtan sayaçlar artık sadece
-- hâlâ kütüphanede olan kayıtları saymalı. `episodes_watched_count` ise
-- bilinçli olarak `in_library`'den bağımsız bırakıldı (kaldırılmış bir
-- dizinin geçmişte izlenen bölümleri toplam izlenen bölüm sayısından
-- düşülmemeli).
create or replace view public.user_watch_stats
with (security_invoker = true) as
select
  we.user_id,
  count(*) filter (where we.status = 'completed' and we.in_library) as completed_count,
  count(*) filter (
    where we.status = 'completed' and we.media_type = 'movie' and we.in_library
  ) as completed_movies_count,
  count(*) filter (
    where we.status = 'completed' and we.media_type = 'tv' and we.in_library
  ) as completed_tv_count,
  count(*) filter (where we.status = 'watching' and we.in_library) as watching_count,
  count(*) filter (where we.status = 'planned' and we.in_library) as planned_count,
  count(*) filter (where we.is_favorite and we.in_library) as favorites_count,
  round(
    avg(we.rating) filter (where we.rating is not null and we.in_library),
    1
  ) as average_rating,
  (
    select count(*)
    from public.episode_logs el
    where el.user_id = we.user_id
  ) as episodes_watched_count
from public.watch_entries we
group by we.user_id;
