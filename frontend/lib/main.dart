import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import 'package:frontend/routes/home.dart';

void main() {
  // if (!kIsWeb) {
  //   SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  //   SystemChrome.setSystemUIOverlayStyle(
  //     const SystemUiOverlayStyle(
  //       statusBarColor: Colors.transparent,
  //       systemNavigationBarColor: Colors.black,
  //       statusBarBrightness: Brightness.dark,
  //     ),
  //   );
  // }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'IFTTT Like',
      theme: ThemeData(fontFamily: 'AvenirNext'),
      debugShowCheckedModeBanner: false,
      getPages: [],
      home: const Home(),
    );
  }
}
