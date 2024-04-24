// import 'package:flutter/material.dart';

// class CustomErrorDialog extends StatelessWidget {
//   final String errorMessage;
//   String? questionText;
//   CustomErrorDialog({super.key, required this.errorMessage, this.questionText});

//   @override
//   Widget build(BuildContext context) {
//     return AlertDialog(
//       title: Text('Error'),
//       content: SingleChildScrollView(
//         child: ListBody(
//           children: <Widget>[
//             Text(errorMessage),
//             SizedBox(height: 16),
//             questionText != null ? Text(questionText!) : Container()
//           ],
//         ),
//       ),
//       actions: <Widget>[
//         TextButton(
//           child: Text('YES'),
//           onPressed: () {
//             Navigator.of(context).pop();
//           },
//         ),
//         TextButton(
//           child: Text('Cancel'),
//           onPressed: () {
//             Navigator.of(context).pop();
//           },
//         ),
//       ],
//     );
//   }
// }
