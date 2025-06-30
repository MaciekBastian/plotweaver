import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../entities/tab_entity.dart';

part 'tab_intent.freezed.dart';

@Freezed(toJson: false, fromJson: false)
sealed class TabIntent extends Intent with _$TabIntent {
  const TabIntent._();

  const factory TabIntent.save([TabEntity? tab]) = SaveTabIntent;
  const factory TabIntent.rollback([TabEntity? tab]) = RollbackTabIntent;
  const factory TabIntent.close([TabEntity? tab]) = CloseTabIntent;
  const factory TabIntent.open([TabEntity? tab]) = OpenTabIntent;
}
