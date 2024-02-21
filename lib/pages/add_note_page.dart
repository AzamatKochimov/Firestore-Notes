import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:math';

import '../style/app_style.dart';

class AddNote extends StatefulWidget {
  static String id = "add-note";
  const AddNote({Key? key}) : super(key: key);

  @override
  State<AddNote> createState() => _AddNoteState();
}

class _AddNoteState extends State<AddNote> {
  TextEditingController titleController = TextEditingController();
  TextEditingController contentController = TextEditingController();

  int colorId = 0;
  late String creationDate;

  @override
  void initState() {
    super.initState();
    creationDate = DateFormat("dd/MM/yyyy hh:mm a").format(DateTime.now());
    colorId = Random().nextInt(10);
  }

  @override
  void dispose() {
    titleController.dispose();
    contentController.dispose();
    super.dispose();
  }

  void addNote() async {
    String title = titleController.text.trim();
    String content = contentController.text.trim();

    if (title.isNotEmpty && content.isNotEmpty) {
      try {
        await FirebaseFirestore.instance.collection('Notes').add({
          'color_id': colorId,
          'creation_date': creationDate,
          'note_content': content,
          'note_title': title,
        });
        Navigator.pop(context);
      } catch (error) {
        print('Error adding note: $error');
      }
    } else {
      setState(() {
        isEmpty = true;
      });
    }
  }

  bool isEmpty = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppStyle.mainColor,
      appBar: AppBar(
        backgroundColor: AppStyle.mainColor,
        foregroundColor: AppStyle.accentColor,
        title: const Text("Your Note"),
        centerTitle: true,
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal:50),
        child: Column(
          children: [
            TextField(
              controller: titleController,
              decoration: InputDecoration(
                hintStyle: const TextStyle(color: Colors.white24),
                hintText: 'Title',
                errorText: isEmpty ? 'Title is required' : null,
              ),
              style: const TextStyle(color: Colors.white),
              textInputAction: TextInputAction.next,
            ),
            TextField(
              controller: contentController,
              decoration: InputDecoration(
                hintStyle: const TextStyle(color: Colors.white24),
                hintText: 'Content',
                errorText: isEmpty ? 'Content is required' : null,
              ),
              style: const TextStyle(color: Colors.white),
              textInputAction: TextInputAction.done,
              keyboardType: TextInputType.multiline,
              maxLines: null,
            ),
            const SizedBox(height: 15),
            MaterialButton(
              onPressed: addNote,
              shape: const StadiumBorder(side: BorderSide(width: 1, color: Colors.white70)),
              child: const Text("Done", style: TextStyle(color: Colors.white),),
            ),
          ],
        ),
      ),
    );
  }
}
