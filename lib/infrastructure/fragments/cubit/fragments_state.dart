part of 'fragments_cubit.dart';

@freezed
class FragmentsState with _$FragmentsState {
  factory FragmentsState({
    @Default(false) bool hasUnsavedChanges,
    @Default([]) List<FragmentModel> openedFragments,
    @Default([]) List<FragmentSnippet> fragments,
  }) = _FragmentsState;
}
