import 'package:flutter/material.dart';
import 'package:todoapp/utilities/dialogs/generec_dialog.dart';

Future<bool> shouldDeleteDialog(BuildContext context) {
  return showGenericDialog(
      context: context,
      title: 'Validate',
      content: 'Are you sure you want to VALIDATE the task?',
      optionBuilder: () => {
            'No': false,
            'Yes': true,
          }).then((value) => value ?? false);
}
