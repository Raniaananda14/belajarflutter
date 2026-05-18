import 'package:flutter/material.dart';

class StateDay12 extends StatefulWidget {
  const StateDay12({super.key});

  @override
  State<StateDay12> createState() => _StateDay12State();
}

class _StateDay12State extends State<StateDay12> {
  int nilaiCounter = 0;
  bool like = false;
  bool showImage = false;
  @override
  Widget build(BuildContext context) {
    print("Mengulang");
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        onPressed: () {},

        child: Icon(Icons.qr_code),
      ),
      appBar: AppBar(
        title: Text("State Day 12"),
        actions: [
          IconButton(
            onPressed: () {
              setState(() {
                showImage = !showImage;
              });
            },
            icon: Icon(Icons.menu),
          ),
        ],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // stateDinamis(),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
            onPressed: () {
              setState(() {
                showImage = !showImage;
              });
            },
            child: Text(
              showImage ? "Sembunyikan Gambar" : "Tampilkan Gambar",
              style: TextStyle(color: Colors.white),
            ),
          ),

          IconButton(
            onPressed: () {
              setState(() {
                showImage = !showImage;
              });
            },
            icon: Icon(Icons.menu),
          ),

          TextButton(
            onPressed: () {
              setState(() {
                showImage = !showImage;
              });
            },
            child: Text("Daftar"),
          ),

          InkWell(
            splashColor: Colors.red,
            onTap: () {
              print("Tekan kucing");
            },
            onLongPress: () {
              print("Tekan kucing agak lama");
            },

            onDoubleTap: () {
              print("Tekan kucing dua kali");
            },
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Image.asset("assets/images/kucing_4.jpg", height: 200),
            ),
          ),

          GestureDetector(
            onTap: () {
              print("Tekan kucing");
            },
            onLongPress: () {
              print("Tekan kucing agak lama");
            },

            onDoubleTap: () {
              print("Tekan kucing dua kali");
            },
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Image.asset("assets/images/kucing_5.avif", height: 200),
            ),
          ),
        ],
      ),
    );
  }

  Column stateDinamis() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [Text("$nilaiCounter", style: TextStyle(fontSize: 40))],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
              onPressed: () {
                nilaiCounter--;
                setState(() {});
                print("Nilai saat ini adalah : $nilaiCounter");
              },
              icon: Icon(Icons.minimize),
            ),
            IconButton(
              onPressed: () {
                nilaiCounter++;
                setState(() {});
                print("Nilai saat ini adalah : $nilaiCounter");
              },
              icon: Icon(Icons.add),
            ),
          ],
        ),
        Text(
          like ? "Suka" : "Tidak Suka",
          style: TextStyle(
            fontSize: 50,
            color: like ? Colors.red : Colors.black,
          ),
        ),
        IconButton(
          onPressed: () {
            setState(() {
              like = !like;
            });
          },
          icon: Icon(
            Icons.favorite,
            size: 50,
            color: like ? Colors.red : Colors.black,
          ),
        ),

        showImage
            ? Image.asset("assets/images/kucing_3.jpeg", height: 200)
            : Container(height: 200),
        IconButton(
          onPressed: () {
            setState(() {
              showImage = !showImage;
            });
          },
          icon: Icon(showImage ? Icons.visibility_off : Icons.visibility),
        ),
      ],
    );
  }
}
