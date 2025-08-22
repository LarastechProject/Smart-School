class School {
  final String id;
  final String name;
  final String? logoUrl;
  const School({required this.id, required this.name, this.logoUrl});
}

class AppUser {
  final String uid;
  final String schoolId;
  final Map<String, bool> roles;
  const AppUser({required this.uid, required this.schoolId, required this.roles});

  bool get isStudent => roles['student'] == true;
  bool get isTeacher => roles['teacher'] == true;
  bool get isAdmin => roles['admin'] == true;
  bool get isSuperAdmin => roles['super_admin'] == true;
  bool get isParent => roles['parent'] == true;
}

class Exam {
  final String id;
  final String title;
  final List<Question> questions;
  const Exam({required this.id, required this.title, required this.questions});
}

class Question {
  final String id;
  final String text;
  final String type; // objective|theory
  final List<String>? options;
  final int? answer; // index for objective
  final int marks;
  const Question({
    required this.id,
    required this.text,
    required this.type,
    this.options,
    this.answer,
    this.marks = 1,
  });
}

class SubmissionAnswer {
  final String id;
  final int? choice;
  final String? text;
  const SubmissionAnswer({required this.id, this.choice, this.text});
}

class Submission {
  final String id;
  final String examId;
  final String userId;
  final List<SubmissionAnswer> answers;
  final int? score;
  const Submission({
    required this.id,
    required this.examId,
    required this.userId,
    required this.answers,
    this.score,
  });
}

class MessageThread {
  final String id;
  final List<String> participants;
  const MessageThread({required this.id, required this.participants});
}

class Message {
  final String id;
  final String senderId;
  final String text;
  final DateTime sentAt;
  const Message({required this.id, required this.senderId, required this.text, required this.sentAt});
}