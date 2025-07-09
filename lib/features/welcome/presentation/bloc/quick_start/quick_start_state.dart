part of 'quick_start_bloc.dart';

@freezed
sealed class QuickStartState with _$QuickStartState {
  const factory QuickStartState.initial() = QuickStartStateInitial;
  const factory QuickStartState.success(
    ProjectEntity project,
    String identifier,
    String path,
  ) = QuickStartStateSuccess;

  /// App should be locked because picker is opened
  const factory QuickStartState.locked(bool shouldShowBackdrop) =
      QuickStartStateLocked;
  const factory QuickStartState.failure(PlotweaverError error) =
      QuickStartStateFailure;
}
