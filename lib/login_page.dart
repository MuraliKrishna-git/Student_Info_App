// import 'package:flutter/material.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'admin_home.dart';
// import 'student_home.dart';
//
// class LoginPage extends StatefulWidget {
//   const LoginPage({super.key});
//
//   @override
//   State<LoginPage> createState() => _LoginPageState();
// }
//
// class _LoginPageState extends State<LoginPage> {
//   final emailController = TextEditingController();
//   final passwordController = TextEditingController();
//
//   final adminEmails = [
//     'admin1@example.com',
//     'admin2@example.com',
//   ];
//
//   void login() async {
//     try {
//       final userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
//         email: emailController.text.trim(),
//         password: passwordController.text.trim(),
//       );
//
//       final email = userCredential.user?.email;
//
//       if (adminEmails.contains(email)) {
//         Navigator.pushReplacement(
//           context,
//           MaterialPageRoute(builder: (_) => const AdminHome()),
//         );
//       } else {
//         Navigator.pushReplacement(
//           context,
//           MaterialPageRoute(
//             builder: (_) => StudentHome(studentId: userCredential.user!.uid),
//           ),
//         );
//       }
//     } on FirebaseAuthException catch (e) {
//       String message = 'Login failed';
//       if (e.code == 'user-not-found') {
//         message = 'No user found for that email.';
//       } else if (e.code == 'wrong-password') {
//         message = 'Incorrect password.';
//       }
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text(message)),
//       );
//     } catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Something went wrong')),
//       );
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text('Login')),
//       body: Padding(
//         padding: const EdgeInsets.all(20.0),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             TextField(
//               controller: emailController,
//               decoration: const InputDecoration(labelText: 'Email'),
//             ),
//             const SizedBox(height: 10),
//             TextField(
//               controller: passwordController,
//               obscureText: true,
//               decoration: const InputDecoration(labelText: 'Password'),
//             ),
//             const SizedBox(height: 20),
//             ElevatedButton(
//               onPressed: login,
//               child: const Text('Login'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
//
//
//
//
//
//
//
//
//
//
//
//
// // import 'package:flutter/material.dart';
// // import 'package:firebase_auth/firebase_auth.dart';
// //
// // class LoginPage extends StatefulWidget {
// //   const LoginPage({super.key});
// //   @override
// //   State<LoginPage> createState() => _LoginPageState();
// // }
// //
// // class _LoginPageState extends State<LoginPage> {
// //   final emailCtrl = TextEditingController();
// //   final pwdCtrl = TextEditingController();
// //   String msg = '';
// //
// //   Future<void> login() async {
// //     setState(() => msg = '');
// //     try {
// //       final cred = await FirebaseAuth.instance
// //           .signInWithEmailAndPassword(
// //         email: emailCtrl.text.trim(),
// //         password: pwdCtrl.text.trim(),
// //       );
// //       print('✅ Logged in: ${cred.user?.email}');
// //       setState(() => msg = '✅ Login success');
// //     } on FirebaseAuthException catch (e) {
// //       String errorMsg = 'Error: ${e.message}';
// //       print(errorMsg);
// //       setState(() => msg = errorMsg);
// //     } catch (e) {
// //       print(e);
// //       setState(() => msg = 'Unexpected error');
// //     }
// //   }
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       appBar: AppBar(title: const Text('Login Demo')),
// //       body: Padding(
// //         padding: const EdgeInsets.all(16),
// //         child: Column(children: [
// //           TextField(
// //             controller: emailCtrl,
// //             decoration: const InputDecoration(labelText: 'Email'),
// //           ),
// //           TextField(
// //             controller: pwdCtrl,
// //             obscureText: true,
// //             decoration: const InputDecoration(labelText: 'Password'),
// //           ),
// //           const SizedBox(height: 20),
// //           ElevatedButton(onPressed: login, child: const Text('Login')),
// //           const SizedBox(height: 20),
// //           Text(msg, style: const TextStyle(color: Colors.red)),
// //         ]),
// //       ),
// //     );
// //   }
// // }


import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'admin_home.dart';
import 'student_home.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> with SingleTickerProviderStateMixin  {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  late AnimationController _animController;
  late Animation<double> _fadeInAnimation;

  @override
  void initState() {
    super.initState();
    _animController =
        AnimationController(vsync: this, duration: const Duration(milliseconds: 800));
    _fadeInAnimation = CurvedAnimation(parent: _animController, curve: Curves.easeIn);
    _animController.forward();
  }

  final adminEmails = [
    'admin1@example.com',
    'admin2@example.com',
  ];

  void login() async {
    try {
      final userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );

      final email = userCredential.user?.email;
      if (email == null) throw Exception("No email found for user");

      // If admin
      if (adminEmails.contains(email)) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const AdminHome()),
        );
        return;
      }

      // Lookup Firestore for student doc with matching email
      final snap = await FirebaseFirestore.instance
          .collection('students')
          .where('email', isEqualTo: email)
          .limit(1)
          .get();

      if (snap.docs.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Student record not found for this email.')),
        );
        return;
      }

      final rollNo = snap.docs.first.id;

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => StudentHome(studentId: rollNo),
        ),
      );
    } on FirebaseAuthException catch (e) {
      String message = 'Login failed';
      if (e.code == 'user-not-found') {
        message = 'No user found for that email.';
      } else if (e.code == 'wrong-password') {
        message = 'Incorrect password.';
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message)),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Something went wrong')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 48),
          child: FadeTransition(
            opacity: _fadeInAnimation,
            child: ConstrainedBox(
                constraints: const BoxConstraints(
                  maxWidth: 400
                ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Welcome Back',
                      style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      )
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Log in to your account to continue',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 48),
                  TextField(
                    key: const Key('email'),
                    controller: emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: const InputDecoration(
                      labelText: 'Email',
                      prefixIcon: Icon(Icons.email_outlined),
                    ),
                  ),
                  const SizedBox(height: 24),
                  TextField(
                    key: const Key('password'),
                    controller: passwordController,
                    obscureText: true,
                    decoration: const InputDecoration(
                      labelText: 'Password',
                      prefixIcon: Icon(Icons.lock_outline),
                    ),
                  ),
                  const SizedBox(height: 32),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () => login(),
                      child: const Text('Log In'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        )
      ),
    );
  }
}
