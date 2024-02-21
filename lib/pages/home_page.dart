import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firestore_notes/pages/add_note_page.dart';
import 'package:firestore_notes/widgets/note_card.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import '../style/app_style.dart';

class HomePage extends StatefulWidget {
  static String id = "home-page";
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppStyle.mainColor,
      appBar: AppBar(
        elevation: 0.0,
        title: Text("Firestore Notes", style: GoogleFonts.roboto(
            color: Colors.white70,
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        ),
        centerTitle: true,
        backgroundColor: AppStyle.mainColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream:
                    FirebaseFirestore.instance.collection("Notes").snapshots(),
                builder: (context, AsyncSnapshot<QuerySnapshot> notes) {
                  if (notes.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }

                  if (notes.hasData) {
                    return GridView.builder(
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 8.0,
                        mainAxisSpacing: 8.0,
                      ),
                      itemCount: notes.data!.docs.length,
                      itemBuilder: (context, index) {
                        final note = notes.data!.docs[index];
                        return noteCard(
                          () {
                          _editNoteDialog(context, note);
                        }, note);
                      },
                    );
                  }

                  return Center(
                    child: Text(
                      "There is no note",
                      style: GoogleFonts.nunito(color: Colors.white),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, AddNote.id);
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  void _editNoteDialog(BuildContext context, DocumentSnapshot note) {
    TextEditingController titleController =
        TextEditingController(text: note['note_title']);
    TextEditingController contentController =
        TextEditingController(text: note['note_content']);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Edit Note"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: titleController,
                decoration: const InputDecoration(labelText: 'Title'),
              ),
              TextField(
                controller: contentController,
                decoration: const InputDecoration(labelText: 'Content'),
                keyboardType: TextInputType.multiline,
                maxLines: null,
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                String title = titleController.text.trim();
                String content = contentController.text.trim();

                if (title.isNotEmpty && content.isNotEmpty) {
                  try {
                    await note.reference.update({
                      'note_title': title,
                      'note_content': content,
                      'creation_date':
                          DateFormat("dd/MM/yyyy hh:mm a").format(DateTime.now()),
                    });
                    Navigator.pop(context);
                  } catch (error) {
                    print('Error updating note: $error');
                  }
                }
              },
              child: const Text('Save'),
            ),
            ElevatedButton(
              onPressed: () async {
                try {
                  await note.reference.delete();
                  Navigator.pop(context);
                } catch (error) {
                  print('Error deleting note: $error');
                }
              },
              child: const Text('Delete', style: TextStyle(color: Colors.red),),
            ),
          ],
        );
      },
    );
  }
}
