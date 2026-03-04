import 'package:intl/intl.dart';

class GameResult {
  final int? id;
  final int guess;
  final int correctNumber;
  final String status;
  final DateTime timestamp;

  GameResult({
    this.id,
    required this.guess,
    required this.correctNumber,
    required this.status,
    required this.timestamp,
  });

  Map<String, Object?> toMap() {
    return {
      'id': id,
      'guess': guess,
      'correct_number': correctNumber,
      'status': status,
      'timestamp': timestamp.toIso8601String(),
    };
  }

  factory GameResult.fromMap(Map<String, Object?> map) {
    return GameResult(
      id: map['id'] as int?,
      guess: map['guess'] as int,
      correctNumber: map['correct_number'] as int,
      status: map['status'] as String,
      timestamp: DateTime.parse(map['timestamp'] as String),
    );
  }

  String getFormattedTimestamp() {
    return DateFormat('yyyy-MM-dd hh:mm a').format(timestamp);
  }
}
