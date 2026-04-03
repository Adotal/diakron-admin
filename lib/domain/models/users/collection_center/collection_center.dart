import 'package:diakron_admin/domain/models/users/user_base/user_base.dart';
import 'package:diakron_admin/domain/models/core/validation_status/validation_status.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'collection_center.freezed.dart';
part 'collection_center.g.dart';

@freezed
abstract class CollectionCenter with _$CollectionCenter implements UserBase {
  @JsonSerializable(fieldRename: FieldRename.snake)
  const factory CollectionCenter({
    // UserBase fields
    required String? id,
    required String? userName,
    required String? surnames,
    required String? phoneNumber,
    required bool? isActive,
    required String? userType,
    required DateTime? createdAt,

    // Collection center fields
    String? companyName,
    String? rfc,
    String? taxRegime,
    String? curpRep,
    String? bank,
    String? clabe,
    String? commercialName,
    String? address,
    String? billingEmail,
    String? taxpayerType,
    String? postCode,
    Map<String, dynamic>? schedule,

    // Document Paths
    String? pathIdRep,
    String? pathProofAddress,
    String? pathTaxCertificate,

    @Default(ValidationStatus.uploading) String? validationStatus,

  }) = _CollectionCenter;

  // @override
  factory CollectionCenter.fromJson(Map<String, Object?> json) =>
      _$CollectionCenterFromJson(json);
}
