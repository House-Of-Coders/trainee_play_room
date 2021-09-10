import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/widgets.dart';
import 'package:json_draggable/models/Match.dart';

class MatchNotifier extends ChangeNotifier {
  List<Match> matches;
  final firestoreInstance = FirebaseFirestore.instance;
  FirebaseStorage storage = FirebaseStorage.instance;
  bool loaded = false;
  Match currentMatch;
  List<Question> currentQuestions;
  int cur = -1 ;
 
  MatchNotifier() {
    fetchRemoteData();
  }

  next() async {
    if (this.matches.length == 0) return cur++;
    if (cur == this.matches.length) cur = 0;
    this.cur++;
    this.currentMatch = this.matches[this.cur];
    this.currentQuestions = this.currentMatch.questions.toList(); //clone to  a new list
       
    this.currentQuestions.shuffle();
    notifyListeners();
  }

  

  fetchRemoteData() {
    matches = new List();
    firestoreInstance
        .collection("matches")
        .limit(6)
        .get()
        .then((querySnapshot) {
      querySnapshot.docs.forEach((result) {
        if (result != null) {
          List qs = result.get("questions");
          List<Question> questions = new List();

          qs.forEach((res) {
            print(res);
            questions.add(new Question(
                answer: res["answer"], drag: res["drag"], name: res["name"]));
          });

          Match match = new Match(
              background: result.get("background"),
              questions: questions,
              title: result.get("title"),
              matchId: result.id);
          print(match.background);
          matches.add(match);
        }
      });
      loaded = true;
      notifyListeners();
    });
  }
}
