// ignore_for_file: avoid_print, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:developer' as devtools show log;

import 'package:todoapp/constants/routes.dart';
import 'package:todoapp/services/auth/auth_exceptions.dart';
import 'package:todoapp/services/auth/auth_service.dart';
import 'package:todoapp/services/auth/bloc/auth_bloc.dart';
import 'package:todoapp/services/auth/bloc/auth_event.dart';
// import 'package:todoapp/services/auth/bloc/auth_event.dart';
import 'package:todoapp/services/auth/bloc/auth_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../utilities/dialogs/error_dialog.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({Key? key}) : super(key: key);

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  late final TextEditingController _email;
  late final TextEditingController _password;

  @override
  void initState() {
    _email = TextEditingController();
    _password = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) async {
        if (state is AuthStateRegistering) {
          if (state.exception is InvalidEmailAuthException) {
            await showErrorDialog(context, 'User not found, please repeat');
          } else if (state is EmailInUseAuthException) {
            await showErrorDialog(context,
                'Your email is in use by another fone... Provide another one!');
          } else if (state is WeakPasswordAuthException) {
            await showErrorDialog(context, 'Easy password, please change it');
          } else if (state is GenericAuthException) {
            await showErrorDialog(context, 'Error during registration');
          }
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text.rich(
            TextSpan(
              children: <InlineSpan>[
                WidgetSpan(
                    child: Icon(Icons.edit,
                        color: Color.fromARGB(255, 255, 255, 255))),
                TextSpan(text: 'Register'),
              ],
            ),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  controller: _email,
                  enableSuggestions: false,
                  autocorrect: false,
                  autofocus: true,
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(
                    hintText: 'Enter your email',
                    prefixIcon: Icon(Icons.email),
                  ),
                ),
                TextField(
                  controller: _password,
                  enableSuggestions: false,
                  autocorrect: false,
                  obscureText: true,
                  decoration: const InputDecoration(
                    hintText: 'Enter your password',
                    prefixIcon: Icon(Icons.password),
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextButton(
                        onPressed: () async {
                          final email = _email.text;
                          final password = _password.text;
                          // Firebase.
                          context
                              .read<AuthBloc>()
                              .add(AuthEventRegister(email, password));

                          // final userCredential = await AuthService.firebase()
                          //     .createUser(email: email, password: password);
                          // AuthService.firebase().sendEmailVerification();
                          // Navigator.of(context).pushNamed(verifyEmailRoute);
                        },
                        child: Row(
                          // Replace with a Row for horizontal icon + text
                          children: const <Widget>[
                            Icon(Icons.save_alt),
                            Text('Register'),
                          ],
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          // Navigator.of(context)
                          //     .pushNamedAndRemoveUntil(loginRoute, (route) => false);
                          context.read<AuthBloc>().add(const AuthEventLogOut());
                        },
                        child: Row(
                          // Replace with a Row for horizontal icon + text
                          children: const <Widget>[
                            Text('Login'),
                            Icon(Icons.login_outlined),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
