import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:googly_sign_in/features/states/auth_states/auth_status_enum.dart';
import 'package:googly_sign_in/model_view/g_sign_in.dart';
import 'package:googly_sign_in/model_view/providers/auth_provider.dart';
import 'package:googly_sign_in/view/user_screen.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    void printsnackbar() {
      String errorMessage = ref.watch(authProvider).message ?? '';
      var snackBar = SnackBar(
        content: Text('Sign in process failed $errorMessage'),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }

    return Scaffold(body: Consumer(
      builder: (context, ref, child) {
        return Container(
          child: Center(
            child: MaterialButton(
              onPressed: () async {
                await ref.read(authProvider.notifier).startSignIn();
                print('sign in started');
              },
              height: 50,
              minWidth: 100,
              color: Colors.blueAccent,
              child: const Text(
                'Google Signin',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
        );
      },
    ));
  }
}
