-- WatchChronos - authenticated rolüne eksik tablo yetkilerini ver
-- Sebep: RLS politikaları var, ama tablo/view üzerinde temel GRANT hiç
-- verilmemiş. Postgres'te RLS, GRANT'in yerine geçmez; RLS "hangi
-- satırlara erişilebilir" sorusunu, GRANT ise "bu role tabloya erişebilir
-- mi" sorusunu cevaplar. GRANT olmadan RLS politikaları hiç devreye
-- girmeden "permission denied for table ..." (42501) hatası alınır.

grant usage on schema public to authenticated;

grant select, insert, update on public.profiles to authenticated;

grant select, insert, update, delete on public.watch_entries to authenticated;

grant select, insert, delete on public.watch_logs to authenticated;

grant select, insert, delete on public.episode_logs to authenticated;

grant select on public.user_watch_stats to authenticated;