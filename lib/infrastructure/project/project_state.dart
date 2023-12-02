part of 'project_cubit.dart';

@freezed
class ProjectState with _$ProjectState {
  factory ProjectState({
    @Default(false) bool opened,
  }) = _ProjectState;
}
