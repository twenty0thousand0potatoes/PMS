import 'package:cloud_firestore/cloud_firestore.dart';

class Job {
  final String title;
  final String duration;
  final String category;

  Job({
    required this.title,
    required this.duration,
    required this.category,
  });

  factory Job.fromFirestore(QueryDocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Job(
      title: data['Title'] ?? '',
      duration: data['Duration'] ?? '',
      category: data['Category'] ?? '',
    );
  }

  Job.fromJson(Map<String, Object?> json)
      : this(
            title: json['title']! as String,
            duration: json['duration']! as String,
            category: json['category']! as String);

  Map<String, Object?> toJson() {
    return {'title': title, 'duration': duration, 'category': category};
  }
}
