import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'add_transaction_screen.dart';
import 'transaction_model.dart';
import 'transaction_model.dart' as custom;

class TransactionListScreen extends StatefulWidget {
  final List<custom.UserTransaction> transactions;

  TransactionListScreen({Key? key, required this.transactions}) : super(key: key);

  @override
  _TransactionListScreenState createState() => _TransactionListScreenState();
}

class _TransactionListScreenState extends State<TransactionListScreen> {
  bool showChart = false;
  List<custom.UserTransaction> _transactions = [];

  @override
  void initState() {
    super.initState();
    fetchTransactions();
  }

  Future<void> fetchTransactions() async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    QuerySnapshot snapshot = await firestore.collection('Income and expenses').get();

    setState(() {
      _transactions = snapshot.docs.map((doc) {
        return custom.UserTransaction.fromFirestore(doc);
      }).toList();
    });
  }

  void _addTransaction(custom.UserTransaction transaction) {
    setState(() {
      _transactions.add(transaction);
    });
    fetchTransactions(); // รีเฟรชข้อมูลหลังจากเพิ่ม
  }

  double get totalIncome => _transactions
      .where((tx) => tx.type == 'รายรับ')
      .fold(0.0, (sum, item) => sum + item.amount);

  double get totalExpense => _transactions
      .where((tx) => tx.type == 'รายจ่าย')
      .fold(0.0, (sum, item) => sum + item.amount);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('รายการรายรับรายจ่าย', style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.deepPurple, Colors.indigoAccent],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        elevation: 5,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // แสดงรวมรายรับและรายจ่าย
            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(color: Colors.grey.withOpacity(0.3), blurRadius: 10, spreadRadius: 3),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'รวมรายรับ: $totalIncome บาท',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.green.shade600,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'รวมรายจ่าย: $totalExpense บาท',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.red.shade600,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: () {
                setState(() {
                  showChart = !showChart;
                });
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.teal.shade300,
                padding: EdgeInsets.symmetric(vertical: 12, horizontal: 20),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              icon: Icon(showChart ? Icons.bar_chart : Icons.show_chart),
              label: Text(
                showChart ? 'ซ่อนกราฟย้อนหลัง 2 เดือน' : 'แสดงกราฟย้อนหลัง 2 เดือน',
                style: TextStyle(fontSize: 16),
              ),
            ),
            SizedBox(height: 20),
            if (showChart)
              Container(
                height: 300,
                padding: EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(color: Colors.grey.withOpacity(0.3), blurRadius: 10, spreadRadius: 5),
                  ],
                ),
                child: BarChart(
                  BarChartData(
                    alignment: BarChartAlignment.spaceEvenly,
                    barGroups: [
                      BarChartGroupData(
                        x: 0,
                        barRods: [
                          BarChartRodData(toY: totalIncome, color: Colors.green, width: 30),
                          BarChartRodData(toY: totalExpense, color: Colors.red, width: 30),
                        ],
                        showingTooltipIndicators: [0, 1],
                      ),
                    ],
                    titlesData: FlTitlesData(
                      leftTitles: AxisTitles(
                        sideTitles: SideTitles(showTitles: true),
                      ),
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          getTitlesWidget: (double value, TitleMeta meta) {
                            switch (value.toInt()) {
                              case 0:
                                return Text('เดือนที่แล้ว', style: TextStyle(color: Colors.black));
                              case 1:
                                return Text('เดือนนี้', style: TextStyle(color: Colors.black));
                              default:
                                return Text('');
                            }
                          },
                        ),
                      ),
                    ),
                    borderData: FlBorderData(show: false),
                  ),
                ),
              ),
            SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: _transactions.length,
                itemBuilder: (context, index) {
                  final tx = _transactions[index];
                  return Card(
                    elevation: 5,
                    margin: EdgeInsets.symmetric(vertical: 8),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    child: ListTile(
                      title: Text(
                        tx.note,
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                      ),
                      subtitle: Text(
                        '${tx.amount} บาท - ${tx.type}',
                        style: TextStyle(fontSize: 16),
                      ),
                      trailing: Text(
                        tx.date.toLocal().toString(),
                        style: TextStyle(color: Colors.grey),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddTransactionScreen(onAddTransaction: _addTransaction),
            ),
          );
        },
        backgroundColor: Colors.green.shade700,
        child: Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
