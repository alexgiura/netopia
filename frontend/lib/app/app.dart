import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../constants/theme.dart';
import '../models/app_localizations.dart';
import '../routing/router.dart';

class App extends StatelessWidget {
  App({super.key});
  final FlutterLocalization _localization = FlutterLocalization.instance;
  @override
  Widget build(BuildContext context) {
    _localization.init(
      mapLocales: [
        const MapLocale(
          'ro',
          {
            'title': 'RO',
            'thisIs': 'Română',
          },
          countryCode: 'RO',
        ),
      ],
      initLanguageCode: 'ro',
    );
    return ProviderScope(
      child: MaterialApp.router(
        debugShowCheckedModeBanner: false,
        theme: customTheme(context),
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
        ],
        supportedLocales: _localization.supportedLocales,
        localeResolutionCallback: (locale, supportedLocales) {
          for (var supportedLocale in supportedLocales) {
            if (supportedLocale.languageCode == locale!.languageCode &&
                supportedLocale.countryCode == locale.countryCode) {
              return supportedLocale;
            }
          }
          return supportedLocales.first;
        },
        routerConfig: router,
      ),
    );
  }
}
