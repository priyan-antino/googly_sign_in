import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:googly_sign_in/features/states/auth_states/auth_status_enum.dart';
import 'package:googly_sign_in/model_view/providers/auth_provider.dart';
import 'package:googly_sign_in/view/home_screen.dart';
import 'package:googly_sign_in/view/user_screen.dart';

class EntryScreen extends ConsumerWidget {
  const EntryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: Consumer(
        builder: (context, ref, child) {
          switch (ref.watch(authProvider).status) {
            case Status.LOADING:
              {
                return const Center(child: CircularProgressIndicator());
              }
            case Status.LOGGEDOUT:
              {
                return const HomeScreen();
              }
            case Status.LOGGEDIN:
              {
                return const UserScreen();
              }
            case Status.SIGNINFAILED:
              {
                print("came to entry scrennnnnnnnnn");
                return const HomeScreen();
              }
            case Status.SIGNOUTFAILED:
              {
                const snackBar = SnackBar(
                  content: Text('Sign out process failed'),
                );
                ScaffoldMessenger.of(context).showSnackBar(snackBar);
                return const UserScreen();
              }
            default:
              {
                String errorMessage =
                    ref.read(authProvider).message?.toString() ?? "";
                return Center(
                    child: Text("something went wrong: $errorMessage "));
              }
          }
        },
      ),
    );
  }
}
