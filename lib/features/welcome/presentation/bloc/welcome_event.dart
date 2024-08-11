part of 'welcome_bloc.dart';

@freezed
class WelcomeEvent with _$WelcomeEvent {
  const factory WelcomeEvent.loadRecent() = _LoadRecent;
}
