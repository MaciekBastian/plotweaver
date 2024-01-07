import '../models/act_model.dart';
import '../models/episode_model.dart';
import '../models/fragment_model.dart';
import '../models/fragment_type.dart';
import '../models/part_model.dart';

class FragmentMapper {
  FragmentModel decode(Map<String, dynamic> json) {
    final type = FragmentType.fromCodeName(json['type']);
    switch (type) {
      case FragmentType.part:
        return PartModel.fromJson(json);
      case FragmentType.act:
        return ActModel.fromJson(json);
      case FragmentType.episode:
        return EpisodeModel.fromJson(json);
    }
  }
}
