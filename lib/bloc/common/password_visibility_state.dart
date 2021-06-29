part of 'password_visibility_cubit.dart';

abstract class PasswordVisibilityState extends Equatable {
  final bool visibility;
  const PasswordVisibilityState(this.visibility);

  @override
  List<Object> get props => [visibility];
}

class PasswordVisibilityVisible extends PasswordVisibilityState {
  PasswordVisibilityVisible() : super(true);
}

class PasswordVisibilityHidden extends PasswordVisibilityState {
  PasswordVisibilityHidden() : super(false);
}
