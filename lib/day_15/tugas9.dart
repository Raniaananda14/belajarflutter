import 'package:flutter/material.dart';
import 'package:flutter_application_1/data/dara_ran.dart';
import 'package:flutter_application_1/data/data2_ran.dart';
import 'package:flutter_application_1/data/data3_ran.dart';

class Tugas9 extends StatefulWidget {
  const Tugas9({super.key});

  @override
  State<Tugas9> createState() => _Tugas9State();
}

class _Tugas9State extends State<Tugas9> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Icon(Icons.auto_graph),
            SizedBox(width: 8),
            Text("BizGrow", style: TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
        backgroundColor: const Color.fromARGB(255, 255, 255, 255),
        centerTitle: true,
        // actions: const [Icon(Icons.auto_graph)],
      ),
      body: ListView(
        children: [
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Categories",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 32,
                      ),
                    ),
                    Text(
                      "Manage your UMKM store inventory by selecting a product category.",
                      style: TextStyle(fontSize: 16),
                    ),
                    const SizedBox(height: 24),

                    Container(
                      padding: EdgeInsets.all(12),
                      height: 64,
                      decoration: BoxDecoration(
                        border: Border.all(width: 1, color: Colors.grey),
                        color: Color(0xffF3F3F3),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.search),
                          const SizedBox(width: 15),
                          Text("Search Categories..."),
                        ],
                      ),
                    ),

                    const SizedBox(height: 24),

                    GridView.builder(
                      shrinkWrap: true,

                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 12,
                            mainAxisSpacing: 12,
                            childAspectRatio: 2.9,
                          ),

                      itemCount: kategoriBizGrow.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Container(
                          padding: EdgeInsets.all(20),
                          // width: double.infinity,
                          height: 200,
                          decoration: BoxDecoration(
                            border: Border.all(width: 1, color: Colors.grey),
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(24),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                kategoriBizGrow[index],
                                style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              Icon(Icons.arrow_forward_ios_outlined),
                            ],
                          ),
                        );
                      },
                    ),
                    Padding(
                      padding: const EdgeInsetsGeometry.all(10),
                      child: SizedBox(
                        width: double.infinity,
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Premium Growth Tools",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 23,
                                  ),
                                ),

                                Container(
                                  padding: EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    color: Colors.black,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Text(
                                    "ENTERPRISE",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                              ],
                            ),

                            SizedBox(height: 10),

                            ListView.builder(
                              shrinkWrap: true,
                              itemCount: fiturBizGrow.length,
                              itemBuilder: (BuildContext context, int index) {
                                return Container(
                                  padding: EdgeInsets.all(12),
                                  margin: EdgeInsets.only(bottom: 12),
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      width: 1,
                                      color: Colors.grey,
                                    ),
                                    color: Color(0xffF3F3F3),
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  child: Row(
                                    children: [
                                      Container(
                                        width: 48,
                                        height: 48,
                                        decoration: BoxDecoration(
                                          color: Colors.grey,
                                          borderRadius: BorderRadius.circular(
                                            12,
                                          ),
                                        ),
                                        child: Icon(
                                          fiturBizGrow[index]["ikon"],
                                        ),
                                      ),
                                      SizedBox(width: 12),
                                      Row(
                                        children: [
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                fiturBizGrow[index]["nama"],
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),

                                              Text(
                                                "Centralize operations & workflows",
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    ),

                    Column(
                      children: [
                        Text(
                          "Premium Selection",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 42,
                          ),
                        ),

                        Text(
                          "Curated excellence for the modern entrepreneur. A collection of 10 handcrafted essentials.",
                          style: TextStyle(fontSize: 14),
                        ),
                        const SizedBox(height: 10),
                      ],
                    ),

                    const SizedBox(height: 5),

                    ListView.builder(
                      shrinkWrap: true,
                      itemCount: listBizGrow.length,
                      itemBuilder: (BuildContext context, int index) {
                        final barang = listBizGrow[index];
                        return Container(
                          color: Colors.grey,
                          child: Column(
                            children: [
                              Container(
                                padding: EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              Text(barang.nama, style: TextStyle(fontSize: 30)),
                              Image.asset(barang.gambar),
                              Text(barang.deskripsi),
                            ],
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
