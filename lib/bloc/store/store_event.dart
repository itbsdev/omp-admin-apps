part of 'store_bloc.dart';

abstract class StoreEvent extends Equatable {
  const StoreEvent();
}

class StoreChangedNameEvent extends StoreEvent {
  final String name;

  const StoreChangedNameEvent({@required this.name})
      : assert(name != null),
        super();

  @override
  List<Object> get props => [this.name];
}

class StoreChangedDescriptionEvent extends StoreEvent {
  final String description;

  const StoreChangedDescriptionEvent({@required this.description})
      : assert(description != null),
        super();

  @override
  List<Object> get props => [this.description];
}

class StoreUpdateEvent extends StoreEvent {
  final Store store;
  final Address address;

  const StoreUpdateEvent({@required this.store, @required this.address})
      : assert(store != null),
        assert(address != null),
        super();

  @override
  List<Object> get props => [this.store, this.address];
}

class StoreChangedCoverPhotoEvent extends StoreEvent {
  final String url;

  const StoreChangedCoverPhotoEvent({@required this.url})
      : assert(url != null),
        super();

  @override
  List<Object> get props => [this.url];
}

class StoreChangedProfilePhotoEvent extends StoreEvent {
  final String url;

  const StoreChangedProfilePhotoEvent({@required this.url})
      : assert(url != null),
        super();

  @override
  List<Object> get props => [this.url];
}

class StoreSelectedEvent extends StoreEvent {
  @override
  List<Object> get props => [];
}

class StoreErrorEvent extends StoreEvent {
  final String errorMessage;

  const StoreErrorEvent({ this.errorMessage }): super();

  @override
  List<Object> get props => [this.errorMessage];

}
