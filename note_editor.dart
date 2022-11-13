import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:notes/Style/app_style.dart';

class NoteEditorScreen extends StatefulWidget {
  NoteEditorScreen(this.doc, {Key? key}) : super(key: key);
  QueryDocumentSnapshot? doc;

  @override
  State<NoteEditorScreen> createState() => _NoteEditorScreenState();
}

class _NoteEditorScreenState extends State<NoteEditorScreen> {
  @override
  Widget build(BuildContext context) {

    bool isNew = (widget.doc == null);

    TextEditingController titleController = TextEditingController(
      text: isNew ? "" : widget.doc!['note_title']);

    TextEditingController mainController = TextEditingController(
      text: isNew ? "" : widget.doc!['note_content']);

    int colorId = isNew ?
     Random().nextInt(AppStyle.cardsColor.length) : widget.doc!['color_id'];
     
    String date = isNew ?
     DateFormat('dd.MM.yy').format(DateTime.now()) : widget.doc!['creation_date'];
    
    return Scaffold(
      backgroundColor: AppStyle.cardsColor[colorId],
      appBar: AppBar(
        backgroundColor: AppStyle.mainColor,
        elevation: 0.0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: titleController,
              decoration: const InputDecoration(
                border: InputBorder.none,
                hintText: 'Note title'
              ),
              style: AppStyle.mainTitle,
            ),
            const SizedBox(height: 8),
            Text(date, style: AppStyle.dateTitle,),
            const SizedBox(height: 28.0),
            TextField(
              controller: mainController,
              keyboardType: TextInputType.multiline,
              maxLines: null,
              decoration: const InputDecoration(
                border: InputBorder.none,
              ),
              style: AppStyle.mainContent,
            ),
          ],
        ), 
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          FloatingActionButton(
            heroTag: 'saveBtn',
            onPressed: () async {
              if(isNew)
              {
              FirebaseFirestore.instance.collection("Notes").add({
                "note_title": titleController.text,
                "creation_date": date,
                "note_content": mainController.text,
                "color_id": colorId
              }).then((value){
                Navigator.pop(context);
              }).catchError((error) => print("Failed saving due $error"));
              }
              else
              {
                FirebaseFirestore.instance.collection("Notes").doc(widget.doc!.id).update({
                  "note_title": titleController.text,
                  "creation_date": date,
                  "note_content": mainController.text,
                  "color_id": colorId
                }).then((value){
                  Navigator.pop(context);
                }).catchError((error) => print("Failed saving due $error"));
              }
            },
            backgroundColor: AppStyle.mainColor, 
            child: const Icon(Icons.save, color: Colors.white),
          ),
        const SizedBox(width: 20),
        FloatingActionButton(
          heroTag: 'dltBtn',
          onPressed: () async {
            Navigator.pop(context);
            if(!isNew)
            {
              FirebaseFirestore.instance.collection("Notes").doc(widget.doc!.id).delete();
            }
            },
          backgroundColor: AppStyle.mainColor,
          child: const Icon(Icons.delete,),
        ),
    ],)
    );
  }
}