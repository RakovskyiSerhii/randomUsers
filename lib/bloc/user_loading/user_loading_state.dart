part of 'user_loading_cubit.dart';

@immutable
abstract class UserLoadingState{}

class UserLoadingProgressState extends UserLoadingState{}
class UserLoadingErrorState extends UserLoadingState{}
class UserLoadingCompleteState extends UserLoadingState {}

