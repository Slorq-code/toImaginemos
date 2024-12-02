import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:to_imaginemos_app/models/models.dart';
import 'package:to_imaginemos_app/services/auth_service.dart'; // Importa el servicio de autenticación
//import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class NoteService {
  final CollectionReference _notesCollection =
      FirebaseFirestore.instance.collection('notas');
  final AuthService _authService = AuthService(); // Instancia del servicio de autenticación

  // Función para obtener el token del usuario logueado
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
    // Comienza la consulta básica para obtener las notas del usuario
    Query query = _notesCollection.where('uid', isEqualTo: userUid);

    // Si se pasa una categoría y no es "todas", añadimos el filtro de categoría
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
    yield []; // Devuelve una lista vacía si el usuario no está autenticado
  }
}

  // Agregar una nueva nota, vinculada al usuario logueado
  Future<void> addNote(Note note) async {
    final String? userUid = await _getUserUid();

    print("===============================================================");
    print(userUid);
    print("===============================================================");

    if (userUid != null) {
      final noteWithUid = Note(
        id: note.id,
        title: note.title,
        body: note.body,
        creationDate: note.creationDate,
        modificationDate: note.modificationDate,
        uid: userUid, // Asignamos el uid al campo correspondiente
      );

      // Agregar la nota a Firestore
      await _notesCollection.add(noteWithUid.toFirestore());
    } else {
      print("Usuario no autenticado. No se puede agregar la nota.");
    }
  }

  // Actualizar una nota existente
  Future<void> updateNote(Note note) {
    return _notesCollection.doc(note.id).update(note.toFirestore());
  }

  // Eliminar una nota
  Future<void> deleteNote(String id) {
    return _notesCollection.doc(id).delete();
  }
}
