import 'package:alarm_app/features/auth/controller/auth_controller.dart';
import 'package:alarm_app/features/help/screens/help_me_screen.dart';
import 'package:alarm_app/features/notification/controller/notification_controller.dart';
import 'package:alarm_app/utils/connection_listener.dart';
import 'package:alarm_app/utils/shared_prefs.dart';
import 'package:alarm_app/utils/utils.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'core/subscription_controller.dart';
import 'features/auth/screen/singnup_screen.dart';
import 'firebase_options.dart';

@pragma("vm:entry-point")
Future<void> _firebaseBackgroundHandler(RemoteMessage message) async {
  if (Get.isRegistered<NotificationController>()) {
    Get.find<NotificationController>().getNotificationsFromNotification();
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  MySharedPrefs mySharedPrefs = MySharedPrefs();
  mySharedPrefs.sharedPreferences = await SharedPreferences.getInstance();
  // MySharedPrefs().sharedPreferences.setBool("isLoggedIn", true);

  await dotenv.load(fileName: ".env");

  await Supabase.initialize(
    url: dotenv.env['PROJECT_URL']!,
    anonKey: dotenv.env['ANON_KEY']!,
    realtimeClientOptions: const RealtimeClientOptions(
      eventsPerSecond: 2,
    ),
  );

  // final inAppPurchaseUtils = Get.put(InAppPurchaseUtils());
  FirebaseMessaging.onBackgroundMessage(_firebaseBackgroundHandler);

  runApp(const AlarmApp());
}

class AlarmApp extends StatefulWidget {
  const AlarmApp({super.key});
  @override
  State<AlarmApp> createState() => _AlarmAppState();
}

class _AlarmAppState extends State<AlarmApp> {
  late final InAppPurchaseUtils inAppPurchaseUtils;

  @override
  void initState() {
    super.initState();
    initNoInternetListener();
    Utils.shouldInitNotification(context);
    Get.put(AuthController(), permanent: true);
    inAppPurchaseUtils = InAppPurchaseUtils.inAppPurchaseUtilsInstance;
  }

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      theme: ThemeData(
          appBarTheme: AppBarTheme(
              backgroundColor: Colors.white, surfaceTintColor: Colors.white)),
      debugShowCheckedModeBanner: false,
      home: const SessionController(),
      initialBinding: BindingsBuilder(() async {
        final inAppController =
            Get.put<InAppPurchaseUtils>(inAppPurchaseUtils, permanent: true);
        await inAppController.initInApp();
      }),
    );
  }
}

class SessionController extends StatelessWidget {
  const SessionController({super.key});
  @override
  Widget build(BuildContext context) {
    bool isLoggedIn =
        MySharedPrefs().sharedPreferences.getBool("isLoggedIn") ?? false;

    final authController = Get.find<AuthController>();
    final session = Supabase.instance.client.auth.currentSession;
    if (session != null) {
      return FutureBuilder<int>(
        future: authController.getProfile(),
        builder: (BuildContext context, AsyncSnapshot<int> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return isLoggedIn ? HelpMeScreen() : AuthScreen();
          } else if (snapshot.hasData) {
            if (snapshot.data == 1) {
              return HelpMeScreen();
            }
          }
          return AuthScreen();
        },
      );
    } else {
      return AuthScreen();
    }
  }
}
