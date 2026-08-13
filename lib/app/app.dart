import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:window_manager/window_manager.dart';

import '../core/localization/app_locale.dart';
import '../core/localization/app_localizations.dart';
import '../core/localization/locale_controller.dart';
import '../core/theme/app_theme.dart';
import 'router/app_router.dart';

/// Masaüstü (Windows/Linux/macOS) mü çalışıyoruz; F11 tam ekran kısayolu
/// ve `window_manager` sadece bu platformlarda anlamlı (bkz. `main.dart`
/// içindeki aynı kontrol).
bool get _isDesktopPlatform =>
    !kIsWeb && (Platform.isWindows || Platform.isLinux || Platform.isMacOS);

/// PC'de F11'e basınca pencereyi büyütür (maximize — pencere çerçevesi ve
/// görev çubuğu görünür kalır, gerçek/borderless tam ekran DEĞİL), tekrar
/// basınca eski boyutuna döndürür. `HardwareKeyboard.instance` üzerinden GLOBAL bir
/// dinleyici kullanılıyor (odaktaki widget'tan bağımsız); böylece bir
/// TextField (ör. Discover arama kutusu) odaktayken de F11 çalışır.
/// Tüketilen tuş olayı `true` döndürülerek altındaki widget'lara
/// sızdırılmaz.
class _FullscreenShortcutListener extends StatefulWidget {
  const _FullscreenShortcutListener({required this.child});

  final Widget child;

  @override
  State<_FullscreenShortcutListener> createState() =>
      _FullscreenShortcutListenerState();
}

class _FullscreenShortcutListenerState
    extends State<_FullscreenShortcutListener> {
  @override
  void initState() {
    super.initState();
    if (_isDesktopPlatform) {
      HardwareKeyboard.instance.addHandler(_handleKeyEvent);
    }
  }

  @override
  void dispose() {
    if (_isDesktopPlatform) {
      HardwareKeyboard.instance.removeHandler(_handleKeyEvent);
    }
    super.dispose();
  }

  bool _handleKeyEvent(KeyEvent event) {
    if (event is! KeyDownEvent || event.logicalKey != LogicalKeyboardKey.f11) {
      return false;
    }
    unawaited(_toggleFullscreen());
    return true;
  }

  Future<void> _toggleFullscreen() async {
    final isMaximized = await windowManager.isMaximized();
    if (isMaximized) {
      await windowManager.unmaximize();
    } else {
      await windowManager.maximize();
    }
  }

  @override
  Widget build(BuildContext context) => widget.child;
}

/// Varsayılan [MaterialScrollBehavior] sadece dokunma/kalem ile sürüklemeye
/// izin verir; PC'de mouse ile basılı tutup sürükleyerek kaydırma
/// (özellikle yana kayan poster şeritlerinde) çalışmaz. Mouse ve trackpad'i
/// de sürükleme cihazlarına ekleyerek tüm uygulamadaki kaydırılabilir
/// listeler için bunu düzeltir.
class _AppScrollBehavior extends MaterialScrollBehavior {
  @override
  Set<PointerDeviceKind> get dragDevices => {
    PointerDeviceKind.touch,
    PointerDeviceKind.mouse,
    PointerDeviceKind.trackpad,
    PointerDeviceKind.stylus,
    PointerDeviceKind.unknown,
  };
}

class WatchChronosApp extends ConsumerWidget {
  const WatchChronosApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(appRouterProvider);
    final locale = ref.watch(localeControllerProvider);

    return MaterialApp.router(
      title: 'WatchChronos',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: ThemeMode.system,
      scrollBehavior: _AppScrollBehavior(),
      routerConfig: router,
      locale: locale.toLocale,
      supportedLocales: AppLocale.supportedLocales,
      builder: (context, child) => _FullscreenShortcutListener(
        child: child ?? const SizedBox.shrink(),
      ),
      // AppLocalizations.delegate uygulamanın kendi metinlerini çözer;
      // Global* delegate'ler ise TextField'daki "Kes/Kopyala/Yapıştır"
      // araç çubuğu, tarih seçici, geri düğmesi tooltip'i gibi Flutter'ın
      // yerleşik Material/Widgets/Cupertino widget'larının seçili dile göre
      // metinlerini sağlar. Bunlar olmadan `locale` İngilizce/en-US dışında
      // bir şeye ayarlandığında "No MaterialLocalizations found" hatası
      // alınır.
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
    );
  }
}