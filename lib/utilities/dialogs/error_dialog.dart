import 'package:flutter/material.dart';
import 'package:todoapp/utilities/dialogs/generec_dialog.dart';

Future<void> showErrorDialog(
  BuildContext context,
  String text,
) {
  return showGenericDialog(
      context: context,
      title: 'There is a mistake ',
      content: text,
      optionBuilder: () {
        // the return is a map
        return {'OK': null};
      });
}
