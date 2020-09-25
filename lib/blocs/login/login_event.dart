part of 'login_bloc.dart';

abstract class LoginEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class LoginWithCredentialsPressed extends LoginEvent {
  final String email;
  final String password;
  LoginWithCredentialsPressed(this.email,this.password);

  @override
  List<Object> get props => [email, password];
}