class Match {
  final String title;
  final String background;
  final List<Question> questions;
  final String matchId;

  Match({this.title, this.background, this.questions, this.matchId});

  factory Match.fromJson(Map<String, dynamic> json) {
    List<Question> items = [];
    (json['questions'] as List<dynamic>).forEach((json) {
      items.add(Question.fromJson(json));
    });

    return Match(
        title: json['title'],
        background: json['background'],
        questions: items,
        matchId: json['id']);
  }
}

class Question {
  final String drag;
  final String answer;
  final String name;

  Question({this.drag, this.answer, this.name});

  factory Question.fromJson(Map<String, dynamic> json) {
    return Question(
        drag: json['drag'], answer: json['answer'], name: json['name']);
  }
}
