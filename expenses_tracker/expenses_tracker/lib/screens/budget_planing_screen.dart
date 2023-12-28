// import 'package:expenses_tracker/exports.dart';

// class _BudgetPlanningForm extends StatefulWidget {
//   const _BudgetPlanningForm();

//   @override
//   __BudgetPlanningFormState createState() => __BudgetPlanningFormState();
// }

// class __BudgetPlanningFormState extends State<_BudgetPlanningForm> {
//   final _formKey = GlobalKey<FormState>();
//   TextEditingController familyMembersController = TextEditingController();
//   TextEditingController expensesMembersController = TextEditingController();
//   double emergencyFunds = 0.0;

//   String incomeSource = '';
//   String expensesSource = '';

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title:const Text('Income and Expenses Form'),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Form(
//           key: _formKey,
//           child: Column(
//             children: [
//               TextFormField(
//                 controller: familyMembersController,
//                 decoration:const  InputDecoration(labelText: 'Number of Family Members Contributing to Income'),
//                 keyboardType: TextInputType.number,
//                 validator: (value) {
//                   if (value == null || value.isEmpty) {
//                     return 'Please enter a valid number';
//                   }
//                   return null;
//                 },
//               ),
//               verticalSpacer(16),
//               Row(
//                 children: [
//                   const Text('Source of Income: '),
//                   Radio(
//                     value: 'Fixed Income',
//                     groupValue: incomeSource,
//                     onChanged: (value) {
//                       setState(() {
//                         incomeSource = value.toString();
//                       });
//                     },
//                   ),
//                   const Text('Fixed Income'),
//                   Radio(
//                     value: 'Variable Income',
//                     groupValue: incomeSource,
//                     onChanged: (value) {
//                       setState(() {
//                         incomeSource = value.toString();
//                       });
//                     },
//                   ),
//                   const Text('Variable Income'),
//                 ],
//               ),
//               verticalSpacer(16),
//               TextFormField(
//                 controller: expensesMembersController,
//                 decoration:const  InputDecoration(labelText: 'Number of Family Members Responsible for Expenses'),
//                 keyboardType: TextInputType.number,
//                 validator: (value) {
//                   if (value == null || value.isEmpty) {
//                     return 'Please enter a valid number';
//                   }
//                   return null;
//                 },
//               ),
//               verticalSpacer(16),
//               Row(
//                 children: [
//                   const Text('Source of Expenses: '),
//                   Radio(
//                     value: 'Fixed Expenses',
//                     groupValue: expensesSource,
//                     onChanged: (value) {
//                       setState(() {
//                         expensesSource = value.toString();
//                       });
//                     },
//                   ),
//                   const Text('Fixed Expenses'),
//                   Radio(
//                     value: 'Variable Expenses',
//                     groupValue: expensesSource,
//                     onChanged: (value) {
//                       setState(() {
//                         expensesSource = value.toString();
//                       });
//                     },
//                   ),
//                   const Text('Variable Expenses'),
//                 ],
//               ),
//               verticalSpacer(16),
//               Row(
//                 children: [
//                   const Text('Emergency Funds Allocation (%): '),
//                   Slider(
//                     value: emergencyFunds,
//                     min: 0,
//                     max: 100,
//                     onChanged: (value) {
//                       setState(() {
//                         emergencyFunds = value;
//                       });
//                     },
//                   ),
//                   Text(emergencyFunds.toStringAsFixed(0)),
//                 ],
//               ),
//               verticalSpacer(16),
//               ElevatedButton(
//                 onPressed: () {
//                   if (_formKey.currentState?.validate() ?? false) {
//                     print('Number of Family Members: ${familyMembersController.text}');
//                     print('Source of Income: $incomeSource');
//                     print('Number of Expenses Members: ${expensesMembersController.text}');
//                     print('Source of Expenses: $expensesSource');
//                     print('Emergency Funds Allocation: $emergencyFunds%');
//                   }
//                 },
//                 child: Text('Submit'),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }