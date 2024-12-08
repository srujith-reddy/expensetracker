import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController expenseController = TextEditingController();
  final TextEditingController amountController = TextEditingController();
  
  double totalExpenses = 0.0;
  final double budgetLimit = 15000.0;
  Map<String, double> adultExpenses = {};
  Map<String, double> kidExpenses = {};

  void addExpense(String category) {
    final String expenseName = expenseController.text;
    final double expenseAmount = double.tryParse(amountController.text) ?? 0.0;

    if (expenseName.isEmpty || expenseAmount <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill in all fields correctly')),
      );
      return;
    }

    if (totalExpenses + expenseAmount > budgetLimit) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('You have exceeded the budget limit!')),
      );
      return;
    }

    setState(() {
      totalExpenses += expenseAmount;
      if (category == 'adult') {
        adultExpenses[expenseName] = expenseAmount;
      } else {
        kidExpenses[expenseName] = expenseAmount;
      }
    });

    // Clear text fields after adding expense
    expenseController.clear();
    amountController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Home')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: expenseController,
              decoration: const InputDecoration(labelText: 'Expense Name'),
            ),
            TextField(
              controller: amountController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Amount'),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                ElevatedButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Text('Select Category'),
                          content: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              ListTile(
                                title: const Text('Adult'),
                                onTap: () {
                                  Navigator.pop(context);
                                  addExpense('adult');
                                },
                              ),
                              ListTile(
                                title: const Text('Kid'),
                                onTap: () {
                                  Navigator.pop(context);
                                  addExpense('kid');
                                },
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  },
                  child: const Text('Add Expense'),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Text('Total Expenses: \$${totalExpenses.toStringAsFixed(2)}'),
            const SizedBox(height: 20),
            Text('Remaining Budget: \$${(budgetLimit - totalExpenses).toStringAsFixed(2)}'),
            const SizedBox(height: 20),
            Text('Adult Expenses:'),
            ...adultExpenses.entries.map((entry) {
              return Text('${entry.key}: \$${entry.value}');
            }).toList(),
            const SizedBox(height: 20),
            Text('Kid Expenses:'),
            ...kidExpenses.entries.map((entry) {
              return Text('${entry.key}: \$${entry.value}');
            }).toList(),
          ],
        ),
      ),
    );
  }
}
