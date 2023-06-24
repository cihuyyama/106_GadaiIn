import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class User {
  final String id;
  final String username;
  final String email;
  final String bio;
  final String displayName;
  final String photoUrl;
  User({
    required this.id,
    required this.username,
    required this.email,
    required this.bio,
    required this.displayName,
    required this.photoUrl,
  });

  factory User.fromDocument(DocumentSnapshot doc){
    return User(
      id: doc['id'],
      email: doc['email'],
      username: doc['username'],
      displayName: doc['displayName'],
      bio: doc['bio'],
      photoUrl: doc['photoUrl']
    );
  }

  

  User copyWith({
    String? id,
    String? username,
    String? email,
    String? bio,
    String? displayName,
    String? photoUrl,
  }) {
    return User(
      id: id ?? this.id,
      username: username ?? this.username,
      email: email ?? this.email,
      bio: bio ?? this.bio,
      displayName: displayName ?? this.displayName,
      photoUrl: photoUrl ?? this.photoUrl,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'username': username,
      'email': email,
      'bio': bio,
      'displayName': displayName,
      'photoUrl': photoUrl,
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'] as String,
      username: map['username'] as String,
      email: map['email'] as String,
      bio: map['bio'] as String,
      displayName: map['displayName'] as String,
      photoUrl: map['photoUrl'] as String,
    );
  }


  String toJson() => json.encode(toMap());

  factory User.fromJson(String source) => User.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'User(id: $id, username: $username, email: $email, bio: $bio, displayName: $displayName, photoUrl: $photoUrl)';
  }

  @override
  bool operator ==(covariant User other) {
    if (identical(this, other)) return true;
  
    return 
      other.id == id &&
      other.username == username &&
      other.email == email &&
      other.bio == bio &&
      other.displayName == displayName &&
      other.photoUrl == photoUrl;
  }

  @override
  int get hashCode {
    return id.hashCode ^
      username.hashCode ^
      email.hashCode ^
      bio.hashCode ^
      displayName.hashCode ^
      photoUrl.hashCode;
  }
}
