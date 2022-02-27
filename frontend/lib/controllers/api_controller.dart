import 'package:dio/dio.dart';
import 'package:frontend/sdk/user.dart';
import 'package:frontend/sdk/workflow.dart';
import 'package:get/get.dart';

class ApiController extends GetxController {
  static ApiController instance = Get.find();

  UserAPI userAPI = UserAPI(
    dio: Dio(
      BaseOptions(
        baseUrl: 'http://localhost:7001/',
        connectTimeout: 15000,
        receiveTimeout: 13000,
        headers: {
          "Accept": "application/json",
          "Access-Control-Allow-Origin": "*",
          "Access-Control-Allow-Credentials": "true",
          "Access-Control-Allow-Methods": "GET, POST, PUT, DELETE, OPTIONS",
        },
      ),
    ),
  );

  WorkflowAPI taskAPI = WorkflowAPI(
    dio: Dio(
      BaseOptions(
        baseUrl: 'http://localhost:7001/',
        connectTimeout: 15000,
        receiveTimeout: 13000,
        headers: {
          "Accept": "application/json",
          "Access-Control-Allow-Origin": "*",
          "Access-Control-Allow-Credentials": "true",
          "Access-Control-Allow-Methods": "GET, POST, PUT, DELETE, OPTIONS",
        },
      ),
    ),
  );
}
