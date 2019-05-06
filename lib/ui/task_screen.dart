import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import './NewSubject_screen.dart';
import 'package:flutter_assignment_03/utility/firestore_utils.dart';

class TaskScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return TaskScreenState();
  }
}

class TaskScreenState extends State {
  int current_state = 0;

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text("Todo"),
          actions: <Widget>[
            current_state == 0
                ? IconButton(
                    icon: Icon(Icons.add),
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => NewSubject()));
                    },
                  )
                : IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () {
                      FirestoreUtils.deleteAllCompleted();
                    },
                  )
          ],
          backgroundColor: Colors.pink,
        ),
        body: Center(
            child: current_state == 0
                ?
                // taskscreen
                StreamBuilder<QuerySnapshot>(
                    stream: Firestore.instance
                        .collection('todo')
                        .where('done', isEqualTo: false)
                        .snapshots(),
                    builder: (BuildContext context,
                        AsyncSnapshot<QuerySnapshot> snapshot) {
                      if (snapshot.hasData) {
                        return snapshot.data.documents.length == 0
                            ? Text("No data found..")
                            : ListView.builder(
                                itemCount: snapshot.data.documents.length,
                                itemBuilder: (context, int position) {
                                  return Column(
                                    children: <Widget>[
                                      Divider(
                                        height: 1.0,
                                        color: Colors.black,
                                      ),
                                      CheckboxListTile(
                                          title: Text(
                                            snapshot.data.documents[position]
                                                ['title'],
                                            style: TextStyle(
                                                fontSize: 18,
                                                color: Colors.redAccent),
                                          ),
                                          onChanged: (bool value) {
                                            FirestoreUtils.update(
                                                snapshot
                                                    .data
                                                    .documents[position]
                                                    .documentID,
                                                value);
                                          },
                                          value: snapshot.data
                                              .documents[position]['done']),
                                    ],
                                  );
                                },
                              );
                      }
                      else{
                        return CircularProgressIndicator();
                      }
                    },
                  )

                // completeScreen
                : StreamBuilder<QuerySnapshot>(
                    stream: Firestore.instance
                        .collection('todo')
                        .where('done', isEqualTo: true)
                        .snapshots(),
                    builder: (BuildContext context,
                        AsyncSnapshot<QuerySnapshot> snapshot) {
                      if (snapshot.hasData) {
                        return snapshot.data.documents.length == 0
                            ? Text("No data found..")
                            : ListView.builder(
                                itemCount: snapshot.data.documents.length,
                                itemBuilder: (context, int position) {
                                  return Column(
                                    children: <Widget>[
                                      Divider(
                                        height: 1.0,
                                        color: Colors.black,
                                      ),
                                      CheckboxListTile(
                                          title: Text(
                                            snapshot.data.documents[position]
                                                ['title'],
                                            style: TextStyle(
                                                fontSize: 18,
                                                color: Colors.green),
                                          ),
                                          onChanged: (bool value) {
                                            FirestoreUtils.update(
                                                snapshot
                                                    .data
                                                    .documents[position]
                                                    .documentID,
                                                value);
                                          },
                                          value: snapshot.data
                                              .documents[position]['done']),
                                    ],
                                  );
                                },
                              );
                      }
                      else{
                        return CircularProgressIndicator();
                      }
                    },
                  )),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: current_state,
          items: [
            BottomNavigationBarItem(
                icon: Icon(Icons.list), title: Text('Task')),
            BottomNavigationBarItem(
                icon: Icon(Icons.done_all), title: Text('Complete'))
          ],
          onTap: (int index) {
            setState(() {
              current_state = index;
            });
          },
        ),
      ),
    );
  }
}
