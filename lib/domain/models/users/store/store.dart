import 'package:diakron_admin/domain/models/users/user_base/user_base.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'store.freezed.dart';
part 'store.g.dart';

// User base with conversion from camelCase to snake_case
// gen freezed files with $ dart run build_runner build --delete-conflicting-outputs

@freezed
abstract class Store with _$Store implements UserBase {
  @JsonSerializable(fieldRename: FieldRename.snake)
  const factory Store({ 
    // UserBase fields
    required String id,
    required String userName,
    required String surnames,
    required String phoneNumber,
    required bool isActive,
    required String userType,
    required DateTime createdAt,

    // Store fields
    String? companyName,
    String? rfc,
    String? address,
  }) = _Store;

  factory Store.fromJson(Map<String, Object?> json) =>
      _$StoreFromJson(json);
}
