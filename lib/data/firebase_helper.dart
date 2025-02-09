import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'todo_item.dart';

class FirebaseHelper {
  final DatabaseReference _todoitemsRef = FirebaseDatabase.instance
      .ref()
      .child('todoitems')
      .child(FirebaseAuth.instance.currentUser!.uid);

  void saveTodoItem(TodoItem item) {
    var itemRef = _todoitemsRef.push();
    item.fbid = itemRef.key;
    item.ownerId = FirebaseAuth.instance.currentUser!.uid;
    itemRef.set(item.toJson());
  }

  void deleteTodoItem(TodoItem item) {
    if (item.fbid != null) {
      _todoitemsRef.child(item.fbid!).remove();
    }
  }

  void updateTodoItem(TodoItem item) {
    if (item.fbid != null) {
      _todoitemsRef.child(item.fbid!).update(item.toJson());
    }
  }

  Future<List<TodoItem>> getData() async {
    List<TodoItem> items = [];

    DatabaseEvent event = await _todoitemsRef.once();
    var snapshot = event.snapshot;

    for (var child in snapshot.children) {
      TodoItem item = TodoItem.fromJson(child.value as Map<dynamic, dynamic>);
      item.fbid = child.key;
      items.add(item);
    }
    return items;
  }
}
