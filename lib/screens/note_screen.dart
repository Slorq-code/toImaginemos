import 'package:flutter/material.dart';
import 'package:to_imaginemos_app/models/models.dart';
import 'package:to_imaginemos_app/services/services.dart';

class NoteScreen extends StatefulWidget {
  final Note? note; // Parámetro opcional para recibir la nota a editar

  const NoteScreen({super.key, this.note}); // Constructor modificado

  @override
  _NoteScreenState createState() => _NoteScreenState();
}

class _NoteScreenState extends State<NoteScreen> {
  final _formKey = GlobalKey<FormState>();
  final NoteService _noteService = NoteService();

  // Controladores para los campos de texto
  late TextEditingController _titleController;
  late TextEditingController _bodyController;

  // Controlador para la categoría
  String? _selectedCategory;

  @override
  void initState() {
    super.initState();
    // Inicializar controladores con los valores de la nota si existe
    _titleController = TextEditingController(text: widget.note?.title ?? '');
    _bodyController = TextEditingController(text: widget.note?.body ?? '');

    if (widget.note != null) {
      _selectedCategory = widget.note?.category;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.note == null
            ? 'Nueva Nota'
            : 'Editar Nota'), // Título dinámico
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              // Título
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(labelText: 'Título'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingresa un título';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16.0),

              // Categoría
              DropdownButtonFormField<String>(
                value: _selectedCategory,
                onChanged: (String? newValue) {
                  setState(() {
                    print(
                        "********************************************************");
                    print("newValue: $newValue");
                    _selectedCategory = newValue;
                    print("_selectedCategory: $_selectedCategory");
                    print(
                        "********************************************************");
                  });
                },
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
                ],
                decoration: const InputDecoration(labelText: 'Categoría'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor selecciona una categoría';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20.0),

              // Contenido
              TextFormField(
                controller: _bodyController,
                decoration: const InputDecoration(labelText: 'Contenido'),
                maxLines: 5,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingresa el contenido';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16.0),

              // Botón para guardar o actualizar la nota
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    final noteData = Note(
                      id: widget.note?.id ?? '',
                      title: _titleController.text,
                      body: _bodyController.text,
                      creationDate: widget.note?.creationDate ?? DateTime.now(),
                      modificationDate: DateTime.now(),
                      uid: widget.note?.uid ??
                          '', // Asegúrate de que el UID esté presente
                      category:
                          _selectedCategory!, // Asignar la categoría seleccionada
                    );

                    if (widget.note == null) {
                      // Crear una nueva nota
                      await _noteService.addNote(noteData);
                    } else {
                      // Actualizar la nota existente
                      await _noteService.updateNote(noteData);
                    }
                    Navigator.pop(context); // Volver a la pantalla anterior
                  }
                },
                child: Text(
                    widget.note == null ? 'Guardar Nota' : 'Actualizar Nota'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _titleController.dispose();
    _bodyController.dispose();
    super.dispose();
  }
}
