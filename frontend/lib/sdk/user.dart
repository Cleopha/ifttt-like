import 'package:dio/dio.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:cookie_jar/cookie_jar.dart';

/// Represents a user of the application.
class User {
  final String uid;

  String email;
  String? password;

  User({
    required this.email,
    required this.uid,
  });
}

/// Handles any interaction with the backend related to authentication and user management.
class UserAPI {
  Dio dio;

  UserAPI({required this.dio}) {
    dio.interceptors.add(CookieManager(CookieJar()));
  }

  final String loginUrl = "auth/login";
  final String registerUrl = "auth/register";
  final String logoutUrl = "auth/logout";
  final String patchUrl = "user/";
  final String meUrl = "user/me";
  final String oauthUrl = "oauth/login";

  /// Registers a new user.
  Future<void> register(String email, String password) async {
    try {
      Response response = await dio.post(registerUrl, data: {
        "email": email,
        "password": password,
      });

      if (response.statusCode != 201) {
        throw Exception("Error registering");
      }
    } catch (e) {
      rethrow;
    }
  }

  /// Logs in a user.
  Future<void> login(String email, String password) async {
    try {
      Response response = await dio.post(loginUrl, data: {
        "email": email,
        "password": password,
      });

      if (response.statusCode != 200) {
        throw Exception("Error logging in");
      }
    } catch (e) {
      rethrow;
    }
  }

  /// Logs out a user.
  Future<void> logout() async {
    try {
      Response response = await dio.post(logoutUrl);

      if (response.statusCode != 200) {
        throw Exception("Error logging out");
      }
    } catch (e) {
      rethrow;
    }
  }

  /// Gets the user's information.
  Future<User> me() async {
    try {
      Response response = await dio.get(meUrl);

      if (response.statusCode != 200) {
        throw Exception("Error getting user");
      }

      return User(email: response.data['email'], uid: response.data['id']);
    } catch (e) {
      rethrow;
    }
  }

  /// Updates the user's information.
  Future<void> patch(User user) async {
    try {
      Response response = await dio.patch(patchUrl + user.uid, data: {
        "email": user.email,
      });

      if (response.statusCode != 200) {
        throw Exception("Error patching user");
      }
    } catch (e) {
      rethrow;
    }
  }

  /// Deletes the user's information.
  Future<void> delete(User user) async {
    try {
      Response response = await dio.delete(patchUrl + user.uid);

      if (response.statusCode != 200) {
        throw Exception("Error deleting user");
      }
    } catch (e) {
      rethrow;
    }
  }

  /// Gets the user's github repositories.
  Future<List<String>> githubRepos(String token) async {
    Dio dio = Dio(BaseOptions(
      baseUrl: 'https://api.github.com/',
      connectTimeout: 15000,
      receiveTimeout: 13000,
      headers: {"Authorization": "token " + token},
    ));

    try {
      String reposUrl = "user/repos";

      Response response = await dio.get(reposUrl);

      if (response.statusCode != 200) {
        throw Exception("Error getting user repos");
      }

      List<String> repos = [];

      for (var x in response.data) {
        repos.add(x['full_name']);
      }
      return repos;
    } catch (e) {
      rethrow;
    }
  }

  /// Gets the user's github name.
  Future<String> githubName(String token) async {
    Dio dio = Dio(BaseOptions(
      baseUrl: 'https://api.github.com/',
      connectTimeout: 15000,
      receiveTimeout: 13000,
      headers: {"Authorization": "token " + token},
    ));

    try {
      String reposUrl = "user";

      Response response = await dio.get(reposUrl);

      if (response.statusCode != 200) {
        throw Exception("Error getting user repos");
      }

      return response.data['login'];
    } catch (e) {
      rethrow;
    }
  }

  /// Logs in with github.
  Future<void> oauthSignin(
      String? accessToken, String email, String type) async {
    try {
      Response response = await dio.post(oauthUrl,
          data: {"accessToken": accessToken, "email": email, "type": type});

      if (response.statusCode != 201) {
        throw Exception("Error login with oauth");
      }
    } catch (e) {
      rethrow;
    }
  }
}
