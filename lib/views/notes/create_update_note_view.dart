import 'package:flutter/material.dart';
import 'package:todoapp/services/auth/auth_service.dart';
import 'package:todoapp/services/cloud/firebase_cloud_storage.dart';
import 'package:todoapp/utilities/generics_get_argments.dart';
import 'package:todoapp/services/cloud/cloud_note.dart';
import 'package:share_plus/share_plus.dart';

import '../../utilities/dialogs/cannot_share_empty_note_dialog.dart';

class CreateUpdateNoteView extends StatefulWidget {
  const CreateUpdateNoteView({Key? key}) : super(key: key);

  @override
  State<CreateUpdateNoteView> createState() => _CreateUpdateNoteViewState();
}

class _CreateUpdateNoteViewState extends State<CreateUpdateNoteView> {
  CloudNote? _note;
  late final FirebaseCloudStorage _noteService;
  late final TextEditingController _textController;
  late final TextEditingController _titleController;
  late String headerPage;

  @override
  void initState() {
    _noteService = FirebaseCloudStorage();
    _textController = TextEditingController();
    _titleController = TextEditingController();
    super.initState();
  }

  // creation of a listerner on screen keyboard
  void _textControllerListener() async {
    final note = _note;
    if (note == null) {
      return;
    }
    final text = _textController.text;
    final title = _titleController.text;
    // await _noteService.updateNote(
    //    note: note,
    //    text: text
    // );
    await _noteService.updateNote(
      documentId: note.documentId,
      text: text,
      title: title,
      dateOperation: DateTime.now().toString(),
    );
  }

  // setup of our listener by removing it and add it!!
  void _setupTextControllerListener() {
    _textController.removeListener(_textControllerListener);
    _textController.addListener(_textControllerListener);
  }

  // create the note if is not existing
  Future<CloudNote> createOrGetExistingNote(BuildContext context) async {
    // get the selected note if is select for updating
    final widgetNote = context.getArgument<CloudNote>();

    if (widgetNote != null) {
      _note = widgetNote;
      _textController.text = widgetNote.text;
      _titleController.text = widgetNote.title;
      return widgetNote;
    }
    // end

    final existingNote = _note;
    if (existingNote != null) {
      return existingNote;
    }

    final currentUser = AuthService.firebase().currentUser!;
    // make sure the user is existing before add new note by adding !
    // old
    //  final email = currentUser.email!;
    //  final owner = await _noteService.getUser(email: email);
    //  final newNote = await _noteService.createNote(owner: owner);
    // old
    final userId = currentUser.id;
    final newNote = await _noteService.createNewNote(ownerUSerId: userId);
    _note = newNote;
    return newNote;
  }

  void _deleteNoteIfTextIsEmpty() {
    final note = _note;
    if ((_textController.text.isEmpty && note != null) ||
        (_titleController.text.isEmpty && note != null)) {
      // _noteService.deleteNote(id: note.id);
      _noteService.deleteNote(documentId: note.documentId);
    }
  }

  void _saveNoteIfTextIsNoteEmpty() async {
    final note = _note;
    final text = _textController.text;
    final title = _titleController.text;
    if (note != null && text.isNotEmpty) {
      //  await _noteService.updateNote(
      //      note: note,
      //      text: text,
      //   );
      await _noteService.updateNote(
        text: text,
        documentId: note.documentId,
        title: title,
        dateOperation: DateTime.now().toString(),
      );
    }
  }

  @override
  void dispose() {
    _deleteNoteIfTextIsEmpty();
    _saveNoteIfTextIsNoteEmpty();
    _textController.dispose();
    _titleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text.rich(
          TextSpan(
            children: <InlineSpan>[
              const WidgetSpan(
                  child: Icon(Icons.note_add,
                      color: Color.fromARGB(255, 255, 255, 255))),
              TextSpan(
                  text: context.getArgument<CloudNote>() != null
                      ? 'Update'
                      : 'New Notes'),
            ],
          ),
        ),
        actions: [
          IconButton(
              onPressed: () async {
                final text = _textController.text;
                final title = _titleController.text;

                if (title == null || title.isEmpty) {
                  await showCannotShareEmptyNoteDialog(context);
                } else {
                  Share.share('$title : $text');
                }
              },
              icon: const Icon(Icons.share))
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: FutureBuilder(
            future: createOrGetExistingNote(context),
            builder: (context, snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.done:
                  //  _note = snapshot.data as DatabaseNote; /// no need again to have this line
                  _setupTextControllerListener();
                  return Column(
                    children: [
                      TextField(
                        controller: _titleController,
                        keyboardType: TextInputType.multiline,
                        maxLines: null,
                        decoration: const InputDecoration(
                          hintText: "Give the title",
                        ),
                      ),
                      TextField(
                        controller: _textController,
                        keyboardType: TextInputType.multiline,
                        maxLines: null,
                        decoration: const InputDecoration(
                          hintText: 'Give the content',
                        ),
                      ),
                    ],
                  );
                default:
                  return const CircularProgressIndicator();
              }
            }),
      ),
    );
  }
}
