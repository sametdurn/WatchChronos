import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../../../core/config/env_config.dart';
import '../../../core/localization/app_localizations.dart';
import '../data/credentials_qr_codec.dart';

/// Bu cihazda kayıtlı TMDB/Supabase bağlantı bilgilerini QR kod olarak
/// gösterir. Başka bir cihazda "QR Kodu Tara" ile okutularak bilgiler
/// elle yazılmadan aktarılabilir (Ayarlar > Bağlantı).
///
/// QR, ekran her açıldığında EnvConfig'teki O ANKİ değerlerle yeniden
/// üretilir — canlı senkron DEĞİLDİR. Bir API anahtarı değiştirildiğinde
/// önceden alınmış bir ekran görüntüsü güncelliğini yitirir; güncel
/// bilgiyi almak için bu ekranın yeniden açılması gerekir.
class QrCredentialsScreen extends StatelessWidget {
  const QrCredentialsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final payload = CredentialsQrCodec.encode(
      supabaseUrl: EnvConfig.supabaseUrl,
      supabaseAnonKey: EnvConfig.supabaseAnonKey,
      tmdbApiKey: EnvConfig.tmdbApiKey,
    );

    return Scaffold(
      appBar: AppBar(title: Text(context.l10n.t('qr_show_title'))),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 420),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: QrImageView(
                        data: payload,
                        size: 240,
                        backgroundColor: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(
                        Icons.warning_amber_rounded,
                        color: Theme.of(context).colorScheme.error,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          context.l10n.t('qr_show_warning'),
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
