import 'package:dio/dio.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:cookie_jar/cookie_jar.dart';


/// Handles every interaction with the Credentials API
class CredentialApi {
  Dio dio;

  CredentialApi({required this.dio}) {
    dio.interceptors.add(CookieManager(CookieJar()));
  }

  /// Get the storage of a user
  Future<List<Map<String, String>>> getStorage(String userId) async {
    try {
      Response response = await dio.get("/user/$userId/storage");

      if (response.statusCode != 200) {
        throw Exception("Error getting storage");
      }

      return List<Map<String, String>>.from(response.data["credentials"]);
    } catch (e) {
      rethrow;
    }
  }

  /// Create a new storage for a user
  Future<void> createStorage(String userId) async {
    try {
      Response response = await dio.post("/user/$userId/storage");

      if (response.statusCode != 201) {
        throw Exception("Error creating storage");
      }

      return;
    } catch (e) {
      rethrow;
    }
  }

  /// Delete a storage for a user
  Future<void> deleteStorage(String userId) async {
    try {
      Response response = await dio.delete("/user/$userId/storage");

      if (response.statusCode != 200) {
        throw Exception("Error deleting storage");
      }

      return;
    } catch (e) {
      rethrow;
    }
  }

  /// Create a new credential for a user
  Future<String> createCredential(
      String userId, String service, String token) async {
    if (service.isEmpty ||
        [
              "GITHUB",
              "GOOGLE",
              "SCALEWAY",
              "COINMARKET",
              "ETH",
              "NOTION",
            ].contains(service) ==
            false) {
      throw Exception("Invalid credential");
    }

    try {
      Response response = await dio
          .post("/user/$userId/storage/credential?service=$service", data: {
        "token": token,
      });

      if (response.statusCode != 201) {
        throw Exception("Error creating credential");
      }

      return response.data['token'];
    } catch (e) {
      rethrow;
    }
  }

  /// Delete a credential for a user
  Future<void> deleteCredential(String userId, String service) async {
    if (service.isEmpty ||
        [
              "GITHUB",
              "GOOGLE",
              "SCALEWAY",
              "COINMARKET",
              "ETH",
              "NOTION",
            ].contains(service) ==
            false) {
      throw Exception("Invalid credential");
    }

    try {
      Response response =
          await dio.delete("/user/$userId/storage/credential?service=$service");

      if (response.statusCode != 200) {
        throw Exception("Error deleting credential");
      }

      return;
    } catch (e) {
      rethrow;
    }
  }

  /// Put a credential for a user
  Future<void> putCredential(
      String userId, String service, String token) async {
    if (service.isEmpty ||
        [
              "GITHUB",
              "GOOGLE",
              "SCALEWAY",
              "COINMARKET",
              "ETH",
              "NOTION",
            ].contains(service) ==
            false) {
      throw Exception("Invalid credential");
    }

    try {
      Response response = await dio
          .put("/user/$userId/storage/credential?service=$service", data: {
        "token": token,
      });

      if (response.statusCode != 200) {
        throw Exception("Error patching credential");
      }

      return;
    } catch (e) {
      rethrow;
    }
  }

  /// Get a credential for a user
  Future<String> getCredential(String userId, String service) async {
    if (service.isEmpty ||
        [
              "GITHUB",
              "GOOGLE",
              "SCALEWAY",
              "COINMARKET",
              "ETH",
              "NOTION",
            ].contains(service) ==
            false) {
      throw Exception("Invalid credential");
    }

    try {
      Response response =
          await dio.get("/user/$userId/storage/credential?service=$service");

      if (response.statusCode != 200) {
        throw Exception("Error getting credential");
      }

      return response.data['token'];
    } catch (e) {
      rethrow;
    }
  }
}
