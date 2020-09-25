import 'package:festiwal_nauki_warszawa/utils/DetailEvent.dart';
import 'package:festiwal_nauki_warszawa/utils/User.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
class DetailEventRepository{
  String nid;
  DetailEventRepository(this.nid);
  String baseUrl = 'https://festiwalnauki.edu.pl/fn-rest/node/';

  Future<void> getDetails() async{
    User user = await getUserFromSharedPreferences();
    Map<String, String> requestHeaders = {
      'Cookie': user.userSession.toString(),
      'Content-Type': 'application/json',
      'X-CSRF-Token': user.token.toString()
    };

    var detailData = await http.get(baseUrl + nid, headers: requestHeaders);
    var jsonData = json.decode(detailData.body);

    DetailEvent event = DetailEvent(jsonData['title'], jsonData['type'], jsonData['body']['und'][0]['value'],
        jsonData['field_termin']['und'][0]['value'], jsonData['field_lokalizacja']['und'][0]['thoroughfare'],
        jsonData['field_lokalizacja']['und'][0]['postal_code'], jsonData['field_lokalizacja_dodatkowe_info']);
    return event;
  }
  }

  Future<User> getUserFromSharedPreferences() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String userSession = sharedPreferences.getString('userSession');
    String token = sharedPreferences.getString('token');
    return User(userSession, token);
}