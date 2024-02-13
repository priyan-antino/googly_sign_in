import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:googly_sign_in/view/chat/chat_screen.dart';

class AllUsers extends ConsumerStatefulWidget {
  const AllUsers({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _AllUsersState();
}

class _AllUsersState extends ConsumerState<AllUsers> {
  FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Available Users'),
        backgroundColor: Colors.blueGrey,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Center(
          child: StreamBuilder(
            stream: FirebaseFirestore.instance.collection('Users').snapshots(),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return Center(
                    child: Text('Some error occured ${snapshot.error} '));
              }
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
              return ListView.builder(
                itemCount: snapshot.data?.docs.length,
                itemBuilder: (context, index) {
                  return Center(
                    child: GestureDetector(
                        onTap: () {
                          Navigator.push(context, MaterialPageRoute(
                            builder: (context) {
                              return ChatScreen(
                                  receiverId: snapshot.data?.docs[index]
                                      ['uid']);
                            },
                          ));
                        },
                        child: ListTile(
                          contentPadding: const EdgeInsets.all(5),
                          leading: const Icon(Icons.person),
                          title: snapshot.data?.docs[index]['email'] != null &&
                                  snapshot.data?.docs[index]['email'] !=
                                      _auth.currentUser?.email
                              ? Text(snapshot.data?.docs[index]['email'])
                              : const Text("Self"),
                        )

                        //  Container(
                        //   height: 60,
                        //   width: 200,
                        //   color: Colors.grey,
                        //   child: Center(
                        //     child: Text(snapshot.data?.docs[index]['email'] ??
                        //         'null val received'),
                        //   ),
                        // ),
                        ),
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }
}
