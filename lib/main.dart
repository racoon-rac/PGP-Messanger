import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:pgpmessanger/classes/animations/class_noanim.dart';
import 'package:pgpmessanger/screens/contactpage.dart';
import 'package:pgpmessanger/screens/homepage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: const FirebaseOptions(
      apiKey: 'AIzaSyA5R3VR3SHHhuNN6DRzrmEgQJxRdzsYz2U',
      appId: '1:713126175000:android:da435a1662e70ff8acbe6d',
      messagingSenderId: '713126175000',
      projectId: 'pgpmessanger',
    ),
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({Key? key}) : super(key: key);

  // require to use named routing.
  final RouteObserver<PageRoute> routeObserver = RouteObserver<PageRoute>();

  // This widget is the root of my application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PGP Messenger',
      theme: ThemeData(
          colorScheme: const ColorScheme.dark(
              primary: Colors.pink, secondary: Colors.pinkAccent)),
      initialRoute: '/home',
      onGenerateRoute: (settings) {
        switch (settings.name) {
          case '/home':
            {
              return NoAnim(
                  page: HomePage(routeObserver: routeObserver),
                  settings: settings);
            }
          case '/contact':
            {
              return NoAnim(
                  page: ContactPage(routeObserver: routeObserver),
                  settings: settings);
            }
        }
      },
      navigatorObservers: [
        routeObserver,
      ],
    );
  }
}
