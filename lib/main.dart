import 'package:device_preview/device_preview.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import 'providers/game_provider.dart';
import 'screens/home_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    DevicePreview(
      enabled: !kReleaseMode,
      builder: (context) => const BebidasApp(),
    ),
  );
}

class BebidasApp extends StatelessWidget {
  const BebidasApp({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = GoogleFonts.poppinsTextTheme(ThemeData.light().textTheme);

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => GameProvider()..init()),
      ],
      child: MaterialApp(
        title: 'Beber com Amigos',
        useInheritedMediaQuery: true,
        builder: DevicePreview.appBuilder,
        debugShowCheckedModeBanner: false,
        themeMode: ThemeMode.system,
        theme: ThemeData(
          colorSchemeSeed: const Color(0xFF7C4DFF),
          brightness: Brightness.light,
          useMaterial3: true,
          textTheme: textTheme,
        ),
        darkTheme: ThemeData(
          colorSchemeSeed: const Color(0xFFB388FF),
          brightness: Brightness.dark,
          useMaterial3: true,
          textTheme: textTheme,
        ),
        home: const HomeScreen(),
      ),
    );
  }
}
