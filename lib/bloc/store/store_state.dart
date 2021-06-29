part of 'store_bloc.dart';

abstract class StoreState extends Equatable {
  const StoreState();
}

class StoreInitial extends StoreState {
  @override
  List<Object> get props => [];
}

class StoreChangedNameState extends StoreState {
  final String name;

  const StoreChangedNameState({@required this.name}): assert(name != null), super();

  @override
  List<Object> get props => [this.name];
}

class StoreSuccessState extends StoreState {
  @override
  List<Object> get props => [];
}

class StoreErrorState extends StoreState {
  final String err;

  const StoreErrorState({this.err}): super();

  @override
  List<Object> get props => [this.err];
}

class StoreChangedDescriptionState extends StoreState {
  final String description;

  const StoreChangedDescriptionState({@required this.description})
      : assert(description != null),
        super();

  @override
  List<Object> get props => [this.description];
}

class StoreChangedCoverPhotoState extends StoreState {
  final String url;

  const StoreChangedCoverPhotoState({@required this.url})
      : assert(url != null),
        super();

  @override
  List<Object> get props => [this.url];
}

class StoreChangedProfilePhotoState extends StoreState {
  final String url;

  const StoreChangedProfilePhotoState({@required this.url})
      : assert(url != null),
        super();

  @override
  List<Object> get props => [this.url];
}

class StoreSelectedState extends StoreState {
  @override
  List<Object> get props => [];
}
