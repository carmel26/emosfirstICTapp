import 'package:flutter/material.dart';
import 'package:todoapp/services/cloud/cloud_note.dart';

import '../../utilities/dialogs/delete_dialog.dart';

typedef NoteCallBack = void Function(CloudNote);

class NoteListView extends StatelessWidget {
  final Iterable<CloudNote> notes;
  final NoteCallBack onDeleteNote;
  final NoteCallBack onTapNote;

  const NoteListView({
    Key? key,
    required this.notes,
    required this.onDeleteNote,
    required this.onTapNote,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: notes.length,
      itemBuilder: (context, index) {
        // final currentNote = notes[index];
        final currentNote = notes.elementAt(index);
        return ListTile(
          onTap: () {
            onTapNote(currentNote);
          },
          title: Text(
            '${index + 1}) ${currentNote.title}',
            maxLines: 1,
            softWrap: true,
            overflow: TextOverflow.ellipsis,
          ),
          trailing: IconButton(
            onPressed: () async {
              final shouldDelete = await shouldDeleteDialog(context);
              if (shouldDelete) {
                onDeleteNote(currentNote);
              }
            },
            icon: const Icon(Icons.check_box_outlined),
            color: const Color.fromARGB(255, 8, 168, 134),
          ),
          textColor: (index % 2) == 0
              ? Colors.blueGrey.shade800
              : Colors.blueGrey.shade600,
        );
      },
    );
  }
}
