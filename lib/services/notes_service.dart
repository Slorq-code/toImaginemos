import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:to_imaginemos_app/models/models.dart';
import 'package:to_imaginemos_app/services/auth_service.dart';

class NoteService {
  final CollectionReference _notesCollection =
      FirebaseFirestore.instance.collection('notas');
  final AuthService _authService = AuthService();

  Future<String?> _getUserUid() async {
    String? userUid = await _authService.readUid();
    print("=============================================");
    print("UID en NoteService: $userUid");
    print("=============================================");
    return userUid;
  }

Stream<List<Note>> getNotes({String? category}) async* {
  final String? userUid = await _getUserUid();

  if (userUid != null) {
    Query query = _notesCollection.where('uid', isEqualTo: userUid);

    if (category != null && category.isNotEmpty && category != 'todas') {
      query = query.where('category', isEqualTo: category);
    }

    yield* query.snapshots().map((snapshot) {
      print("Número de notas recuperadas: ${snapshot.docs.length}");
      return snapshot.docs.map((doc) {
        print("Datos de la nota: ${doc.data()}");
        return Note.fromFirestore(doc.data() as Map<String, dynamic>, doc.id);
      }).toList();
    });
  } else {
    print("Usuario no autenticado. No se pueden recuperar las notas.");
    yield [];
  }
}

  Future<void> addNote(Note note) async {
    final String? userUid = await _getUserUid();

    print("===============================================================");
    print("ESTOY EN addNote");
    print(userUid);
    print("note, $note");
    print("===============================================================");

    if (userUid != null) {
      final noteWithUid = Note(
        id: note.id,
        title: note.title,
        body: note.body,
        creationDate: note.creationDate,
        modificationDate: note.modificationDate,
        category: note.category,
        uid: userUid,
      );
      await _notesCollection.add(noteWithUid.toFirestore());
    } else {
      print("Usuario no autenticado. No se puede agregar la nota.");
    }
  }

  Future<void> updateNote(Note note) {
    return _notesCollection.doc(note.id).update(note.toFirestore());
  }

  Future<void> deleteNote(String id) {
    return _notesCollection.doc(id).delete();
  }
}
