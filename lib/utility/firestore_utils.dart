import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreUtils {
  static void addTask(String title) {
    Firestore.instance
        .collection('todo')
        .document()
        .setData({'title': title, 'done': false});
  }

  static void update(String id, bool value) {
    final DocumentReference todo = Firestore.instance.document('todo/' + id);

    Firestore.instance.runTransaction((Transaction tx) async {
      DocumentSnapshot postSnapshot = await tx.get(todo);
      if (postSnapshot.exists) {
        await tx.update(todo, <String, dynamic>{'done': value});
      }
    });
  }

  static void deleteAllCompleted() async {
    QuerySnapshot query = await Firestore.instance
        .collection('todo')
        .where('done', isEqualTo: true)
        .getDocuments();

    query.documents.forEach((e) => FirestoreUtils.deleteEach(e.documentID));
  }

  static void deleteEach(String documentId) {
    final DocumentReference todo =
        Firestore.instance.document('todo/' + documentId);

    Firestore.instance.runTransaction((Transaction tx) async {
      DocumentSnapshot postSnapshot = await tx.get(todo);
      if (postSnapshot.exists) {
        await tx.delete(todo);
      }
    });
  }
}
