import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';
import 'package:budgetbuddy/widgets/expenses.dart';
import 'package:budgetbuddy/models/expense.dart';

final formatter = DateFormat.yMd();

class newexpense extends StatefulWidget {
  const newexpense({super.key, required this.onAddExpense});
  final void Function(Expense expense) onAddExpense;
  @override
  State<newexpense> createState() => _newexpenseState();
}

class _newexpenseState extends State<newexpense> {
  final titleController = TextEditingController();

  final amountcontroller = TextEditingController();
  DateTime? selecteddate;
  ashbabe selectedcategory2 = ashbabe.Outing;

  void sumbitdatacheck() {
    final entereddata = double.tryParse(amountcontroller.text);
    final amountisinvalid = entereddata == null || entereddata <= 0;
    if (titleController.text.trim().isEmpty ||
        amountisinvalid ||
        selecteddate == null) {
      showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
                title: Text("Invalid Input"),
                content: const Text(
                    "Please make sure a valid title,amount,date and category was entered."),
                actions: [
                  TextButton(
                      onPressed: () {
                        Navigator.pop(ctx);
                      },
                      child: Text("Okay"))
                ],
              ));
    }

    widget.onAddExpense(Expense(
        title: titleController.text,
        amount: entereddata!,
        date: selecteddate!,
        category: selectedcategory2!));
    Navigator.pop(context);
  }

  void presentdatepicker() async {
    final now = DateTime.now();
    final firstdate = DateTime(now.year - 1, now.month, now.day);
    final lastdate = DateTime(now.year + 1, now.month, now.day);
    final pickeddate = await showDatePicker(
        context: context,
        initialDate: now,
        firstDate: firstdate,
        lastDate: lastdate);

    setState(() {
      selecteddate = pickeddate;
    });
  }

  @override
  void dispose() {
    titleController.dispose();
    amountcontroller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final keyboardspace = MediaQuery.of(context).viewInsets.bottom;
    return LayoutBuilder(builder: (ctx, constraints) {
      final width = constraints.maxWidth;
      return SizedBox(
        height: double.infinity,
        child: SingleChildScrollView(
          child: Padding(
              padding: EdgeInsets.fromLTRB(16, 48, 16, keyboardspace + 16),
              child: Column(
                children: [
                  if (width >= 600)
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: TextField(
                            maxLength: 50,
                            keyboardType: TextInputType.name,
                            decoration: InputDecoration(label: Text("Title")),
                            controller: titleController,
                          ),
                        ),
                        SizedBox(
                          width: 30,
                        ),
                        Expanded(
                          child: TextField(
                              maxLength: 50,
                              keyboardType: TextInputType.number,
                              controller: amountcontroller,
                              decoration: InputDecoration(
                                  prefixText: '\$ ', label: Text("Amount"))),
                        ),
                      ],
                    )
                  else
                    TextField(
                      maxLength: 50,
                      keyboardType: TextInputType.name,
                      decoration: InputDecoration(label: Text("Title")),
                      controller: titleController,
                    ),
                  SizedBox(
                    height: 20,
                  ),
                  if (width >= 600)
                    Row(
                      children: [
                        DropdownButton(
                            value: selectedcategory2,
                            items: ashbabe.values
                                .map(
                                  (category) => DropdownMenuItem(
                                    value: category,
                                    child: Text(
                                      category.name.toUpperCase(),
                                    ),
                                  ),
                                )
                                .toList(),
                            onChanged: (value) {
                              setState(() {
                                if (value == null) return;
                                selectedcategory2 = value;
                              });
                            }),
                        Spacer(),
                        Text(selecteddate == null
                            ? "nodateselected"
                            : formatter.format(selecteddate!)),
                        IconButton(
                            onPressed: presentdatepicker,
                            icon: const Icon(Icons.calendar_month))
                      ],
                    )
                  else
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                              maxLength: 50,
                              keyboardType: TextInputType.number,
                              controller: amountcontroller,
                              decoration: InputDecoration(
                                  prefixText: 'Rs. ', label: Text("Amount"))),
                        ),
                        const SizedBox(
                          width: 16,
                        ),
                        Expanded(
                            child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                              Text(selecteddate == null
                                  ? "nodateselected"
                                  : formatter.format(selecteddate!)),
                              IconButton(
                                  onPressed: presentdatepicker,
                                  icon: const Icon(Icons.calendar_month))
                            ]))
                      ],
                    ),
                  SizedBox(height: 16),
                  if (width >= 600)
                    Row(
                      children: [
                        ElevatedButton(
                            onPressed: () {
                              sumbitdatacheck();
                            },
                            child: const Text("add")),
                        Spacer(),
                        ElevatedButton(
                            onPressed: () {
                              print("Shutter Down succesfully");

                              Navigator.pop(context);
                            },
                            child: const Text("Cancel")),
                      ],
                    )
                  else
                    Row(
                      children: [
                        DropdownButton(
                            value: selectedcategory2,
                            items: ashbabe.values
                                .map(
                                  (category) => DropdownMenuItem(
                                    value: category,
                                    child: Text(
                                      category.name.toUpperCase(),
                                    ),
                                  ),
                                )
                                .toList(),
                            onChanged: (value) {
                              setState(() {
                                if (value == null) return;
                                selectedcategory2 = value;
                              });
                            }),
                        SizedBox(
                          width: 15,
                        ),
                        ElevatedButton(
                            onPressed: () {
                              sumbitdatacheck();
                            },
                            child: const Text("add")),
                        Spacer(),
                        ElevatedButton(
                            onPressed: () {
                              print("Shutter Down succesfully");

                              Navigator.pop(context);
                            },
                            child: const Text("Remove")),
                      ],
                    ),
                ],
              )),
        ),
      );
    });
  }
}
