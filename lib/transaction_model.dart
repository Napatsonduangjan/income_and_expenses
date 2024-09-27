import 'package:cloud_firestore/cloud_firestore.dart';

class UserTransaction {
  final double amount;
  final String type; // 'รายรับ' หรือ 'รายจ่าย'
  final String note;
  final DateTime date;

  UserTransaction({
    required this.amount,
    required this.type,
    required this.note,
    required this.date,
  });

  factory UserTransaction.fromFirestore(DocumentSnapshot doc) {
  Map<String, dynamic> data = doc.data() as Map<String, dynamic>; // ใช้ Map<string, dynamic>
  return UserTransaction(
    amount: (data['amount'] is int) ? (data['amount'] as int).toDouble() : (data['amount'] is double) ? data['amount'] : 0.0, // แปลงค่า
    type: data['type'] ?? '',
    note: data['note'] ?? '',
    date: (data['date'] as Timestamp).toDate(), // แปลง Timestamp เป็น DateTime
  );
}


  Map<String, dynamic> toMap() {
    return {
      'amount': amount,
      'type': type,
      'note': note,
      'date': date,
    };
  }
}
