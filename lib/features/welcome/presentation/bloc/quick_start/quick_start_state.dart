part of 'quick_start_bloc.dart';

@freezed
class QuickStartState with _$QuickStartState {
  const factory QuickStartState.initial() = _Initial;
  const factory QuickStartState.success() = _Success;

  /// App should be locked because picker is opened
  const factory QuickStartState.locked(bool shouldShowBackdrop) = _Locked;
  const factory QuickStartState.failure(PlotweaverError error) = _Failure;
}
