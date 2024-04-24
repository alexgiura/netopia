import 'package:erp_frontend_v2/constants/style.dart';
import 'package:flutter/material.dart';

// class CustomErrorDialog extends StatelessWidget {
//   final String description;

//   const CustomErrorDialog({Key? key, required this.description})
//       : super(key: key);

//   static void showError(BuildContext context, String description) {
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return CustomErrorDialog(description: description);
//       },
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return AlertDialog(
//       title: Row(
//         children: const [
//           Icon(Icons.error, color: Colors.red),
//           SizedBox(width: 8),
//           Text('Error'),
//         ],
//       ),
//       content: Text(description),
//       actions: <Widget>[
//         TextButton(
//           child: const Text('Close'),
//           onPressed: () {
//             Navigator.of(context).pop();
//           },
//         ),
//       ],
//     );
//   }
// }

void showErrorDialog(
    BuildContext context, String description, VoidCallback onActionPressed) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Stack(
          clipBehavior: Clip.none,
          alignment: Alignment.topCenter,
          children: [
            Container(
              width: 250,
              margin: const EdgeInsets.only(top: 32), // Space for circular icon
              padding: const EdgeInsets.fromLTRB(
                  20, 20, 20, 20), // Padding inside the dialog
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'Eroare',
                    style: CustomStyle.titleText,
                  ),
                  const SizedBox(height: 24),
                  Text(
                    description,
                    style: CustomStyle.bodyText,
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    "Doriti sa anulati toate documentele?",
                    style: CustomStyle.bodyText,
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        child: const Text('Anuleaza toate'),
                        onPressed: () {
                          onActionPressed();
                          Navigator.of(context).pop();
                        },
                      ),
                      const SizedBox(width: 8),
                      TextButton(
                        child: const Text('Close'),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Positioned(
              top: -42, // Position the circle above the dialog
              child: Container(
                decoration: const BoxDecoration(
                  color: Colors.red, // Circle color
                  shape: BoxShape.circle,
                ),
                padding: const EdgeInsets.all(22), // Padding inside the circle
                child: const Icon(
                  Icons.clear,
                  color: Colors.white, // Icon color
                  size: 40, // Icon size
                ),
              ),
            ),
          ],
        ),
      );
    },
  );
}
