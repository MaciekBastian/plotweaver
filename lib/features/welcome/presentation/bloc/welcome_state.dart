part of 'welcome_bloc.dart';

@freezed
class WelcomeState with _$WelcomeState {
  const factory WelcomeState.initial() = _Initial;
  const factory WelcomeState.loading() = _Loading;
  const factory WelcomeState.empty() = _Empty;
  const factory WelcomeState.success(List<RecentProjectEntity> projects) =
      _Success;
  const factory WelcomeState.failure(PlotweaverError error) = _Failure;
}
