part of 'register_bloc.dart';

abstract class RegisterEvent extends Equatable {
  const RegisterEvent();
}

class RegisterStoreDetailsSave extends RegisterEvent {
  final String storeName;

  final String description;

  final String contactNumber;

  final String addressName;

  final String houseNumber;

  final String street;

  final String barangay;

  final String municipality;

  final String city;

  final String province;

  final String region;

  final String zip;

  final String country;

  final double latitude;

  final double longitude;

  const RegisterStoreDetailsSave({
    @required this.storeName,
    @required this.description,
    @required this.contactNumber,
    @required this.addressName,
    @required this.houseNumber,
    @required this.street,
    @required this.barangay,
    @required this.municipality,
    @required this.city,
    @required this.province,
    @required this.region,
    @required this.zip,
    @required this.country,
    @required this.longitude,
    @required this.latitude,
}): assert(storeName != null),
        assert(description != null),
        assert(contactNumber != null),
        assert(addressName != null),
        assert(houseNumber != null),
        assert(street != null),
        assert(barangay != null),
        assert(municipality != null),
        assert(city != null),
        assert(province != null),
        assert(region != null),
        assert(zip != null),
        assert(country != null),
        super();

  @override
  List<Object> get props => [
    this.storeName,
    this.description,
    this.contactNumber,
    this.addressName,
    this.houseNumber,
    this.street,
    this.barangay,
    this.municipality,
    this.city,
    this.province,
    this.region,
    this.zip,
    this.country,
    this.latitude,
    this.longitude,
  ];
}

class RegisterSetAddressEvent extends RegisterEvent {
  final String completeAddress;

  const RegisterSetAddressEvent({@required this.completeAddress}): assert(completeAddress != null), super();

  @override
  List<Object> get props => [this.completeAddress];
}

class RegisterSetStoreNameEvent extends RegisterEvent {
  final String storeName;

  const RegisterSetStoreNameEvent({@required this.storeName}): assert(storeName != null), super();

  @override
  List<Object> get props => [this.storeName];
}

class RegisterChangedCoverPhotoEvent extends RegisterEvent {
  final String coverPhotoUrl;

  const RegisterChangedCoverPhotoEvent({@required this.coverPhotoUrl}): assert(coverPhotoUrl != null), super();

  @override
  List<Object> get props => [this.coverPhotoUrl];
}

class RegisterAddressUpdatableEvent extends RegisterEvent {
  const RegisterAddressUpdatableEvent(): super();

  @override
  List<Object> get props => [];
}

class RegisterErrorEvent extends RegisterEvent {
  final String errorMessage;

  const RegisterErrorEvent({ this.errorMessage }): super();

  @override
  List<Object> get props => [this.errorMessage];
}
