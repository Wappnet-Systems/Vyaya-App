import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

import '../model/transaction.dart';
import '../model/users.dart';
import 'const.dart';

class CurrentValues{
  static int getCurrentYear(){
  int current_year = DateTime.now().year;
  return current_year;
  }

  static int getCurrentMonth(){
    int current_month= DateTime.now().month;
    return current_month;
  }
}

String? getCurrentHour() {
  final int current_hour = DateTime.now().hour;
  print(current_hour);
  if (current_hour >= 1 && current_hour < 12) {
    return "Good Morning";
  } else if (current_hour >= 12 && current_hour < 16) {
    return "Good Afternoon";
  } else if (current_hour >= 16 && current_hour < 21) {
    return "Good Evening";
  } else if (current_hour >= 21 && current_hour < 24) {
    return "Good Night";
  }
  return null;
}

  String? getCurrentMonth() {
   return DateFormat.yMMM().format(DateTime.now());
}





// class FetchTransactions{
//   static List<AllTransactionDetails> curentmonthtransactions = [];
//   static List<int> income_of_the_month=[];
//   static List<int> spending_of_the_month=[];
//   static int? income_of_the_month_value =00;
//   static int? spending_of_the_month_value=00;
//   static int? balance_of_the_month_value=00;

// static Future<void> getAllTransaction() async {
//   income_of_the_month.clear();
//   spending_of_the_month.clear();
//   income_of_the_month_value =00;
//   spending_of_the_month_value=00;
//   balance_of_the_month_value=00;

//   DateTime startDate = DateTime(CurrentValues.getCurrentYear(), CurrentValues.getCurrentMonth(), 1);
//   DateTime endDate = DateTime(CurrentValues.getCurrentYear(), CurrentValues.getCurrentMonth()+1, 1);


//   final snapshot = await FirebaseFirestore.instance
//         .collection('users')
//         .doc(UserData.CurrentUserId)
//         .collection('transaction')
//         .orderBy('transactionDate', descending: true)
//          .where('transactionDate', isGreaterThanOrEqualTo: startDate)
//       .where('transactionDate', isLessThanOrEqualTo: endDate)
//         .get();
    
//     final transactionData = snapshot.docs
//         .map((doc) => AllTransactionDetails(
//            uId: doc["uId"],
//             tID: doc['tID'],
//             transactionsubcategoryindex: doc['transactionsubcategoryindex'],
//             transactionAmount: doc['transactionAmount'],
//             transactioncategory: doc['transactionCategory'],
//             transactionDate: doc['transactionDate'],
//             transactionnote: doc['transactionnote'],
//             transactionpaymentmode: doc['transactionpaymentmode'],
//             transactionsubcategory: doc['transactionsubcategory'],
//             transactionCreatedAt:doc['transactionCreatedAt']
//            ))
//         .toList();

//     curentmonthtransactions = transactionData;
//     print(curentmonthtransactions.length);
//     print(transactionData.length);
//     findIncomeSpending();
//   }

//   static void findIncomeSpending(){
//     for(int i=0;i<curentmonthtransactions.length;i++){
//       if(curentmonthtransactions[i].transactioncategory==0){
//         income_of_the_month.add(curentmonthtransactions[i].transactionAmount!);
//       }
//       else if(curentmonthtransactions[i].transactioncategory==1){
//         spending_of_the_month.add(curentmonthtransactions[i].transactionAmount!);
//       }
//       else{
//                 // spending_of_the_month.add(transactions[i].transactionAmount!);
//       }
      
//     }

//     print("spending_of_the_month.length ${spending_of_the_month.length}");  
//     print("income_of_the_month.length ${income_of_the_month.length}");  
    
//     totlaIncomOfTheMonth();
//     totlaExpensesOfTheMonth();
//     getBalanceOfMonth();
//   }

//   static void totlaIncomOfTheMonth(){
//     for(int i=0;i<income_of_the_month.length;i++){
//        income_of_the_month_value=income_of_the_month[i] + income_of_the_month_value!; 
//     }
//   }

//   static void totlaExpensesOfTheMonth(){
//   for(int i=0;i<spending_of_the_month.length;i++){
//        spending_of_the_month_value=spending_of_the_month[i] + spending_of_the_month_value! ; 
//     }
//     print("income_of_the_month_value : $income_of_the_month_value");
//     print("expenses_of_the_month_value : $spending_of_the_month_value");
//   }
   
//   static getBalanceOfMonth(){
//     balance_of_the_month_value=(income_of_the_month_value! - spending_of_the_month_value!);
//     print(balance_of_the_month_value);

//   }
// }
  
