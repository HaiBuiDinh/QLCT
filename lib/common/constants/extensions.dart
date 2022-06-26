import 'package:flutter/material.dart';
import 'currency.dart';
import '../enum/transaction.dart';
import 'package:hive_flutter/adapters.dart';

import '../../data/expense/model/expense.dart';
import 'time.dart';

extension ExpenseListMapping on Box<Expense> {
  List<Expense> allAccount(int accountId) {
    return values.where((element) => element.accountId == accountId).toList();
  }

  List<Expense> isFilterTimeBetween(DateTimeRange range) {
    return values
        .where((element) => element.time.isAfterBeforeTime(range))
        .toList();
  }
}

extension TextStyleHelpers on TextStyle {
  TextStyle toBigTextBold(BuildContext context) => copyWith(
        fontWeight: FontWeight.w700,
        fontSize: Theme.of(context).textTheme.headline6?.fontSize,
      );
}

extension TotalAmountOnExpenses on Iterable<Expense> {
  double get filterTotal => fold<double>(0, (previousValue, element) {
        if (element.type == TransactonType.expense) {
          return previousValue - element.currency;
        } else {
          return previousValue + element.currency;
        }
      });

  double get totalExpense =>
      where((element) => element.type == TransactonType.expense)
          .map((e) => e.currency)
          .fold<double>(0, (previousValue, element) => previousValue + element);

  double get totalIncome =>
      where((element) => element.type == TransactonType.income)
          .map((e) => e.currency)
          .fold<double>(0, (previousValue, element) => previousValue + element);

  double get total => map((e) => e.currency)
      .fold<double>(0, (previousValue, element) => previousValue + element);

  String get totalWithCurrenySymbol => formattedCurrency(total);

  double get thisMonthExpense =>
      where((element) => element.type == TransactonType.expense)
          .where((element) => element.time.month == DateTime.now().month)
          .map((e) => e.currency)
          .fold<double>(0, (previousValue, element) => previousValue + element);

  double get thisMonthIncome =>
      where((element) => element.type == TransactonType.income)
          .where((element) => element.time.month == DateTime.now().month)
          .map((e) => e.currency)
          .fold<double>(0, (previousValue, element) => previousValue + element);
}
