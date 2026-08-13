-- WatchChronos - profiles için Realtime'i etkinleştir
-- Sebep: ProfileRepository.profileStream() `.stream()` kullanıyor; bu
-- Supabase Realtime'a (postgres_changes) dayanır. `profiles` tablosu
-- `supabase_realtime` publication'ına HİÇ eklenmemişti (sadece
-- `watch_entries` eklenmişti). Tablo publication'da olmadığından
-- Realtime kanalı sunucu tarafında düzgün "join" olamıyor; istemci de
-- bunu sürekli yeniden denemeye çalışıyor ve her deneme profil sayfasının
-- yeniden yüklenmesine/yenilenmesine yol açıyordu (özellikle uygulama
-- yeni build edilip ilk açıldığında belirgin).
--
-- "if not exists" kontrolü idempotent olması için: migration tekrar
-- çalıştırılırsa veya tablo zaten eklenmişse hata vermez.

do $$
begin
  if not exists (
    select 1
    from pg_publication_tables
    where pubname = 'supabase_realtime'
      and schemaname = 'public'
      and tablename = 'profiles'
  ) then
    alter publication supabase_realtime add table public.profiles;
  end if;
end $$;