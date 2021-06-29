// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

User _$UserFromJson(Map<String, dynamic> json) {
  return User(
    id: json['id'] as String,
    idType: json['idType'] as String,
    name: json['name'] as String,
    email: json['email'] as String,
    mobileNumber: json['mobileNumber'] as String,
    userId: json['userId'] as String,
    createdAt: json['createdAt'] as num,
    updatedAt: json['updatedAt'] as num,
    deletedAt: json['deletedAt'] as num,
    birthDate: json['birthDate'] as num,
    gender: _$enumDecode(_$GenderEnumMap, json['gender']),
    mediaUrl: json['mediaUrl'] as String,
    role: _$enumDecode(_$UserRoleEnumMap, json['role']),
  );
}

Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'idType': instance.idType,
      'name': instance.name,
      'email': instance.email,
      'mobileNumber': instance.mobileNumber,
      'createdAt': instance.createdAt,
      'updatedAt': instance.updatedAt,
      'deletedAt': instance.deletedAt,
      'mediaUrl': instance.mediaUrl,
      'role': _$UserRoleEnumMap[instance.role],
      'gender': _$GenderEnumMap[instance.gender],
      'birthDate': instance.birthDate,
    };

T _$enumDecode<T>(
  Map<T, dynamic> enumValues,
  dynamic source, {
  T unknownValue,
}) {
  if (source == null) {
    throw ArgumentError('A value must be provided. Supported values: '
        '${enumValues.values.join(', ')}');
  }

  final value = enumValues.entries
      .singleWhere((e) => e.value == source, orElse: () => null)
      ?.key;

  if (value == null && unknownValue == null) {
    throw ArgumentError('`$source` is not one of the supported values: '
        '${enumValues.values.join(', ')}');
  }
  return value ?? unknownValue;
}

const _$GenderEnumMap = {
  Gender.MALE: 'MALE',
  Gender.FEMALE: 'FEMALE',
};

const _$UserRoleEnumMap = {
  UserRole.ADMIN: 'ADMIN',
  UserRole.USER: 'USER',
  UserRole.CUSTOMER: 'CUSTOMER',
};
