
// ignore_for_file: non_constant_identifier_names

import 'dart:convert';

Post postFromJson(String str) => Post.fromJson(json.decode(str));

String postToJson(Post data) => json.encode(data.toJson());


List<Post> ListPostFromJson(String str) => List<Post>.from(json.decode(str).map((x) => Post.fromJson(x)));

String ListPostToJson(List<Post> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Post {
    Post({
        required this.author,
        this.text,
        this.media,
        required this.addedAt,
        required this.question,
        required this.liked,
        required this.comments,
        required this.savedPosts,
    });

    String author;
    String? text;
    String? media;
    String addedAt;
    String question;
    List<dynamic> liked;
    List<dynamic> comments;
    List<dynamic> savedPosts;
    factory Post.fromJson(Map<String, dynamic> json) => Post(
        author: json["author"],
        text: json["text"],
        media: json["media"],
        addedAt: json["addedAt"],
        question: json["question"],
        liked: List<String>.from(json["liked"].map((x) => x)),
        comments: List<String>.from(json["comments"].map((x) => x)),
        savedPosts: List<String>.from(json["savedPosts"].map((x) => x)),
    );

    Map<String, dynamic> toJson() => {
        "author": author,
        "text": text,
        "media": media,
        "addedAt": addedAt,
        "question": question,
        "liked": List<dynamic>.from(liked.map((x) => x)),
        "comments": List<dynamic>.from(comments.map((x) => x)),
        "savedPosts": List<dynamic>.from(savedPosts.map((x) => x)),
    };
}
