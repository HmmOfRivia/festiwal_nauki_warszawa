import 'package:festiwal_nauki_warszawa/utils/Event.dart';
import 'package:festiwal_nauki_warszawa/utils/User.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class EventsTableRepository {
  List<Event> meetingsList = [];
  List<Event> expoList = [];
  List<Event> lecturesList = [];
  Future getEvents({String url, int listReturned}) async {
    User user = await getUserFromSharedPreferences();
    Map<String, String> requestHeaders = {
      'Cookie': user.userSession.toString(),
      'Content-Type': 'application/json',
      'X-CSRF-Token': user.token.toString()
    };
    var eventsData = await http.get(url, headers: requestHeaders);

    var jsonData = json.decode(eventsData.body);

    for (var x in jsonData) {
      var domain;
      if (x['Dziedzina'].length == 1) {
        domain = 'Brak danych';
      } else {
        domain = x['Dziedzina'];
      }
      try {
        Event event = Event(
            x['nid'],
            domain,
            x['Forma'],
            x['Organizatorzy'],
            x['Termin'][0]['value'],
            x['Lokalizacja']['locality'],
            x['Lokalizacja']['postal_code'],
            x['Lokalizacja']['thoroughfare'],
            x['Tytuł i opis'],
            x['field_opis_do_prasy']);
        switch (listReturned) {
          case 0: { meetingsList.add(event); }
          break;
          case 1: { expoList.add(event); }
          break;
          case 2: { lecturesList.add(event); }
          break;
          case 3: { meetingsList.add(event); }
        }
      } on Exception catch (e) {}
    }
  }
}

Future<User> getUserFromSharedPreferences() async {
  SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  String userSession = sharedPreferences.getString('userSession');
  String token = sharedPreferences.getString('token');
  return User(userSession, token);
}
