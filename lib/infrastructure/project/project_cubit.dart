import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

part 'project_cubit.freezed.dart';
part 'project_state.dart';

@singleton
class ProjectCubit extends Cubit<ProjectState> {
  ProjectCubit() : super(ProjectState());
}
