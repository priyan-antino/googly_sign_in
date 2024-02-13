import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:googly_sign_in/model_view/providers/auth_provider.dart';
import 'package:googly_sign_in/view/chat/chat_screen.dart';
import 'package:googly_sign_in/view/chat/user_list_screen.dart';

class UserScreen extends StatelessWidget {
  const UserScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Title(color: Colors.black, child: const Text("User Screen")),
      ),
      body: Consumer(
        builder: (context, ref, child) {
          final _userObj = ref.read(authProvider).data;
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Image.network(_userObj.photoUrl),
                const SizedBox(
                  height: 20,
                ),
                Text(_userObj.displayName ?? "user name not found"),
                const SizedBox(
                  height: 20,
                ),
                Text(_userObj.email),
                const SizedBox(
                  height: 20,
                ),
                MaterialButton(
                  onPressed: () {
                    ref.read(authProvider.notifier).startSignOut();
                  },
                  height: 50,
                  minWidth: 100,
                  color: Colors.red,
                  child: const Text(
                    'Logout',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                const SizedBox(
                  height: 40,
                ),
                MaterialButton(
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(
                      builder: (context) {
                        return AllUsers();
                      },
                    ));
                  },
                  height: 50,
                  minWidth: 100,
                  color: Colors.blueGrey,
                  child: const Text(
                    'Chat',
                    style: TextStyle(color: Colors.white),
                  ),
                )
              ],
            ),
          );
        },
      ),
    );
  }
}
