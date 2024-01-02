
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';

import '../model/localtransaction.dart';

class AppDetailsClass{
  static String appName="Vyaya";
}

  Future<List<LocalTransaction>> getAllLocalTransactions() async {
    final box = await Hive.openBox<LocalTransaction>('local_transactions');
    final transactions = box.values.toList();
    return transactions;
  }

  String getDatestamp(DateTime transactionDateTime) {
  DateTime currentDate = DateTime.now();
  DateTime yesterdayDate = currentDate.subtract(const Duration(days: 1));
  
  if (transactionDateTime.year == currentDate.year &&
      transactionDateTime.month == currentDate.month &&
      transactionDateTime.day == currentDate.day) {
    return 'Today';
  } else if (transactionDateTime.year == yesterdayDate.year &&
      transactionDateTime.month == yesterdayDate.month &&
      transactionDateTime.day == yesterdayDate.day) {
    return 'Yesterday';
  } else {
    String formattedDate = DateFormat.yMMMd().format(transactionDateTime);
    return formattedDate;
  }
}


  bool isDifferentDay(DateTime date1, DateTime date2) {
  return date1.year != date2.year || date1.month != date2.month || date1.day != date2.day;
}



String? getCurrentHour() {
  final int currentHour = DateTime.now().hour;
  if (currentHour >= 0 && currentHour < 12) {
    return "Good Morning";
  } else if (currentHour >= 12 && currentHour < 16) {
    return "Good Afternoon";
  } else if (currentHour >= 16 && currentHour < 21) {
    return "Good Evening";
  } else if (currentHour >= 21 && currentHour < 24) {
    return "Good Night";
  }
  return null;
}