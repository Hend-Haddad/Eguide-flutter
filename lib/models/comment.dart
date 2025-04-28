import 'dart:convert';

List<Comment> commentFromJson(String str) => List<Comment>.from(json.decode(str).map((x) => Comment.fromJson(x)));

String commentToJson(List<Comment> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Comment {
    Comment({
        required this.author,
        required this.text,
    });

    String author;
    String text;

    factory Comment.fromJson(Map<String, dynamic> json) => Comment(
        author: json["author"],
        text: json["text"],
    );

    Map<String, dynamic> toJson() => {
        "author": author,
        "text": text,
    };
}
