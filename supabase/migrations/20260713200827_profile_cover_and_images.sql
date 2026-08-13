-- WatchChronos - profil sayfası: kapak fotoğrafı alanı, kayıt sırasında
-- seçilen kullanıcı adının doğrudan kaydedilmesi ve avatar/kapak
-- fotoğrafları için storage bucket.

alter table public.profiles
  add column if not exists cover_url text;

create or replace function public.handle_new_user()
returns trigger
language plpgsql
security definer
set search_path = public
as $$
begin
  insert into public.profiles (id, username)
  values (new.id, new.raw_user_meta_data ->> 'username');
  return new;
end;
$$;

insert into storage.buckets (id, name, public)
values ('profile-images', 'profile-images', true)
on conflict (id) do nothing;

create policy "Profile images are publicly readable"
  on storage.objects for select
  using (bucket_id = 'profile-images');

create policy "Users can upload their own profile images"
  on storage.objects for insert
  with check (
    bucket_id = 'profile-images'
    and (storage.foldername(name))[1] = auth.uid()::text
  );

create policy "Users can update their own profile images"
  on storage.objects for update
  using (
    bucket_id = 'profile-images'
    and (storage.foldername(name))[1] = auth.uid()::text
  );

create policy "Users can delete their own profile images"
  on storage.objects for delete
  using (
    bucket_id = 'profile-images'
    and (storage.foldername(name))[1] = auth.uid()::text
  );