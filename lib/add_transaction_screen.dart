import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'transaction_model.dart';

class AddTransactionScreen extends StatefulWidget {
  final Function(UserTransaction) onAddTransaction;

  AddTransactionScreen({required this.onAddTransaction});

  @override
  _AddTransactionScreenState createState() => _AddTransactionScreenState();
}

class _AddTransactionScreenState extends State<AddTransactionScreen> {
  final _formKey = GlobalKey<FormState>();
  String? _type;
  double? _amount;
  DateTime _selectedDate = DateTime.now();
  String _note = '';

  void _saveTransaction() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      final newTransaction = UserTransaction(
        type: _type!,
        amount: _amount!,
        date: _selectedDate,
        note: _note,
      );

      // เพิ่มข้อมูลไปยัง Firestore
      await FirebaseFirestore.instance.collection('Income and expenses').add({
        'type': newTransaction.type,
        'amount': newTransaction.amount,
        'date': newTransaction.date,
        'note': newTransaction.note,
      });

      // เรียกใช้ฟังก์ชันเพื่อ refresh ข้อมูลในหน้าหลัก
      widget.onAddTransaction(newTransaction); 
      Navigator.pop(context); // กลับไปที่หน้าก่อนหน้านี้
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('บันทึกรายรับรายจ่าย')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              DropdownButtonFormField<String>(
                value: _type,
                items: ['รายรับ', 'รายจ่าย'].map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                hint: Text('เลือกประเภท'),
                onChanged: (newValue) {
                  setState(() {
                    _type = newValue;
                  });
                },
                validator: (value) => value == null ? 'กรุณาเลือกประเภท' : null,
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'จำนวนเงิน'),
                keyboardType: TextInputType.number,
                onSaved: (value) => _amount = double.parse(value!),
                validator: (value) => value!.isEmpty ? 'กรุณากรอกจำนวนเงิน' : null,
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'โน้ต'),
                onSaved: (value) => _note = value!,
              ),
              ElevatedButton(
                onPressed: _saveTransaction,
                child: Text('บันทึก'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
