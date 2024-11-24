import 'package:fit_25/Providers/bodyProvider.dart';
import 'package:fit_25/Providers/timeProvider.dart';
import 'package:fit_25/Providers/weatherData.dart';
import 'package:fit_25/Screen/home.dart';
import 'package:fit_25/Service/assets_api.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gemini/flutter_gemini.dart';
import 'package:provider/provider.dart';
// import 'package:firebase_core/firebase_core.dart';

void main() async {
  Gemini.init(
    apiKey: API_KEY_AI
  );
  WidgetsFlutterBinding.ensureInitialized();
  // await Firebase.initializeApp();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => TimeProvider()),
        ChangeNotifierProvider(create: (context) => UserInfoProvider()),
        ChangeNotifierProvider(create: (context) => WeatherProvider()) // Thêm aqui
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home:  MyHomePage()
    );
  }
}