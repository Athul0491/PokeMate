import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserData extends Equatable {
  final String uid;
  final String? email;
  final String? name;
  final int? age;

  const UserData(
      {required this.uid,
      this.email,
      this.name,
      this.age,
      });

  static UserData fromUser(User user) {
    return UserData(uid: user.uid, email: user.email);
  }

  static UserData empty = const UserData(uid: '');

  UserData.fromJson(Map<String, Object?> json)
      : this(
          uid: json['uid']! as String,
          email: json['email']! as String,
          name: json['name']! as String,
          age: json['age']! as int,
        );

  Map<String, Object?> toJson() {
    return {
      'uid': uid,
      'email': email,
      'name': name,
      'age': age,
    };
  }

  bool get isEmpty => this == UserData.empty;

  bool get isNotEmpty => this != UserData.empty;

  @override
  String toString() {
    return 'uid: $uid, email: $email, name: $name, age: $age';
  }

  @override
  List<Object?> get props =>
      [uid, email, name, age];
}
