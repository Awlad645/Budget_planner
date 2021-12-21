import 'package:gsheets/gsheets.dart';

class GoogleSheetsApi {
  static const _credentials = r'''
  {
  "type": "service_account",
  "project_id": "budget-planner-335718",
  "private_key_id": "f28a8a2e09fef2bd73c7d1a678910b74f8f253c6",
  "private_key": "-----BEGIN PRIVATE KEY-----\nMIIEvAIBADANBgkqhkiG9w0BAQEFAASCBKYwggSiAgEAAoIBAQDA2FHOgTxRVWWp\nKZjpqM+1eAFnzZS3cVfqiQyuvTz1qicfWpF9GdI0IdIDH0s6PJcV2sUfe/6a5Ad9\n6ziTUH1RtUnpMCP8/M9WvGelIkhOAPk46kWqTWZPjDo6dqUONOfW6tFhDSs/pJNA\nSYovsS+b8u/U9lm1muJRBpv8VkqLtsFkMRG+yc5AvVCXqnFuyyJTYfA1lsgHPad3\nQ4v7Ol1tVXkYGZanYMQ0vpSAnl7NzLr96Axcsdz6g57c7/S6vizUf19cHCXPdRYt\nr3UmKGzKGPIyM727FIL1IuJ4TXqjIR+IzXXNode5KA68ONSWpCMpNlO6fGRz0qBo\np4DkMPUvAgMBAAECggEAU41FwGVw50JLJgQuSspHl/WzEjDZhrM2ZpjTZF/8Ken7\nQlPgpiWKU+j1T0H/O2+l/COJdY8o7B3w+wbvP7BHY5/asowXg5RbFtbRRxQ35If6\ncsTZwyP+uGdmkQ73i1SzwAOEDPsCKnRZEijqlKg9muEiNRA5JPxCot1stuMCME6R\nHYsf0FXiv2InQwafL7nG3ENQ6iLHXeB3p4m83Nbo48EBcH4P62PEdE5FjSW4R2ED\nBYq0e4IB5UA72N71fqTjkrKc8BZZte8+BpcNzEwTzw5apuXJzVsZo1zJIGOf/Qzy\n05bgTHCkEEUbTEFgrh95u5QC6VtfJXnxVKlDjon7OQKBgQDjNAAVeSyM2VW829mV\n3dx4iPbJx4eLfRl+TXzBt77x14Hjo/UhajXVzDLx7FWJ2swsPTsUbaVHi5lmSte8\n3Ih825JzDY7mVPVr2/xhIeFp5ZpE12Dz0nHaZtj3SPuNjFTYBdLHT7jRtUivy51J\n7ht2qT3yd7AHmYz8wYJqus689wKBgQDZSYKZF/luvfrhhCBJBQsA9JRZ0hIEkWQ3\nzgqagrQCs99pLCWABbWrFP5jzYBDBvFMml6vDpGPH9X+OnHHOAIo81RY0c+FSRel\nQPX+pDp11rQieP/6j7VoKkNnpG3Lj+Yv/AdIQQSTamvsK2qQT650ujubR2u9cfHN\nhFjwbFSTiQKBgEJh0xRzDv0oEtDXOz96Tww4mEJkNcofhu9MHINM+FEYsi6cnOZi\nbdBFlSzx7BwW/Uh/q19QmdXJh8xHWbkohghU7vkGoRXTBNG6uIZ4q6+REf3DH+Sd\nO/6fxgyaGkVFFxT2vprVRB6hZNdYGmCbXRLSZ/ML3TabOoIu17fvVLAJAoGAb69/\nN13BUhDIoZ4eUioLa+RLVJfLtxlcX+rCPIUuLa1zCkYsyE8m/9b8oyP/53PsF6nJ\nPUXJv71naxNzZCj/wzi/hB/kAOh/BOwNBWQ4wFUppgZ33Lx9TBtdJiq4XMeMU+HB\nhHwW9AbhjjUKwz6Rt2H6PWhKkse8uBxs8rdcCbECgYA13WbTeQIsCDYwpjCX9Aws\nsaAyc670aZIgOwlxNp5ZZ9qLC8e2GhJ9X8+wFO4yN/y6H1yhwL55kJVoHIBkiyIO\noCxfbf7zmR2H5gJcnKQIL8ZB3xvJLbeiuYl4u62kTDsU5pqdMqTl4DuV37uxYpH2\nugkQ4MuOvB73ReMzlRep+Q==\n-----END PRIVATE KEY-----\n",
  "client_email": "budget-planner@budget-planner-335718.iam.gserviceaccount.com",
  "client_id": "106238203195430623171",
  "auth_uri": "https://accounts.google.com/o/oauth2/auth",
  "token_uri": "https://oauth2.googleapis.com/token",
  "auth_provider_x509_cert_url": "https://www.googleapis.com/oauth2/v1/certs",
  "client_x509_cert_url": "https://www.googleapis.com/robot/v1/metadata/x509/budget-planner%40budget-planner-335718.iam.gserviceaccount.com"
  }
  ''';

  static final _spreadsheetId = '1Qju3Ojd-TlLoCsOAYE3dFL1vBjRE_UJ8mCzOEr2gidQ';
  static final _gsheets = GSheets(_credentials);
  static Worksheet? _worksheet;

  static int numberOfTransactions = 0;
  static List<List<dynamic>> currentTransactions = [];
  static bool loading = true;

 
  Future init() async {
    final ss = await _gsheets.spreadsheet(_spreadsheetId);
    _worksheet = ss.worksheetByTitle('Sheet1');
    countRows();
  }


  static Future countRows() async {
    while ((await _worksheet!.values
            .value(column: 1, row: numberOfTransactions + 1)) !=
        '') {
      numberOfTransactions++;
    }

    loadTransactions();
  }


  static Future loadTransactions() async {
    if (_worksheet == null) return;

    for (int i = 1; i < numberOfTransactions; i++) {
      final String transactionName =
          await _worksheet!.values.value(column: 1, row: i + 1);
      final String transactionAmount =
          await _worksheet!.values.value(column: 2, row: i + 1);
      final String transactionType =
          await _worksheet!.values.value(column: 3, row: i + 1);

      if (currentTransactions.length < numberOfTransactions) {
        currentTransactions.add([
          transactionName,
          transactionAmount,
          transactionType,
        ]);
      }
    }
    print(currentTransactions);
    loading = false;
  }

  static Future insert(String name, String amount, bool _isIncome) async {
    if (_worksheet == null) return;
    numberOfTransactions++;
    currentTransactions.add([
      name,
      amount,
      _isIncome == true ? 'income' : 'expense',
    ]);
    await _worksheet!.values.appendRow([
      name,
      amount,
      _isIncome == true ? 'income' : 'expense',
    ]);
  }


  static double calculateIncome() {
    double totalIncome = 0;
    for (int i = 0; i < currentTransactions.length; i++) {
      if (currentTransactions[i][2] == 'income') {
        totalIncome += double.parse(currentTransactions[i][1]);
      }
    }
    return totalIncome;
  }

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
