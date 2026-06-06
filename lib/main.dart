import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import 'core/routing/app_router.dart';
import 'core/utils/app_logger.dart';

class AppProviderObserver extends ProviderObserver {
  @override
  void didUpdateProvider(ProviderBase provider, Object? previousValue, Object? newValue, ProviderContainer container) {
    AppLogger.info('[Provider] ${provider.name ?? provider.runtimeType} updated: $newValue', tag: 'STATE');
  }

  @override
  void didAddProvider(ProviderBase provider, Object? value, ProviderContainer container) {
    AppLogger.info('[Provider] ${provider.name ?? provider.runtimeType} initialized', tag: 'STATE');
  }

  @override
  void didDisposeProvider(ProviderBase provider, ProviderContainer container) {
    AppLogger.info('[Provider] ${provider.name ?? provider.runtimeType} disposed', tag: 'STATE');
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  runApp(
    ProviderScope(
      observers: [AppProviderObserver()],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ResponsiveSizer(
      builder: (context, orientation, screenType) {
        return MaterialApp.router(
          title: 'Flutter Demo',
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
            useMaterial3: true,
          ),
          debugShowCheckedModeBanner: false,
          routerConfig: appRouter,
        );
      },
    );
  }
}
