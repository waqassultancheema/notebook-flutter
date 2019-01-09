import 'package:flutter/material.dart';
import 'package:note_keeper_flutter_app/screens/note_list.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return MaterialApp(
      title: "Note Keeper",
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,

      ),
      home: NoteList(),
    );
  }
}
