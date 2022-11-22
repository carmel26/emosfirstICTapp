import 'package:flutter/material.dart';
import 'package:todoapp/utilities/dialogs/generec_dialog.dart';

Future<void> showCannotShareEmptyNoteDialog(BuildContext context) {
  return showGenericDialog(
      context: context,
      title: 'Share',
      content: 'Sorry you can\'t share an empty note',
      optionBuilder: () {
        return {'Ok': null};
      });
}
