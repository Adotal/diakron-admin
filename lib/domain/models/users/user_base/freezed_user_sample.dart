// import 'package:freezed_annotation/freezed_annotation.dart';

// part 'user_base.freezed.dart';
// part 'user_base.g.dart';

// // User base with conversion from camelCase to snake_case
// // gen freezed files with $ dart run build_runner build --delete-conflicting-outputs

// @freezed
// abstract class UserBase with _$UserBase {
//   @JsonSerializable(fieldRename: FieldRename.snake)
//   const factory UserBase({ 
//     required String id,
//     required String userName,
//     required String surnames,
//     required String phoneNumber,
//     required bool isActive,
//     required String userType,
//     required DateTime createdAt,
//   }) = _UserBase;

//   factory UserBase.fromJson(Map<String, Object?> json) =>
//       _$UserBaseFromJson(json);
// }
