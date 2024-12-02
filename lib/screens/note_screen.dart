import 'package:flutter/material.dart';
import 'package:to_imaginemos_app/BLoC/notes/notes_service.dart';
import 'package:to_imaginemos_app/models/models.dart';

class NoteScreen extends StatefulWidget {
  final Note? note;

  const NoteScreen({super.key, this.note});

  @override
  _NoteScreenState createState() => _NoteScreenState();
}

class _NoteScreenState extends State<NoteScreen> {
  final _formKey = GlobalKey<FormState>();
  final NoteService _noteService = NoteService();
  late TextEditingController _titleController;
  late TextEditingController _bodyController;
  String? _selectedCategory;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.note?.title ?? '');
    _bodyController = TextEditingController(text: widget.note?.body ?? '');

    if (widget.note != null) {
      _selectedCategory = widget.note!.category;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.note == null
            ? 'Nueva Nota'
            : 'Editar Nota'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
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
              DropdownButtonFormField<String>(
                value: _selectedCategory,
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedCategory = newValue!;
                  });
                },
                items: const [
                  DropdownMenuItem(
                    value: 'personal',
                    child: Text('Personal'),
                  ),
                  DropdownMenuItem(
                    value: 'trabajo',
                    child: Text('Trabajo'),
                  ),
                  DropdownMenuItem(
                    value: 'idea',
                    child: Text('Idea'),
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

              TextFormField(
                controller: _bodyController,
                decoration: const InputDecoration(labelText: 'Contenido'),
                maxLines: 12,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingresa el contenido';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 36.0),
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    final noteData = Note(
                      id: widget.note?.id ?? '',
                      title: _titleController.text,
                      body: _bodyController.text,
                      creationDate: widget.note?.creationDate ?? DateTime.now(),
                      modificationDate: DateTime.now(),
                      uid: widget.note?.uid ?? '', 
                      category: _selectedCategory!,
                    );

                    if (widget.note == null) {
                      await _noteService.addNote(noteData);
                    } else {
                      await _noteService.updateNote(noteData);
                    }
                    Navigator.pop(context);
                  }
                },
                child: Text(
                    widget.note == null ? 'Guardar' : 'Actualizar'),
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
