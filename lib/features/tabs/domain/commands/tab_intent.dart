import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../entities/tab_entity.dart';

part 'tab_intent.freezed.dart';

@Freezed(toJson: false, fromJson: false)
class TabIntent extends Intent with _$TabIntent {
  const TabIntent._();

  const factory TabIntent.saveTab([TabEntity? tab]) = SaveTabIntent;
  const factory TabIntent.rollback([TabEntity? tab]) = RollbackTabIntent;
}
