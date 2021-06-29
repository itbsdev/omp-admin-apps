part of 'reports_bloc.dart';

extension UsersReportsBloc on ReportsBloc {
  void _provideUserGenderGrouping({@required List<User> users}) {
    assert(users != null);

    final userGenderGroupings = users.groupListsBy((user) => user.gender);

    add(UserGroupedByGenderEvent(userGroupedGender: userGenderGroupings));
  }

  void _provideUserMerchantRiderGroupings(
      {@required List<User> users,
      @required List<Rider> riders,
      @required List<Store> stores}) {
    assert(users != null);
    assert(riders != null);
    assert(stores != null);

    List<Rider> filteredRiders = riders;
    List<Store> filteredStores = stores;
    List<User> filteredUsers = users;

    if (_selectedStartDate != null && _selectedEndDate != null) {
      filteredRiders = riders
          .where((element) =>
      element.createdAt >= _selectedStartDate.millisecondsSinceEpoch &&
          element.createdAt <= _selectedEndDate.millisecondsSinceEpoch)
          .toList();
      filteredStores = stores.where((element) =>
      element.createdAt >= _selectedStartDate.millisecondsSinceEpoch &&
          element.createdAt <= _selectedEndDate.millisecondsSinceEpoch)
          .toList();

      filteredUsers = users.where((element) =>
      element.createdAt >= _selectedStartDate.millisecondsSinceEpoch &&
          element.createdAt <= _selectedEndDate.millisecondsSinceEpoch)
          .toList();
    }

    final List<User> storeOwners = [];
    final List<User> riderOwners = [];

    filteredUsers.forEach((user) {
      final bool isRider =
          filteredRiders.firstWhereOrNull((rider) => rider.userId == user.id) != null;
      final bool isMerchant =
          filteredStores.firstWhereOrNull((store) => store.ownerId == user.id) != null;

      if (isRider) riderOwners.add(user);

      if (isMerchant) storeOwners.add(user);
    });

    add(UserGroupedByMerchantRiderEvent(
        storeOwners: storeOwners, riderOwners: riderOwners));
  }

  void _provideUserAgeGroupings({@required List<User> users}) {
    assert(users != null);
    List<User> filteredUsers = users;

    if (_selectedStartDate != null && _selectedEndDate != null) {
      filteredUsers = users.where((element) =>
      element.createdAt >= _selectedStartDate.millisecondsSinceEpoch &&
          element.createdAt <= _selectedEndDate.millisecondsSinceEpoch)
          .toList();
    }

    final userGroupedByAge = filteredUsers.groupListsBy((user) =>
        _convertBirthDateToAgeGroup(
            birthDate: DateTime.fromMillisecondsSinceEpoch(user.birthDate)));

    add(UserGroupedByAgeEvent(userGroupedByAge: userGroupedByAge));
  }

  /// this function will convert the birth date to age group
  /// Age groups are based on:
  /// A: 0 - 10
  /// B: 11 - 19
  /// C: 20 - 29
  /// D: 30 - 39
  /// E: 40 - 49
  /// F: 50 - 59
  /// G" 60 - 69
  /// H 70 - 79
  /// I: 80 - 89
  /// J: 90 - 99
  /// K: 100 above
  String _convertBirthDateToAgeGroup({@required DateTime birthDate}) {
    final now = Jiffy();
    final jiffyBirthDate = Jiffy(birthDate);
    final diff = now.diff(jiffyBirthDate, Units.YEAR);

    if (_diffNumber(diff: diff, base: 0, ceiling: 10)) {
      return "0 - 10 y.o";
    } else if (_diffNumber(diff: diff, base: 11, ceiling: 19)) {
      return "11 - 19 y.o";
    } else if (_diffNumber(diff: diff, base: 20, ceiling: 29)) {
      return "20 - 29 y.o";
    } else if (_diffNumber(diff: diff, base: 30, ceiling: 39)) {
      return "30 - 39 y.o";
    } else if (_diffNumber(diff: diff, base: 40, ceiling: 49)) {
      return "40 - 49 y.o";
    } else if (_diffNumber(diff: diff, base: 50, ceiling: 59)) {
      return "50 - 59 y.o";
    } else if (_diffNumber(diff: diff, base: 60, ceiling: 69)) {
      return "60 - 69 y.o";
    } else if (_diffNumber(diff: diff, base: 70, ceiling: 79)) {
      return "70 - 79 y.o";
    } else if (_diffNumber(diff: diff, base: 80, ceiling: 89)) {
      return "80 - 89 y.o";
    } else if (_diffNumber(diff: diff, base: 90, ceiling: 99)) {
      return "90 - 99 y.o";
    } else /*if (diff >= 100)*/ {
      return ">= 100 y.o";
    }
  }

  bool _diffNumber({num diff, num base, num ceiling}) {
    assert(diff != null);
    assert(base != null);
    assert(ceiling != null);
    return diff >= base && diff <= ceiling;
  }
}
