part of 'current_project_bloc.dart';

@freezed
class CurrentProjectState with _$CurrentProjectState {
  const factory CurrentProjectState.noProject() = CurrentProjectStateNoProject;
  const factory CurrentProjectState.project(CurrentProjectEntity project) =
      CurrentProjectStateProject;
}
