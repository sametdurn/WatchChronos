import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

import '../../../core/localization/app_localizations.dart';
import '../data/credentials_qr_codec.dart';

/// Başka bir cihazda (örn. PC'de) "QR Kodu Göster" ile üretilen bağlantı
/// QR kodunu kamerayla okutmak için ekran.
///
/// Başarılı okumada `({supabaseUrl, supabaseAnonKey, tmdbApiKey})`
/// kaydını `Navigator.pop` ile döner; kullanıcı geri dönerse `null` döner.
class QrScanScreen extends StatefulWidget {
  const QrScanScreen({super.key});

  @override
  State<QrScanScreen> createState() => _QrScanScreenState();
}

class _QrScanScreenState extends State<QrScanScreen> {
  // Aynı karede birden fazla kez tetiklenip birden fazla pop çağrılmasını
  // (ve "Navigator.pop() called after dispose" hatasını) önlemek için.
  bool _handled = false;

  void _onDetect(BarcodeCapture capture) {
    if (_handled) return;
    if (capture.barcodes.isEmpty) return;

    final raw = capture.barcodes.first.rawValue;
    if (raw == null) return;

    final decoded = CredentialsQrCodec.decode(raw);
    if (decoded == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(context.l10n.t('qr_scan_invalid'))),
      );
      return;
    }

    _handled = true;
    Navigator.of(context).pop(decoded);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(context.l10n.t('qr_scan_title'))),
      body: MobileScanner(onDetect: _onDetect),
    );
  }
}
