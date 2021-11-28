import 'package:random_users/core/data/models/UserModel.dart';

class AppState {
  final bool isFirstLaunch;
  final List<UserModel>? users;
  final bool isLoading;
  final bool usersLoaded;

  AppState({
    required this.users,
    required this.isLoading,
    required this.isFirstLaunch,
    required this.usersLoaded,
  });

  AppState copyWith({bool? isFirstLaunch,
    List<UserModel>? users,
    bool? isLoading,
    bool? usersLoaded,
  }) {
    return AppState(
      isFirstLaunch: isFirstLaunch ?? this.isFirstLaunch,
      users: users ?? this.users,
      isLoading: isLoading ?? this.isLoading,
      usersLoaded: usersLoaded ?? this.usersLoaded,
    );
  }

  factory AppState.empty() =>
      AppState(users: [],
          isLoading: false,
          isFirstLaunch: false,
          usersLoaded: false);
}
