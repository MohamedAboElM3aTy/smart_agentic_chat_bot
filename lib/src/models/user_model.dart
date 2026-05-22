import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  const UserModel({
    required this.uid,
    required this.username,
    required this.email,
    required this.createdAt,
  });

  final String uid;
  final String username;
  final String email;
  final DateTime createdAt;

  factory UserModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return UserModel(
      uid: data['uid'] as String,
      username: data['username'] as String,
      email: data['email'] as String,
      createdAt: (data['createdAt'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toFirestore() => {
        'uid': uid,
        'username': username,
        'email': email,
        'createdAt': Timestamp.fromDate(createdAt),
      };
}
