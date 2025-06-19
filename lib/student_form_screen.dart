import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class StudentFormScreen extends StatefulWidget {
  final bool isEdit;
  final String? docId;
  final Map<String, dynamic>? existingData;

  StudentFormScreen({required this.isEdit, this.docId, this.existingData});

  @override
  _StudentFormScreenState createState() => _StudentFormScreenState();
}

class _StudentFormScreenState extends State<StudentFormScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController nameController = TextEditingController();
  final TextEditingController ageController = TextEditingController();
  final TextEditingController rollController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController feesStatus = TextEditingController();
  final TextEditingController attendanceStatus = TextEditingController();
  final TextEditingController lastReleasedResult = TextEditingController();
  final TextEditingController totalCGPA = TextEditingController();
  final TextEditingController degreeName = TextEditingController();
  final TextEditingController departmentName = TextEditingController();
  final TextEditingController year = TextEditingController();
  final TextEditingController semester = TextEditingController();

  final CollectionReference students = FirebaseFirestore.instance.collection('students');

  @override
  void initState() {
    super.initState();
    if (widget.isEdit && widget.existingData != null) {
      final data = widget.existingData!;
      nameController.text = data['name'] ?? '';
      ageController.text = data['age']?.toString() ?? '';
      rollController.text = data['rollNo'] ?? '';
      emailController.text = data['email'] ?? '';
      feesStatus.text = data['feesStatus'] ?? '';
      attendanceStatus.text = data['attendanceStatus'] ?? '';
      lastReleasedResult.text = data['lastReleasedResult']?.toString() ?? '';
      totalCGPA.text = data['totalCGPA']?.toString() ?? '';
      degreeName.text = data['degreeName'] ?? '';
      departmentName.text = data['departmentName'] ?? '';
      year.text = data['year']?.toString() ?? '';
      semester.text = data['semester']?.toString() ?? '';
    }
  }

  Future<void> handleSubmit() async {
    if (!_formKey.currentState!.validate()) return;

    final data = {
      'name': nameController.text.trim(),
      'age': int.parse(ageController.text.trim()),
      'rollNo': rollController.text.trim(),
      'email': emailController.text.trim(),
      'feesStatus': feesStatus.text.trim(),
      'attendanceStatus': attendanceStatus.text.trim(),
      'lastReleasedResult': double.parse(lastReleasedResult.text.trim()),
      'totalCGPA': double.parse(totalCGPA.text.trim()),
      'degreeName': degreeName.text.trim(),
      'departmentName': departmentName.text.trim(),
      'year': year.text.trim(),
      'semester': semester.text.trim(),
    };

    try {
      if (widget.isEdit) {
        await students.doc(widget.docId).update(data);
        showMessage("Student updated!");
      } else {
        final roll = rollController.text.trim();
        final exists = await students.doc(roll).get();
        if (exists.exists) {
          showMessage("Roll number already exists!");
          return;
        }
        await students.doc(roll).set({
          ...data,
          'createdAt': Timestamp.now(),
        });
        showMessage("Student added!");
      }
      Navigator.pop(context);
    } catch (e) {
      showMessage("Error: ${e.toString()}");
    }
  }

  void showMessage(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  Widget buildField(String label, TextEditingController controller,
      {TextInputType type = TextInputType.text, bool readOnly = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        controller: controller,
        keyboardType: type,
        readOnly: readOnly,
        validator: (val) => val == null || val.trim().isEmpty ? 'Required' : null,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.isEdit ? "Edit Student" : "Add Student")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              buildField("Name", nameController),
              buildField("Age", ageController, type: TextInputType.number),
              buildField("Roll Number", rollController, readOnly: widget.isEdit),
              buildField("Email", emailController, type: TextInputType.emailAddress),
              buildField("Fees Status", feesStatus),
              buildField("Attendance Status", attendanceStatus),
              buildField("Last Released Result", lastReleasedResult, type: TextInputType.number),
              buildField("Total CGPA", totalCGPA, type: TextInputType.number),
              buildField("Degree Name", degreeName),
              buildField("Department Name", departmentName),
              buildField("Year", year, type: TextInputType.number),
              buildField("Semester", semester, type: TextInputType.number),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: handleSubmit,
                  child: Text(widget.isEdit ? "Update" : "Add"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}






















// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
//
// class StudentFormScreen extends StatefulWidget {
//   final bool isEdit;
//   final String? docId;
//   final Map<String, dynamic>? existingData;
//
//   StudentFormScreen({required this.isEdit, this.docId, this.existingData});
//
//   @override
//   _StudentFormScreenState createState() => _StudentFormScreenState();
// }
//
// class _StudentFormScreenState extends State<StudentFormScreen> {
//   final TextEditingController nameController = TextEditingController();
//   final TextEditingController ageController = TextEditingController();
//   final TextEditingController rollController = TextEditingController();
//   final TextEditingController emailController = TextEditingController();
//   final TextEditingController feesStatus = TextEditingController();
//   final TextEditingController attendanceStatus = TextEditingController();
//   final TextEditingController lastReleasedResult = TextEditingController();
//   final TextEditingController totalCGPA = TextEditingController();
//   final TextEditingController degreeName = TextEditingController();
//   final TextEditingController departmentName = TextEditingController();
//   final TextEditingController year = TextEditingController();
//   final TextEditingController semester = TextEditingController();
//
//   final CollectionReference students =
//   FirebaseFirestore.instance.collection('students');
//
//   @override
//   void initState() {
//     super.initState();
//     if (widget.isEdit && widget.existingData != null) {
//       nameController.text = widget.existingData!['name'];
//       ageController.text = widget.existingData!['age'].toString();
//       rollController.text = widget.existingData!['rollNo'];
//     }
//   }
//
//   Future<void> handleSubmit() async {
//     final name = nameController.text.trim();
//     final age = ageController.text.trim();
//     final roll = rollController.text.trim();
//
//     if (name.isEmpty || age.isEmpty || roll.isEmpty) {
//       showMessage("Please fill all fields");
//       return;
//     }
//
//     try {
//       if (widget.isEdit) {
//         await students.doc(widget.docId).update({
//           'name': name,
//           'age': int.parse(age),
//           'rollNo': roll,
//         });
//         showMessage("Student updated!");
//       } else {
//         final exists = await students.doc(roll).get();
//         if (exists.exists) {
//           showMessage("Roll number already exists!");
//           return;
//         }
//         await students.doc(roll).set({
//           'name': name,
//           'age': int.parse(age),
//           'rollNo': roll,
//           'createdAt': Timestamp.now(),
//         });
//         showMessage("Student added!");
//       }
//       Navigator.pop(context);
//     } catch (e) {
//       showMessage("Error: ${e.toString()}");
//     }
//   }
//
//   void showMessage(String msg) {
//     ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(widget.isEdit ? "Edit Student" : "Add Student"),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           children: [
//             TextField(
//               controller: nameController,
//               decoration: InputDecoration(labelText: 'Name'),
//             ),
//             const SizedBox(height: 48),
//             TextField(
//               controller: ageController,
//               decoration: InputDecoration(labelText: 'Age'),
//               keyboardType: TextInputType.number,
//             ),
//             const SizedBox(height: 48),
//             TextField(
//               controller: rollController,
//               enabled: !widget.isEdit,
//               decoration: InputDecoration(labelText: 'Roll Number'),
//             ),
//             const SizedBox(height: 48),
//             SizedBox(
//               width: double.infinity,
//               child: ElevatedButton(
//                 onPressed: handleSubmit,
//                 child: Text(widget.isEdit ? "Update" : "Add"),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
