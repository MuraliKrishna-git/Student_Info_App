import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'login_page.dart';

class StudentHome extends StatelessWidget {
  final String studentId;
  const StudentHome({super.key, required this.studentId});

  Future<DocumentSnapshot> fetchStudentDetails() async {
    return await FirebaseFirestore.instance
        .collection('students')
        .doc(studentId)
        .get();
  }

  void logout(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const LoginPage()),
          (route) => false,
    );
  }

  Widget detailTile(String label, String value) {
    return Card(
      color: Colors.lightBlue.shade50,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: const EdgeInsets.symmetric(vertical: 6),
      child: ListTile(
        leading: const Icon(Icons.info_outline, color: Colors.blue),
        title: Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(value),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Student Dashboard'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Logout',
            onPressed: () => logout(context),
          )
        ],
      ),
      body: FutureBuilder<DocumentSnapshot>(
        future: fetchStudentDetails(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError || !snapshot.hasData || !snapshot.data!.exists) {
            return const Center(child: Text('Error loading student data'));
          }

          final data = snapshot.data!.data() as Map<String, dynamic>;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                const Text(
                  "Student Information",
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.blue),
                ),
                const SizedBox(height: 20),
                detailTile("Name", data['name']),
                detailTile("Roll Number", data['rollNo']),
                detailTile("Age", data['age'].toString()),
                detailTile("Email", data['email']),
                detailTile("Fees Status", data['feesStatus']),
                detailTile("Attendance", data['attendanceStatus']),
                detailTile("Last Result", "${data['lastReleasedResult']} / 10"),
                detailTile("CGPA", "${data['totalCGPA']} / 10"),
                detailTile("Degree", data['degreeName']),
                detailTile("Department", data['departmentName']),
                if (data['degreeName'] != "PhD") ...[
                  detailTile("Year", data['year']),
                  detailTile("Semester", data['semester']),
                ]
              ],
            ),
          );
        },
      ),
    );
  }
}




















//
// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
//
// import 'login_page.dart'; // import your login page here
//
// class StudentHome extends StatelessWidget {
//   final String studentId;
//   const StudentHome({super.key, required this.studentId});
//
//   Future<DocumentSnapshot> fetchStudentDetails() async {
//     return await FirebaseFirestore.instance
//         .collection('students')
//         .doc(studentId)
//         .get();
//   }
//
//   void logout(BuildContext context) async {
//     await FirebaseAuth.instance.signOut();
//     Navigator.pushAndRemoveUntil(
//       context,
//       MaterialPageRoute(builder: (_) => const LoginPage()),
//           (route) => false,
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Student Dashboard'),
//         actions: [
//           IconButton(
//             icon: const Icon(Icons.logout),
//             onPressed: () => logout(context),
//             tooltip: 'Logout',
//           ),
//         ],
//       ),
//       body: FutureBuilder<DocumentSnapshot>(
//         future: fetchStudentDetails(),
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return const Center(child: CircularProgressIndicator());
//           }
//
//           if (snapshot.hasError || !snapshot.hasData || !snapshot.data!.exists) {
//             return const Center(child: Text('Error loading student details'));
//           }
//
//           final data = snapshot.data!.data() as Map<String, dynamic>;
//
//           return Padding(
//             padding: const EdgeInsets.all(16.0),
//             child: Column(
//               children: [
//                 const Text(
//                   'Student Details',
//                   style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
//                 ),
//                 const SizedBox(height: 20),
//                 _buildInfoCard('Name', data['name']),
//                 _buildInfoCard('Roll Number', studentId),
//                 _buildInfoCard('Age', data['age'].toString()),
//                 _buildInfoCard('Email', data['email'] ?? 'Not Provided'),
//               ],
//             ),
//           );
//         },
//       ),
//     );
//   }
//
//   Widget _buildInfoCard(String label, String value) {
//     return Card(
//       margin: const EdgeInsets.symmetric(vertical: 8),
//       elevation: 4,
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//       child: ListTile(
//         leading: const Icon(Icons.person, color: Colors.indigo),
//         title: Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
//         subtitle: Text(value, style: const TextStyle(fontSize: 16)),
//         tileColor: Colors.indigo.shade50,
//       ),
//     );
//   }
// }
