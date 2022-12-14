library settings_dialogs;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

part 'settings_dialog_textfield.dart';
part 'settings_dialog_colorpicker.dart';
part 'settings_dialog_selection.dart';

class SettingsDialogs {
  static Widget textField({
    required String title,
    String? subtitle,
    String? hintText,
    required TextEditingController controller,
    TextInputType? keyboardType,
    bool obscureText = false,
    required final Function(String text) onSaved,
    final Function()? onCanceled,
    bool closeOnAction = true,
    List<TextInputFormatter>? inputFormatters,
  }) =>
      _SettingsDialogTextField(
        title: title,
        subtitle: subtitle,
        hintText: hintText,
        controller: controller,
        keyboardType: keyboardType,
        obscureText: obscureText,
        onSaved: onSaved,
        onCanceled: onCanceled,
        closeOnAction: closeOnAction,
        inputFormatters: inputFormatters,
      );

  static Widget colorPicker({
    required String title,
    required String? subtitle,
    required List<Color> colors,
    required Function(Color color) onColorClicked,
    bool closeOnAction = true,
  }) =>
      _SettingsDialogColorPicker(
        title: title,
        subtitle: subtitle,
        colors: colors,
        onColorClicked: onColorClicked,
        closeOnAction: closeOnAction,
      );

  static Widget selection<T>({
    required String title,
    String? subtitle,
    required List<SettingsDialogSelectionItem<T>> items,
    required ValueChanged<T> onItemClicked,
    bool closeOnAction = true,
  }) =>
      _SettingsDialogSelection(
        title: title,
        subtitle: subtitle,
        items: items,
        onItemClicked: onItemClicked,
        closeOnAction: closeOnAction,
      );
}
