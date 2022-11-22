// // ignore_for_file: hash_and_equals

// import 'dart:async';

// import 'package:flutter/cupertino.dart';
// import 'package:todoapp/extensions/list/filter.dart';
// import 'package:todoapp/services/crud/crud_exceptions.dart';
// import 'package:sqflite/sqflite.dart';
// import 'package:path_provider/path_provider.dart';
// import 'package:path/path.dart' show join;

// // check connection status and throw exception
// // differents exceptions


// //  for to connect to our database
// class NoteService {

//    Database? _db;

//    static final NoteService _shared = NoteService._sharedInstance();
//    NoteService._sharedInstance() {
//       _noteStreamController = StreamController<List<DatabaseNote>>.broadcast(
//         onListen: () {
//           _noteStreamController.sink.add(_notes);
//         },
//       );
//    }
//    factory NoteService() => _shared;

//    List<DatabaseNote> _notes = [];
//    // help to store a list of a liste of notes
//    late final StreamController<List<DatabaseNote>> _noteStreamController ;

//     //  check this function ... Stream<List<DatabaseNote>> get allNotes => 
//    Stream<List<DatabaseNote>> get allNotes => 
//       _noteStreamController.stream.filter((note)  {
//         final currentUser = _user;
//         if(currentUser != null){
//           return note.user_id == currentUser.id;
//         }else{
//           throw UserShouldBeSetBeforeReadingAllNotesException();
//         } 
//       });

//    DatabaseUser? _user;
   
//    Future<void> _cacheNotes() async {
//      final allNotes = await getAllNote();
//      _notes = allNotes.toList();
//      _noteStreamController.add(_notes);
//    }


//   Database _getDatabaseOrThrow() {
//     final db = _db;
//      if (db == null) {
//        throw DatabaseNotOpenedException();
//      }else{
//        return db;
//      }
//    }

//    Future<void> close() async {
//      final db = _db;
//      if (db == null) {
//        throw DatabaseNotOpenedException();
//      }else{
//        await db.close();
//        _db = null;
//      }
//    }
   
//    Future<void> open() async {

//      if (_db != null) {
//         throw DatabaseAlreadyOpenException();
//      }

//      try {
//        final docsPath = await getApplicationSupportDirectory();
//        final dbPath = join(docsPath.path, dbName);
//        final db = await openDatabase(dbPath);
//        _db = db;

//      // create user table
//       await db.execute(createUserTable);
//       // create note table
//       await db.execute(createNoteTable);
//       // put all notes in our variable off notes by caching them
//       await _cacheNotes();

//      } on MissingPlatformDirectoryException {
//        throw UnableToGetDocumentsDirectory();
//      }
//    }

//    Future<void> _ensureDBIsOpen() async {
//      try {
//        await open();
//      } on DatabaseAlreadyOpenException {
//        // nothing
//      }
//    }

//    // DML function for manupulate the user table
//    // Delete function 
//    Future<void> deleteUser({required String email}) async {
//      await _ensureDBIsOpen();
//      final db = _getDatabaseOrThrow();
//      final deletedCount =  db.delete(userTable, where: 'user_email = ?', whereArgs: [email.toLowerCase()]);
//      if (deletedCount == 0) {
//         throw CouldNotDeleteTheUser();
//      }
//    }

//   // create function
//    Future<DatabaseUser> createUser({required String email}) async {
//      await _ensureDBIsOpen();
//      final db = _getDatabaseOrThrow();
//      final results = await db.query(userTable, limit: 1, 
//            where: 'user_email = ? ', whereArgs: [email.toLowerCase()]);
//       if (results.isNotEmpty) {
//         throw UserAlreadyExistException();
//       }
//         final userId = await db.insert(userTable, {emailColumn: email.toLowerCase()});
//         return DatabaseUser(id: userId, email: email);
//    }

//    // get user function
//    Future<DatabaseUser> getUser({required String email}) async {
//      await _ensureDBIsOpen();
//      final db = _getDatabaseOrThrow();
//      final results = await db.query(userTable, limit: 1, 
//            where: 'user_email = ? ', whereArgs: [email.toLowerCase()]);
//       if (results.isEmpty) {
//         throw CouldNotFindUserException();
//       }else {
//         return DatabaseUser.fromRow(results.first);
//       }
//    }

//   //  DML for note
//   // create function
//    Future<DatabaseNote> createNote({required DatabaseUser owner}) async {
//       await _ensureDBIsOpen();
//       final db =_getDatabaseOrThrow();

//       // make sure the user exist in the database
//       final dbUser = await getUser(email: owner.email);
//       if (dbUser != owner) {
//          throw CouldNotFindUserException();
//       }

//       const text = '';
//       // create the note 
//       final noteId = await db.insert(noteTable, {
//         userIdCulumn: owner.id,
//         textColumn : text,
//         titleColumn : title, 
//         dateOperationColumn : DateTime.now().toString(),
//         isSyncedWithCloudCulumn: 1,
//       });
      
//       final note = DatabaseNote(id: noteId, userId: owner.id, text: text, isSyncedWithCloud: true);
//       // add our note on our streamController for caching
//       _notes.add(note);
//       _noteStreamController.add(_notes);
//       return note;
//    }

//   // delete Function
//   Future<void> deleteNote({required int id}) async {
//     await _ensureDBIsOpen();
//     final db = _getDatabaseOrThrow();
//     final deletedCount = await db.delete(
//        noteTable, 
//        where: 'id = ?', 
//        whereArgs: [id],
//        );
//      if (deletedCount == 0) {
//        throw CouldNotDeleteNoteException();
//      }else{
//        _notes.removeWhere((note) => note.id == id);
//        _noteStreamController.add(_notes);
//      }
//   }

//   // delete all reccord in note
//   Future<int> deleteAllNote() async {
//     await _ensureDBIsOpen();
//     final db = _getDatabaseOrThrow();
//      final numberOffDeletions =  await db.delete(noteTable);
//        _notes = [];
//        _noteStreamController.add(_notes);
//      return numberOffDeletions;
//   }

//   // get a specific note or a specific note
//    Future<DatabaseNote> getNote({required int id}) async {
//      await _ensureDBIsOpen();
//      final db =_getDatabaseOrThrow();
//      final notes = await db.query(noteTable, 
//              limit: 1,
//              where: 'id = ?', 
//              whereArgs: [id]
//       );
     
//       if (notes.isEmpty) {
//          throw CouldNotFindNoteException();
//       }else{
//         final note = DatabaseNote.fromRow(notes.first);
//         _notes.removeWhere((note) => note.id == id);
//         _notes.add(note); 
//        _noteStreamController.add(_notes);
//         return note;
//       }
//    }

//   //  get All note from the database in the system
//    Future<Iterable<DatabaseNote>> getAllNote() async {
//      await _ensureDBIsOpen();
//      final db =_getDatabaseOrThrow();
//      final notes = await db.query(noteTable); 
       
//     return notes.map((noteRow) => DatabaseNote.fromRow(noteRow));
//    }

//    // update note 
//    Future<DatabaseNote> updateNote({
//         required DatabaseNote note, 
//         required String text,
//         required String title,
//       }) async {
//         await _ensureDBIsOpen();
//         final db = _getDatabaseOrThrow();
//         // make sure note exists
//         await getNote(id: note.id);
//         // update DB
//        final updateCount = await db.update(noteTable, {
//           textColumn: text,
//           titleColumn : title, 
//           dateOperationUpdateColumn : DateTime.now().toString(),
//           isSyncedWithCloudCulumn: 0,
//         }, where: 'id = ?', whereArgs: [note.id]);

//         if (updateCount == 0) {
//            throw CouldNotUpdateNoteException();
//         }else {
//           final updatedNote =  await getNote(id: note.id);
//            _notes.removeWhere((note) => note.id == updatedNote.id);
//            _notes.add(updatedNote);
//            _noteStreamController.add(_notes);
//           return updatedNote;
//         }
//     }

//     Future<DatabaseUser> getOrCreateUser ({required String email, bool setCurrentUser = true}) async { 
//       try {
//          final user = await getUser(email: email);
//          if (setCurrentUser) {
//            _user = user;
//          }
//          return user;
//       } on CouldNotFindUserException {
//         final createNewUser = await createUser(email: email); 
//          if (setCurrentUser) {
//            _user = createNewUser;
//          }
//         return createNewUser;
//       }catch (e) {
//         rethrow;
//       }
//     }
// }


// @immutable
// class DatabaseUser {
//   final int id;
//   final String email;

//   const DatabaseUser({required this.id, required this.email});

//   DatabaseUser.fromRow(Map<String?, Object?> map) 
//        : id = map[idColumn] as int, email = map[emailColumn] as String;

//   @override
//   String toString()  => 'Person, ID = $id , user_email = $email';

//   @override 
//   bool operator == (covariant DatabaseUser other) => id == other.id;

//   @override 
//   int get hashCode => id.hashCode;
// }

// class DatabaseNote {
//   final int id;
//   final int userId;
//   final String text;
//   final bool isSyncedWithCloud;

//   DatabaseNote({required this.id, required this.userId, required this.text, required this.isSyncedWithCloud});

//   DatabaseNote.fromRow(Map<String, Object?> map) 
//        : id = map[idColumn] as int, 
//        userId = map[userIdCulumn] as int,
//        text = map[textColumn] as String,
//        title = map[titleColumn] as String, 
//        title = map[dateOperationColumn] as String, 
//        title = map[dateOperationUpdateColumn] as String,
//        isSyncedWithCloud = (map[isSyncedWithCloudCulumn] as int) == 1 ? true : false;

//    @override 
//    String toString() => 'Note: ID= $id , userId = $userId, isSynchrwithCloud= $isSyncedWithCloud, text= $text';

//    @override  
//   int get hashCode => id.hashCode;
// }

// // constants which are used during connection
// const dbName = 'note.db';
// const noteTable = 'note';
// const userTable = 'user';
// const idColumn = 'id';
// const emailColumn = 'user_email';
// const userIdCulumn = 'user_id';
// const titleColumn = 'title';
// const dateOperationColumn = 'date_operation';  
// const dateOperationUpdateColumn = 'date_update_operation'; 
// const textColumn = 'text';
// const isSyncedWithCloudCulumn = 'is_snced_with_cloud';
//  const createUserTable = ''' 
//         CREATE TABLE IF NOT EXISTS "user" (
//           "id"	INTEGER NOT NULL,
//           "user_email"	TEXT NOT NULL,
//           PRIMARY KEY("id" AUTOINCREMENT)
//         );
//       ''';
//  const createNoteTable = '''
//         CREATE TABLE IF NOT EXISTS "note" (
//           "id"	INTEGER NOT NULL,
//           "user_id"	INTEGER NOT NULL,
//           "title"	VARCHAR NOT NULL,
//           "text"	a NOT NULL,
//           "is_snced_with_cloud"	INTEGER NOT NULL DEFAULT 0,
//           PRIMARY KEY("id" AUTOINCREMENT),
//           FOREIGN KEY("user_id") REFERENCES "user"("id")
//         );
//       ''';