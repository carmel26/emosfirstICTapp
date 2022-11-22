import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:todoapp/services/cloud/cloud_storage_constants.dart';

class CloudNote {
  final String documentId;
  final String ownerId;
  final String text;
  final String title;
  final String dateOperation;

  CloudNote(
      {required this.documentId,
      required this.ownerId,
      required this.text,
      required this.title,
      required this.dateOperation});

  CloudNote.fromSnapshot(QueryDocumentSnapshot<Map<String, dynamic>> snapshot)
      : documentId = snapshot.id,
        ownerId = snapshot.data()[ownerUserIdFieldName],
        text = snapshot.data()[textFieldName],
        title = snapshot.data()[titleFieldName],
        dateOperation = snapshot.data()[dateOperationFieldName];
}
