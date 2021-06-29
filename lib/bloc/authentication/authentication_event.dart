part of 'authentication_bloc.dart';

abstract class AuthenticationEvent extends Equatable {
  const AuthenticationEvent();
}

class LoginEvent extends AuthenticationEvent {
  final String userName;
  final String password;

  const LoginEvent({
    @required this.userName,
    @required this.password
}): assert(userName != null), assert(password != null), super();

  @override
  List<Object> get props => [
    this.userName,
    this.password
  ];
}

class LogoutEvent extends AuthenticationEvent {
  @override
  List<Object> get props => [];
}
