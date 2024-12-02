import 'package:flutter/material.dart';
import 'package:to_imaginemos_app/BLoC/notes/notes_bloc.dart';
import 'package:to_imaginemos_app/models/models.dart';
import 'package:to_imaginemos_app/screens/note_screen.dart';
import 'package:to_imaginemos_app/widgets/widgets.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final NoteService _noteService = NoteService();
  String? _selectedCategory = 'todas';
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Tus notas',
          style: TextStyle(fontSize: 20, color: Colors.white),
        ),
        leading: IconButton(
          icon: Icon(Icons.logout),
          onPressed: () {
            Navigator.pushReplacementNamed(context, 'login');
          },
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: Container(
              padding: const EdgeInsets.only(left: 12.0, right: 8.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
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
                    child: Row(
                      children: [
                        Icon(Icons.person,
                            color: Colors.blue), 
                        SizedBox(width: 8), 
                        Text('Personal'),
                      ],
                    ),
                  ),
                  DropdownMenuItem(
                    value: 'trabajo',
                    child: Row(
                      children: [
                        Icon(Icons.work,
                            color: Colors.green),
                        SizedBox(width: 8),
                        Text('Trabajo'),
                      ],
                    ),
                  ),
                  DropdownMenuItem(
                    value: 'idea',
                    child: Row(
                      children: [
                        Icon(Icons.lightbulb_outline,
                            color: Colors.orange), 
                        SizedBox(width: 8),
                        Text('Idea'),
                      ],
                    ),
                  ),
                  DropdownMenuItem(
                    value: 'todas',
                    child: Row(
                      children: [
                        Icon(Icons.all_inclusive,
                            color: Colors.purple), 
                        SizedBox(width: 8),
                        Text('Todas'),
                      ],
                    ),
                  ),
                ],
                onChanged: (value) {
                  setState(() {
                    _selectedCategory = value;
                  });
                },
                underline: SizedBox(),
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                labelText: 'Buscar nota',
                hintText: 'lo que buscas es a Andres...',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
              ),
              onChanged: (value) {
                setState(() {
                  _searchQuery = value; 
                });
              },
            ),
          ),
          Expanded(
            child: StreamBuilder<List<Note>>(
              stream: _noteService.getNotes(category: _selectedCategory),
              builder: (context, snapshot) {
                if (snapshot.hasError) return Text('Error: ${snapshot.error}');
                if (!snapshot.hasData) {
                  return Center(child: CircularProgressIndicator());
                }
                final notes = snapshot.data!.where((note) {
                  final query = _searchQuery.toLowerCase();
                  return note.title.toLowerCase().contains(query) ||
                      note.body.toLowerCase().contains(query);
                }).toList();
                if (notes.isEmpty) {
                  return Center(child: Text('no hay notas por aqui...'));
                }
                return ListView.builder(
                  itemCount: notes.length,
                  itemBuilder: (context, index) {
                    final note = notes[index];
                    return NoteCard(note: note);
                  },
                );
              },
            ),
          ),
        ],
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
