import 'package:flutter/material.dart';
import 'package:todoapp/utilities/dialogs/generec_dialog.dart';

Future<void> showPasswordResetSentDialog(BuildContext context) {
  return showGenericDialog(
      context: context,
      title: 'Change your password',
      content:
          'There is a verification email sent to your email, go and check it for confirmation!',
      optionBuilder: () => {'Ok': null});
}
