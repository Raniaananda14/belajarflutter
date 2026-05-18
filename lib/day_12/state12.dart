import 'package:flutter/material.dart';

class State12 extends StatefulWidget {
  const State12({super.key});

  @override
  State<State12> createState() => _State12State();
}

class _State12State extends State<State12> {
  int counter = 5;
  bool like = false;
  bool showSecret = false;
  bool favorite = false;
  bool showInfo = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.teal,
        onPressed: () {
          setState(() {
            counter--;
          });
        },
        child: const Icon(Icons.remove),
      ),
      appBar: AppBar(
        title: Text("Wellcome to App"),
        backgroundColor: const Color.fromARGB(255, 137, 130, 128),
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              setState(() {});
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundImage: AssetImage("assets/images/wowjok.jpg"),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 10),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  setState(() {
                    showSecret = !showSecret;
                  });
                },
                child: const Text("Pop Up Post"),
              ),
            ),

            const SizedBox(height: 5),
            Center(
              child: Text(showSecret ? "Ada yang bisa admin bantu kak?" : ""),
            ),

            const SizedBox(height: 5),
            Center(
              child: const Text(
                "Like, darling",
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
              ),
            ),

            const SizedBox(height: 10),
            TextButton(
              onPressed: () {
                setState(() {
                  showInfo = !showInfo;
                });
              },
              child: Text("Klik Here"),
            ),
            Text(
              showInfo
                  ? "Welcome back to my app, if you need me, just press the like button."
                  : "",
            ),

            InkWell(
              onTap: () {
                print("Klik");
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(const SnackBar(content: Text("Hlloww Guys")));
              },

              child: Column(
                children: [
                  Container(
                    height: 150,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage("assets/images/9.jpg"),
                        fit: BoxFit.cover,
                      ),
                      color: Colors.yellowAccent,
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),

                  const SizedBox(height: 15),
                  Container(
                    height: 150,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage("assets/images/13.jpg"),
                        fit: BoxFit.cover,
                      ),
                      color: Colors.yellowAccent,
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),

                  const SizedBox(height: 15),
                  Container(
                    height: 150,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage("assets/images/10.jpg"),
                        fit: BoxFit.cover,
                      ),
                      color: Colors.yellowAccent,
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: 1),

            const SizedBox(height: 10),
            Row(
              children: [
                IconButton(
                  onPressed: () {
                    setState(() {
                      favorite = !favorite;
                    });
                  },
                  icon: Icon(
                    Icons.favorite,
                    color: favorite
                        ? Colors.pinkAccent
                        : const Color.fromARGB(31, 87, 87, 87),
                    size: 55,
                  ),
                ),

                Text(
                  favorite ? "Like" : "Dislike",
                  style: const TextStyle(fontSize: 15),
                ),
              ],
            ),

            GestureDetector(
              onTap: () {
                setState(() {
                  counter += 1;
                });

                print("Tekan Sekali");
              },

              onDoubleTap: () {
                setState(() {
                  counter += 1;
                });
              },

              onLongPress: () {
                setState(() {
                  counter += 1;
                });
                print("Tekan lama");
              },

              child: Container(
                height: 50,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.lightBlueAccent,
                  borderRadius: BorderRadius.circular(17),
                ),

                child: Center(
                  child: Text(
                    "Counter : $counter",
                    style: const TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
