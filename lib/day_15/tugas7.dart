import 'package:flutter/material.dart';

class checkBoxDay15 extends StatefulWidget {
  const checkBoxDay15({super.key});

  @override
  State<checkBoxDay15> createState() => _checkBoxDay15State();
}

class _checkBoxDay15State extends State<checkBoxDay15> {
  bool isCheck = false;
  bool isSwitch = false;
  String? selectedDropdown;
  DateTime? selectedDate;
  TimeOfDay? selectedTime;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: const Color.fromARGB(255, 202, 118, 118),
        iconTheme: IconThemeData(color: Colors.cyanAccent),
        title: Center(
          child: Text(
            style: TextStyle(fontWeight: FontWeight.bold),
            "Dashboard",
          ),
        ),
      ),
      body: Row(
        children: [
          Padding(
            padding: EdgeInsetsGeometry.infinity,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Text("Switch"),
                  Switch(
                    value: isSwitch,
                    onChanged: (bool? value) {
                      setState(() {});
                      isSwitch = value ?? false;
                      print(value);
                      print(isSwitch);
                    },
                  ),
                  SwitchListTile(
                    value: isSwitch,
                    title: Text("Aktifkan Mode Gelap"),
                    activeThumbColor: Colors.red,
                    onChanged: (bool? value) {
                      setState(() {});
                      isSwitch = value ?? false;
                      print(value);
                      print(isSwitch);
                    },
                  ),
                  Text(isSwitch ? "Mode Terang" : "Mode Gelap"),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
