import 'package:http/http.dart' as http;
// import 'package:user.dart';
// import 'package:frontend/utils/services.dart';

class User {
  String? uid;
  final String email;
  final String password;

  String? name;

  User({
    required this.email,
    required this.password,
  });
}

void main() {
  UserAPI api = new UserAPI();

  final String mail = "daazzerzeerzdea@gmail.com";
  final String password = "dazdaazrazr";

  // api.register(mail, password).then((void v) {
  //   print("registered");

  //   api.me().then((User u) {
  //     print("me-ed");
  //   });

  //   api.logout().then((void v) {
  //     print("logged out");
  //   });
  // });

  api.login(mail, password).then((void v) {
    print("logged in");

    api.me().then((User u) {
      print("me-ed");
    });

    api.logout().then((void v) {
      print("logged out");
    });
  });


}

class UserAPI {
  final String baseUrl = "http://localhost:7001/";
  final String loginUrl = "auth/login";
  final String registerUrl = "auth/register";
  final String logoutUrl = "auth/logout";
  final String patchUrl = "user/patch";

  final http.Client client = new http.Client();

  Future<void> register(String email, String password) async {
    String url = baseUrl + registerUrl;

    Map<String, String> body = {
      "email": email,
      "password": password
    };

    Map<String, String> headers = {
      "Accept": "application/json",
      "credential": "true",
      "Access-Control-Allow-Credentials": "true",
      "Access-Control-Allow-Origin": "*",
      "Access-Control-Allow-Headers": "Origin, X-Requested-With, Content-Type, Accept",
    };


    try {
      var response = await client.post(Uri.parse(url), headers: headers, body: body);

      if (response.statusCode == 201) {
        return; // TODO: return user
      } else {
        throw Exception("User registration failed with status code ${response.statusCode} and body ${response.body}");
      }
    } catch (e) {
      throw e;
    }
  }

  Future<void> login(String email, String password) async {
    String url = baseUrl + loginUrl;

    Map<String, String> body = {
      "email": email,
      "password": password,
    };

    Map<String, String> headers = {
      "Accept": "application/json",
      "Access-Control-Allow-Credentials": "true",
      "Access-Control-Allow-Origin": "*",
      "Access-Control-Allow-Headers": "Origin, X-Requested-With, Content-Type, Accept",
    };

    try {
      var response = await client.post(Uri.parse(url), headers: headers, body: body);

      print(response);
      // print(response.cookies);

      if (response.statusCode == 200) {
        // TODO: fill User class by calling /me endpoint
        return; // TODO: return user
      } else {
        throw Exception("User login failed with status code ${response.statusCode} and body ${response.body}");
      }
    } catch (e) {
      throw e;
    }
  }

  Future<void> logout() async {
    try {
      var response = await client.post(Uri.parse(baseUrl + logoutUrl));

      if (response.statusCode == 200) {
        return;
      }

      throw Exception("User logout failed with status code ${response.statusCode} and body ${response.body}");

    } catch (e) {
      throw e;
    }
  }

  Future<void> patch(User user) async {
    // String url = baseUrl + patchUrl + "/" + user.uid;

    // Map<String, String> body = {
    //   "name": user.name,
    //   "email": user.email,
    //   "password": user.password,
    // };

    // Map<String, String> headers = {
    //   "Accept": "application/json",
    //   "credential": "true",
    // "Access-Control-Allow-Credentials"
    // };


    // try {
    //   var response = await client.patch(Uri.parse(url), headers: headers, body: body);

    //   if (response.statusCode == 200) {
    //     return;
    //   }

    //   throw Exception("User patch failed with status code ${response.statusCode} and body ${response.body}");

    // } catch (e) {
    //   throw e;
    // }
  }

  Future<User> me() async {
    String url = baseUrl + "user/me";

    Map<String, String> headers = {
      "Accept": "application/json",
      "Access-Control-Allow-Credentials": "true",
      "Access-Control-Allow-Origin": "*",
      "Access-Control-Allow-Headers": "Origin, X-Requested-With, Content-Type, Accept",
    };

    try {
      var response = await client.get(Uri.parse(url), headers: headers);

      if (response.statusCode == 200) {
        // return User.fromJson(json.decode(response.body));
        return User(email: "lol", password: "lol");
      }

      throw Exception("User me failed with status code ${response.statusCode} and body ${response.body}");
    } catch (e) {
      throw e;
    }
  }
}