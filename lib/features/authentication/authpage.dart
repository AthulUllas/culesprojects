// import 'package:flutter/material.dart';

// class Authpage extends StatelessWidget {
//   const Authpage({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color.fromARGB(255, 255, 62, 49),
//       body: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           InkWell(
//             onTap: () {
//               Navigator.push(
//                 context,
//                 MaterialPageRoute(builder: (context) => Loginpage()),
//               );
//             },
//             child: Container(
//               height: 50,
//               decoration: BoxDecoration(
//                 color: Colors.white,
//                 borderRadius: BorderRadius.circular(10),
//               ),
//               margin: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
//               child: Center(
//                 child: Text(
//                   "Login",
//                   style: TextStyle(
//                     letterSpacing: 2,
//                     color: Colors.black,
//                     fontWeight: FontWeight.w500,
//                     fontSize: 20,
//                   ),
//                 ),
//               ),
//             ),
//           ),
//           InkWell(
//             onTap: () {
//               Navigator.push(
//                 context,
//                 MaterialPageRoute(builder: (context) => SignUpPage()),
//               );
//             },
//             child: Container(
//               height: 50,
//               decoration: BoxDecoration(
//                 color: Colors.white,
//                 borderRadius: BorderRadius.circular(10),
//               ),
//               margin: EdgeInsets.symmetric(horizontal: 24),
//               child: Center(
//                 child: Text(
//                   "SignUp",
//                   style: TextStyle(
//                     letterSpacing: 2,
//                     color: Colors.black,
//                     fontWeight: FontWeight.w500,
//                     fontSize: 20,
//                   ),
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
