import 'package:budgetbuddy/models/expense.dart';
import 'package:budgetbuddy/widgets/chart/chart.dart';
import 'package:budgetbuddy/widgets/expenses_list/expenses_list.dart';
import 'package:budgetbuddy/widgets/new_expense.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class expenses extends StatefulWidget {
  const expenses({super.key});

  @override
  State<expenses> createState() => _expensesState();
}

class _expensesState extends State<expenses> {
  double sum = 0.0;
  double sumfriends = 0.0;
  double sumouting = 0.0;
  double sumstationary = 0.0;
  double sumfood = 0.0;
  String selectedCategory = 'Net Sum';

  final List<Expense> _registeredExpenses = [];

  void _openAddExpenseOverlay() {
    showModalBottomSheet(
        useSafeArea: true,
        isScrollControlled: true,
        context: context,
        builder: (ctx) => newexpense(onAddExpense: addexpenses));
  }

  void addexpenses(Expense expense) {
    setState(() {
      _registeredExpenses.add(expense);
      sum += expense.amount;
      if (expense.category == ashbabe.Food) sumfood += expense.amount;
      if (expense.category == ashbabe.stationary)
        sumstationary += expense.amount;
      if (expense.category == ashbabe.Outing) sumouting += expense.amount;
      if (expense.category == ashbabe.Friends) sumfriends += expense.amount;
    });
  }

  void removeexpense(Expense expense) {
    final expenseindex = _registeredExpenses.indexOf(expense);
    setState(() {
      _registeredExpenses.remove(expense);
    });
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        duration: Duration(seconds: 5),
        content: Text("Expense deleted"),
        action: SnackBarAction(
            label: "Undo",
            onPressed: () {
              setState(() {
                _registeredExpenses.insert(expenseindex, expense);
              });
            })));
  }

  @override
  Widget build(BuildContext context) {
    final width = (MediaQuery.of(context).size.width);

    Widget mainContent = const Center(
      child: Text("No expenses found. Start adding some"),
    );
    if (_registeredExpenses.isNotEmpty) {
      mainContent = ExpensesList(
        expenses: _registeredExpenses,
        onRemoveExpenses: removeexpense,
      );
    }
    return Scaffold(
      appBar: AppBar(
        title: Text("BudgetBuddy"),
        actions: [
          IconButton(
            onPressed: _openAddExpenseOverlay,
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      body: width < 600
          ? Column(
              children: [
                Chart(expenses: _registeredExpenses),
                Expanded(child: mainContent),
                Padding(
                  padding: EdgeInsets.all(18),
                  child: Row(
                    children: [
                      Text(selectedCategory),
                      Spacer(),
                      Text(" = ${getCategorySum(selectedCategory)}"),
                      Spacer(),
                      PopupMenuButton<String>(
                        itemBuilder: (BuildContext context) {
                          final categories = [
                            'Net Sum',
                            'Food',
                            'Stationary',
                            'Friends',
                            'Outing'
                          ];
                          return categories.map((String category) {
                            return PopupMenuItem<String>(
                              value: category,
                              child: Text(category),
                            );
                          }).toList();
                        },
                        onSelected: (String value) {
                          setState(() {
                            selectedCategory = value;
                          });
                        },
                        icon: Icon(Icons.question_mark),
                      ),
                    ],
                  ),
                )
              ],
            )
          : Row(
              children: [
                Expanded(
                  child: Column(
                    children: [
                      Expanded(child: Chart(expenses: _registeredExpenses)),
                      Expanded(
                        child: Padding(
                          padding: EdgeInsets.all(18),
                          child: Row(
                            children: [
                              Text(selectedCategory),
                              Spacer(),
                              Text(" = ${getCategorySum(selectedCategory)}"),
                              Spacer(),
                              PopupMenuButton<String>(
                                itemBuilder: (BuildContext context) {
                                  final categories = [
                                    'Net Sum',
                                    'Food',
                                    'Stationary',
                                    'Friends',
                                    'Outing'
                                  ];
                                  return categories.map((String category) {
                                    return PopupMenuItem<String>(
                                      value: category,
                                      child: Text(category),
                                    );
                                  }).toList();
                                },
                                onSelected: (String value) {
                                  setState(() {
                                    selectedCategory = value;
                                  });
                                },
                                icon: Icon(Icons.question_mark),
                              ),
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                Expanded(child: mainContent),
              ],
            ),
    );
  }

  double getCategorySum(String category) {
    switch (category) {
      case 'Net Sum':
        return sum;
      case 'Food':
        return sumfood;
      case 'Stationary':
        return sumstationary;
      case 'Friends':
        return sumfriends;
      case 'Outing':
        return sumouting;
      default:
        return 0.0;
    }
  }
}
