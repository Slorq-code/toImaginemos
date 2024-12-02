import 'package:flutter/material.dart';
import 'package:to_imaginemos_app/BLoC/notes/notes_bloc.dart';
import 'package:to_imaginemos_app/models/models.dart';
import 'package:to_imaginemos_app/screens/note_screen.dart'; // Importa NoteScreen
import 'package:intl/intl.dart';

class NoteCard extends StatelessWidget {
  final Note note;

  final NoteService _noteService = NoteService();  // Instancia del servicio

  NoteCard({
    super.key,
    required this.note,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => NoteScreen(note: note),
            ),
          );
        },
        child: Container(
          width: double.infinity,
          decoration: _cardBorders(),
          child: Stack(
            alignment: Alignment.bottomLeft,
            children: [
              _BackgroundDecoration(),
              _NoteDetails(
                title: note.title,
                body: note.body,
              ),
              Positioned(
                top: 0,
                left: 10,  // Ajusta la posición de la categoría
                child: _CategoryTag(note.category),  // Mostrar categoría
              ),
              Positioned(
                top: 0,
                right: 0,
                child: _CreationDateTag(note.creationDate),
              ),
              Positioned(
                bottom: 10,
                right: 10,
                child: IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () async {
                    await _noteService.deleteNote(note.id);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  BoxDecoration _cardBorders() => BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(25),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            offset: Offset(0, 7),
            blurRadius: 10,
          ),
        ],
      );
}

class _NoteDetails extends StatelessWidget {
  final String title;
  final String body;

  const _NoteDetails({
    required this.title,
    required this.body,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 20,
              color: Colors.black87,
              fontWeight: FontWeight.bold,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 6),
          Text(
            body,
            style: const TextStyle(
              fontSize: 15,
              color: Colors.black54,
            ),
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}

class _CategoryTag extends StatelessWidget {
  final String category;

  const _CategoryTag(this.category);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.blueAccent,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        
        "Categoria: $category",
        style: const TextStyle(
          color: Colors.white,
          fontSize: 14,
        ),
      ),
    );
  }
}

class _CreationDateTag extends StatelessWidget {
  final DateTime date;
  const _CreationDateTag(this.date);
  @override
  Widget build(BuildContext context) {
    String formattedDate =
        DateFormat('dd/MM/yyyy').format(date); // Formato deseado
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: const BoxDecoration(
        color: Colors.blueAccent,
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(25),
          bottomLeft: Radius.circular(25),
        ),
      ),
      child: Text(
        formattedDate,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 14,
        ),
      ),
    );
  }
}

class _BackgroundDecoration extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(25),
      child: Container(
        color: Colors.grey[200], // Fondo suave
        height: 180,
        width: double.infinity,
      ),
    );
  }
}
