// class _ResetPasswordDoneState extends State<ResetPasswordDone> {
//   int delayInSeconds = 5;
//   ValueNotifier<bool> canResend = ValueNotifier(false);

//   @override
//   void initState() {
//     super.initState();
//     Future.delayed(Duration(seconds: delayInSeconds), () {
//       canResend.value = true;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: () {
//         FocusScope.of(context).unfocus();
//       },
//       child: Scaffold(
//         // ... other widgets ...
//         body: Padding(
//           padding: const EdgeInsets.all(24),
//           child: Column(
//             children: <Widget>[
//               // ... other widgets ...
//               Expanded(
//                 child: Column(
//                   mainAxisAlignment: MainAxisAlignment.end,
//                   children: <Widget>[
//                     const Text(
//                       'Didn\'t get an email?',
//                       style: TextStyle(fontSize: 14),
//                     ),
//                     ValueListenableBuilder(
//                       valueListenable: canResend,
//                       builder: (context, value, child) {
//                         return GestureDetector(
//                           onTap: value
//                               ? () {
//                                   Navigator.pushReplacementNamed(
//                                     context,
//                                     '/',
//                                   );
//                                 }
//                               : null,
//                           child: Text(
//                             'Resend',
//                             style: TextStyle(
//                               color: value ? Colors.blue : Colors.grey,
//                             ),
//                           ),
//                         );
//                       },
//                     ),
//                     const SizedBox(height: 20),
//                     // ... other widgets ...
//                   ],
//                 ),
//               )
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }