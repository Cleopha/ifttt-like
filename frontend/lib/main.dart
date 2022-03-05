import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:frontend/controllers/api_controller.dart';
import 'package:frontend/controllers/controller_constant.dart';
import 'package:frontend/controllers/task_controller.dart';
import 'package:frontend/routes/home.dart';
import 'package:frontend/routes/login.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (!kIsWeb) {
    await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        systemNavigationBarColor: Colors.black,
        statusBarBrightness: Brightness.dark,
      ),
    );
  }
  await dotenv.load(fileName: '.env');
  Get.put(ApiController());
  Get.put(TaskController());
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  Future<void> _getDataForRoute(String id, String currentRoute) async {
    try {
      if (currentRoute == '/home') {
        taskController.getTasks();
      }
    } catch (e) {
      Get.snackbar(
        'Erreur',
        e.toString().split('\n')[0],
        backgroundColor: Colors.red,
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'IFTTT Like',
      theme: ThemeData(fontFamily: 'AvenirNext'),
      debugShowCheckedModeBanner: false,
      routingCallback: (routing) {
        if (routing != null) {
          final List<String> splitRoute = routing.current.split('/');
          final String id = splitRoute.last;
          _getDataForRoute(id, routing.current);
        }
      },
      initialRoute: '/',
      getPages: <GetPage<dynamic>>[
        GetPage<dynamic>(
          name: '/',
          page: () => const Login(),
          transition: Transition.fade,
        ),
        GetPage<dynamic>(
          name: '/home',
          page: () => const Home(),
          transition: Transition.fade,
        ),
      ],
    );
  }
}
