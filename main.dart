// @dart=2.19
import 'package:flutter/material.dart';

void main() {
  runApp(const EquilibriaApp());
}

class EquilibriaApp extends StatelessWidget {
  const EquilibriaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Equilibria Budget',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color(0xFF0B0F19), 
        primaryColor: const Color(0xFF6366F1), 
        cardColor: const Color(0xFF131C2E), 
      ),
      home: const DashboardPage(),
    );
  }
}

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  // ১. ডিফল্ট টাকার পরিমাণ ০ (ফাঁকা) করে দেওয়া হলো
  double netIncome = 0.0;
  List<Map<String, dynamic>> transactions = [];

  final TextEditingController _incomeController = TextEditingController();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();
  String selectedCategory = 'Needs (50%)';

  double getSpentAmount(String type) {
    double total = 0;
    for (var tx in transactions) {
      if (tx['type'] == type) {
        total += tx['amount'];
      }
    }
    return total;
  }

  @override
  Widget build(BuildContext context) {
    double targetNeeds = netIncome * 0.50;
    double targetWants = netIncome * 0.30;
    double targetSavings = netIncome * 0.20;

    double spentNeeds = getSpentAmount('Needs');
    double spentWants = getSpentAmount('Wants');
    double spentSavings = getSpentAmount('Savings');

    return Scaffold(
      appBar: AppBar(
        title: const Text('📊 Equilibria Budget', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
      ),
      body: Stack(
        children: [
          // Background Text for Watermark
          Positioned(
            bottom: 20, // adjust as needed
            left: 20, // adjust as needed
            child: Opacity(
              opacity: 0.1, // make it subtle
              child: Text(
                'আব্দুর রাজ্জাক',
                style: TextStyle(
                  fontSize: 60, // adjust as needed
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Income Input Card
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1E293B),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.white10),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _incomeController,
                          keyboardType: TextInputType.number,
                          style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                          decoration: const InputDecoration(
                            hintText: "Enter Monthly Net Income",
                            hintStyle: TextStyle(color: Colors.grey),
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF6366F1), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
                        onPressed: () {
                          if (_incomeController.text.isNotEmpty) {
                            setState(() {
                              netIncome = double.parse(_incomeController.text);
                              _incomeController.clear();
                            });
                          }
                        },
                        child: const Text("Set Budget", style: TextStyle(color: Colors.white)),
                      )
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                // Progress Bars Card
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(color: const Color(0xFF131C2E), borderRadius: BorderRadius.circular(16)),
                  child: Column(
                    children: [
                      _buildBudgetBar("🔵 NEEDS (50%)", spentNeeds, targetNeeds, const Color(0xFF3B82F6)),
                      const SizedBox(height: 14),
                      _buildBudgetBar("🟠 WANTS (30%)", spentWants, targetWants, const Color(0xFFF59E0B)),
                      const SizedBox(height: 14),
                      _buildBudgetBar("🟢 SAVINGS (20%)", spentSavings, targetSavings, const Color(0xFF10B981)),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                // Add Transaction Section
                const Text("Add Transaction", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(child: TextField(controller: _titleController, style: const TextStyle(color: Colors.white), decoration: const InputDecoration(hintText: "Description", hintStyle: TextStyle(color: Colors.grey)))),
                    const SizedBox(width: 10),
                    Expanded(child: TextField(controller: _amountController, keyboardType: TextInputType.number, style: const TextStyle(color: Colors.white), decoration: const InputDecoration(hintText: "Amount (৳)", hintStyle: TextStyle(color: Colors.grey)))),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    DropdownButton<String>(
                      value: selectedCategory,
                      dropdownColor: const Color(0xFF131C2E),
                      style: const TextStyle(color: Colors.white),
                      items: <String>['Needs (50%)', 'Wants (30%)', 'Savings (20%)']
                          .map((value) => DropdownMenuItem(value: value, child: Text(value))).toList(),
                      onChanged: (val) => setState(() => selectedCategory = val!),
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF6366F1)),
                      onPressed: () {
                        if (_titleController.text.isNotEmpty && _amountController.text.isNotEmpty) {
                          String type = selectedCategory.split(' ')[0];
                          setState(() {
                            transactions.insert(0, {
                              'id': DateTime.now().toString(), // ইউনিক আইডি ট্রানজেকশন ডিলিটের জন্য
                              'title': _titleController.text,
                              'amount': double.parse(_amountController.text),
                              'type': type,
                            });
                            _titleController.clear();
                            _amountController.clear();
                          });
                        }
                      },
                      child: const Text("Record", style: TextStyle(color: Colors.white)),
                    )
                  ],
                ),
                const SizedBox(height: 15),

                // Recent Transactions List
                const Text("Recent Transactions", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
                const SizedBox(height: 8),
                Expanded(
                  child: transactions.isEmpty
                      ? const Center(child: Text("No transactions yet. Start budgeting today!", style: TextStyle(color: Colors.grey)))
                      : ListView.builder(
                          itemCount: transactions.length,
                          itemBuilder: (context, index) {
                            final item = transactions[index];
                            return Card(
                              color: const Color(0xFF1E293B),
                              child: ListTile(
                                title: Text(item['title'], style: const TextStyle(color: Colors.white)),
                                subtitle: Text(item['type'], style: const TextStyle(color: Colors.grey)),
                                trailing: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text("৳${item['amount']}", style: const TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold)),
                                    const SizedBox(width: 8),
                                    // ২. এখানে লাল ডিলিট বাটনটি যুক্ত করা হলো
                                    IconButton(
                                      icon: const Icon(Icons.delete_outline, color: Colors.redAccent, size: 20),
                                      onPressed: () {
                                        setState(() {
                                          transactions.removeAt(index); // লিস্ট থেকে খরচটি ডিলিট করে দেওয়া হলো
                                        });
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBudgetBar(String title, double spent, double target, Color color) {
    double percentage = target > 0 ? (spent / target) : 0.0;
    if (percentage > 1.0) percentage = 1.0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(title, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white)),
            Text("৳${spent.toStringAsFixed(0)} / ৳${target.toStringAsFixed(0)}", style: TextStyle(color: color, fontWeight: FontWeight.bold)),
          ],
        ),
        const SizedBox(height: 6),
        ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: LinearProgressIndicator(value: percentage, minHeight: 10, backgroundColor: Colors.white10, valueColor: AlwaysStoppedAnimation<Color>(color)),
        )
      ],
    );
  }
}
