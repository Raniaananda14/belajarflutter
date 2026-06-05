// import 'package:flutter/material.dart';
// import 'package:flutter_application_1/day_19/database/preference_handler.dart';

// /// ===============================
// /// ROOT APP
// /// ===============================

// class BizGrowApp extends StatelessWidget {
//   const BizGrowApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       home: const SplashScreen(),

//       theme: ThemeData(
//         fontFamily: 'Poppins',
//         scaffoldBackgroundColor: const Color(0xFFF4F4F4),
//       ),
//     );
//   }
// }

// /// ===============================
// /// SPLASH SCREEN
// /// ===============================

// class SplashScreen extends StatefulWidget {
//   const SplashScreen({super.key});

//   @override
//   State<SplashScreen> createState() => _SplashScreenState();
// }

// class _SplashScreenState extends State<SplashScreen> {
//   @override
//   void initState() {
//     super.initState();

//     checkLogin();
//   }

//   void checkLogin() async {
//     await Future.delayed(const Duration(seconds: 2));

//     if (PreferenceHandler.isLogin) {
//       Navigator.pushReplacement(
//         context,
//         MaterialPageRoute(builder: (_) => const MainNavigation()),
//       );
//     } else {
//       Navigator.pushReplacement(
//         context,
//         MaterialPageRoute(builder: (_) => const LoginScreen()),
//       );
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,

//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,

//           children: const [
//             Icon(Icons.auto_graph, size: 100, color: Colors.black),

//             SizedBox(height: 20),

//             Text(
//               "BizGrow",
//               style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
//             ),

//             SizedBox(height: 30),

//             CircularProgressIndicator(color: Colors.black),
//           ],
//         ),
//       ),
//     );
//   }
// }

// /// ===============================
// /// LOGIN SCREEN
// /// ===============================

// class LoginScreen extends StatefulWidget {
//   const LoginScreen({super.key});

//   @override
//   State<LoginScreen> createState() => _LoginScreenState();
// }

// class _LoginScreenState extends State<LoginScreen> {
//   bool obscurePassword = true;

//   final _formKey = GlobalKey<FormState>();

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0xFFF3F3F3),

//       body: SafeArea(
//         child: Padding(
//           padding: const EdgeInsets.symmetric(horizontal: 14),

//           child: Column(
//             children: [
//               /// HEADER
//               Padding(
//                 padding: const EdgeInsets.only(top: 10),

//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.center,

//                   children: [
//                     Row(
//                       children: const [
//                         Icon(Icons.auto_graph, color: Colors.black, size: 55),

//                         SizedBox(width: 6),

//                         Text(
//                           "BizGrow",
//                           style: TextStyle(
//                             color: Colors.black,
//                             fontSize: 18,
//                             fontWeight: FontWeight.w700,
//                           ),
//                         ),
//                       ],
//                     ),
//                   ],
//                 ),
//               ),

//               const SizedBox(height: 6),

//               /// LOGIN CARD
//               Expanded(
//                 child: Container(
//                   width: double.infinity,

//                   padding: const EdgeInsets.symmetric(
//                     horizontal: 22,
//                     vertical: 24,
//                   ),

//                   decoration: BoxDecoration(
//                     color: Colors.white,
//                     borderRadius: BorderRadius.circular(28),
//                   ),

//                   child: SingleChildScrollView(
//                     child: Form(
//                       key: _formKey,

//                       child: Column(
//                         children: [
//                           const SizedBox(height: 6),

//                           const Text(
//                             "Sign in to your Account",
//                             textAlign: TextAlign.center,
//                             style: TextStyle(
//                               color: Colors.black,
//                               fontSize: 30,
//                               fontWeight: FontWeight.w800,
//                             ),
//                           ),

//                           const SizedBox(height: 10),

//                           const Text(
//                             "Enter your details to access your growth dashboard.",
//                             textAlign: TextAlign.center,
//                             style: TextStyle(
//                               color: Colors.black54,
//                               fontSize: 14,
//                               height: 1.5,
//                             ),
//                           ),

//                           const SizedBox(height: 20),

//                           /// EMAIL
//                           Row(
//                             children: const [
//                               Text(
//                                 "Email Address",
//                                 style: TextStyle(
//                                   color: Colors.black,
//                                   fontWeight: FontWeight.w600,
//                                   fontSize: 13,
//                                 ),
//                               ),
//                             ],
//                           ),

//                           const SizedBox(height: 6),

//                           TextFormField(
//                             decoration: InputDecoration(
//                               hintText: "name@company.com",

//                               filled: true,
//                               fillColor: const Color(0xFFF4F4F4),

//                               border: OutlineInputBorder(
//                                 borderRadius: BorderRadius.circular(16),
//                                 borderSide: BorderSide.none,
//                               ),

//                               enabledBorder: OutlineInputBorder(
//                                 borderRadius: BorderRadius.circular(16),
//                                 borderSide: const BorderSide(
//                                   color: Colors.black12,
//                                 ),
//                               ),

//                               focusedBorder: OutlineInputBorder(
//                                 borderRadius: BorderRadius.circular(16),
//                                 borderSide: const BorderSide(
//                                   color: Colors.black,
//                                 ),
//                               ),
//                             ),

//                             validator: (value) {
//                               if (value == null || value.isEmpty) {
//                                 return "Email tidak boleh kosong";
//                               }

//                               return null;
//                             },
//                           ),

//                           const SizedBox(height: 16),

//                           /// PASSWORD
//                           Row(
//                             mainAxisAlignment: MainAxisAlignment.spaceBetween,

//                             children: [
//                               const Text(
//                                 "Password",
//                                 style: TextStyle(
//                                   color: Colors.black,
//                                   fontWeight: FontWeight.w600,
//                                   fontSize: 13,
//                                 ),
//                               ),

//                               GestureDetector(
//                                 onTap: () {},

//                                 child: const Text(
//                                   "Forgot?",
//                                   style: TextStyle(
//                                     color: Colors.black,
//                                     fontWeight: FontWeight.w600,
//                                     fontSize: 13,
//                                   ),
//                                 ),
//                               ),
//                             ],
//                           ),

//                           const SizedBox(height: 6),

//                           TextFormField(
//                             obscureText: obscurePassword,

//                             decoration: InputDecoration(
//                               hintText: "********",

//                               filled: true,
//                               fillColor: const Color(0xFFF4F4F4),

//                               border: OutlineInputBorder(
//                                 borderRadius: BorderRadius.circular(16),
//                                 borderSide: BorderSide.none,
//                               ),

//                               enabledBorder: OutlineInputBorder(
//                                 borderRadius: BorderRadius.circular(16),
//                                 borderSide: const BorderSide(
//                                   color: Colors.black12,
//                                 ),
//                               ),

//                               focusedBorder: OutlineInputBorder(
//                                 borderRadius: BorderRadius.circular(16),
//                                 borderSide: const BorderSide(
//                                   color: Colors.black,
//                                 ),
//                               ),

//                               suffixIcon: IconButton(
//                                 onPressed: () {
//                                   setState(() {
//                                     obscurePassword = !obscurePassword;
//                                   });
//                                 },

//                                 icon: Icon(
//                                   obscurePassword
//                                       ? Icons.visibility_outlined
//                                       : Icons.visibility_off_outlined,
//                                 ),
//                               ),
//                             ),

//                             validator: (value) {
//                               if (value == null || value.isEmpty) {
//                                 return "Password tidak boleh kosong";
//                               }

//                               return null;
//                             },
//                           ),

//                           const SizedBox(height: 28),

//                           /// LOGIN BUTTON
//                           SizedBox(
//                             width: double.infinity,
//                             height: 56,

//                             child: ElevatedButton(
//                               style: ElevatedButton.styleFrom(
//                                 backgroundColor: Colors.black,
//                                 elevation: 0,

//                                 shape: RoundedRectangleBorder(
//                                   borderRadius: BorderRadius.circular(16),
//                                 ),
//                               ),

//                               onPressed: () async {
//                                 if (_formKey.currentState!.validate()) {
//                                   // simpan login
//                                   await PreferenceHandler.setLogin(true);

//                                   ScaffoldMessenger.of(context).showSnackBar(
//                                     const SnackBar(
//                                       content: Text("Berhasil Login"),
//                                     ),
//                                   );

//                                   Navigator.pushReplacement(
//                                     context,
//                                     MaterialPageRoute(
//                                       builder: (_) => const MainNavigation(),
//                                     ),
//                                   );
//                                 }
//                               },

//                               child: const Text(
//                                 "Login",
//                                 style: TextStyle(
//                                   color: Colors.white,
//                                   fontSize: 16,
//                                   fontWeight: FontWeight.w700,
//                                 ),
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

// /// ===============================
// /// HOME / MAIN NAVIGATION
// /// ===============================

// class MainNavigation extends StatelessWidget {
//   const MainNavigation({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("BizGrow"),

//         actions: [
//           IconButton(
//             onPressed: () async {
//               // logout
//               await PreferenceHandler.setLogin(false);

//               Navigator.pushReplacement(
//                 context,
//                 MaterialPageRoute(builder: (_) => const LoginScreen()),
//               );
//             },

//             icon: const Icon(Icons.logout),
//           ),
//         ],
//       ),

//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,

//           children: const [
//             Icon(Icons.auto_graph, size: 100),

//             SizedBox(height: 20),

//             Text(
//               "Selamat Datang di BizGrow",
//               style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
//             ),

//             SizedBox(height: 10),

//             Text(
//               "Business Growth Dashboard",
//               style: TextStyle(color: Colors.black54),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
