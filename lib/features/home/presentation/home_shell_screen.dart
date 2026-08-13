import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/localization/app_localizations.dart';

/// Kütüphanem / Keşfet / Profil sekmeleri arasında geçiş yapan alt
/// navigasyon kabuğu. `StatefulShellRoute.indexedStack` tarafından
/// enjekte edilen [navigationShell] her sekmenin kendi navigasyon
/// yığınını (stack) korur.
class HomeShellScreen extends StatelessWidget {
  const HomeShellScreen({required this.navigationShell, super.key});

  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: NavigationBar(
        selectedIndex: navigationShell.currentIndex,
        onDestinationSelected: (index) => navigationShell.goBranch(
          index,
          initialLocation: index == navigationShell.currentIndex,
        ),
        destinations: [
          NavigationDestination(
            icon: const Icon(Icons.video_library_outlined),
            selectedIcon: const Icon(Icons.video_library),
            label: context.l10n.t('nav_library'),
          ),
          NavigationDestination(
            icon: const Icon(Icons.search_outlined),
            selectedIcon: const Icon(Icons.search),
            label: context.l10n.t('nav_discover'),
          ),
          NavigationDestination(
            icon: const Icon(Icons.person_outline_rounded),
            selectedIcon: const Icon(Icons.person_rounded),
            label: context.l10n.t('nav_profile'),
          ),
        ],
      ),
    );
  }
}