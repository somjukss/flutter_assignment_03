import 'package:flutter/material.dart';
import 'package:flutter_assignment_03/utility/firestore_utils.dart';

class NewSubject extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return NewSubjectState();
  }
}

class NewSubjectState extends State<StatefulWidget> {
  final _formkey = GlobalKey<FormState>();
  TextEditingController subjectNew = TextEditingController();
  // TodoProvider tdProv = TodoProvider();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('New Subject'),
        backgroundColor: Colors.pink,
      ),
      body: Form(
        key: _formkey,
        child: ListView(
          children: <Widget>[
            TextFormField(
              controller: subjectNew,
              decoration: InputDecoration(labelText: 'Subject'),
              style: TextStyle(fontSize: 20,color: Colors.black),
              validator: (value) {
                if (value.isEmpty) {
                  return "Please fill subject";
                }
              },
            ),
            RaisedButton(
              child: Text(
                'Save',
                style: TextStyle(
                  fontSize: 20,
                ),
              ),
              onPressed: () {
                _formkey.currentState.validate();
                if(subjectNew.text.isNotEmpty){
                  FirestoreUtils.addTask(subjectNew.text);
                  Navigator.pop(context,true);
                }
              },
            )
          ],
        ),
      ),
    );
  }
}
