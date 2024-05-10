import 'package:flutter/material.dart';
import '../constants/theme.dart';
import '../routing/router.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      theme: customTheme(context),
      routerConfig: router,
    );
  }
}

// class App extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       title: 'Your App',
//       home: Scaffold(
//         body: Builder(
//           builder: (context) {
//             return GraphQLProvider(
//               client: graphQLClient,
//               child: SplashPage(),
//             );
//           },
//         ),
//       ),
//     );
//   }
// }
