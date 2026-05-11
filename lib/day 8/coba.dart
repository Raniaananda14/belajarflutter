import 'package:flutter/material.dart';

class Tugas2 extends StatelessWidget {
  const Tugas2({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 100,
        title: Text("Wellcome BizGrow App"),
        backgroundColor: const Color.fromARGB(255, 237, 237, 237)),
      body: Column(
        children: [
          Container(
            width: 200,
            height: 200,
            decoration: BoxDecoration(

            ),
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            spacing: 8,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  "Kelola Bisnis anda dengan Mudah",
                  style: TextStyle(color: const Color.fromARGB(255, 0, 0, 0), fontSize: 14)
                ),
              ),
               Text(
              "Selanjutnya",
              style: TextStyle(
                fontSize: 14,
                color: const Color.fromARGB(255, 48, 48, 48),
                fontWeight: FontWeight.bold,
                fontStyle: FontStyle.italic,
                decoration: TextDecoration.underline,
              ),
            ),
              Text("Selanjutnya"),
              Text("Lewati"),
            ],
          ),
           Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              spacing: 2,
              children: [
                Text("No balance"),
                Text("Pay"),
                Text("Top Up"),
                Text("Explor"),
              ],
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              spacing: 4,
              children: [
                Text("Little balance"),
                Text("Buy"),
                Text("Top Up"),
                Text("Explor"),
              ],
            ),
        ],
      ),
    );
  }
}