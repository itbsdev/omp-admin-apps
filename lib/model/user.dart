import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:json_annotation/json_annotation.dart';

part 'user.g.dart';

@JsonSerializable(nullable: false)
class User extends Equatable {
  final String id;
  final String userId; // userId from CPA
  final String
      idType; // from verify api -- type of id the user associated with it's profile.. ??
  final String name;
  final String email;
  final String mobileNumber;
  final num createdAt;
  final num updatedAt;
  final num deletedAt;
  String mediaUrl;
  final UserRole role;
  final Gender gender;
  final num birthDate;

  User(
      {@required this.id,
      @required this.idType,
      @required this.name,
      @required this.email,
      @required this.mobileNumber,
      @required this.userId,
      @required this.createdAt,
      @required this.updatedAt,
      @required this.deletedAt,
      @required this.birthDate,
      @required this.gender,
      this.mediaUrl,
      this.role});

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);

  Map<String, dynamic> toJson() => _$UserToJson(this);

  @override
  List<Object> get props => [
        this.id,
        this.idType,
        this.name,
        this.email,
        this.mobileNumber,
        this.userId,
        this.createdAt,
        this.updatedAt,
        this.deletedAt,
        this.mediaUrl,
        this.birthDate,
        this.gender
      ];
}

enum UserRole { ADMIN, USER, CUSTOMER }

enum Gender { MALE, FEMALE }
