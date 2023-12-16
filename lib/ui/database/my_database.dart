import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:to_do/ui/database/model/task.dart';
import 'package:to_do/ui/database/model/user.dart';

class MyDatabase {
  static CollectionReference<User> getUsersCollections() {
    return FirebaseFirestore.instance
        .collection(User.collectionName)
        .withConverter<User>(
            fromFirestore: (snapShot, options) =>
                User.fromFireStore(snapShot.data()),
            toFirestore: (user, options) => user.toFireStore());
  }

  static CollectionReference<Task> getTasksCollection(String uid) {
    return getUsersCollections()
        .doc(uid)
        .collection(Task.collectionName)
        .withConverter<Task>(
            fromFirestore: (snapshot, options) =>
                Task.fromFireStore(snapshot.data()),
            toFirestore: (task, options) => task.toFireStore());
  }

  static Future<void> addUser(User user) {
    var collection = getUsersCollections();
    return collection.doc(user.id).set(user);
  }

  static Future<User?> readUser(String id) async {
    var collection = getUsersCollections();
    var docSnapshot = await collection.doc(id).get();
    return docSnapshot.data();
  }

  static Future<void> addTask(String uid, Task task) {
    var newTaskDoc = getTasksCollection(uid).doc();
    task.id = newTaskDoc.id;
    return newTaskDoc.set(task);
  }

  static Future<QuerySnapshot<Task>> getTasks(String uid) {
    return getTasksCollection(uid).get();
  }
  static Stream<QuerySnapshot<Task>> getTasksRealTimeUpdate(String uid)  {
    return getTasksCollection(uid).snapshots();
  }

  static Future<void> deleteTask(String uid, String taskId) {
    return getTasksCollection(uid).doc(taskId).delete();
  }
}
