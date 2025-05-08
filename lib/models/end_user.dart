
import 'dart:convert';

EndUser endUserFromJson(String str) => EndUser.fromJson(json.decode(str));

String endUserToJson(EndUser data) => json.encode(data.toJson());

class EndUser {
    EndUser({
       required this.uid,
        this.username,
        this.email,
        this.avatarUrl,
        this.from,
        this.livingIn,
        this.mediaLink,
        this.bio,
    });

    String uid;
    String? username;
    String? email;
    String? avatarUrl;
    String? from;
    String? livingIn;
    String? mediaLink;
    String? bio;

    factory EndUser.fromJson(Map<String, dynamic> json) => EndUser(
        uid: json["uid"],
        username: json["username"],
        email: json["email"],
        avatarUrl: json["avatarUrl"] ??'',
        from: json["from"],
        livingIn: json["livingIn"],
        mediaLink: json["mediaLink"],
        bio: json["bio"],
    );

    Map<String, dynamic> toJson() => {
        "uid": uid,
        "username": username,
        "email": email,
        "avatarUrl": avatarUrl,
        "from": from,
        "livingIn": livingIn,
         "mediaLink": mediaLink,
          "bio": bio,
    };
}
