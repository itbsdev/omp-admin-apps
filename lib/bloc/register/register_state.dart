part of 'register_bloc.dart';

abstract class RegisterState extends Equatable {
  const RegisterState();
}

class RegisterInitial extends RegisterState {
  @override
  List<Object> get props => [];
}

class RegisterLoadingState extends RegisterState {
  @override
  List<Object> get props => [];
}

class RegisterSuccessState extends RegisterState {
  @override
  List<Object> get props => [];
}

class RegisterErrorState extends RegisterState {
  final String err;

  const RegisterErrorState({@required this.err}): assert(err != null), super();

  @override
  List<Object> get props => [this.err];
}

class RegisterSetAddressState extends RegisterState {
  final String completeAddress;

  const RegisterSetAddressState({@required this.completeAddress}): assert(completeAddress != null), super();

  @override
  List<Object> get props => [this.completeAddress];
}

class RegisterSetStoreNameState extends RegisterState {
  final String storeName;

  const RegisterSetStoreNameState({@required this.storeName}): assert(storeName != null), super();

  @override
  List<Object> get props => [this.storeName];
}

class RegisterChangedCoverPhotoState extends RegisterState {
  final String coverPhotoUrl;

  const RegisterChangedCoverPhotoState({@required this.coverPhotoUrl}): assert(coverPhotoUrl != null), super();

  @override
  List<Object> get props => [this.coverPhotoUrl];
}

class RegisterAddressUpdatableState extends RegisterState {
  const RegisterAddressUpdatableState(): super();

  @override
  List<Object> get props => [];
}
