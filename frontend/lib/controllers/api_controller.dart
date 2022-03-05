import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:frontend/sdk/user.dart';
import 'package:frontend/sdk/workflow.dart';
import 'package:get/get.dart';

class ApiController extends GetxController {
  static ApiController instance = Get.find();

  User? user;
  final Dio dio = Dio(
    BaseOptions(
      baseUrl: dotenv.env['API_URL'] ?? 'http://localhost:7001',
      connectTimeout: 15000,
      receiveTimeout: 13000,
      headers: {
        "Accept": "application/json",
        "Access-Control-Allow-Origin": "*",
        "Access-Control-Allow-Credentials": "true",
        "Access-Control-Allow-Methods": "GET, POST, PUT, DELETE, OPTIONS",
      },
    ),
  );

  late UserAPI userAPI = UserAPI(dio: dio);
  late WorkflowAPI taskAPI = WorkflowAPI(dio: dio);
  late WorkflowAPI credentialAPI = WorkflowAPI(dio: dio);
}
