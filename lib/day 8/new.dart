import 'package:flutter/material.dart';

class Tugas3 extends StatelessWidget {
  const Tugas3({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // 1. Header (AppBar)
      appBar: AppBar(
        title: Text("GrowBiz App"),
        centerTitle: true,
      ),

      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              // 2. Identitas Utama
              Center(
                child: Column(
                  children: [

                    CircleAvatar(
                      radius: 50,
                      backgroundColor: const Color.fromARGB(255, 161, 170, 177),
                      child: Icon(
                        Icons.person,
                        size: 50,
                        color: Colors.white,
                      ),
                    ),

                    SizedBox(height: 12),

                    Text(
                      "Ranssky",
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    Text(
                      "Pebisnis Handal",
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.grey,
                      ),
                    ),

                  ],
                ),
              ),

              SizedBox(height: 30),

              // 3. Detail Kontak
              Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 104, 108, 111),
                  borderRadius: BorderRadius.circular(12),
                ),

                child: Column(
                  children: [

                    Row(
                      children: [

                        Icon(Icons.email, color: const Color.fromARGB(255, 54, 56, 57)),

                        SizedBox(width: 10),

                        Text(
                          "raniaananda1410@gmail.com",
                          style: TextStyle(fontSize: 16),
                        ),

                      ],
                    ),

                    SizedBox(height: 15),

                    Row(
                      children: [

                        Icon(Icons.badge, color: const Color.fromARGB(255, 54, 56, 57)),

                        SizedBox(width: 10),

                        Text(
                          "ID: RAN1410",
                          style: TextStyle(fontSize: 16),
                        ),

                      ],
                    ),

                  ],
                ),
              ),

              SizedBox(height: 25),

              // 4. Informasi Pendukung
              Row(
                children: [

                  Icon(Icons.phone, color: const Color.fromARGB(255, 54, 56, 57)),

                  SizedBox(width: 8),

                  Text("0812-1961-9181"),

                  Spacer(),

                  Icon(Icons.location_on, color: Colors.red),

                  SizedBox(width: 8),

                  Text("Jakarta"),

                ],
              ),

              SizedBox(height: 30),

              // 5. Statistik Horizontal
              Row(
                children: [

                  Expanded(
                    child: Container(
                      padding: EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 54, 56, 57),
                        borderRadius: BorderRadius.circular(12),
                      ),

                      child: Column(
                        children: [

                          Text(
                            "120",
                            style: TextStyle(
                              fontSize: 24,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),

                          SizedBox(height: 8),

                          Text(
                            "Produk",
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),

                        ],
                      ),
                    ),
                  ),

                  SizedBox(width: 16),

                  Expanded(
                    child: Container(
                      padding: EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 54, 56, 57),
                        borderRadius: BorderRadius.circular(12),
                      ),

                      child: Column(
                        children: [

                          Text(
                            "15",
                            style: TextStyle(
                              fontSize: 24,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),

                          SizedBox(height: 8),

                          Text(
                            "Detail Produk",
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),

                        ],
                      ),
                    ),
                  ),

                ],
              ),

              SizedBox(height: 30),

              // 6. Deskripsi Naratif
              Padding(
                padding: const EdgeInsets.all(8.0),

                child: Text(
                  "GrowBiz App adalah aplikasi monitoring pertumbuhan bisnis yang membantu UMKM dan startup dalam menganalisis perkembangan penjualan, pelanggan, serta performa usaha secara real-time.",
                  style: TextStyle(
                    fontSize: 16,
                    height: 1.5,
                  ),
                ),
              ),

              SizedBox(height: 30),

              // 7. Visual Branding
              Container(
                height: 180,
                width: double.infinity,

                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  image: DecorationImage(
                    image: NetworkImage(
                      "https://picsum.photos/500/300",
                    ),
                    fit: BoxFit.cover,
                  ),
                ),
              ),

            ],
          ),
        ),
      ),
    );
  }
}