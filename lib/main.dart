import 'package:event_generator/screens/splash_page.dart';
import 'package:event_generator/widgets/local_String.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:get/get.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
      options: const FirebaseOptions(
          apiKey: 'AIzaSyBiB1wPqkVjfNpGemYz9QsSKlEgRFhGlqM',
          appId: '1:592115294229:web:5e1f1c5f28d8e31f8d2e1c',
          messagingSenderId: "592115294229",
          projectId: "event-registration-8c544",
          storageBucket: 'event-registration-8c544.appspot.com')
      );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      translations: LocalString(),
      locale: Locale('hi', 'IN'),
      title: 'Teachable Event Registration',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.teal,
      ),
      home: const SplashScreen(),
    );
  }
}
