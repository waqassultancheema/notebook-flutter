import 'package:flutter/material.dart';
import 'package:note_keeper_flutter_app/screens/note_detail.dart';
import 'package:note_keeper_flutter_app/utlits/database_helper.dart';
import 'package:sqflite/sqflite.dart';
import 'package:note_keeper_flutter_app/models/note.dart';
import 'package:intl/intl.dart';
import 'dart:async';

class NoteList extends StatefulWidget {

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return NoteListState();

  }
}

class NoteListState extends State<NoteList> {
  var itemCount = 0;
  List<Note> notelist;
  @override
  Widget build(BuildContext context) {
    // TODO: implement build

    if(notelist == null){
      notelist = List<Note>();
      Note note = Note("waqas", "23/23/2",1);
      notelist.add(note);
      updateListView();
    }

    return Scaffold(
      appBar: AppBar(
        title:  Text("Notes"),
      ),
      body: getNoteListView(),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          navigateToDetail(null, "Add Note");
        },
        tooltip: "Add Note",
        child: Icon(Icons.add),
      ),
    );
  }
  ListView getNoteListView(){

    TextStyle titleStyle = Theme.of(context).textTheme.subhead;

    return ListView.builder(
      itemCount: itemCount,
      itemBuilder:(BuildContext context , int position) {
        return Card(
          color: Colors.white,
          elevation: 2.0,
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: getPriorityColor(notelist[position].priority),
              child: getPriorityIcon(notelist[position].priority),
            ) ,
            title: Text(notelist[position].title,style: titleStyle),
            subtitle: Text(notelist[position].date,style: titleStyle),
            trailing: GestureDetector(
              child: Icon(Icons.delete,color: Colors.grey),
              onTap: (){
                _delete(context,this.notelist[position]);
              },
            ) ,
            onTap: (){
              navigateToDetail(notelist[position], "Edit Note");
              // TODO:
            },
          ),
        );
      },
    );
  }

  Color getPriorityColor(int priority) {
    switch(priority){
      case 1:
        return Colors.red;
        break;
      case 2:
        return Colors.yellow;
        break;
      default:
        return Colors.yellow;
    }
  }
  Icon getPriorityIcon(int priority) {
    switch(priority){
      case 1:
        return Icon(Icons.play_arrow);
        break;
      case 2:
        return Icon(Icons.keyboard_arrow_right);
        break;
      default:
        return Icon(Icons.keyboard_arrow_right);
    }
  }
  void _delete(BuildContext context, Note note) async {
    int result = await DatabaseHelper().deleteNote(note.id);
    if(result != 0) {
      _showSnackBar(context, "Note Deleted Successfully");
      updateListView();
    }
  }

  void _showSnackBar(BuildContext context,String message){
    final snackBar = SnackBar(content: Text(message));
    Scaffold.of(context).showSnackBar(snackBar);
  }

  void navigateToDetail(Note note,String title) async {
    bool result = await Navigator.push(context,MaterialPageRoute(builder: (context){
      return NoteDetails(title,note);
    }));

    if (result == true) {
      updateListView();
    }

  }

  void updateListView(){

    final Future<Database> dbFuture = DatabaseHelper().initializeDatabase();

    dbFuture.then((database){

      var noteListFuture = DatabaseHelper().getNoteList();

      noteListFuture.then((noteList){
        setState(() {
          this.notelist = noteList;
          this.itemCount = noteList.length;
        });
      });
    });
  }


}