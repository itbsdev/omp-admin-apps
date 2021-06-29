part of 'settings_bloc.dart';

abstract class SettingsEvent extends Equatable {
  const SettingsEvent();
}

class SettingsErrorEvent extends SettingsEvent {
  final String message;

  const SettingsErrorEvent({@required this.message})
      : assert(message != null),
        super();

  @override
  List<Object> get props => [
        this.message,
      ];
}

class LatestAdminSettingsLoadedEvent extends SettingsEvent {
  final AdminSettings settings;

  const LatestAdminSettingsLoadedEvent({@required this.settings})
      : assert(settings != null),
        super();

  @override
  List<Object> get props => [this.settings];
}

class SaveAdminSettingsEvent extends SettingsEvent {
  final AdminSettings settings;

  const SaveAdminSettingsEvent({@required this.settings})
      : assert(settings != null),
        super();

  @override
  List<Object> get props => [this.settings];
}
