// ignore_for_file: avoid_print, use_build_context_synchronously, unused_local_variable

import 'package:flutter/material.dart';
import 'dart:developer' as devtools show log;

import 'package:todoapp/services/auth/auth_exceptions.dart';
import 'package:todoapp/services/auth/bloc/auth_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todoapp/services/auth/bloc/auth_event.dart';
import 'package:todoapp/services/auth/bloc/auth_state.dart';

import '../utilities/dialogs/error_dialog.dart';

class LoginView extends StatefulWidget {
  const LoginView({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
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
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) async {
        if (state is AuthStateLoggedOut) {
          if (state.exception is UserNotFoundAuthException) {
            await showErrorDialog(context, 'Sorry we failed to get your data');
          } else if (state.exception is WrongPasswordAuthException) {
            await showErrorDialog(
                context, 'Sorry you made a mistake in your credentials');
          } else if (state.exception is GenericAuthException) {
            await showErrorDialog(
                context, 'Sorry you fail to enter, try again');
          }
        }
      },
      child: Scaffold(
        appBar: AppBar(title: const Text('ToDo firstICTEMoS')),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                const Text(
                    'Please enter in your account for you to be able to access your informations'),
                TextField(
                  controller: _email,
                  enableSuggestions: false,
                  autocorrect: false,
                  autofocus: true,
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(
                    hintText: 'Enter your email',
                    prefixIcon: Icon(Icons.email),
                    // border: OutlineInputBorder(),
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
                    // border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    TextButton(
                      onPressed: () async {
                        final email = _email.text;
                        final password = _password.text;

                        context.read<AuthBloc>().add(
                              AuthEventLogIn(email, password),
                            );
                        // devtools.log('Sign * In : $userCredential');
                      },
                      child: Row(
                        // Replace with a Row for horizontal icon + text
                        children: const <Widget>[
                          Text('Login'),
                          Icon(Icons.login),
                        ],
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        context
                            .read<AuthBloc>()
                            .add(const AuthEventShouldRegister());
                      },
                      child: Row(
                        // Replace with a Row for horizontal icon + text
                        children: const <Widget>[
                          Text('Register'),
                          Icon(Icons.save),
                        ],
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        context.read<AuthBloc>().add(
                              const AuthEventForgetPassword(),
                            );
                      },
                      child: Row(
                        // Replace with a Row for horizontal icon + text
                        children: const <Widget>[
                          Text('Forget password'),
                          Icon(Icons.question_mark),
                        ],
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
