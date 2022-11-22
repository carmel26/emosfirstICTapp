import 'package:flutter/material.dart';

@immutable
class  CloudStorageException implements Exception {
  const CloudStorageException();
}
// R in CRUD
class  CouldNotGetAllNotesException extends CloudStorageException {}
// C in CRUD
class  CouldNotCreateAllNotesException extends CloudStorageException {}
//  U in CRUD
class  CouldNotUpdateAllNotesException extends CloudStorageException {}
//  D in CRUD
class  CouldNotDeleteAllNotesException extends CloudStorageException {}