import 'package:app2/read%20data/get_user_name.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final user = FirebaseAuth.instance.currentUser!;

  // document IDs
  List<String> docIDs = [];

  // get docIDs
  Future getDocID() async {
    docIDs.clear();
    await FirebaseFirestore.instance.collection('users').get().then(
          (snapshot) => snapshot.docs.forEach((document) {
            print(document.reference);
            docIDs.add(document.reference.id);
          }),
        );
  }

  // @override
  // void initState() {
  //   getDocID();
  //   super.initState();
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(user.email!, style: TextStyle(fontSize: 16)),
        backgroundColor: Colors.blue[300],
      ),
      body: Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            height: 15,
          ),
          Expanded(
            child: FutureBuilder(
              future: getDocID(),
              builder: (context, snapshot) {
                return ListView.builder(
                  itemCount: docIDs.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ListTile(
                        tileColor: Colors.cyan[100],
                        title: GetUserName(documentId: docIDs[index]),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                      ),
                    );
                  },
                );
              },
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue[800],
                elevation: 10,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30))),
            child: const Text(
              "Sign out",
              style: TextStyle(color: Colors.black, fontSize: 14),
            ),
            onPressed: () {
              FirebaseAuth.instance.signOut();
            },
          ),
          SizedBox(
            height: 30,
          ),
        ],
      )),
    );
  }
}
