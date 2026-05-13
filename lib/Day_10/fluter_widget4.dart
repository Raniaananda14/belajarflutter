import 'package:flutter/material.dart';

class Profile5 extends StatelessWidget {
  const Profile5({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text("List Of Participants")),
        backgroundColor: const Color.fromARGB(255, 202, 118, 118),
      ),
      body: ListView(
        physics: BouncingScrollPhysics(),
        children: [
          Container(
            margin: EdgeInsets.all(12),
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: const Color.fromARGB(255, 202, 118, 118),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              children: [
                Center(
                  child: Text("Personal Data", style: TextStyle(fontSize: 20)),
                ),
                SizedBox(height: 20),

                TextField(
                  decoration: InputDecoration(
                    labelText: "Name",
                    hintText: "Full Name",
                    filled: true,
                    fillColor: Colors.grey[300],
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
                SizedBox(height: 5),
                TextField(
                  decoration: InputDecoration(
                    labelText: "Email",
                    hintText: "Enter Email",
                    filled: true,
                    fillColor: Colors.grey[300],
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
                SizedBox(height: 5),
                TextField(
                  decoration: InputDecoration(
                    labelText: "Phone Number",
                    hintText: "Enter Nomplete Telphone Number",
                    filled: true,
                    fillColor: Colors.grey[300],
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
                SizedBox(height: 5),
                TextField(
                  decoration: InputDecoration(
                    labelText: "Address",
                    hintText: "Complete Address",
                    filled: true,
                    fillColor: Colors.grey[300],
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
                SizedBox(height: 5),
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.all(12),
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: const Color.fromARGB(255, 82, 177, 192),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              children: [
                Center(
                  child: Text(
                    "List Participants ",
                    style: TextStyle(fontSize: 20),
                  ),
                ),
                ListView.builder(
                  shrinkWrap: true,
                  itemCount: kontak.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      leading: SizedBox(
                        height: double.infinity,
                        width: 80,

                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image.asset(
                            "assets/images/${kontak[index]["images"]}",
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      title: Text(kontak[index]["nama"]!),
                      subtitle: Text(kontak[index]["telp"]!),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

final List<Map<String, String>> kontak = [
  {"nama": "Ranski", "telp": "084976197645", "images": "wowjok.jpg"},
  {"nama": "Ana", "telp": "088643791527", "images": "10.jpg"},
  {"nama": "Retha", "telp": "087619854321", "images": "14.jpg"},
  {"nama": "Difa", "telp": "081679435815", "images": "1.jpg"},
  {"nama": "Alya", "telp": "088648734985", "images": "5.jpg"},
];
