import 'package:flutter/material.dart';
// import 'package:uuid/uuid.dart';

class User {
  final String id;
  final String name;
  final String job;
  final String? phone;
  final String email;
  final String? imageUrl;
  final Color? color;
  final List<String>? idTags;

  User({
    required this.id,
    required this.name,
    required this.job,
    this.phone,
    required this.email,
    this.imageUrl,
    this.color,
    this.idTags,
  });

  factory User.fromMap({required Map<String, dynamic> data}) {
    return User(
        id: data['id'],
        name: data['name'],
        job: data['job'],
        phone: data['phone'] ?? '',
        email: data['email'],
        imageUrl: data['imageUrl'],
        color: data['color'] != null
            ? (RegExp(r'^#[0-9a-fA-F]{6}$').hasMatch(data['color'])
                ? Color(int.parse(data['color'].toString().substring(1),
                        radix: 16) +
                    0xFF000000)
                : null)
            : null,
        idTags: data['idTags']);
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'job': job,
      'phone': phone,
      'email': email,
      'imageUrl': imageUrl,
      'color': '#${color?.value.toRadixString(16).substring(2, 8)}',
      'idTags': idTags ?? []
    };
  }
}
