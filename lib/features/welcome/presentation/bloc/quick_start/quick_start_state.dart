part of 'quick_start_bloc.dart';

@freezed
class QuickStartState with _$QuickStartState {
  const factory QuickStartState.initial() = _Initial;
  const factory QuickStartState.success() = _Success;
  const factory QuickStartState.failure(PlotweaverError error) = _Failure;
}
