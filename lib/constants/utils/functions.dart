
import 'package:expenses_tracker/model/localtransaction.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';


class AppDetailsClass{
  static String appName="Vyaya";
}

class CurrentValues{
  static int getCurrentYear(){
  int currentYear = DateTime.now().year;
  return currentYear;
  }

  static int getCurrentMonth(){
    int currentMonth= DateTime.now().month;
    return currentMonth;
  }

  // static String getMonthName(int monthNumber) {
  //   switch (monthNumber) {
  //     case 1:
  //       return 'Jan';
  //     case 2:
  //       return 'Feb';
  //     case 3:
  //       return 'Mar';
  //     case 4:
  //       return 'Apr';
  //     case 5:
  //       return 'May';
  //     case 6:
  //       return 'Jun';
  //     case 7:
  //       return 'Jul';
  //     case 8:
  //       return 'Aug';
  //     case 9:
  //       return 'Sep';
  //     case 10:
  //       return 'Oct';
  //     case 11:
  //       return 'Nov';
  //     case 12:
  //       return 'Dec';
  //     default:
  //       return '';
  //   }
  // }

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