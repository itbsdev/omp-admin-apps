import 'dart:async';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:admin_app/model/address.dart';
import 'package:admin_app/model/store.dart';
import 'package:admin_app/repository/address/address_repository.dart';
import 'package:admin_app/repository/store/store_repository.dart';
import 'package:admin_app/repository/user/user_repository.dart';
import 'package:admin_app/service/upload_file_service.dart';

part 'store_event.dart';

part 'store_state.dart';

class StoreBloc extends Bloc<StoreEvent, StoreState> {
  final StoreRepository storeRepository;
  final UserRepository userRepository;
  final AddressRepository addressRepository;
  final UploadFileService uploadFileService;

  StoreBloc(
      {@required this.storeRepository,
      @required this.userRepository,
      @required this.addressRepository,
      @required this.uploadFileService})
      : assert(storeRepository != null),
        assert(userRepository != null),
        assert(addressRepository != null),
        assert(uploadFileService != null),
        super(StoreInitial());

  Store _store;

  Address _address;

  Address get address => _address;

  Store get store => _store;

  String _name;

  String get name => _name ?? "";

  String _description;

  String get description => _description ?? "";

  String _coverPhotoUrl;

  String get coverPhotoUrl => _coverPhotoUrl;

  String _profilePhotoUrl;

  String get profilePhotoUrl => _profilePhotoUrl;

  @override
  Stream<StoreState> mapEventToState(
    StoreEvent event,
  ) async* {
    yield StoreInitial();

    try {
      if (event is StoreChangedNameEvent) {
        _name = event.name;
        yield StoreChangedNameState(name: event.name);
      } else if (event is StoreChangedDescriptionEvent) {
        _description = event.description;
        yield StoreChangedDescriptionState(description: event.description);
      } else if (event is StoreUpdateEvent) {
        if (event.address != _address) {
          await addressRepository.update(datum: event.address);
          _address = event.address;
        }

        if (_coverPhotoUrl != null && !_coverPhotoUrl.startsWith("http")) {
          event.store.coverUrl = await uploadFileService.upload(File(_coverPhotoUrl));
        }

        if (_profilePhotoUrl != null && !_profilePhotoUrl.startsWith("http")) {
          event.store.profileUrl = await uploadFileService.upload(File(_profilePhotoUrl));
        }



        await storeRepository.update(datum: event.store);

        yield StoreSuccessState();
      } else if (event is StoreChangedCoverPhotoEvent) {
        _coverPhotoUrl = event.url;
        yield StoreChangedCoverPhotoState(url: event.url);
      } else if (event is StoreChangedProfilePhotoEvent) {
        _profilePhotoUrl = event.url;
        yield StoreChangedProfilePhotoState(url: event.url);
      } else if (event is StoreSelectedEvent) {
        yield StoreSelectedState();
      } else if (event is StoreErrorEvent) {
        yield StoreErrorState(err: event.errorMessage);
      }
    } catch (err) {
      yield StoreErrorState(err: err.toString());
    }
  }

  void setStoreName(String name) {
    add(StoreChangedNameEvent(name: name));
  }

  void setDescription(String description) {
    add(StoreChangedDescriptionEvent(description: description));
  }

  void setCoverPhotoUrl(String url) {
    add(StoreChangedCoverPhotoEvent(url: url));
  }

  void setProfilePhotoUrl(String url) {
    add(StoreChangedProfilePhotoEvent(url: url));
  }

  void save({
    String addressName,
    String houseNumber,
    String street,
    String barangay,
    String municipality,
    String city,
    String province,
    String region,
    String zip,
    String country,
    String latitude,
    String longitude
  }) {
    print("save clicked");
    print(
        "location data: $addressName $houseNumber $street $barangay $municipality $city $province $region $zip $country $latitude $longitude");
    // create temp address for comparison with the latest address the  user declared in store.
    // pre-populate with some data that are not enterable by the user.
    if (addressName == null || addressName.trim().isEmpty) {
      add(StoreErrorEvent(errorMessage: "Please enter address name"));
      return;
    }

    // if (houseNumber == null || houseNumber.trim().isEmpty) {
    //   add(StoreErrorEvent(errorMessage: "Please enter house number"));
    //   return;
    // }

    // if (street == null || street.trim().isEmpty) {
    //   add(StoreErrorEvent(errorMessage: "Please enter street number"));
    //   return;
    // }

    if (barangay == null || barangay.trim().isEmpty) {
      add(StoreErrorEvent(errorMessage: "Please enter barangay"));
      return;
    }

    // if (municipality == null || municipality.trim().isEmpty) {
    //   add(StoreErrorEvent(errorMessage: "Please enter municipality"));
    //   return;
    // }

    // if (city == null || city.trim().isEmpty) {
    //   add(StoreErrorEvent(errorMessage: "Please enter city"));
    //   return;
    // }

    if (province == null || province.trim().isEmpty) {
      add(StoreErrorEvent(errorMessage: "Please enter province"));
      return;
    }

    if (region == null || region.trim().isEmpty) {
      add(StoreErrorEvent(errorMessage: "Please enter region"));
      return;
    }

    if (zip == null || zip.trim().isEmpty) {
      add(StoreErrorEvent(errorMessage: "Please enter zip code"));
      return;
    }

    if (country == null || country.trim().isEmpty) {
      add(StoreErrorEvent(errorMessage: "Please enter country"));
      return;
    }

    if (latitude == null ||
        latitude.isEmpty ||
        longitude == null ||
        longitude.isEmpty) {
      add(StoreErrorEvent(
          errorMessage: "Please open map and select your location"));
      return;
    }

    try {
      Address tmpAddress;
      final tmpLat = double.parse(latitude);
      final tmpLong = double.parse(longitude);

      if (_address == null) {
        tmpAddress = Address(
          street: street,
          city: city,
          region: region,
          zip: zip,
          municipality: municipality,
          province: province,
          houseNumber: houseNumber,
          barangay: barangay,
          country: country,
          name: addressName,
          latitude: tmpLat,
          longitude: tmpLong
        );
      } else {
        tmpAddress = Address(
          id: _address.id,
          userId: _address.userId,
          isDefault: _address.isDefault,
          latitude: tmpLat,
          longitude: tmpLong,
          street: street,
          city: city,
          region: region,
          zip: zip,
          municipality: municipality,
          province: province,
          houseNumber: houseNumber,
          barangay: barangay,
          country: country,
          name: addressName,
          createdAt: _address.createdAt,
          updatedAt: _address.updatedAt,
          deletedAt: _address.deletedAt,
        );
      }

      final Store store = Store(
          id: _store.id,
          name: _name,
          description: _description,
          ownerId: _store.ownerId,
          contactNumber: _store.contactNumber,
          profileUrl: _store.profileUrl,
          coverUrl: _store.coverUrl,
          addressId: _address.id,
          createdAt: _store.createdAt,
          updatedAt: _store.updatedAt,
          deletedAt: _store.deletedAt
      );

      add(StoreUpdateEvent(store: store, address: tmpAddress));
    } catch(err) {
      print("err: $err");
    }
  }
}
