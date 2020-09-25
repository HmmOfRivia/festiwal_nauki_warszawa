import 'package:festiwal_nauki_warszawa/utils/User.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class LoginRepository {
  Future<bool> signInWithCredentials(String email, String password) async {
    String url = 'https://festiwalnauki.edu.pl/fn-rest/user/login.json';
    print(url);
    Map<String, String> credentials = {
      'username': '$email',
      'password': '$password'
    };

    var userData = await http.post(url, body: credentials);

    if (userData.statusCode == 200) {
      var userJsonData = json.decode(userData.body);
      String sessionId = userJsonData['sessid'];
      String sessionName = userJsonData['session_name'];
      String token = userJsonData['token'];
      String userSession = '$sessionName=$sessionId';
      updateSharedPreferences(userSession, token);
      return true;
    } else
      return false;
  }


  Future<bool> userSignOut(User user) async {
    String url = 'https://festiwalnauki.edu.pl/fn-rest/user/logout.json';
    String token = user.token;
    String userSession = user.userSession;
    Map<String, String> headers = {
      'X-CSRF-Token': '$token',
      'Cookie': '$userSession'
    };

    var request = await http.post(url, headers: headers);
    if (request.statusCode == 200) {
      SharedPreferences sharedPreferences =
          await SharedPreferences.getInstance();
      await sharedPreferences.clear();
      return true;
    } else
      return false;
  }

  Future<bool> isSignedIn(User user) async {
    String url = 'https://festiwalnauki.edu.pl/fn-rest/user/token.json';
    String token = user.token;
    String userSession = user.userSession;
    Map<String, String> headers = {
      'X-CSRF-Token': '$token',
      'Cookie': '$userSession'
    };

    var logged = await http.post(url, headers: headers);
    var loggedJson = json.decode(logged.body);

    return loggedJson['token'] == token;
  }

 /* Future<void> getUser(String userSession, String token) async {
    String url = 'https://festiwalnauki.edu.pl/fn-rest/system/connect.json';
    Map<String, String> headers = {
      'X-CSRF-Token': '$token',
      'Cookie': '$userSession'
    };
    var userData = await http.post(url, headers: headers);
    var userDataJson = json.encode(userData.body);
  }*/

  Future updateSharedPreferences(String userSession, String token) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    await sharedPreferences.setString('userSession', userSession);
    await sharedPreferences.setString('token', token);
  }
}
