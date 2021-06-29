import 'dart:async';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:admin_app/config/extensions.dart';
import 'package:admin_app/model/address.dart';
import 'package:admin_app/model/store.dart';
import 'package:admin_app/model/user.dart';
import 'package:admin_app/repository/address/address_repository.dart';
import 'package:admin_app/repository/store/store_repository.dart';
import 'package:admin_app/repository/user/user_repository.dart';
import 'package:admin_app/service/upload_file_service.dart';

part 'register_event.dart';

part 'register_state.dart';

class RegisterBloc extends Bloc<RegisterEvent, RegisterState> {
  final AddressRepository addressRepository;
  final UserRepository userRepository;
  final StoreRepository storeRepository;
  final UploadFileService uploadFileService;

  RegisterBloc({
    @required this.addressRepository,
    @required this.userRepository,
    @required this.storeRepository,
    @required this.uploadFileService,
  })  : assert(addressRepository != null),
        assert(userRepository != null),
        assert(storeRepository != null),
        assert(uploadFileService != null),
        super(RegisterInitial());

  User _user = null;

  String _storeName;

  String get storeName => _storeName ?? "";

  String _completeAddress;

  String get completeAddress => _completeAddress ?? "";

  Address _address;

  String _coverPhotoUrl;

  String get coverPhotoUrl => _coverPhotoUrl;

  String _profilePhotoUrl;

  String get profilePhotoUrl => _profilePhotoUrl;

  @override
  Stream<RegisterState> mapEventToState(
    RegisterEvent event,
  ) async* {
    yield RegisterInitial();

    try {
      if (event is RegisterStoreDetailsSave) {
        if (_user == null) {
          yield RegisterErrorState(
              err: "User data is null, did you forget to set the user?");
        } else {
          String sameAddressId = null;
          final tmpAddress = _createTempAddress(
              addressName: event.addressName,
              houseNumber: event.houseNumber,
              street: event.street,
              city: event.city,
              country: event.country,
              province: event.province,
              region: event.region,
              municipality: event.municipality,
              barangay: event.barangay,
              zip: event.zip,
              latitude: event.latitude,
              longitude: event.longitude);

          final userAddresses =
              await addressRepository.loadByUserId(userId: _user.id);

          if (userAddresses.isNotEmpty) {
            final userDefaultAddress = userAddresses
                .firstWhere((element) => element.isDefault == true);
            final userAddressesDuplicate = _createTempAddress(
                addressName: userDefaultAddress.name,
                houseNumber: userDefaultAddress.houseNumber,
                street: userDefaultAddress.street,
                city: userDefaultAddress.city,
                country: userDefaultAddress.country,
                province: userDefaultAddress.province,
                region: userDefaultAddress.region,
                municipality: userDefaultAddress.municipality,
                barangay: userDefaultAddress.barangay,
                zip: userDefaultAddress.zip,
                latitude: userDefaultAddress.latitude,
                longitude: userDefaultAddress.longitude);

            if (userAddressesDuplicate == tmpAddress) {
              sameAddressId = userDefaultAddress.id;
            }
          }

          String coverPhotoUrl;
          String profilePhotoUrl;

          if (_coverPhotoUrl != null && !_coverPhotoUrl.startsWith("http")) {
            coverPhotoUrl =
                await uploadFileService.upload(File(_coverPhotoUrl));
          }

          if (_profilePhotoUrl != null &&
              !_profilePhotoUrl.startsWith("http")) {
            profilePhotoUrl =
                await uploadFileService.upload(File(_profilePhotoUrl));
          }

          final store = Store(
              ownerId: _user.id,
              addressId: sameAddressId ??
                  await addressRepository.insert(datum: tmpAddress),
              name: event.storeName,
              contactNumber: event.contactNumber,
              coverUrl: coverPhotoUrl,
              profileUrl: profilePhotoUrl,
              description: event.description);

          final storeId = await storeRepository.insert(datum: store);

          yield RegisterSuccessState();
        }
      } else if (event is RegisterSetStoreNameEvent) {
        yield RegisterSetStoreNameState(storeName: event.storeName);
      } else if (event is RegisterSetAddressEvent) {
        yield RegisterSetAddressState(completeAddress: event.completeAddress);
      } else if (event is RegisterChangedCoverPhotoEvent) {
        _coverPhotoUrl = event.coverPhotoUrl;
        yield RegisterChangedCoverPhotoState(
            coverPhotoUrl: event.coverPhotoUrl);
      } else if (event is RegisterAddressUpdatableEvent) {
        _completeAddress = "";
        yield RegisterAddressUpdatableState();
      } else if (event is RegisterErrorEvent) {
        yield RegisterErrorState(err: event.errorMessage);
      }
    } catch (e) {
      yield RegisterErrorState(err: e);
    }
  }

  void store(
      {String storeName,
      String description,
      String contactNumber,
      String addressName,
      String houseNumber,
      String street,
      String barangay,
      String municipality,
      String city,
      String province,
      String region,
      String zip,
      String country = DEFAULT_COUNTRY,
      String latitude,
      String longitude}) {
    print("save clicked");
    print(
        "location data: $addressName $houseNumber $street $barangay $municipality $city $province $region $zip $country");

    if (addressName == null || addressName.trim().isEmpty) {
      add(RegisterErrorEvent(errorMessage: "Please enter address name"));
      return;
    }

    if (storeName == null || storeName.trim().isEmpty) {
      add(RegisterErrorEvent(errorMessage: "Please enter store name"));
      return;
    }

    if (houseNumber == null || houseNumber.trim().isEmpty) {
      add(RegisterErrorEvent(errorMessage: "Please enter house number"));
      return;
    }

    if (street == null || street.trim().isEmpty) {
      add(RegisterErrorEvent(errorMessage: "Please enter street number"));
      return;
    }

    if (barangay == null || barangay.trim().isEmpty) {
      add(RegisterErrorEvent(errorMessage: "Please enter barangay"));
      return;
    }

    if (municipality == null || municipality.trim().isEmpty) {
      add(RegisterErrorEvent(errorMessage: "Please enter municipality"));
      return;
    }

    if (city == null || city.trim().isEmpty) {
      add(RegisterErrorEvent(errorMessage: "Please enter city"));
      return;
    }

    if (province == null || province.trim().isEmpty) {
      add(RegisterErrorEvent(errorMessage: "Please enter province"));
      return;
    }

    if (region == null || region.trim().isEmpty) {
      add(RegisterErrorEvent(errorMessage: "Please enter region"));
      return;
    }

    if (zip == null || zip.trim().isEmpty) {
      add(RegisterErrorEvent(errorMessage: "Please enter zip code"));
      return;
    }

    if (country == null || country.trim().isEmpty) {
      add(RegisterErrorEvent(errorMessage: "Please enter country"));
      return;
    }

    if (latitude == null ||
        latitude.isEmpty ||
        longitude == null ||
        longitude.isEmpty) {
      add(RegisterErrorEvent(
          errorMessage: "Please open map and select your location"));
      return;
    }

    try {
      final tmpLat = double.parse(latitude);
      final tmpLong = double.parse(longitude);

      add(RegisterStoreDetailsSave(
          storeName: storeName,
          description: description,
          contactNumber: contactNumber,
          street: street,
          city: city,
          region: region,
          zip: zip,
          municipality: municipality,
          province: province,
          houseNumber: houseNumber,
          barangay: barangay,
          country: country,
          addressName: addressName,
          latitude: tmpLat,
          longitude: tmpLong));
    } catch (err) {
      add(RegisterErrorEvent(
          errorMessage: "Latitude or Longitude values are not valid"));
    }
  }

  Address _createTempAddress(
      {String addressName,
      String houseNumber,
      String street,
      String barangay,
      String municipality,
      String city,
      String province,
      String region,
      String zip,
      String country,
      double latitude,
      double longitude}) {
    return Address(
        id: null,
        userId: null,
        isDefault: null,
        latitude: latitude,
        longitude: longitude,
        street: street,
        city: city,
        region: region,
        zip: zip,
        municipality: municipality,
        province: province,
        houseNumber: houseNumber,
        barangay: barangay,
        name: addressName,
        country: country);
  }

  void setUser(User user) async {
    if (this._user == null) {
      this._user = user;
      this._storeName = "${_user.name}'s store";
      final addressList =
          await addressRepository.loadByUserId(userId: _user.id);

      if (addressList.isNotEmpty) {
        _address = addressList.firstWhere((element) => element.isDefault);
        _completeAddress = "";

        if (_address.name != null) _completeAddress += "${_address.name}, ";

        if (_address.houseNumber != null)
          _completeAddress += "${_address.houseNumber} ";

        if (_address.street != null) _completeAddress += "${_address.street}, ";

        if (_address.barangay != null)
          _completeAddress += "${_address.barangay}, ";

        if (_address.municipality != null)
          _completeAddress += "${_address.municipality}, ";

        if (_address.city != null) _completeAddress += "${_address.city}, ";

        if (_address.province != null)
          _completeAddress += "${_address.province}, ";

        if (_address.country != null)
          _completeAddress += "${_address.country}, ";

        if (_address.zip != null) _completeAddress += "${_address.zip} ";
      }
    }
  }

  void setCoverPhotoUrl(String url) {
    add(RegisterChangedCoverPhotoEvent(coverPhotoUrl: url));
  }

  void setAddressUpdatable() {
    add(RegisterAddressUpdatableEvent());
  }
}
