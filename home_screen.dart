import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:notes/Screens/note_editor.dart';
import 'package:notes/Style/app_style.dart';
import 'package:notes/Widgets/note_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppStyle.mainColor,
      appBar: AppBar(
        elevation: 0.0,
        title: Text("Notes", style: GoogleFonts.roboto(fontSize: 32, fontWeight: FontWeight.bold),),
        centerTitle: true,
        backgroundColor: AppStyle.mainColor,
      ),

      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: 20.0,

            ),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance.collection("Notes").snapshots(),
                builder: (context, AsyncSnapshot<QuerySnapshot> snapshot){
                  if(snapshot.connectionState == ConnectionState.waiting)
                  {
                    return const Center(child: CircularProgressIndicator());
                  }
            
                  if(snapshot.hasData)
                  {
                    return GridView(gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2),
                      children: snapshot.data!.docs.map((note) => noteCard(()
                      {Navigator.push(context, MaterialPageRoute(builder: (context) => NoteEditorScreen(note)));},
                      note)).toList(),
                    );   
                  }
                  return Text("No notes here",
                   style: GoogleFonts.nunito(color: Colors.white),);
                },
              ),
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          Navigator.push(context, MaterialPageRoute(builder: (context) => NoteEditorScreen(null)));
        },
        backgroundColor: AppStyle.accentColor, 
        child: const Icon(Icons.add, color: Colors.black),
        ),
    );
  }
}