import 'package:flutter/material.dart';

import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../data/todo_list_manager.dart';
import 'input_view.dart';

class TodoListView extends StatelessWidget {
  const TodoListView({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<TodoListManager>(builder: (context, listManager, child) {
      return Scaffold(
        appBar: AppBar(title: Text("Todo list"), actions: <Widget>[
          IconButton(
            icon: Icon(Icons.panorama),
            tooltip: 'Main page',
            onPressed: () {
              Navigator.pushNamed(context, '/main');
            },
          ),
          IconButton(
            icon: Icon(Icons.add),
            tooltip: 'Lisää uusi',
            onPressed: () {
              Navigator.pushNamed(context, '/input');
            },
          ),
          IconButton(
            icon: Icon(Icons.person),
            tooltip: 'Profiili',
            onPressed: () {
              Navigator.pushNamed(context, '/profile');
            },
          ),
          IconButton(
            icon: Icon(Icons.camera),
            tooltip: 'Camera',
            onPressed: () {
              Navigator.pushNamed(context, '/camera');
            },
          ),
        ]),
        body: ListView.builder(
            itemCount: listManager.items.length,
            itemBuilder: (context, index) {
              return _BuildTodoCard(
                  listManager.items[index], context, listManager);
            }),
      );
    });
  }
}

Center _BuildTodoCard(item, BuildContext context, TodoListManager listManager) {
  return Center(
    child: Card(
      child: Column(
        children: [
          ListTile(
            title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(item.title),
                  Text(DateFormat('dd.MM.yyyy').format(item.deadline)),
                  Text(item.fbid),
                ]),
            subtitle: Text(item.description),
            trailing: IconButton(
                onPressed: () {
                  listManager.toggleDone(item);
                },
                icon: Icon(
                  Icons.done,
                  color: item.done ? Colors.green : Colors.grey,
                )),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => InputView(item: item)),
                    );
                  },
                  child: Text("Muokkaa")),
              TextButton(
                onPressed: () {
                  //Provider.of<TodoListManager>(context, listen: false)
                  // .delete(item);
                  listManager.delete(item);
                },
                child: Text("Poista"),
              )
            ],
          )
        ],
      ),
    ),
  );
}
