// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'store.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Store _$StoreFromJson(Map<String, dynamic> json) => _Store(
  id: json['id'] as String,
  userName: json['user_name'] as String,
  surnames: json['surnames'] as String,
  phoneNumber: json['phone_number'] as String,
  isActive: json['is_active'] as bool,
  userType: json['user_type'] as String,
  createdAt: DateTime.parse(json['created_at'] as String),
  companyName: json['company_name'] as String?,
  rfc: json['rfc'] as String?,
  address: json['address'] as String?,
);

Map<String, dynamic> _$StoreToJson(_Store instance) => <String, dynamic>{
  'id': instance.id,
  'user_name': instance.userName,
  'surnames': instance.surnames,
  'phone_number': instance.phoneNumber,
  'is_active': instance.isActive,
  'user_type': instance.userType,
  'created_at': instance.createdAt.toIso8601String(),
  'company_name': instance.companyName,
  'rfc': instance.rfc,
  'address': instance.address,
};
