import 'package:random_users/data/local/entity/UserEntity.dart';
import 'package:random_users/data/network/models/UserResponse.dart';

class UserModel {
  int? id;
  String firstName;
  String lastName;
  String email;
  String? icon;
  String? photo;

  UserModel(
      {required this.firstName,
      required this.lastName,
      required this.email,
      this.icon,
      this.photo,
      this.id});

  factory UserModel.fromResponse(UserResponse response) {
    return UserModel(
        firstName: response.name!.first ?? "",
        lastName: response.name!.last ?? "",
        icon: response.picture!.thumbnail,
        photo: response.picture!.medium,
        email: response.email ?? "");
  }

  factory UserModel.fromEntity(UserEntity entity) {
    return UserModel(
        id: entity.id,
        firstName: entity.firstName,
        lastName: entity.lastName,
        email: entity.email,
        icon: entity.icon?.isEmpty == true ? null : entity.icon,
        photo: entity.photo?.isEmpty == true ? null : entity.photo);
  }

  @override
  String toString() {
    return 'UserModel{id: $id, firstName: $firstName, lastName: $lastName, email: $email, icon: $icon, photo: $photo}';
  }
}
