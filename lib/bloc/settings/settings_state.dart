part of 'settings_bloc.dart';

abstract class SettingsState extends Equatable {
  const SettingsState();
}

class SettingsInitial extends SettingsState {
  @override
  List<Object> get props => [];
}

class LatestAdminSettingsLoadedState extends SettingsState {
  final AdminSettings settings;

  const LatestAdminSettingsLoadedState({@required this.settings})
      : assert(settings != null),
        super();

  @override
  List<Object> get props => [this.settings];
}

class SettingsErrorState extends SettingsState {
  final String message;

  const SettingsErrorState({ @required this.message }): assert(message != null), super();

  @override
  List<Object> get props => [this.message];

}

class SettingsSuccessState extends SettingsState {
  final dynamic data;
  final String message;

  const SettingsSuccessState({ this.data, @required this.message}): assert(message != null), super();

  @override
  List<Object> get props => [
    this.data,
    this.message
  ];

}
