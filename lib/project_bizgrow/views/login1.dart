import 'package:flutter/material.dart';

class Pagelogin extends StatefulWidget {
  const Pagelogin({super.key});

  @override
  State<Pagelogin> createState() => _PageloginState();
}

class _PageloginState extends State<Pagelogin> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Icon(Icons.auto_graph),
            Icon(Icons.notifications_none),
            Text("BizGrow", style: TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
        backgroundColor: const Color.fromARGB(255, 255, 255, 255),
        centerTitle: true,
      ),
    );
  }
}
