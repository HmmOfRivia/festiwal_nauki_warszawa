part of 'login_bloc.dart';

class LoginState{
  final bool isSubmitting;
  final bool isSuccess;
  final bool isFailure;
  LoginState({this.isSubmitting, this.isFailure, this.isSuccess});

  factory LoginState.initial(){
    return LoginState(
      isSubmitting: false,
      isSuccess: false,
      isFailure: false,
    );
  }

  factory LoginState.loading() {
    return LoginState(
      isSubmitting: true,
      isSuccess: false,
      isFailure: false,
    );
  }

  factory LoginState.success() {
    return LoginState(
      isSubmitting: false,
      isSuccess: true,
      isFailure: false,
    );
  }

  factory LoginState.failure() {
    return LoginState(
      isSubmitting: false,
      isSuccess: false,
      isFailure: true,
    );
  }
}

