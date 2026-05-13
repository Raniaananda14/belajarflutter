import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Flutter3 extends StatelessWidget {
  const Flutter3({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text(
            style: TextStyle(fontWeight: FontWeight.bold),
            "Registrasi & Katalog"
            ),
        ),
        backgroundColor: const Color.fromARGB(255, 78, 107, 136),
      ),
      body: Padding(
        padding: EdgeInsets.all(8),
        child: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 10,
            children: [
              Text(
                "Nama",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
          
              TextField(
                decoration: InputDecoration(
                  hintText: "Nama Lengkap",
                  filled: true,
                  fillColor: const Color.fromARGB(255, 169, 169, 169),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
          
              Text(
                "No Telpon",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
          
              TextField(
                decoration: InputDecoration(
                  hintText: "Masukan No Telp Aktif",
                  filled: true,
                  fillColor: const Color.fromARGB(255, 169, 169, 169),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
          
               Text(
                "Email",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
          
              TextField(
                decoration: InputDecoration(
                  hintText: "Masukan Email Aktif",
                  filled: true,
                  fillColor: const Color.fromARGB(255, 169, 169, 169),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
          
               Text(
                "Password",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
          
              TextField(
                decoration: InputDecoration(
                  hintText: "Password",
                  prefixIcon: Icon(Icons.key),
                  filled: true,
                  fillColor: const Color.fromARGB(255, 255, 255, 255),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
          
              Text(
                "Konfirmasi Password",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
          
              TextField(
                decoration: InputDecoration(
                  hintText: "Masukan kembali Passwordmu",
                  prefixIcon: Icon(Icons.visibility),
                  filled: true,
                  fillColor: const Color.fromARGB(255, 255, 255, 255),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              
              // Katalog
              Column(
                children: [
                  Text(
                    "Which one are you?",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  SizedBox(height: 10),

                  GridView.count(
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    crossAxisCount: 3,
                    mainAxisExtent: 25,
                    crossAxisSpacing: 10,
                    children: [
                      aboutYou("1.jpg", "cynical"),
                      aboutYou("2.webp", "angry"),
                      aboutYou("3.jpg", "startled"),
                      aboutYou("4.jpg", "spoiled"),
                      aboutYou("5.jpg", "ponder"),
                      aboutYou("6.webp", "laugh"),
                    ],
                  )
                ],
              )
            ]
          ),
        ),
      )
    );
  }
}

Stack aboutYou(String namaImg, String textLabel){
  return Stack(
    alignment: AlignmentGeometry.bottomCenter, clipBehavior: Clip.none,
    children: [
      SizedBox(
        height: double.infinity,
        width: double.infinity,

        child: ClipRRect(
          borderRadius: BorderRadiusGeometry.circular(14),
          child: 
          Image.asset("assets/images/$namaImg", fit: BoxFit.cover),
        ),
      ),
      Positioned(
        bottom: -14,
        child: Container(
          padding: EdgeInsets.all(6),
          width: 78,
          decoration: BoxDecoration(
            color: Colors.grey,
            borderRadius: BorderRadius.circular(8),
          ),

          child: Text(
            textLabel,
            style: TextStyle(color: CupertinoColors.secondarySystemGroupedBackground),
            textAlign: TextAlign.center,
          ),
        ),
      )
    ],
  );
}