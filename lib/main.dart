import 'package:fit_25/Providers/StepsProvider.dart';
import 'package:fit_25/Providers/bodyProvider.dart';
import 'package:fit_25/Providers/loginProvider.dart';
import 'package:fit_25/Providers/weatherData.dart';
import 'package:fit_25/Screen/Login.dart';
import 'package:fit_25/Screen/MainPage.dart';
import 'package:fit_25/Screen/Singup.dart';
import 'package:fit_25/Screen/User.dart';
import 'package:fit_25/Service/assets_api.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gemini/flutter_gemini.dart';
import 'package:provider/provider.dart';

void main() async {

  Gemini.init(apiKey: API_KEY_AI); // Đảm bảo bạn có API_KEY chính xác

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => UserProvider()), // Thêm UserProvider
        ChangeNotifierProvider(create: (context) => BodyProvider()),
        ChangeNotifierProvider(create: (context) => WeatherProvider()),
        ChangeNotifierProvider(create: (context) => StepsProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Fit 25', // Tiêu đề của ứng dụng
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      initialRoute: '/login', // Đặt route khởi đầu
      routes: {
        '/home': (context) => const MyHomePage(),
        '/login': (context) => LoginScreen(),
        '/signup': (context) => SignUpScreen(),
        '/user': (context) => const UserScreen(),
      },
    );
  }
}
