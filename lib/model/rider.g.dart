// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'rider.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Rider _$RiderFromJson(Map<String, dynamic> json) {
  return Rider(
    id: json['id'] as String,
    userId: json['userId'] as String,
    name: json['name'] as String,
    email: json['email'] as String,
    mobileNumber: json['mobileNumber'] as String,
    birthDate: json['birthDate'] as num,
    mediaUrl: json['mediaUrl'] as String,
    availability: json['availability'] as bool,
    createdAt: json['createdAt'] as num,
    updatedAt: json['updatedAt'] as num,
    deletedAt: json['deletedAt'] as num,
    serviceAvailability: (json['serviceAvailability'] as List)
        ?.map((e) => _$enumDecodeNullable(_$RiderServiceTypeEnumMap, e))
        ?.toList(),
    deletedNote: json['deletedNote'] as String,
  );
}

Map<String, dynamic> _$RiderToJson(Rider instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'email': instance.email,
      'mobileNumber': instance.mobileNumber,
      'birthDate': instance.birthDate,
      'mediaUrl': instance.mediaUrl,
      'availability': instance.availability,
      'userId': instance.userId,
      'createdAt': instance.createdAt,
      'serviceAvailability': instance.serviceAvailability
          ?.map((e) => _$RiderServiceTypeEnumMap[e])
          ?.toList(),
      'updatedAt': instance.updatedAt,
      'deletedAt': instance.deletedAt,
      'deletedNote': instance.deletedNote,
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

T _$enumDecodeNullable<T>(
  Map<T, dynamic> enumValues,
  dynamic source, {
  T unknownValue,
}) {
  if (source == null) {
    return null;
  }
  return _$enumDecode<T>(enumValues, source, unknownValue: unknownValue);
}

const _$RiderServiceTypeEnumMap = {
  RiderServiceType.PADALA: 'PADALA',
  RiderServiceType.PABILI: 'PABILI',
  RiderServiceType.PASAKAY: 'PASAKAY',
  RiderServiceType.ORDER: 'ORDER',
};
