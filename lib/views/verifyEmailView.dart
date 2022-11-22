// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:todoapp/constants/routes.dart';
import 'package:todoapp/services/auth/auth_service.dart';
import 'package:todoapp/services/auth/bloc/auth_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todoapp/services/auth/bloc/auth_event.dart';

class VerifyEmailView extends StatefulWidget {
  const VerifyEmailView({Key? key}) : super(key: key);

  @override
  State<VerifyEmailView> createState() => _VerifyEmailViewState();
}

class _VerifyEmailViewState extends State<VerifyEmailView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Verify your email')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: const [
                Text(
                    'A link has been sent to your email, go and click on it...\n If you didn\'t receive any email , click here down!'),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                TextButton(
                  onPressed: () {
                    context
                        .read<AuthBloc>()
                        .add(const AuthEventSendEmailVerification());
                  },
                  child: Row(
                    // Replace with a Row for horizontal icon + text
                    children: const <Widget>[
                      Icon(Icons.save),
                      Text('Resend link'),
                    ],
                  ),
                ),
                TextButton(
                  onPressed: () {
                    // /  await AuthService.firebase().logOut();
                    // Navigator.of(context).pushNamedAndRemoveUntil(
                    //   registerRoute,
                    //   (route) => false
                    //   );
                    context.read<AuthBloc>().add(const AuthEventLogOut());
                  },
                  child: Row(
                    // Replace with a Row for horizontal icon + text
                    children: const <Widget>[
                      Text('Login'),
                      Icon(Icons.login),
                    ],
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
