import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:json_draggable/components/game.dart';
import 'package:json_draggable/models/Match.dart';
import 'package:json_draggable/services/match_notifier.dart';
import 'package:provider/provider.dart';

const List<Key> keys = [Key("Asset"), Key("AssetDialog")];

class GamePage extends StatefulWidget {
  @override
  _GamePageState createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> {
  @override
  Widget build(BuildContext context) {
    var jsonFile =
        "{ \"title\": \"Match the picture\", \"background\": \"forest.png\", \"questions\": [ {\"drag\": \"lamb.png\", \"answer\": \"grass.png\", \"name\": \"lamb\"}, {\"drag\": \"rabbit.png\", \"answer\": \"carrot.png\", \"name\": \"rabbit\"}, {\"drag\": \"lion.png\", \"answer\": \"meat.png\", \"name\": \"lion\"}, {\"drag\": \"cat.png\", \"answer\": \"milk.png\", \"name\": \"cat\"} ] }";
    var matchJson = json.decode(jsonFile);
    var match = Match.fromJson(matchJson);
    List<Match> matches = new List();
    matches.add(match);

    jsonFile =
        "{ \"title\": \"Match the picture\", \"background\": \"sunrise.jpg\", \"questions\": [ {\"drag\": \"airplane.png\", \"answer\": \"sky.png\", \"name\": \"airplane\"}, {\"drag\": \"car.png\", \"answer\": \"road.png\", \"name\": \"car\"}, {\"drag\": \"boat.png\", \"answer\": \"sea.png\", \"name\": \"boat\"}, {\"drag\": \"train.png\", \"answer\": \"railroad.png\", \"name\": \"train\"} ] }";
    matchJson = json.decode(jsonFile);
    match = Match.fromJson(matchJson);
    matches.add(match);

    return ChangeNotifierProvider<MatchNotifier>(
      create: (ctx) => new MatchNotifier(),
      child: Consumer<MatchNotifier>(
        builder: (ctx, changeNotifier, child) {
          if (changeNotifier.currentMatch != null) {
            return Game(
                match: changeNotifier.currentMatch,
                currentQuestions: changeNotifier.currentQuestions,
                matchNotifier: changeNotifier);
          } else {
            // changeNotifier.next();
            return Container(
              width: double.infinity,
              height: double.infinity,
              decoration: BoxDecoration(
                  color: Colors.yellow[500],
                  image: DecorationImage(
                      image: AssetImage("Assets/Images/welcome1.jpg"),
                      fit: BoxFit.fitWidth)),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 80),
                    child: Text(
                      "Lets Play a Game",
                      style: TextStyle(
                          color: Colors.blueGrey[400],
                          fontSize: 30,
                          fontFamily: "Handlee",
                          fontWeight: FontWeight.w800),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 500),
                    child: changeNotifier.loaded
                        ? RaisedButton(
                            color: Colors.blueGrey[400],
                            child: Text("START",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 30,
                                    fontFamily: "Handlee")),
                            onPressed: () {
                              if (changeNotifier.loaded) {
                                changeNotifier.next();
                              }
                            })
                        : Container(),
                  )
                ],
              ),
            );
          }
        },
      ),
    );
  }
}
