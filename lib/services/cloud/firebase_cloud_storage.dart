import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:todoapp/services/cloud/cloud_note.dart';
import 'package:todoapp/services/cloud/cloud_storage_constants.dart';
import 'package:todoapp/services/cloud/cloud_storeage_exceptions.dart';

class FirebaseCloudStorage {
  final notes = FirebaseFirestore.instance.collection('notes');

  Stream<Iterable<CloudNote>> allNotes({required String ownerUSerId}) {
    return notes.snapshots().map((event) => event.docs
        .map((doc) => CloudNote.fromSnapshot(doc))
        .where((note) => note.ownerId == ownerUSerId));
  }

  Future<void> updateNote({
    required String documentId,
    required String text,
    required String title,
    required String dateOperation,
  }) async {
    try {
      await notes.doc(documentId).update({
        textFieldName: text,
        titleFieldName: title,
        dateOperationUpdateFieldName: dateOperation
      });
    } catch (e) {
      throw CouldNotGetAllNotesException();
    }
  }

  Future<void> deleteNote({
    required String documentId,
  }) async {
    try {
      await notes.doc(documentId).delete();
    } catch (e) {
      throw CouldNotDeleteAllNotesException();
    }
  }

  Future<CloudNote> createNewNote({required String ownerUSerId}) async {
    final document = await notes.add({
      ownerUserIdFieldName: ownerUSerId,
      textFieldName: '',
      titleFieldName: '',
      dateOperationFieldName: '',
    });
    final fetcheNote = await document.get();
    return CloudNote(
        documentId: fetcheNote.id,
        ownerId: ownerUSerId,
        text: '',
        title: '',
        dateOperation: '');
  }

  Future<Iterable<CloudNote>> getNote({required String ownerUSerId}) async {
    try {
      return await notes
          .where(
            ownerUserIdFieldName,
            isEqualTo: ownerUSerId,
          )
          .get()
          .then((value) => value.docs.map((doc) {
                return CloudNote.fromSnapshot(doc);
              }));
    } catch (e) {
      throw CouldNotGetAllNotesException();
    }
  }

  static final FirebaseCloudStorage _shared =
      FirebaseCloudStorage._sharedInstance();
  FirebaseCloudStorage._sharedInstance();
  factory FirebaseCloudStorage() => _shared;
}
