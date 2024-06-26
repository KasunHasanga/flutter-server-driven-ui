import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mirai/mirai.dart';
import 'package:mirai_webview/parsers/mirai_webview/mirai_webview_parser.dart';

import 'app/details/details_screen.dart';
import 'app/example/example_screen_parser.dart';
import 'app/home/home_screen.dart';
import 'app_theme/app_theme_cubit.dart';


class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

void main() async {
  HttpOverrides.global = MyHttpOverrides();
  await Mirai.initialize(
    parsers: const [
      ExampleScreenParser(),
      MiraiWebViewParser(),
    ],
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AppThemeCubit()..loadThemes(),
      child: BlocBuilder<AppThemeCubit, AppThemeState>(
        builder: (context, state) {
          return MiraiApp(
            theme: state.lightTheme,
            debugShowCheckedModeBanner: false,
            darkTheme: state.darkTheme,
            themeMode: state.themeMode,
            homeBuilder: (context) => const HomeScreen(),
            title: 'Mirai Gallery',
            routes: {
              '/homeScreen': (context) => const HomeScreen(),
              '/detailsScreen': (context) => const DetailsScreen(),
            },
          );
        },
      ),
    );
  }
}
