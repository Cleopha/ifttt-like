import 'package:dio/dio.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:cookie_jar/cookie_jar.dart';

class User {
  final String uid;

  String email;
  String? password;

  User({
    required this.email,
    required this.uid,
  });
}


void main() {
  Dio dio = Dio(new BaseOptions(
    baseUrl: 'http://localhost:7001/',
    connectTimeout: 15000,
    receiveTimeout: 13000,
    headers: {
      "Accept": "application/json",
      "Access-Control-Allow-Origin": "*",
      "Access-Control-Allow-Credentials": "true",
      "Access-Control-Allow-Methods": "GET, POST, PUT, DELETE, OPTIONS",
    },
  ));

  UserAPI userAPI = new UserAPI(dio: dio);
  WorkflowAPI workflowAPI = new WorkflowAPI(dio: dio);

  final String mail = "abc@gmail.com";
  final String password = "dazdzrazr";

  // api.register(mail, password).then((void v) {
  //   print("Registered");
  // });

  userAPI.login(mail, password).then((void v) {
    print("Registered");

    userAPI.me().then((User user) {
      print(user.email);

      userAPI.me().then((User user) {
        print("me: ${user.email}");
      });

      // userAPI.logout().then((void v) {
      //   print("Logged out");
      // });

      workflowAPI.getWorkflows(user.uid).then((List<Workflow> workflows) {
        print(workflows);
      });

      workflowAPI.postWorkflow(user.uid, "My workflow n2").then((Workflow w) {
        print("workflow posted");

        workflowAPI.getWorkflow(user.uid, w.id).then((Workflow w) {
          print("workflow: ${w.name}");
        });

        workflowAPI.deleteWorkflow(user.uid, w.id).then((void v) {
          print("workflow deleted");
        });

        workflowAPI.getWorkflows(user.uid).then((List<Workflow> workflows) {
          workflowAPI.putWorkflow(user.uid, workflows[0].id, "New Name").then((void v) {
            print("workflow updated");
          });
        });

      });
    });

  });
}

class UserAPI {
  Dio dio;

  UserAPI({
    required this.dio
  }) {
    dio.interceptors.add(CookieManager(CookieJar()));
  }

  final String loginUrl = "auth/login";
  final String registerUrl = "auth/register";
  final String logoutUrl = "auth/logout";
  final String patchUrl = "user/";
  final String meUrl = "user/me";

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
      throw e;
    }
  }

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
      throw e;
    }
  }

  Future<void> logout() async {
    try {
      Response response = await dio.post(logoutUrl);

      if (response.statusCode != 200) {
        throw Exception("Error logging out");
      }
    } catch (e) {
      throw e;
    }
  }

  Future<User> me() async {
    try {

      Response response = await dio.get(meUrl);

      if (response.statusCode != 200) {
        throw Exception("Error getting user");
      }

      return User(email: response.data['email'], uid: response.data['id']);

    } catch (e) {
      throw e;
    }
  }

  Future<void> patch(User user) async {
    try {

      Response response = await dio.patch(patchUrl + user.uid, data: {
        "email": user.email,
      });

      if (response.statusCode != 200) {
        throw Exception("Error patching user");
      }

    } catch (e) {
      throw e;
    }
  }

  Future<void> delete(User user) async {
    try {

      Response response = await dio.delete(patchUrl + user.uid);

      if (response.statusCode != 200) {
        throw Exception("Error deleting user");
      }

    } catch (e) {
      throw e;
    }
  }

  Future<List> githubRepos(String token) async {
    Dio dio = Dio(new BaseOptions(
      baseUrl: 'https://api.github.com/',
      connectTimeout: 15000,
      receiveTimeout: 13000,
      headers: {
        "Authorization": "token " + token
      },
    ));
    
    try {
      String reposUrl = "user/repos";

      Response response = await dio.get(reposUrl);

      if (response.statusCode != 200) {
        throw Exception("Error getting user repos");
      }

      return response.data;

    } catch (e) {
      throw e;
    }
  }
}

class Workflow {
  final String id;
  final String name;

  Workflow({
    required this.id,
    required this.name,
  });
}

class WorkflowAPI {
  Dio dio;

  WorkflowAPI({
    required this.dio
  }) {
    dio.interceptors.add(CookieManager(CookieJar()));
  }

  String getWorkflowsUrl(String userId) {
    return "user/${userId}/workflow";
  }

  String postWorkflowUrl(String userId) {
    return "user/${userId}/workflow";
  }

  Future<List<Workflow>> getWorkflows(String userId) async {
    try {
      Response response = await dio.get(getWorkflowsUrl(userId));

      if (response.statusCode != 200) {
        throw Exception("Error getting workflows");
      }

      return List<Workflow>.from(response.data.map((dynamic w) {
        return Workflow(
          id: w['id'],
          name: w['name'],
        );
      }));

    } catch (e) {
      throw e;
    }
  }

  Future<Workflow> getWorkflow(String userId, String workflowId) async {
    try {
      Response response = await dio.get(getWorkflowsUrl(userId) + "/${workflowId}");

      if (response.statusCode != 200) {
        throw Exception("Error getting workflow");
      }

      return Workflow(
        id: response.data['id'],
        name: response.data['name'],
      );

    } catch (e) {
      throw e;
    }
  }

  Future<Workflow> postWorkflow(String userId, String name) async {
    try {
      Response response = await dio.post(postWorkflowUrl(userId), data: {
        "name": name,
      });

      if (response.statusCode != 201) {
        throw Exception("Error posting workflow");
      }

      return Workflow(
        id: response.data['id'],
        name: name,
      );

    } catch (e) {
      throw e;
    }
  }

  Future<void> deleteWorkflow(String userId, String workflowId) async {
    try {
      Response response = await dio.delete(postWorkflowUrl(userId) + "/${workflowId}");

      if (response.statusCode != 200) {
        throw Exception("Error deleting workflow");
      }

    } catch (e) {
      throw e;
    }
  }

  Future<void> putWorkflow(String userId, String workflowId, String name) async {
    try {
      Response response = await dio.put(postWorkflowUrl(userId) + "/${workflowId}", data: {
        "name": name,
      });

      if (response.statusCode != 200) {
        throw Exception("Error putting workflow");
      }

    } catch (e) {
      throw e;
    }
  }
}