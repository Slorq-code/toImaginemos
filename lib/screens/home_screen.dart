import 'package:flutter/material.dart';
import 'package:to_imaginemos_app/models/models.dart';
import 'package:to_imaginemos_app/screens/note_screen.dart';

import 'package:to_imaginemos_app/services/services.dart';
import 'package:to_imaginemos_app/widgets/widgets.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final NoteService _noteService = NoteService();
  String? _selectedCategory = 'todas'; // Valor inicial para la categoría

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Tus notas',
          style: TextStyle(
            fontSize: 20,
            color: Colors.white,
          ), // Reducir el tamaño del título
        ),
        leading: IconButton(
          icon: Icon(Icons.logout),
          onPressed: () {
            Navigator.pushReplacementNamed(context, 'login');
          },
        ),
        actions: [
          // Contenedor con fondo blanco para el DropdownButton
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white, // Fondo blanco
                borderRadius: BorderRadius.circular(8), // Bordes redondeados
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.2),
                    spreadRadius: 1,
                    blurRadius: 4,
                  ),
                ],
              ),
              child: DropdownButton<String>(
                value: _selectedCategory,
                items: const [
                  DropdownMenuItem(
                    value: 'personal',
                    child: Text('personal'),
                  ),
                  DropdownMenuItem(
                    value: 'trabajo',
                    child: Text('trabajo'),
                  ),
                  DropdownMenuItem(
                    value: 'idea',
                    child: Text('idea'),
                  ),
                  DropdownMenuItem(
                    value: 'todas',
                    child: Text('todas'),
                  ),
                ],
                onChanged: (value) {
                  setState(() {
                    _selectedCategory = value; // Actualizar categoría seleccionada
                  });
                  print("Categoría seleccionada: $value");
                },
                hint: Padding(
                  padding: const EdgeInsets.only(
                      left: 8.0), // Agrega espacio horizontal al hint
                  child: Text('Categoría'),
                ),
                icon: Icon(Icons.arrow_downward),
                underline: SizedBox(), // Eliminar la línea debajo del Dropdown
              ),
            ),
          ),
        ],
      ),
      body: StreamBuilder<List<Note>>(
        stream: _noteService.getNotes(category: _selectedCategory), // Pasar la categoría seleccionada
        builder: (context, snapshot) {
          if (snapshot.hasError) return Text('Error: ${snapshot.error}');
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }
          final notes = snapshot.data!;
          return ListView.builder(
            itemCount: notes.length,
            itemBuilder: (context, index) {
              final note = notes[index];
              return NoteCard(note: note);
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => NoteScreen()),
          );
        },
      ),
    );
  }
}
