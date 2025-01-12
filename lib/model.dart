// To parse this JSON data, do
//
//     final welcome = welcomeFromJson(jsonString);

import 'dart:convert';

Welcome welcomeFromJson(String str) => Welcome.fromJson(json.decode(str));

String welcomeToJson(Welcome data) => json.encode(data.toJson());

class Welcome {
  Book book;
  String count;
  List<Chapter> chapters;

  Welcome({
    required this.book,
    required this.count,
    required this.chapters,
  });

  factory Welcome.fromJson(Map<String, dynamic> json) => Welcome(
        book: Book.fromJson(json["book"]),
        count: json["count"],
        chapters: List<Chapter>.from(
            json["chapters"].map((x) => Chapter.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "book": book.toJson(),
        "count": count,
        "chapters": List<dynamic>.from(chapters.map((x) => x.toJson())),
      };
}

class Book {
  String english;
  String telugu;

  Book({
    required this.english,
    required this.telugu,
  });

  factory Book.fromJson(Map<String, dynamic> json) => Book(
        english: json["english"],
        telugu: json["telugu"],
      );

  Map<String, dynamic> toJson() => {
        "english": english,
        "telugu": telugu,
      };
}

class Chapter {
  String chapter;
  List<Verse> verses;

  Chapter({
    required this.chapter,
    required this.verses,
  });

  factory Chapter.fromJson(Map<String, dynamic> json) => Chapter(
        chapter: json["chapter"],
        verses: List<Verse>.from(json["verses"].map((x) => Verse.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "chapter": chapter,
        "verses": List<dynamic>.from(verses.map((x) => x.toJson())),
      };
}

class Verse {
  String verse;
  String text;

  Verse({
    required this.verse,
    required this.text,
  });

  factory Verse.fromJson(Map<String, dynamic> json) => Verse(
        verse: json["verse"],
        text: json["text"],
      );

  Map<String, dynamic> toJson() => {
        "verse": verse,
        "text": text,
      };
}
