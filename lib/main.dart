// ignore_for_file: avoid_print, use
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todoapp/constants/routes.dart';
import 'package:todoapp/helpers/loading/loading_screen.dart';
import 'package:todoapp/services/auth/bloc/auth_bloc.dart';
import 'package:todoapp/services/auth/bloc/auth_event.dart';
import 'package:todoapp/services/auth/bloc/auth_state.dart';
import 'package:todoapp/services/auth/firebase_auth_provider.dart';
import 'package:todoapp/views/forgot_password_view.dart';
import 'package:todoapp/views/login_view.dart';
import 'package:todoapp/views/notes/create_update_note_view.dart';
import 'package:todoapp/views/notes/note_view.dart';
import 'package:todoapp/views/registration_view.dart';
import 'package:todoapp/views/verifyEmailView.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ToDo firstICTEMoS',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blueGrey,
      ),
      home: BlocProvider<AuthBloc>(
        create: (context) => AuthBloc(FirebaseAuthProvider()),
        child: const HomePage(),
      ),
      routes: {
        createOrUpdateNoteRoute: (context) => const CreateUpdateNoteView(),
      },
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    context.read<AuthBloc>().add(const AuthEventInitialize());
    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state.isLoading) {
          LoadingScreen().show(
              context: context, text: state.laodingText ?? 'Please wait ...');
        } else {
          LoadingScreen().hide();
        }
      },
      builder: (context, state) {
        if (state is AuthStateLoggedIn) {
          return const NotesView();
        } else if (state is AuthStateLoggedOut) {
          return const LoginView(title: '');
        } else if (state is AuthStateNeedsVerification) {
          return const VerifyEmailView();
        } else if (state is AuthStateRegistering) {
          return const RegisterView();
        } else if (state is AuthStateForgetPassword) {
          return const ForgotPassWordView();
        } else {
          return const Scaffold(
              body: Center(
            child: CircularProgressIndicator(),
          ));
        }
      },
    );
  }
}
