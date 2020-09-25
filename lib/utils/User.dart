class User {
  String userSession;
  String token;
  User(this.userSession, this.token);

  Map toJson() => {'sessionId': userSession, 'token': token};

  User.fromJson(Map json)
      : userSession = json['sessionId'],
        token = json['token'];
}
