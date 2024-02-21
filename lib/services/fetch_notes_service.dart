import 'package:cloud_firestore/cloud_firestore.dart';

class FetchNotesService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<Map<String, dynamic>>> fetchAllNotes() async {
    try {
      final QuerySnapshot<Map<String, dynamic>> snapshot =
          await _firestore.collection("Notes").get();
      return snapshot.docs.map((doc) => doc.data()).toList();
    } catch (error) {
      print('Error fetching notes: $error');
      return [];
    }
  }
}
