import 'package:dynamic_color/dynamic_color.dart';
import 'package:material_ui/material_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/router/app_router.dart';
import 'core/theme/app_theme.dart';
import 'l10n/generated/app_localizations.dart';

class LoanTrackApp extends ConsumerWidget {
  const LoanTrackApp({super.key});

  static const locale = Locale('fr');

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(appRouterProvider);
    return DynamicColorBuilder(
      builder: (lightDynamic, darkDynamic) => MaterialApp.router(
        onGenerateTitle: (context) => AppLocalizations.of(context).appTitle,
        debugShowCheckedModeBanner: false,
        locale: locale,
        supportedLocales: AppLocalizations.supportedLocales,
        // Not AppLocalizations.localizationsDelegates: the generated list
        // holds the legacy package:flutter/material delegates (CR-003).
        localizationsDelegates: const [
          AppLocalizations.delegate,
          ...GlobalMaterialLocalizations.delegates,
        ],
        theme: AppTheme.light(lightDynamic),
        darkTheme: AppTheme.dark(darkDynamic),
        routerConfig: router,
      ),
    );
  }
}
