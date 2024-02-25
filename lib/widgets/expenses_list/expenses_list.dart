import 'package:budgetbuddy/models/expense.dart';
import 'package:budgetbuddy/widgets/expenses_list/expenses_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class ExpensesList extends StatelessWidget {
  const ExpensesList(
      {super.key, required this.expenses, required this.onRemoveExpenses});
  final List<Expense> expenses;
  final void Function(Expense expense) onRemoveExpenses;
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: expenses.length,
      itemBuilder: (ctx, index) => Dismissible(
          key: ValueKey(expenses[index]),
          background: Container(
            color: Theme.of(context).colorScheme.error.withOpacity(0.7),
          ),
          onDismissed: (direction) {
            onRemoveExpenses(expenses[index]);
          },
          child: ExpenseItem(expenses[index])),
    );
  }
}
