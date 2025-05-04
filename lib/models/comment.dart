import 'package:cloud_firestore/cloud_firestore.dart';

class Comment {
  final String author;
  final String text;
  final DateTime createdAt;

  Comment({
    required this.author,
    required this.text,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  factory Comment.fromJson(Map<String, dynamic> json) {
    return Comment(
      author: json['author'] as String,
      text: json['text'] as String,
      createdAt: (json['createdAt'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'author': author,
      'text': text,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Comment &&
          runtimeType == other.runtimeType &&
          author == other.author &&
          text == other.text &&
          createdAt == other.createdAt;

  @override
  int get hashCode => author.hashCode ^ text.hashCode ^ createdAt.hashCode;
}