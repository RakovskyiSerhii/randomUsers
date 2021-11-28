import 'actions.dart';
import 'app_state.dart';

AppState appStateReducers(AppState state, dynamic action) {
  if (action is IsFirstLaunch) {
    return state.copyWith(isFirstLaunch: action.isFirstLaunch);
  }
  if (action is LoadListAction) {
    return state.copyWith(isLoading: true);
  } else if (action is UserLoadedAction) {
    return state.copyWith(
      isFirstLaunch: false,
      isLoading: false,
      usersLoaded: true,
      users: [],
    );
  } else if (action is UsersLoadingError) {
    return state.copyWith(isLoading: false, usersLoaded: true, users: null);
  } else if (action is GetListFromDBAction) {
    return state.copyWith(isLoading: true, users: null);
  } else if (action is UsersRetrievedAction) {
    return state.copyWith(isLoading: false, users: action.users);
  } else if (action is RefreshUsersAction) {
    return state.copyWith(isLoading: true, users: null);
  }

  return state;
}
