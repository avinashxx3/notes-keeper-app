import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:notes_keeper/models/notes_list.dart';
import 'package:notes_keeper/models/user_model.dart';

class DatabaseService {
  final String uid;
  String noteId;
  DatabaseService({this.uid, this.noteId}){
    print(noteId);
    print(uid);
  }

  Future deleteNotesData() async{
    final CollectionReference notesCollection = FirebaseFirestore.instance.collection(uid.toString());
    return await notesCollection.doc(noteId).delete();
  }

  Future updateNotesData(String heading, String content) async{
    final CollectionReference notesCollection = FirebaseFirestore.instance.collection(uid.toString());
    return await notesCollection.doc(noteId).update({
      'uid' : noteId,
      'heading' : heading,
      'content' : content,
    });
  }

  Future addNotesData(String heading, String content) async{
    final CollectionReference notesCollection = FirebaseFirestore.instance.collection(uid.toString());
    return await notesCollection.add({
      'uid' : this.noteId,
      'heading' : heading,
      'content' : content,
    }).then((ref) => {noteId = ref.id})
    .then((_) => {
      notesCollection.doc(noteId).update({
        'uid' : noteId,
        'heading' : heading,
        'content' : content,
    })});
  }

  //notes data from QuerySnapshot
  List<NotesData> _notesDataFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc){
      return NotesData(
        noteId: doc['uid']?? null,
        heading: doc['heading'] ?? "",
        content: doc['content'] ?? "" ,
      );
    }).toList();
  }

  //userdata from snapshot
  UserData _userDataFromSnapshot(DocumentSnapshot snapshot) {
    return UserData(
      noteID: noteId,
      noteHeading: snapshot[3].data(),
      noteContent: snapshot[2].data(),
    );
  }

  //setup stream for accessing notes data
  Stream<List<NotesData>> get notes {
    final CollectionReference notesCollection = FirebaseFirestore.instance.collection(uid.toString());
    return notesCollection.snapshots()
    .map(_notesDataFromSnapshot);
  }

  //stream to get userData
  Stream<UserData> get userData {
    final CollectionReference notesCollection = FirebaseFirestore.instance.collection(uid.toString());
    return notesCollection.doc(noteId).snapshots()
        .map(_userDataFromSnapshot);
  }
}