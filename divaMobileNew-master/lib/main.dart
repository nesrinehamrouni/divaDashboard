import 'package:divamobile/Notification/notif.dart';
import 'package:divamobile/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hexcolor/hexcolor.dart';

import './pages/Menu/Menu.dart';
import './pages/splash_screen.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Initialize notifications
  final notificationSetup = NotificationSetUp();
  await notificationSetup.initializeNotification();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({Key? key}) : super(key: key);

  final Map<String, WidgetBuilder> routes = {
    '/Menu': (context) => Menu(),
  };

  static GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  Color _primaryColor = HexColor('#44596c');
  Color _accentColor = Color(0xFF2f3b46);
  // This widget is the root of your application.
  
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
        designSize: const Size(360, 690),
    minTextAdapt: true,
    splitScreenMode: true,
    builder: (context , child) {
          return MaterialApp(
            routes: routes,
            debugShowCheckedModeBanner: false,
            title: 'Flutter Auth',
            navigatorKey: navigatorKey,

            localizationsDelegates: [
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],

            supportedLocales: [
              const Locale('en'),
              const Locale('fr')
            ],

            theme:  ThemeData(
              primaryColor: _primaryColor,
              hintColor: _accentColor,
              scaffoldBackgroundColor: Colors.grey.shade100,
              primarySwatch: Colors.grey,
            ),
            home:  SplashScreen(title: 'Tableau de bord',),
          );
    }
  );


  }
}
