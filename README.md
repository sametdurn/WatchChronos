# WatchChronos

Dizi ve film takip uygulaması. Flutter ile geliştirildi.
A TV show and movie tracking app built with Flutter.

---

## 🇹🇷 Türkçe

### Kurulum

Uygulama API anahtarlarını **kod içinde barındırmaz**. İlk açılışta karşınıza
bir kurulum ekranı çıkar ve gerekli bilgileri orada girersiniz; bu bilgiler
cihazınızda güvenli şekilde (Keychain/Keystore) saklanır. `.env` dosyasına
gerek yoktur.

#### 1. Supabase

1. [supabase.com](https://supabase.com) üzerinde ücretsiz bir hesap açın ve
   yeni bir proje oluşturun.
2. Proje ayarlarından **Project URL** ve **anon/public key** değerlerini
   alın (Project Settings → API).
3. Uygulamayı ilk açtığınızda "Bu Supabase projesi sıfırdan mı kuruluyor?"
   sorusuna **Evet** derseniz, gerekli veritabanı tablolarını otomatik
   oluşturabilmesi için ayrıca bir **Personal Access Token** (Supabase
   hesap ayarlarından oluşturulur) istenir. Tablolar zaten kuruluysa
   (örn. başka bir cihazda daha önce kurulum yaptıysanız) bu token'a
   gerek yoktur, sadece URL + anon key yeterlidir.

#### 2. TMDB

1. [themoviedb.org](https://www.themoviedb.org) üzerinde ücretsiz bir hesap
   açın.
2. Hesap ayarlarından API bölümüne gidip bir **API Read Access Token (v4
   auth)** oluşturun (kısa v3 `api_key` değil, uzun JWT formatındaki token).
3. Bu token'ı kurulum ekranındaki TMDB alanına girin.

#### 3. Uygulama

APK (Android) veya EXE (Windows) olarak dağıtılan hazır sürümü indirip
doğrudan çalıştırabilirsiniz. Uygulama açıldığında gerekli bilgiler kayıtlı
değilse otomatik olarak kurulum ekranını gösterir; yukarıdaki bilgileri
orada girmeniz yeterlidir.

> Kaynak koddan kendiniz derlemek isterseniz:
> ```bash
> flutter pub get
> flutter run
> ```

---

## 🇬🇧 English

### Setup

The app does **not** ship with any API keys baked in. On first launch you'll
see a setup screen where you enter the required credentials yourself; they
are stored securely on your device (Keychain/Keystore). No `.env` file is
needed.

#### 1. Supabase

1. Create a free account and a new project at
   [supabase.com](https://supabase.com).
2. Grab your **Project URL** and **anon/public key** from
   Project Settings → API.
3. On first launch, if you answer **Yes** to "Is this Supabase project being
   set up from scratch?", you'll also be asked for a **Personal Access
   Token** (created in your Supabase account settings) so the app can
   automatically create the required database tables. If the tables already
   exist (e.g. you've already set this up on another device), you don't
   need the token — just the URL + anon key.

#### 2. TMDB

1. Create a free account at [themoviedb.org](https://www.themoviedb.org).
2. In your account's API settings, generate an **API Read Access Token
   (v4 auth)** (the long JWT-style token, not the short v3 `api_key`).
3. Enter that token in the TMDB field on the setup screen.

#### 3. Running the app

You can download and run the prebuilt APK (Android) or EXE (Windows)
directly. On launch, if the required credentials aren't saved yet, the app
automatically shows the setup screen — just enter the details above there.

> To build from source instead:
> ```bash
> flutter pub get
> flutter run
> ```
