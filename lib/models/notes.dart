import 'package:cloud_firestore/cloud_firestore.dart';

class Note {
  String id;
  String title;
  String body;
  DateTime creationDate;
  DateTime modificationDate;
  String category; // Nuevo campo para la categoría
  String uid;

  // Constructor con id opcional
  Note({
    this.id = '', // O algún valor por defecto
    this.category = 'personal', // Valor por defecto para la categoría
    required this.title,
    required this.body,
    required this.creationDate,
    required this.modificationDate,
    required this.uid,
  });

  // Método para convertir de Firestore a Note
  factory Note.fromFirestore(Map<String, dynamic> firestoreData, String id) {
    return Note(
      id: id,
      title: firestoreData['title'],
      body: firestoreData['body'],
      creationDate: firestoreData['creationDate'] is Timestamp
          ? (firestoreData['creationDate'] as Timestamp).toDate()
          : DateTime.parse(firestoreData['creationDate']), // Convertir de String a DateTime si es String
      modificationDate: firestoreData['modificationDate'] is Timestamp
          ? (firestoreData['modificationDate'] as Timestamp).toDate()
          : DateTime.parse(firestoreData['modificationDate']), // Convertir de String a DateTime si es String
      uid: firestoreData['uid'],
      category: firestoreData['category'], // Recuperar categoría o asignar valor por defecto
    );
  }

  // Método para convertir de Note a Firestore
  Map<String, dynamic> toFirestore() {
    return {
      'title': title,
      'body': body,
      'creationDate': Timestamp.fromDate(creationDate), // Convertir DateTime a Timestamp
      'modificationDate': Timestamp.fromDate(modificationDate), // Convertir DateTime a Timestamp
      'category': category, // Incluir la categoría en Firestore
      'uid': uid,
    };
  }
}
