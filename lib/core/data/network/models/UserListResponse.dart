
import 'UserResponse.dart';

class UserListResponse {
  List<UserResponse>? results;

  UserListResponse({this.results});

  factory UserListResponse.fromJson(Map<String, dynamic> json) {
    return UserListResponse(
      results: List.of(json["results"])
          .map((i) => UserResponse.fromJson(i))
          .toList(),
    );
  }
}