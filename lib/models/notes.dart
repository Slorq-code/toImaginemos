import 'package:cloud_firestore/cloud_firestore.dart';

class Note {
  String id;
  String title;
  String body;
  DateTime creationDate;
  DateTime modificationDate;
  String category; 
  String uid;

  Note({
    this.id = '', 
    this.category = 'personal',
    required this.title,
    required this.body,
    required this.creationDate,
    required this.modificationDate,
    required this.uid,
  });

  factory Note.fromFirestore(Map<String, dynamic> firestoreData, String id) {
    return Note(
      id: id,
      title: firestoreData['title'],
      body: firestoreData['body'],
      creationDate: firestoreData['creationDate'] is Timestamp
          ? (firestoreData['creationDate'] as Timestamp).toDate()
          : DateTime.parse(firestoreData['creationDate']),
      modificationDate: firestoreData['modificationDate'] is Timestamp
          ? (firestoreData['modificationDate'] as Timestamp).toDate()
          : DateTime.parse(firestoreData['modificationDate']), 
      uid: firestoreData['uid'],
      category: firestoreData['category'],
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'title': title,
      'body': body,
      'creationDate': Timestamp.fromDate(creationDate),
      'modificationDate': Timestamp.fromDate(modificationDate),
      'category': category, 
      'uid': uid,
    };
  }
  
  @override
  String toString() {
    return 'Note { id: $id, title: $title, body: $body, creationDate: $creationDate, modificationDate: $modificationDate, uid: $uid, category: $category }';
  }
  
}
