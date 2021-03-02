import 'dart:collection';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
//import 'package:firebase_storage/firebase_storage.dart';
import 'package:json_draggable/models/Match.dart';
import 'package:flutter/material.dart';
import 'package:giffy_dialog/giffy_dialog.dart';
import 'package:json_draggable/services/match_notifier.dart';
import 'package:json_draggable/storage/fireStorageService.dart';
import 'dart:ui';
import '../dragObject.dart';

const List<Key> keys = [Key("Asset"), Key("AssetDialog")];

class Game extends StatefulWidget {
  final Match match;
  final List<Question> currentQuestions;
  final MatchNotifier matchNotifier;

  const Game({Key key, this.match, this.currentQuestions, this.matchNotifier})
      : super(key: key);

  @override
  _GameState createState() => _GameState();
}

class _GameState extends State<Game> {
  HashMap<String, bool> answerState = new HashMap();

  int score = 0;

  final firestoreInstance = FirebaseFirestore.instance;
  FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  FirebaseStorage storage = FirebaseStorage.instance;

  Future<String> getImage(
      BuildContext context, String matchId, String image) async {
    String downloadUrl =
        await FireStorageService.loadFromStorage(context, matchId, image);

    return downloadUrl.toString();
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(
    BuildContext context,
  ) {
    List<DragTarget> items = [];
    List<DragObject> dragOb = [];
    widget.match.questions.forEach((question) {
      items.add(buildDragTarget(
          context, question.drag, question.answer, question.name));
    });

    widget.currentQuestions.forEach((question) {
      dragOb.add(buildDragObject(
          context, question.drag, question.answer, question.name));
    });

    return Scaffold(
        body: new Container(
            child: Stack(
      children: <Widget>[
        Row(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(150, 30, 0, 0),
              child: Container(
                child: Text(
                  "Score : $score",
                  style: TextStyle(
                      color: Colors.grey[300],
                      fontSize: 30,
                      fontWeight: FontWeight.bold),
                ),
              ),
            )
          ],
        ),
        FutureBuilder(
          future:
              getImage(context, widget.match.matchId, widget.match.background),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done)
              return Container(
                child: Image.network(snapshot.data, fit: BoxFit.cover),
                width: double.infinity,
                height: double.infinity,
              );
            if (snapshot.connectionState == ConnectionState.waiting)
              return Container(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Center(child: CircularProgressIndicator()),
                  ],
                ),
              );

            return Container();
          },
        ),
        Padding(
          padding: const EdgeInsets.only(left: 250),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: items,
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(right: 250),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: dragOb,
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(150, 760, 0, 0),
          child: RaisedButton(
              key: keys[0],
              color: Colors.teal,
              child: Text(
                "Finished",
                style: TextStyle(
                    color: Colors.white, fontSize: 20, fontFamily: "Handlee"),
              ),
              onPressed: () async {
                bool result = await showDialog(
                    context: context,
                    builder: (_) => AssetGiffyDialog(
                          key: keys[1],
                          image: Image.asset(
                            'Assets/Images/yay.png',
                            fit: BoxFit.cover,
                          ),
                          title: Text(
                            'Shall we go to the next game ?',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 22.0,
                                fontWeight: FontWeight.w600,
                                fontFamily: "Handlee"),
                          ),
                          entryAnimation: EntryAnimation.BOTTOM_RIGHT,
                          description: Text(
                            'CLICK OK',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 21,
                                fontWeight: FontWeight.w600,
                                color: Colors.red,
                                fontFamily: "Handlee"),
                          ),
                          onOkButtonPressed: () {
                            Navigator.pop(context, true);
                          },
                          onCancelButtonPressed: () {
                            Navigator.pop(context);
                          },
                        ));
                if (result) {
                  widget.matchNotifier.next();
                }
              }),
        ),
      ],
    )));
  }

  DragObject buildDragObject(
      BuildContext context, String imageSrc, String feedbackSrc, String dName) {
    return DragObject(
      image: ("Assets/Images/$imageSrc"),
      dataName: dName,
    );
  }

  DragTarget<String> buildDragTarget(
      BuildContext context, String image, String image2, String name) {
    bool accepted = false;
    if (answerState.containsKey(name)) {
      accepted = answerState[name];
    }
    return DragTarget(
      builder: (context, List<String> data, rejectedData) {
        if (accepted == true) {
          return Row(
            children: [
              Container(
                child: Image.asset("Assets/Images/rigth.png"),
                width: 140,
                height: 140,
              ),
            ],
          );
        }
        return Container(
          child: accepted
              ? Image.asset(
                  "Assets/Images/$image",
                  width: 500,
                  height: 140,
                )
              : data.isEmpty
                  ? Image.asset(
                      "Assets/Images/$image2",
                      width: 140,
                      height: 140,
                    )
                  : Opacity(
                      opacity: 0.7,
                      child: Image.asset(
                        "Assets/Images/$image2",
                        width: 140,
                        height: 140,
                      ),
                    ),
        );
      },
      onWillAccept: (data) {
        return true;
      },
      onAccept: (data) {
        if (data == name) {
          setState(() {
            answerState[name] = true;
            score += 50;
          });
        }
      },
    );
  }
}
