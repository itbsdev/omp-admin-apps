part of 'authentication_bloc.dart';

abstract class AuthenticationState extends Equatable {
  const AuthenticationState();
}

class AuthenticationInitial extends AuthenticationState {
  @override
  List<Object> get props => [];
}

class AuthenticationSuccessState extends AuthenticationState {
  @override
  List<Object> get props => [];
}

class AuthenticationErrorState extends AuthenticationState {
  final String err;

  const AuthenticationErrorState({@required this.err}): super();
  @override
  List<Object> get props => [this.err];
}

class AuthenticationLoadingState extends AuthenticationState {
  @override
  List<Object> get props => [];
}

class UserNoStoreDetectedState extends AuthenticationState {
  final Me.User user;

  const UserNoStoreDetectedState({@required this.user}): assert(user != null), super();

  @override
  List<Object> get props => [this.user];
}

class LogoutState extends AuthenticationState {
  @override
  List<Object> get props => [];
}
