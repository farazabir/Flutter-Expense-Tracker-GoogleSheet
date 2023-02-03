import 'package:flutter/material.dart';
import 'package:gsheets/gsheets.dart';

class GoogleSheetsApi {
  //create credentials
  static const credential = r'''{
  // GOOGLE CLOUD CREDENTIAL 
}''';

//spread sheet id
  static const spreadSheetId = 'PUT HERE SPREAD SHEET ID';

  //init gsheet
  static final gsheet = GSheets(credential);
  static Worksheet? worksheet;

  static int numberofTransaction = 0;
  static List<List<dynamic>> currentTransactions = [];
  static bool loading = true;

  Future init() async {
    //feth spreadsheet by id
    final ss = await gsheet.spreadsheet(spreadSheetId);
    worksheet = ss.worksheetByTitle('Sheet1');
  }

  //count the number of notes
  static Future countRows() async {
    while ((await worksheet!.values
            .value(column: 1, row: numberofTransaction + 1)) !=
        '') {
      numberofTransaction++;
    }
    loadTransaction();
  }

  static Future loadTransaction() async {
    if (worksheet == null) return;

    for (int i = 1; i < numberofTransaction; i++) {
      final String transactionName =
          await worksheet!.values.value(column: 1, row: i + 1);
      final String transactionAmout =
          await worksheet!.values.value(column: 2, row: i + 1);
      final String transactionType =
          await worksheet!.values.value(column: 3, row: i + 1);
      if (currentTransactions.length < numberofTransaction) {
        currentTransactions
            .add([transactionName, transactionAmout, transactionType]);
      }
    }
    //stop loading
    loading = false;
  }



  // insert a new transaction
  static Future insert(String name, String amount, bool _isIncome) async {
    if (worksheet == null) return;
    numberofTransaction++;
    currentTransactions.add([
      name,
      amount,
      _isIncome == true ? 'income' : 'expense',
    ]);
    await worksheet!.values.appendRow([
      name,
      amount,
      _isIncome == true ? 'income' : 'expense',
    ]);
  }

  // CALCULATE THE TOTAL INCOME!
  static double calculateIncome() {
    double totalIncome = 0;
    for (int i = 0; i < currentTransactions.length; i++) {
      if (currentTransactions[i][2] == 'income') {
        totalIncome += double.parse(currentTransactions[i][1]);
      }
    }
    return totalIncome;
  }

  // CALCULATE THE TOTAL EXPENSE!
  static double calculateExpense() {
    double totalExpense = 0;
    for (int i = 0; i < currentTransactions.length; i++) {
      if (currentTransactions[i][2] == 'expense') {
        totalExpense += double.parse(currentTransactions[i][1]);
      }
    }
    return totalExpense;
  }
}
