import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'student_form_screen.dart';

class StudentListScreen extends StatefulWidget {
  @override
  State<StudentListScreen> createState() => _StudentListScreenState();
}

class _StudentListScreenState extends State<StudentListScreen> {
  final CollectionReference students = FirebaseFirestore.instance.collection('students');
  String searchQuery = '';

  void showStudentDetailsDialog(BuildContext context, Map<String, dynamic> data, String docId) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: Colors.lightBlue.shade50,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text("${data['name']} - ${data['rollNo']}", style: const TextStyle(fontWeight: FontWeight.bold)),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              detailItem("Age", data['age'].toString()),
              detailItem("Email", data['email']),
              detailItem("Fees Status", data['feesStatus']),
              detailItem("Attendance", data['attendanceStatus']),
              detailItem("Last Result", "${data['lastReleasedResult']} / 10"),
              detailItem("CGPA", "${data['totalCGPA']} / 10"),
              detailItem("Degree", data['degreeName']),
              detailItem("Department", data['departmentName']),
              if (data['degreeName'] != "PhD") ...[
                detailItem("Year", data['year']),
                detailItem("Semester", data['semester']),
              ],
            ],
          ),
        ),
        actions: [
          TextButton(
            child: const Text("Edit", style: TextStyle(color: Colors.blue)),
            onPressed: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => StudentFormScreen(
                    isEdit: true,
                    docId: docId,
                    existingData: data,
                  ),
                ),
              );
            },
          ),
          TextButton(
            child: const Text("Close", style: TextStyle(color: Colors.red)),
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
    );
  }

  Widget detailItem(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Text("$label: ", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blue.shade800)),
          Flexible(child: Text(value)),
        ],
      ),
    );
  }

  bool matchesSearch(Map<String, dynamic> data) {
    if (searchQuery.trim().isEmpty) return true;
    final q = searchQuery.toLowerCase();
    return data.entries.any((e) => e.value.toString().toLowerCase().contains(q));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("All Students"),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              onChanged: (val) => setState(() => searchQuery = val),
              decoration: InputDecoration(
                hintText: "Search by name, rollNo, dept, etc...",
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
          ),
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: students.snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) return const Center(child: Text('Error fetching data'));
          if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());

          final docs = snapshot.data!.docs.where((doc) {
            final data = doc.data() as Map<String, dynamic>;
            return matchesSearch(data);
          }).toList();

          if (docs.isEmpty) return const Center(child: Text('No matching students found'));

          return ListView.builder(
            itemCount: docs.length,
            itemBuilder: (context, index) {
              final data = docs[index].data() as Map<String, dynamic>;
              return Card(
                color: Colors.lightBlue.shade50,
                margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                child: ListTile(
                  title: Text(data['rollNo'], style: const TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text(data['name'], style: TextStyle(color: Colors.blue.shade800, fontWeight: FontWeight.bold)),
                  onTap: () => showStudentDetailsDialog(context, data, docs[index].id),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blue.shade500,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => StudentFormScreen(isEdit: false),
            ),
          );
        },
        child: const Icon(Icons.add),
        tooltip: 'Add New Student',
      ),
    );
  }
}












// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'student_form_screen.dart';
//
// class StudentListScreen extends StatelessWidget {
//   final CollectionReference students =
//   FirebaseFirestore.instance.collection('students');
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text("All Students")),
//       body: StreamBuilder<QuerySnapshot>(
//         stream: students.orderBy('createdAt', descending: true).snapshots(),
//         builder: (context, snapshot) {
//           if (snapshot.hasError) return Center(child: Text('Error: ${snapshot.error}'));
//           if (!snapshot.hasData) return Center(child: CircularProgressIndicator());
//
//           final docs = snapshot.data!.docs;
//
//           if (docs.isEmpty) return Center(child: Text('No students found'));
//
//           return ListView.builder(
//             itemCount: docs.length,
//             itemBuilder: (context, index) {
//               final data = docs[index].data() as Map<String, dynamic>;
//               return Card(
//                 color: Colors.teal.shade50,
//                 margin: EdgeInsets.all(10),
//                 shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//                 child: ListTile(
//                   title: Text('${data['name']} (Roll: ${data['rollNo']})'),
//                   subtitle: Text('Age: ${data['age']}'),
//                   trailing: IconButton(
//                     icon: Icon(Icons.edit, color: Colors.teal),
//                     onPressed: () {
//                       Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                           builder: (_) => StudentFormScreen(
//                             isEdit: true,
//                             docId: docs[index].id,
//                             existingData: data,
//                           ),
//                         ),
//                       );
//                     },
//                   ),
//                 ),
//               );
//             },
//           );
//         },
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: () {
//           Navigator.push(
//             context,
//             MaterialPageRoute(
//               builder: (_) => StudentFormScreen(isEdit: false),
//             ),
//           );
//         },
//         child: Icon(Icons.add),
//         tooltip: 'Add Student',
//       ),
//     );
//   }
// }
