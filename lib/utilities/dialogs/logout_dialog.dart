import 'package:flutter/material.dart';
import 'package:todoapp/utilities/dialogs/generec_dialog.dart';

Future<bool> showLogOutDialog(
    {required BuildContext context, required String text}) {
  return showGenericDialog(
      context: context,
      title: 'Logout.',
      content: 'Are you sure you want to logout?',
      optionBuilder: () => {
            'No': false,
            'Yes': true,
          }).then((value) => value ?? false);
}
