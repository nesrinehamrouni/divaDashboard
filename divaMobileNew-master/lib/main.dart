import 'package:divamobile/Notification/notif.dart';
import 'package:divamobile/firebase_options.dart';
import 'package:divamobile/pages/Chat/HomePage.dart';
import 'package:divamobile/pages/Chat/message_screen.dart';
import 'package:divamobile/pages/Menu/MenuBI.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hexcolor/hexcolor.dart';

import './pages/Menu/Menu.dart';
import './pages/splash_screen.dart';

// @pragma('vm:entry-point')
// Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
//   await Firebase.initializeApp();
//   print("Handling a background message: ${message.messageId}");
//   if (message.data['screen'] == 'tableau_de_bord') {
//     MyApp.navigatorKey.currentState?.pushReplacementNamed('/tableau_de_bord');
//   }
// }

Future main() async {
  
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  // FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  FlutterError.onError = (FlutterErrorDetails details) {
    FlutterError.presentError(details);
    debugPrint(details.toString());
  };

  // Initialize notifications
  final notificationSetup = NotificationSetUp();
  await notificationSetup.initializeNotification();
  try {
    await dotenv.load(fileName: "lib/.env");
    print('Loaded .env file');
  } catch (e) {
    print('Failed to load .env file: $e');
  }
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({Key? key}) : super(key: key);

  final Map<String, WidgetBuilder> routes = {
    '/Menu': (context) => Menu(),
    '/tableau_de_bord': (context) => Menu_BI(),
    '/chatHome': (context) => HomePage(), // Chat app home page
    '/messageScreen': (context) => MessageScreen(),
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
