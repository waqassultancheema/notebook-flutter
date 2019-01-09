import 'package:flutter/material.dart';
import 'package:note_keeper_flutter_app/utlits/database_helper.dart';
import 'package:sqflite/sqflite.dart';
import 'package:note_keeper_flutter_app/models/note.dart';
import 'package:intl/intl.dart';
import 'dart:async';

class NoteDetails extends StatefulWidget {

  var appBarTitle =  "";
  Note  note;
  NoteDetails(this.appBarTitle,this.note);
  @override
  State<StatefulWidget> createState() {
    if (this.note == null){
      this.note = Note("", "", 1);
    }
    return NoteDetailsState(this.appBarTitle,this.note);
  }
}

class NoteDetailsState extends State<NoteDetails> {

  static var _priorities = ["High","Low"];
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  @override
  var appBarTitle = "";
  Note  note;
  NoteDetailsState(this.appBarTitle,this.note);
  Widget build(BuildContext context) {
    // TODO: implement build
    return WillPopScope(
      onWillPop: (){
        popToMainScreen();
      },
      child: Scaffold(
          appBar: AppBar(
            title:  Text(appBarTitle),
          ),
          body: Padding(
            padding: EdgeInsets.only(
                top: 15.0,
                left: 15.0,
                right: 10.0
            ),
            child: getNoteDetailView(),
          )
      ),
    );
  }
  ListView getNoteDetailView(){

    TextStyle titleStyle = Theme.of(context).textTheme.title;

    titleController.text = note.title;
    descriptionController.text = note.description;
    return ListView(
      children: <Widget>[

        ListTile(
          title: DropdownButton(
            items: _priorities.map((String dropDownStringItem){
              return DropdownMenuItem<String>(
                value: dropDownStringItem,
                child: Text(dropDownStringItem),
              );
            }).toList(),
            style: titleStyle,
            value: getPriorityAsString(note.priority),
            onChanged: (valueSelectedBYBuyer){
              setState(() {
                updatePriorityAsInt(valueSelectedBYBuyer);
              });
              // TODO:add selection behviour
            },
          ),
        ),
        Padding(
          padding: EdgeInsets.only(top: 15.0,bottom: 15.0),
          child: TextField(
            controller: titleController,
            onChanged: (value){
              note.title = value;
              //TODO: need to add code
            },
            decoration: InputDecoration(
              labelText: "Title",
              labelStyle: titleStyle,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(5.0)
              )
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(top: 15.0,bottom: 15.0),
          child: TextField(
            controller : descriptionController,
            onChanged: (value){
              note.description = value;
            },
            decoration: InputDecoration(
                labelText: "Description",
                labelStyle: titleStyle,
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5.0)
                )
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(top: 15.0,bottom: 15.0),
          child: Row(
            children: <Widget>[
              Expanded(
                child: RaisedButton(
                  child: Text("Save",textScaleFactor: 1.5),
                  onPressed: (){
                    setState(() {
                      save();
                    });
                  },
                  elevation: 1.0,
                  textColor:Theme.of(context).primaryColorLight,
                  color:Theme.of(context).primaryColorDark,
                ),
              ),
              Container(
                width: 5.0,
              ),
              Expanded(
                child: RaisedButton(
                  child: Text("Delete",textScaleFactor: 1.5),
                  onPressed: (){
                    setState(() {
                      delete();
                    });
                  },
                  elevation: 1.0,
                  textColor:Theme.of(context).primaryColorLight,
                  color:Theme.of(context).primaryColorDark,
                ),
              )
            ],
          ),
        )
      ],
    );
  }

  void updatePriorityAsInt(String val){

    switch(val) {
      case 'High':
        note.priority = 1;
        break;
      case 'Low':
        note.priority = 2;
        break;
    }
  }

  String getPriorityAsString(int val){

    switch(val) {
      case 1:
        return _priorities[0];
        break;
      case 2:
        return _priorities[1];
        break;
    }
  }

  void save() async {
    int result = 0;
    note.date = DateFormat.yMMMd().format(DateTime.now());
    if (note.id != null) {
      result  = await DatabaseHelper().updateNote(note);
    } else {
      result  = await DatabaseHelper().insertNote(note);
    }

    if(result != 0) {
      _showAlterDialog("Status", "Note Saved Succesfully");
    } else {
      _showAlterDialog("Status", "Problem While Saving");
    }
    popToMainScreen();
  }

  void delete() async {
    int result = 0;
    if (note.id != null) {
      result  = await DatabaseHelper().deleteNote(note.id);
    } else {

    }

    if(result != 0) {
      _showAlterDialog("Status", "Note Delete Succesfully");
    } else {
      _showAlterDialog("Status", "Problem While Deleting");
    }
    popToMainScreen();
  }

  void _showAlterDialog(String title,String message) {

    AlertDialog alertDialog = AlertDialog(
      title: Text(title),
      content: Text(message),
    );
    showDialog(context: context,builder: (_) => alertDialog);
  }

  void popToMainScreen(){
    Navigator.pop(context,true);
  }

}