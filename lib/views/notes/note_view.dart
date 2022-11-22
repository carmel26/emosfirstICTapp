// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:todoapp/services/auth/auth_service.dart';
import 'package:todoapp/services/auth/bloc/auth_bloc.dart';
import 'package:todoapp/services/auth/bloc/auth_event.dart';
import 'package:todoapp/services/cloud/cloud_note.dart';
import 'package:todoapp/services/cloud/firebase_cloud_storage.dart';
// import 'package:todoapp/services/crud/note_service.dart';
import 'package:todoapp/views/notes/notes_list_view.dart';
import 'package:flutter_bloc/flutter_bloc.dart' show ReadContext;

import '../../constants/routes.dart';
import '../../enums/menu_action.dart';
import '../../utilities/dialogs/logout_dialog.dart';

class NotesView extends StatefulWidget {
  const NotesView({Key? key}) : super(key: key);

  @override
  State<NotesView> createState() => _NotesViewState();
}

class _NotesViewState extends State<NotesView> {
  late final FirebaseCloudStorage _noteService;
  // get user email informations
  // String get userEmail => AuthService.firebase().currentUser!.email!;
  String get userId => AuthService.firebase().currentUser!.id;

  @override
  void initState() {
    _noteService = FirebaseCloudStorage();
    // _noteService.open();
    super.initState();
  }

  // no need to dispose in note_view....
  // @override
  // void dispose() {
  //   _noteService.close();
  //   super.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text.rich(
            TextSpan(
              children: <InlineSpan>[
                WidgetSpan(
                    child: Icon(Icons.note_alt_sharp,
                        color: Color.fromARGB(255, 255, 255, 255))),
                TextSpan(text: 'This is your list'),
              ],
            ),
          ),
          actions: [
            IconButton(
                onPressed: () {
                  Navigator.of(context).pushNamed(createOrUpdateNoteRoute);
                },
                icon: const Icon(Icons.add)),
            PopupMenuButton<MenuAction>(onSelected: (value) async {
              switch (value) {
                case MenuAction.logout:
                  final shouldLogOut =
                      await showLogOutDialog(context: context, text: 'Logout');
                  if (shouldLogOut) {
                    context.read<AuthBloc>().add(
                          const AuthEventLogOut(),
                        );
                  } else {}
                  break;
                case MenuAction.test:
                  // TODO: Handle this case after .
                  break;
              }
            }, itemBuilder: (context) {
              return const [
                PopupMenuItem<MenuAction>(
                    value: MenuAction.logout,
                    child: Text.rich(
                      TextSpan(
                        children: <InlineSpan>[
                          WidgetSpan(
                              child: Icon(Icons.logout, color: Colors.red)),
                          TextSpan(text: 'Logout'),
                        ],
                      ),
                    )
                    // icon : Icon(Icons.logout),
                    )
              ];
            })
          ],
        ),
        body: StreamBuilder(
            // stream:  _noteService.allNotes,
            stream: _noteService.allNotes(ownerUSerId: userId),
            builder: (context, snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.active:
                case ConnectionState.waiting:
                  if (snapshot.hasData) {
                    final allNotes = snapshot.data as Iterable<CloudNote>;
                    return NoteListView(
                      notes: allNotes,
                      onDeleteNote: (note) async {
                        await _noteService.deleteNote(
                            documentId: note.documentId);
                      },
                      onTapNote: (note) {
                        Navigator.of(context).pushNamed(createOrUpdateNoteRoute,
                            arguments: note);
                      },
                    );
                  } else {
                    return const CircularProgressIndicator();
                  }
                default:
                  return const CircularProgressIndicator();
              }
            }));
  }
}
