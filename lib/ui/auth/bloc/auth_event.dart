part of 'auth_bloc.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object> get props => [];
}

class AuthStatrted extends AuthEvent {}

class AuthButtonClicked extends AuthEvent {
  final String username;
  final String password;

  const AuthButtonClicked(this.username, this.password);
}

class AuthModeChangedClicked extends AuthEvent {}
