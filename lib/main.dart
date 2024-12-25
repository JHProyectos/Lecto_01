import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:provider/provider.dart';
import 'src/core/providers/theme_provider.dart';
import 'src/core/navigation/routes.dart';
import 'src/core/navigation/app_navigator.dart';
import 'src/core/pages/settings_page.dart';
import 'src/core/navigation/route_arguments.dart';
import 'src/features/processing/processing_screen.dart';
import 'src/features/playback/playback_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();

  runApp(
    EasyLocalization(
      supportedLocales: const [Locale('en'), Locale('es')],
      path: StaticResources.translationPath,
      fallbackLocale: const Locale('en'),
      child: MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ],
        child: const MyApp(),      
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
      ],
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, child) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: ThemeConfig.lightTheme,        // Light theme
            darkTheme: ThemeConfig.darkTheme,     // Dark theme
            themeMode: themeProvider.themeMode,   // Current theme mode
            locale: context.locale,
            supportedLocales: context.supportedLocales,
            localizationsDelegates: context.localizationDelegates,
            home: const SettingsPage(),
            navigatorKey: AppNavigator.navigatorKey, // Added navigator key
            navigatorObservers: [AppNavigatorObserver()],
            // Added onGenerateRoute for dynamic route generation
            onGenerateRoute: (settings) {
              final args = settings.arguments;
              
              switch (settings.name) {
                case AppRoute.processing.path:
                  if (args is ProcessingArguments) {
                    return MaterialPageRoute(
                      builder: (_) => ProcessingScreen(
                        fileName: args.fileName,
                        fileSize: args.fileSize,
                      ),
                    );
                  }
                  return _errorRoute();
                
                case AppRoute.playback.path:
                  if (args is PlaybackArguments) {
                    return MaterialPageRoute(
                      builder: (_) => PlaybackScreen(
                        audioFile: args.audioFile,
                        duration: args.duration,
                      ),
                    );
                  }
                  return _errorRoute();
                
                // Add other routes here
                default:
                  return _errorRoute();
              }
            },
          );
        },
      ),
    );
  }

  // Added error route method
  Route<dynamic> _errorRoute() {
    return MaterialPageRoute(
      builder: (_) => Scaffold(
        body: Center(
          child: Text('Error: Ruta no encontrada'),
        ),
      ),
    );
  }
}

// Added AppNavigatorObserver class
class AppNavigatorObserver extends NavigatorObserver {
  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    // Navigation logging
    print('New route: ${route.settings.name}');
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    // Navigation logging
    print('Route removed: ${route.settings.name}');
  }
}
