part of 'authentication_bloc.dart';

abstract class AuthenticationState extends Equatable {
  @override
  List<Object> get props => [];
}

class AuthenticationInitial extends AuthenticationState {}

class AuthenticationSuccess extends AuthenticationState {
  final User user;
  AuthenticationSuccess(this.user);
}

class AuthenticationFailure extends AuthenticationState {}