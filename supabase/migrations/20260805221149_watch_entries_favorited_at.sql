-- WatchChronos - favorilerin "en son favorilenen üstte" sıralanabilmesi
--
-- Sorun: Favoriler sekmesi/grid'i şimdiye kadar sıralama yapmıyordu (stream
-- ne sırada dönerse o sırada gösteriliyordu). Bunu düzeltmek için "ne zaman
-- favorilendi" bilgisi gerekiyor; ama var olan `updated_at` bu iş için
-- GÜVENİLİR DEĞİL çünkü favori dışında herhangi bir alan (rating, izlenen
-- bölüm, durum...) değiştiğinde de güncelleniyor. Bu yüzden ayrı, sadece
-- favori durumuna bağlı bir zaman damgası (`favorited_at`) ekleniyor.
--
-- Çözüm: `favorited_at` sütunu eklenir ve `is_favorite` FALSE'tan TRUE'ya
-- geçtiği her an (hem INSERT hem UPDATE'te) otomatik olarak `now()`'a
-- ayarlanır. Halihazırda TRUE olup değişmeyen satırlarda (ör. dizinin puanı
-- güncellendi ama favori zaten TRUE'ydu) `favorited_at` OLDUĞU GİBİ kalır —
-- sadece favori durumu değiştiğinde güncellenir, başka bir alan
-- değiştiğinde DEĞİL. Bunun DB seviyesinde (uygulama kodunda değil) tetik
-- olarak yapılmasının sebebi: `toggleFavorite`, içe aktarım (`restoreEntry`)
-- gibi is_favorite'i değiştirebilecek TÜM yollarda ayrı ayrı hatırlanması
-- gereken bir mantık olmaktan çıkıp, satırı her kim/hangi yoldan
-- güncellerse güncellesin garantili şekilde doğru çalışması.

alter table public.watch_entries
  add column favorited_at timestamptz;

create or replace function public.set_favorited_at()
returns trigger
language plpgsql
as $$
begin
  if new.is_favorite and not coalesce(old.is_favorite, false) then
    new.favorited_at = now();
  end if;
  return new;
end;
$$;

create trigger set_watch_entries_favorited_at
  before insert or update on public.watch_entries
  for each row
  execute function public.set_favorited_at();

-- Geriye dönük dolgu: migration çalıştığı anda zaten favori olan kayıtlar
-- için gerçek favorilenme anı bilinmiyor; en iyi yaklaşık değer olarak
-- `updated_at` kullanılır (yukarıdaki trigger bundan sonra sadece gerçek
-- favori geçişlerinde tetiklenir, bu tek seferlik bir dolgudur).
update public.watch_entries
set favorited_at = updated_at
where is_favorite and favorited_at is null;

create index watch_entries_user_favorited_at_idx
  on public.watch_entries (user_id, favorited_at desc)
  where is_favorite;
