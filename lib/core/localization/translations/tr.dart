/// Türkçe metinler (uygulamanın orijinal / varsayılan dili).
///
/// YENİ BİR DİL EKLERKEN: Bu dosyadaki TÜM anahtarları, aynı sırayla,
/// yeni dil dosyana (ör. `de.dart`) kopyala ve değerlerini çevir. Bir
/// anahtarı atlarsan sorun olmaz: `AppLocalizations.t()` eksik anahtarlar
/// için otomatik olarak bu Türkçe metne (fallback) düşer.
final Map<String, String> trTranslations = {
  // === common ===
  'common_cancel': 'Vazgeç',
  'common_save': 'Kaydet',
  'common_delete': 'Sil',
  'common_ok': 'Tamam',
  'common_retry': 'Tekrar Dene',
  'common_close': 'Kapat',
  'common_continue': 'Devam Et',
  'common_error_generic': 'Bir hata oluştu: {error}',
  'common_loading': 'Yükleniyor...',
  'common_unknown_error': 'Bilinmeyen bir hata oluştu.',

  // === setup / connection settings ===
  'setup_app_title': 'WatchChronos Kurulum',
  'setup_connection_title': 'Bağlantı Ayarları',
  'setup_headline': 'WatchChronos Kurulumu',
  'setup_body':
      'Devam etmek için TMDB ve Supabase bilgilerini gir. Bu bilgiler '
      'yalnızca bu cihazda güvenli şekilde saklanır.',
  'setup_field_required': 'Bu alan zorunludur',
  'setup_connection_updated':
      'Bağlantı bilgileri güncellendi. Değişikliklerin geçerli olması '
      'için uygulamayı yeniden başlatın.',
  'setup_start': 'Başla',
  'setup_error_invalid_tmdb_key': 'Geçersiz TMDB API anahtarı.',
  'setup_error_tmdb_unreachable':
      'TMDB sunucusuna ulaşılamadı. İnternet bağlantını kontrol et.',
  'setup_error_invalid_supabase_url':
      'Geçersiz Supabase URL. Örn: https://xxxxx.supabase.co',
  'setup_error_invalid_supabase_credentials':
      'Geçersiz Supabase URL veya Anon Key.',
  'setup_error_supabase_unreachable':
      'Supabase sunucusuna ulaşılamadı. URL\'yi kontrol et.',

  // === setup / QR ile bağlantı aktarımı ===
  'qr_scan_button': 'QR Kodu Tara',
  'qr_scan_title': 'QR Kodu Tara',
  'qr_scan_invalid': 'Geçersiz QR kodu. Lütfen tekrar deneyin.',
  'qr_show_title': 'QR Kodu Göster',
  'qr_show_warning':
      'Bu QR kod bağlantı bilgilerinizi (API anahtarları dahil) içerir. '
      'Yalnızca güvendiğiniz cihazlarla paylaşın.',
  'settings_qr_show_title': 'QR ile Aktar',
  'settings_qr_show_subtitle':
      'Bağlantı bilgilerini başka bir cihaza QR ile aktar',
  'settings_reset_connection_title': 'Bağlantı Bilgilerini Sıfırla',
  'settings_reset_connection_subtitle':
      'Supabase ve TMDB bilgilerini cihazdan siler, kurulum ekranına döner',
  'settings_reset_connection_confirm_title': 'Bağlantı bilgileri silinsin mi?',
  'settings_reset_connection_confirm_message':
      'Kayıtlı Supabase ve TMDB bağlantı bilgileri bu cihazdan silinecek ve '
      'kurulum ekranına döneceksiniz. Verileriniz Supabase\'de saklı kalır, '
      'sadece bu cihazdaki bağlantı bilgileri silinir.',
  'settings_reset_connection_confirm_action': 'Sil ve Sıfırla',

  // === setup / kurulum modu seçimi ===
  'setup_mode_headline': 'Nasıl kuruyorsun?',
  'setup_mode_body':
      'Bu, veritabanı tablolarının otomatik olarak oluşturulup '
      'oluşturulmayacağını belirler.',
  'setup_mode_first_time_title': 'İlk defa kuruyorum',
  'setup_mode_first_time_subtitle':
      'Yeni bir Supabase projem var, tablolar henüz oluşturulmadı. '
      'Bunları benim için otomatik oluştur.',
  'setup_mode_existing_title': 'Daha önce başka bir cihazda kurmuştum',
  'setup_mode_existing_subtitle':
      'Supabase projesi ve tablolar zaten hazır, sadece bu cihazı '
      'bağlamak istiyorum.',
  'setup_management_api_section_title': 'Veritabanı Kurulumu',
  'setup_management_api_section_body':
      'Tabloları otomatik oluşturmak için Supabase hesap ayarlarından '
      'üretilen bir "Personal Access Token" gerekir. Bu, proje anon '
      'anahtarından farklı ve çok daha yetkili bir anahtardır; hesabındaki '
      'TÜM projelere erişebilir. Bu token cihazına KAYDEDİLMEZ, sadece '
      'kurulum sırasında bir kerelik kullanılır.',
  'setup_running_migrations': 'Veritabanı hazırlanıyor...',
  'setup_error_no_migrations_found':
      'Uygulamaya gömülü migration dosyaları bulunamadı.',
  'setup_error_invalid_project_ref':
      'Supabase URL adresinden proje referansı çıkarılamadı. Kendi '
      'sunucunda barındırıyorsan (self-hosted), tabloları Supabase CLI '
      'ile elle oluşturman gerekir.',
  'setup_error_invalid_access_token':
      'Geçersiz Personal Access Token. Bunu Supabase hesap ayarlarındaki '
      '"Access Tokens" bölümünden oluşturabilirsin.',
  'setup_error_migration_failed':
      'Veritabanı tabloları oluşturulurken bir hata oluştu.',

  // === auth: common ===
  'common_email': 'E-posta',
  'common_password': 'Şifre',

  // === auth: login ===
  'login_subtitle': 'Film ve dizi takibine hoş geldin',
  'login_email_invalid': 'Geçerli bir e-posta gir',
  'login_password_too_short': 'Şifre en az 6 karakter olmalı',
  'login_submit': 'Giriş Yap',
  'login_forgot_password': 'Şifremi unuttum',
  'login_no_account': 'Hesabın yok mu? Kayıt ol',

  // === auth: register ===
  'register_title': 'Kayıt Ol',
  'register_headline': 'Yeni hesap oluştur',
  'register_username_label': 'Kullanıcı Adı',
  'register_username_helper':
      'Sadece profilinde görünür; bu adla giriş yapılamaz.',
  'register_username_too_short': 'Kullanıcı adı en az 3 karakter olmalı',
  'register_confirm_password_label': 'Şifre (tekrar)',
  'register_passwords_mismatch': 'Şifreler eşleşmiyor',
  'register_submit': 'Kayıt Ol',
  'register_success': 'Kayıt başarılı. E-postanı onaylayıp giriş yapabilirsin.',

  // === auth: forgot password ===
  'forgot_password_title': 'Şifremi Unuttum',
  'forgot_password_request_body':
      'Hesabına kayıtlı e-postayı gir, sana 6 haneli bir doğrulama kodu '
      'gönderelim.',
  'forgot_password_send_code': 'Kod Gönder',
  'forgot_password_reset_body':
      '{email} adresine bir kod gönderildi (eğer bu adresle bir hesap '
      'varsa). Kodu ve yeni şifreni gir.',
  'forgot_password_otp_label': 'Doğrulama Kodu',
  'forgot_password_new_password_label': 'Yeni Şifre',
  'forgot_password_confirm_password_label': 'Yeni Şifre (tekrar)',
  'forgot_password_reset_submit': 'Şifreyi Sıfırla',
  'forgot_password_change_email': 'Kodu almadım, e-postayı değiştir',
  'forgot_password_done_headline': 'Şifren güncellendi',
  'forgot_password_done_body': 'Artık yeni şifrenle giriş yapabilirsin.',
  'forgot_password_back_to_login': 'Girişe Dön',

  // === auth errors ===
  'auth_error_invalid_credentials': 'E-posta veya şifre hatalı.',
  'auth_error_already_registered': 'Bu e-posta adresi zaten kayıtlı.',
  'auth_error_email_not_confirmed': 'E-posta adresini onaylaman gerekiyor.',
  'auth_error_same_password': 'Yeni şifre, eski şifrenle aynı olamaz.',
  'auth_error_email_in_use':
      'Bu e-posta adresi başka bir hesap tarafından kullanılıyor.',
  'auth_error_token_expired':
      'Kod geçersiz veya süresi dolmuş. Yeni bir kod iste.',
  'auth_error_username_taken':
      'Bu kullanıcı adı zaten alınmış, başka bir tane dene.',
  'auth_error_unexpected': 'Beklenmeyen bir hata oluştu. Lütfen tekrar dene.',

  // === settings: change password ===
  'change_password_title': 'Şifre Değiştir',
  'change_password_success': 'Şifren başarıyla güncellendi.',
  'change_password_current_wrong': 'Mevcut şifren hatalı.',
  'change_password_current_label': 'Mevcut Şifre',
  'common_new_password': 'Yeni Şifre',
  'change_password_same_as_current': 'Yeni şifre, eski şifrenle aynı olamaz',
  'common_confirm_new_password': 'Yeni Şifre (tekrar)',
  'change_password_submit': 'Şifreyi Güncelle',

  // === settings: change email ===
  'change_email_title': 'E-posta Değiştir',
  'change_email_same_as_current': 'Yeni e-posta, mevcut e-postanla aynı olamaz.',
  'change_email_current_email': 'Mevcut e-posta: {email}',
  'change_email_body':
      'Yeni adrese bir onay bağlantısı göndereceğiz. Değişikliğin geçerli '
      'olması için hem şu anki e-postana hem de yeni adrese gelen '
      'bağlantılara tıklaman gerekiyor. İkisi de onaylanana kadar hesabın '
      'mevcut e-postayla kullanılmaya devam eder.',
  'change_email_new_label': 'Yeni E-posta',
  'change_email_send_link': 'Onay Bağlantısı Gönder',
  'change_email_sent_headline': 'Onay bağlantısı gönderildi',
  'change_email_sent_body':
      '{email} adresine bir onay bağlantısı gönderdik. Şu anki e-postana '
      'da bir onay bağlantısı gitti; değişikliğin geçerli olması için '
      'ikisine de tıklaman gerekiyor.',

  // === settings: main screen ===
  'settings_title': 'Ayarlar',
  'settings_section_general': 'Genel',
  'settings_language': 'Dil',
  'settings_language_dialog_title': 'Dil Seç',
  'settings_section_data': 'Veri',
  'settings_export_dialog_title': 'Verilerini Nereye Kaydetmek İstersin?',
  'settings_tv_time_import_title': 'TV Time Verilerini Aktar',
  'settings_tv_time_import_subtitle':
      'İzleme listeni, izlediklerini ve izlediğin bölümleri TV Time GDPR '
      'ZIP\'inden aktar',
  'settings_export_title': 'Verilerimi Dışa Aktar',
  'settings_export_subtitle':
      'İzleme durumu, favoriler, puanlar ve tam bölüm geçmişini tek bir '
      'JSON dosyasına kaydet',
  'settings_export_success': 'Verilerin başarıyla dışa aktarıldı.',
  'settings_export_error': 'Dışa aktarım sırasında bir hata oluştu: {error}',
  'settings_import_title': 'Verilerimi İçe Aktar',
  'settings_import_subtitle':
      'Daha önce dışa aktardığın WatchChronos .json dosyasını geri yükle',
  'settings_section_connection': 'Bağlantı',
  'settings_connection_title': 'TMDB / Supabase Bilgileri',
  'settings_connection_subtitle': 'API anahtarlarını görüntüle veya güncelle',
  'settings_section_account': 'Hesap',
  'settings_change_email_subtitle':
      'Onay için hem eski hem yeni e-postana bağlantı gönderilir',
  'settings_sign_out': 'Çıkış Yap',
  'settings_sign_out_confirm': 'Hesabından çıkış yapmak istediğine emin misin?',

  // === settings: watchchronos import ===
  'watchchronos_import_intro':
      'Daha önce "Verilerimi Dışa Aktar" ile oluşturduğun WatchChronos '
      '.json dosyasını seç; izleme durumun, favorilerin, puanların, '
      'notların ve tam bölüm geçmişin bu hesaba geri yüklensin.',
  'watchchronos_import_notes':
      'Bilinmesi gerekenler:\n'
      '• Bu içe aktarım SADECE WatchChronos\'un kendi export dosyasını '
      'okur (TV Time ZIP\'i için ayrı bir seçenek var).\n'
      '• Her kayıt kendi TMDB kimliğiyle geldiğinden belirsiz eşleşme ya '
      'da manuel seçim adımı yoktur; dosyadaki her kayıt birebir geri '
      'yüklenir.\n'
      '• Aynı içerik hesapta zaten varsa üzerine yazılır (mevcut durum/'
      'puan/not dosyadakiyle değiştirilir); aynı dosyayı tekrar içe '
      'aktarmak güvenlidir, veri tekrarlanmaz.',
  'watchchronos_import_pick_button':
      'WatchChronos JSON Dosyasını Seç ve İçe Aktar',
  'watchchronos_import_error_file_read': 'Dosya okunamadı, lütfen tekrar dene.',
  'watchchronos_import_status_reading': 'Dosya okunuyor...',
  'watchchronos_import_status_starting': 'Geri yükleme başlıyor...',
  'watchchronos_import_error_generic':
      'Geri yükleme sırasında bir hata oluştu: {error}',
  'watchchronos_import_total_found': 'Toplam {count} kayıt bulundu',
  'watchchronos_import_restored_entries': 'Geri yüklenen kayıt: {count}',
  'watchchronos_import_restored_episode_logs':
      'Geri yüklenen bölüm izleme kaydı: {count}',
  'watchchronos_import_failed_entries': 'Geri yüklenemeyenler ({count}):',
  'watchchronos_import_error_unreadable':
      'Dosya okunamadı; bu bir WatchChronos export (.json) dosyası '
      'olmayabilir.\nHata: {error}',
  'watchchronos_import_error_bad_format':
      'Dosya beklenen WatchChronos export formatında değil.',
  'watchchronos_import_error_missing_entries':
      'Dosyada "entries" alanı bulunamadı; bu bir WatchChronos export '
      'dosyası değil.',
  'watchchronos_import_error_parse_failed':
      'Dosya ayrıştırılamadı; içeriği bozuk olabilir.\nHata: {error}',
  'watchchronos_import_progress_restoring': 'Geri yükleniyor: TMDB #{tmdbId}',

  // === settings: tv time import progress ===
  'tv_time_progress_matching_show': 'Dizi eşleştiriliyor: {name}',
  'tv_time_progress_matching_movie': 'Film eşleştiriliyor: {name}',
  'tv_time_import_intro':
      'TV Time\'ın gdpr.tvtime.com adresinden indirdiğin veri ZIP dosyasını '
      'seç; izleme listeni, izlediğin dizi/filmleri ve izlediğin bölümleri '
      'WatchChronos\'a aktaralım.',
  'tv_time_import_notes':
      'Bilinmesi gerekenler:\n'
      '• TV Time\'da yıldızlı/numaralı bir puanlama sistemi yoktu (sadece '
      'beğeni-tepki vardı), bu yüzden puan aktarılmaz.\n'
      '• İzleme durumu, favori, izleme listesi, arşiv durumu, kaldığın '
      'sezon/bölüm ve bölüm geçmişi aktarılır. Yeniden izleme sayısı bir '
      'not olarak eklenir (WatchChronos\'ta ayrı bir alanı yok).\n'
      '• TV Time export\'u her dizi için bölüm bölüm tarihçe içermez; bazı '
      'diziler için sadece toplam izlenen bölüm sayısı bulunur. Bu diziler '
      'için TMDB\'deki sıraya göre ilk N bölüm izlendi olarak işaretlenir '
      '(yaklaşık aktarım).\n'
      '• Diziler/filmler başlık, orijinal başlık, yayın yılı ve (gerekirse) '
      'sezon/bölüm sayısı birlikte değerlendirilerek TMDB\'de eşleştirilir. '
      'Birden fazla güçlü aday çıkarsa otomatik seçim yapılmaz; aktarım '
      'sonunda senden seçim istenir.',
  'tv_time_import_pick_button': 'TV Time ZIP Dosyasını Seç ve Aktar',
  'tv_time_import_error_file_read': 'Dosya okunamadı, lütfen tekrar dene.',
  'tv_time_import_status_parsing': 'ZIP dosyası okunuyor...',
  'tv_time_import_status_starting': 'Aktarım başlıyor...',
  'tv_time_import_error_generic':
      'Aktarım sırasında bir hata oluştu: {error}',
  'tv_time_import_done_with_pending':
      'Aktarım tamamlandı, birkaç kayıt seni bekliyor',
  'tv_time_import_done': 'Aktarım tamamlandı',
  'tv_time_import_found_stats':
      'TV Time\'da bulunan: {shows} dizi ({followed} işlenmeye aday), '
      '{movies} film',
  'tv_time_import_matched_shows': 'Eşleşen dizi: {count}',
  'tv_time_import_matched_movies': 'Eşleşen film: {count}',
  'tv_time_import_exact_shows': 'Tam bölüm geçmişiyle aktarılan dizi: {count}',
  'tv_time_import_approx_shows':
      'Toplam sayıya göre yaklaşık aktarılan dizi: {count}',
  'tv_time_import_choose_candidate':
      'Birden fazla güçlü aday bulundu, hangisi doğruysa seç:',
  'tv_time_import_type_show': 'dizi',
  'tv_time_import_type_movie': 'film',
  'tv_time_import_subtitle_with_year': '({year}) • {type}',
  'tv_time_import_unmatched_shows': 'Eşleşmeyen diziler ({count}):',
  'tv_time_import_unmatched_movies': 'Eşleşmeyen filmler ({count}):',
  'tv_time_import_resolve_first': 'Önce yukarıdakileri çöz',
  'tv_time_import_auto_pick': 'Oto seç (en olası)',
  'tv_time_import_skip': 'Hiçbiri / atla',
  'tv_time_import_release_date_unknown': 'Yayın tarihi bilinmiyor',
  'month_1': 'Ocak',
  'month_2': 'Şubat',
  'month_3': 'Mart',
  'month_4': 'Nisan',
  'month_5': 'Mayıs',
  'month_6': 'Haziran',
  'month_7': 'Temmuz',
  'month_8': 'Ağustos',
  'month_9': 'Eylül',
  'month_10': 'Ekim',
  'month_11': 'Kasım',
  'month_12': 'Aralık',

  // === navigation ===
  'nav_library': 'Kütüphanem',
  'nav_discover': 'Keşfet',
  'nav_profile': 'Profil',

  // === library ===
  'library_tab_shows': 'Diziler',
  'library_tab_movies': 'Filmler',
  'library_tab_completed': 'Tamamlandı',
  'library_tab_upcoming': 'Yaklaşanlar',
  'library_tab_favorites': 'Favoriler',
  'library_no_shows': 'Henüz bir dizi eklemedin. Keşfet sekmesinden ara.',
  'library_no_ongoing_shows':
      'Devam eden bir dizin yok. Tamamlanan diziler Tamamlandı sekmesinde.',
  'library_section_watching': 'İzleniyor',
  'library_section_upcoming': 'Devamı Gelecek',
  'library_section_not_started': 'Henüz Başlanmadı',
  'library_no_movies': 'Henüz bir film eklemedin. Keşfet sekmesinden ara.',
  'library_no_upcoming':
      'Henüz çıkmamış, takip ettiğin bir dizi ya da film yok.',
  'library_upcoming_shows_title': 'Yaklaşan Diziler',
  'library_upcoming_movies_title': 'Yaklaşan Filmler',
  'library_no_completed': 'Henüz tamamladığın bir şey yok.',
  'library_completed_shows_title': 'Tamamlanan Diziler',
  'library_completed_movies_title': 'Tamamlanan Filmler',
  'library_no_favorites': 'Henüz favori eklemedin.',
  'library_favorite_shows_title': 'Favori Diziler',
  'library_favorite_movies_title': 'Favori Filmler',
  'common_something_went_wrong': 'Bir şeyler ters gitti.',
  'common_load_failed_retry': 'Yüklenemedi. Tekrar dene.',

  // === tv show lifecycle badges ===
  'tv_lifecycle_returning_series': 'Devam Ediyor',
  'tv_lifecycle_in_production': 'Yapımda',
  'tv_lifecycle_planned': 'Planlanıyor',
  'tv_lifecycle_pilot': 'Pilot Aşamasında',
  'tv_lifecycle_ended': 'Final Yaptı',
  'tv_lifecycle_canceled': 'İptal Edildi',

  // === watch entry card ===
  'watch_entry_card_upcoming_badge': 'Devamı Gelecek',
  'watch_entry_card_all_episodes_watched': 'Tüm bölümler izlendi',
  'watch_entry_card_mark_watched_tooltip': 'Bölümü izledim',
  'watch_entry_card_mark_watched_failed':
      'Bölüm izlendi olarak işaretlenemedi.',

  // === discover ===
  'discover_search_hint': 'Film veya dizi ara...',
  'discover_trending_shows': 'Gündemdeki Diziler',
  'discover_trending_movies': 'Gündemdeki Filmler',
  'discover_search_failed': 'Arama başarısız oldu.',
  'discover_no_results': 'Sonuç bulunamadı',

  // === api errors ===
  'api_error_network': 'İnternet bağlantınızı kontrol edin.',
  'api_error_timeout': 'Sunucudan yanıt alınamadı, lütfen tekrar deneyin.',
  'api_error_not_found': 'İçerik bulunamadı.',
  'api_error_server': 'Sunucu hatası oluştu.',
  'api_error_unknown': 'Beklenmeyen bir hata oluştu.',
  'api_error_cancelled': 'İstek iptal edildi.',

  // === discover: trending grid ===
  'discover_no_content': 'Gösterilecek içerik bulunamadı.',
  'common_loading_ellipsis': 'Yükleniyor…',
  'common_minutes_short': '{count} dk',
  'common_one_season': '1 sezon',
  'common_n_seasons': '{count} sezon',

  // === common media type labels ===
  'common_media_type_movie': 'Film',
  'common_media_type_show': 'Dizi',
  'discover_upcoming_label': 'Yakında',

  // === episode tracking ===
  'episode_tracking_title': 'Bölüm Takibi',
  'episode_tracking_init_error': 'Bölüm bilgileri yüklenemedi.',
  'episode_tracking_season_load_error': 'Sezon yüklenemedi.',
  'episode_tracking_action_failed': 'İşlem başarısız oldu.',
  'episode_tracking_season_complete_error': 'Sezon tamamlanamadı.',
  'episode_tracking_season_reset_error': 'Sezon sıfırlanamadı.',
  'episode_tracking_season_switched': 'Sezon {season}\'e geçildi.',
  'episode_tracking_tv_only':
      'Bölüm takibi sadece diziler için kullanılabilir.',
  'common_go_back': 'Geri Dön',
  'episode_tracking_complete_season': 'Sezonu tamamla',
  'episode_tracking_reset_season': 'Sezonu izlenmedi olarak işaretle',
  'episode_tile_default_title': '{number}. Bölüm',
  'season_selector_label': 'Sezon {number}',

  // === watch entry errors ===
  'watch_entry_error_episode_logs_tv_only':
      'Bölüm takibi sadece dizi türündeki içerikler için kullanılabilir.',
  'watch_entry_error_already_exists': 'Bu kayıt zaten mevcut.',
  'watch_entry_error_value_out_of_range':
      'Girilen değer izin verilen aralığın dışında.',

  // === media detail screen ===
  'media_detail_rating_warning_movie':
      'Puan verebilmek için önce filmi izledim olarak işaretlemelisin.',
  'media_detail_rating_warning_tv':
      'Puan verebilmek için en az 1 bölümü izlendi olarak işaretlemelisin.',
  'media_detail_error_add_failed': 'Kütüphaneye eklenemedi.',
  'media_detail_error_status_update_failed': 'Durum güncellenemedi.',
  'media_detail_error_remove_failed': 'Kütüphaneden kaldırılamadı.',
  'media_detail_error_favorite_failed': 'Favori durumu güncellenemedi.',
  'media_detail_error_rating_failed': 'Puan kaydedilemedi.',
  'media_detail_error_no_session': 'Oturum bulunamadı. Lütfen tekrar giriş yap.',
  'media_detail_load_failed': 'İçerik yüklenemedi.',
  'media_detail_favorite': 'Favori',
  'media_detail_your_rating': 'Puanın',
  'media_detail_disabled_hint_movie':
      'Puan verebilmek için önce izledim olarak işaretle.',
  'media_detail_disabled_hint_tv':
      'Puan verebilmek için en az 1 bölümü izlendi olarak işaretle.',
  'media_detail_add_to_library': 'Kütüphaneme Ekle',
  'media_detail_re_add_to_library': 'Kütüphaneye Tekrar Ekle',
  'media_detail_view_watched_episodes': 'İzlenen Bölümlere Bak',
  'media_detail_watched': 'İzledim',
  'media_detail_mark_watched': 'İzledim olarak işaretle',
  'media_detail_remove_from_library': 'Kütüphaneden Kaldır',
  'media_detail_manage_episodes': 'Bölümleri Yönet',
  'media_detail_mark_completed': 'Tamamlandı olarak işaretle',
  'media_detail_watch_trailer': 'Fragmanı İzle',
  'media_detail_more_info': 'Daha Fazla Bilgi',
  'media_detail_cast': 'Oyuncular',
  'media_detail_error_trailer_open_failed': 'Fragman açılamadı.',
  'media_detail_error_tmdb_open_failed': 'TMDB sayfası açılamadı.',

  // === rating input ===
  'rating_input_remove_rating': 'Puanı Geri Al',
  'rating_input_not_rated_yet': 'Henüz puanlamadın',
  'rating_input_stars_out_of_5': '{count} / 5',

  // === profile screen ===
  'profile_error_photo_read_failed': 'Fotoğraf okunamadı.',
  'profile_error_photo_upload_failed': 'Fotoğraf yüklenemedi.',
  'profile_edit_username_title': 'Kullanıcı Adını Değiştir',
  'profile_error_username_update_failed': 'Kullanıcı adı güncellenemedi.',
  'profile_load_failed': 'Profil yüklenemedi.',
  'profile_unnamed_user': 'İsimsiz Kullanıcı',
  'profile_your_stats': 'İstatistiklerin',
  'profile_stats_load_failed': 'İstatistikler yüklenemedi.',
  'profile_stat_completed_shows': 'Tamamlanan Dizi',
  'profile_stat_completed_movies': 'Tamamlanan Film',
  'profile_stat_planned': 'Planlanan',
  'profile_stat_episodes_watched': 'İzlenen Bölüm',
  'profile_stat_average_rating': 'Ortalama Puan',

  // === tv time zip parse errors ===
  'tv_time_parse_error_empty_file':
      'Seçilen dosya boş görünüyor (0 bayt). Dosya seçiciden ZIP verisi '
      'okunamadı; lütfen dosyayı tekrar seçmeyi dene.',
  'tv_time_parse_error_empty_zip':
      'ZIP açıldı ama içinde hiç dosya bulunamadı (seçilen dosya {bytes} '
      'bayt). Bu genelde dosyanın indirilirken bozulduğu ya da seçilen '
      'dosyanın gerçek TV Time ZIP\'i olmadığı anlamına gelir.',
  'tv_time_parse_error_missing_files':
      'ZIP içinde beklenen dosya(lar) bulunamadı: {missing}.\n'
      'ZIP içinde bulunan {count} dosyadan bazıları: {sample}',
  'tv_time_parse_error_no_records':
      'Gerekli CSV dosyaları ZIP içinde bulundu ama içlerinden hiç kayıt '
      'okunamadı. Dosya formatı beklenenden farklı olabilir (örn. sütun '
      'başlıkları değişmiş olabilir).',
};
