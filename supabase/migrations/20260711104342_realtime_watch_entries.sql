-- WatchChronos - watch_entries için Realtime'i etkinleştir
-- Sebep: WatchEntriesRepository.watchEntriesByStatus/favoriteEntries
-- `.stream()` kullanıyor; bu Supabase Realtime'a (postgres_changes)
-- dayanır. Tablo `supabase_realtime` publication'ına eklenmeden bu stream
-- sadece ilk anlık veriyi çeker, sonraki değişiklikleri (örn. bir bölüm
-- izlendi işaretlenince current_season/current_episode güncellemesi)
-- otomatik yansıtmaz.
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
      and tablename = 'watch_entries'
  ) then
    alter publication supabase_realtime add table public.watch_entries;
  end if;
end $$;