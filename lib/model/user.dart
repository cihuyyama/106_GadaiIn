import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class User {
  final String id;
  double balance;
  final String email;
  final String displayName;
  final String photoUrl;
  User({
    required this.id,
    required this.balance,
    required this.email,
    required this.displayName,
    required this.photoUrl,
  });

  factory User.fromDocument(DocumentSnapshot doc){
    return User(
      id: doc['id'],
      email: doc['email'],
      balance: doc['balance'],
      displayName: doc['displayName'],
      photoUrl: doc['photoUrl']
    );
  }

  

  User copyWith({
    String? id,
    double? balance,
    String? email,
    String? bio,
    String? displayName,
    String? photoUrl,
  }) {
    return User(
      id: id ?? this.id,
      balance: balance ?? this.balance,
      email: email ?? this.email,
      displayName: displayName ?? this.displayName,
      photoUrl: photoUrl ?? this.photoUrl,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'balance': balance,
      'email': email,
      'displayName': displayName,
      'photoUrl': photoUrl,
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'] as String,
      balance: map['balance'] as double,
      email: map['email'] as String,
      displayName: map['displayName'] as String,
      photoUrl: map['photoUrl'] as String,
    );
  }


  String toJson() => json.encode(toMap());

  factory User.fromJson(String source) => User.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'User(id: $id, balance: $balance, email: $email, displayName: $displayName, photoUrl: $photoUrl)';
  }

  @override
  bool operator ==(covariant User other) {
    if (identical(this, other)) return true;
  
    return 
      other.id == id &&
      other.balance == balance &&
      other.email == email &&
      other.displayName == displayName &&
      other.photoUrl == photoUrl;
  }

  @override
  int get hashCode {
    return id.hashCode ^
      balance.hashCode ^
      email.hashCode ^
      displayName.hashCode ^
      photoUrl.hashCode;
  }
}
