import 'package:alarm_app/features/auth/controller/auth_controller.dart';
import 'package:alarm_app/features/help/screens/help_me_screen.dart';
import 'package:alarm_app/servies/get_services_key.dart';
import 'package:alarm_app/servies/notification_service.dart';
import 'package:alarm_app/utils/connection_listener.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'features/auth/screen/singnup_screen.dart';
import 'features/contact/add_contacts_controller/add_contact_controller.dart';
import 'firebase_options.dart';


@pragma("vm:entry-point")
Future<void> _firebaseBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
}
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await dotenv.load(fileName: ".env");
  await Supabase.initialize(
    url: dotenv.env['PROJECT_URL']!,
    anonKey: dotenv.env['ANON_KEY']!,
    realtimeClientOptions: const RealtimeClientOptions(
      eventsPerSecond: 2,
    ),
  );

   FirebaseMessaging.onBackgroundMessage(_firebaseBackgroundHandler);


  runApp( const AlarmApp());
}

class AlarmApp extends StatefulWidget {
   const AlarmApp({super.key});

  @override
  State<AlarmApp> createState() => _AlarmAppState();
}

class _AlarmAppState extends State<AlarmApp> {
  NotificationService notificationService = NotificationService();
  GetServicesKey getServicesKey=GetServicesKey();


  @override
  void initState() {
    super.initState();
    initNoInternetListener();
    getServicesKey.getServerToken();
    notificationService.requestNotificationPermission();
    notificationService.getDeviceToken();
    notificationService.firebaseInit(context);
    notificationService.setupInteractMessage(context);

  }

  @override
  Widget build(BuildContext context) {
    Get.put(AuthController(), permanent: true);
    return const GetMaterialApp(
      debugShowCheckedModeBanner: false,
      home:  HelpMeScreen(),
      // home: SessionController(),
    );
  }
}

class SessionController extends StatelessWidget {
  const SessionController({super.key});

  @override
  Widget build(BuildContext context) {
    final authController =Get.find<AuthController>();
    final session = Supabase.instance.client.auth.currentSession;

    if (session != null) {
     authController.getProfile();

      return const HelpMeScreen();
    } else {
      return  AuthScreen();
    }
  }
}

