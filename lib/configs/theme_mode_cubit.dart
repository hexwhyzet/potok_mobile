import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:potok/configs/storage_manager.dart';

class ThemeModeCubit extends Cubit<ThemeMode> {
  static const String THEME_MODE_PREFERENCE_LABEL = 'themeMode';
  static const String THEME_MODE_SYSTEM_LABEL = 'system';
  static const String THEME_MODE_LIGHT_LABEL = 'light';
  static const String THEME_MODE_DARK_LABEL = 'dark';

  ThemeModeCubit() : super(ThemeMode.system) {
    StorageManager.readData(THEME_MODE_PREFERENCE_LABEL).then((value) {
      var themeMode = value ?? THEME_MODE_SYSTEM_LABEL;
      if (themeMode == THEME_MODE_LIGHT_LABEL) {
        emit(ThemeMode.light);
      } else if (themeMode == THEME_MODE_DARK_LABEL) {
        emit(ThemeMode.dark);
      }
    });
  }

  void setDarkMode() async {
    await StorageManager.saveData(
        THEME_MODE_PREFERENCE_LABEL, THEME_MODE_DARK_LABEL);
    emit(ThemeMode.dark);
  }

  void setLightMode() async {
    StorageManager.saveData(
        THEME_MODE_PREFERENCE_LABEL, THEME_MODE_LIGHT_LABEL);
    emit(ThemeMode.light);
  }
}
