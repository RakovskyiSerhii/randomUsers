import 'package:floor/floor.dart';
import 'package:random_users/data/models/UserModel.dart';

@Entity(
  tableName: "UserEntity",
)
class UserEntity {
  @PrimaryKey(autoGenerate: true)
  int? id;
  String firstName;
  String lastName;
  String email;
  String? icon;
  String? photo;

  UserEntity(this.id,
      {required this.firstName,
        required this.lastName,
        required this.email,
        this.icon,
        this.photo});

  factory UserEntity.fromModel(UserModel model) {
    return UserEntity(model.id ?? 0, firstName: model.firstName,
        lastName: model.lastName,
        email: model.email,
        icon: model.icon ?? "",
        photo: model.photo ?? "");
  }

  @override
  String toString() {
    return 'UserEntity{id: $id, firstName: $firstName, lastName: $lastName, email: $email, icon: $icon, photo: $photo}';
  }
}
