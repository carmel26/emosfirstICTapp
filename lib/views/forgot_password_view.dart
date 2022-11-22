// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todoapp/services/auth/bloc/auth_bloc.dart';
import 'package:todoapp/services/auth/bloc/auth_event.dart';
import 'package:todoapp/services/auth/bloc/auth_state.dart';
import 'package:todoapp/utilities/dialogs/error_dialog.dart';

import '../utilities/dialogs/password_reset_email_sent_dialog.dart';

class ForgotPassWordView extends StatefulWidget {
  const ForgotPassWordView({Key? key}) : super(key: key);

  @override
  State<ForgotPassWordView> createState() => _ForgotPassWordViewState();
}

class _ForgotPassWordViewState extends State<ForgotPassWordView> {
  late final TextEditingController _controller;

  @override
  void initState() {
    _controller = TextEditingController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) async {
        if (state is AuthStateForgetPassword) {
          if (state.hasSendEmail) {
            _controller.clear();
            await showPasswordResetSentDialog(context);
          }
          if (state.exception != null) {
            await showErrorDialog(
                context,
                //  'Ntibikunda ko ivyusavye tubitunganya. Banza utohoze ko wiyandikishije neza nkumukoresha. Urarungikigwa link yukuyihindura mukanya'
                'It is not possible to execute your request. You must register first and you will get a link on your email.');
          }
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text.rich(
            TextSpan(
              children: <InlineSpan>[
                WidgetSpan(
                    child: Icon(Icons.question_answer,
                        color: Color.fromARGB(255, 255, 255, 255))),
                TextSpan(text: 'Forget password?'),
              ],
            ),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const Text(
                      // 'Tugira tubatunganirize ariko, Banza utohoze ko wiyandikishije neza nkumukoresha. Urarungikigwa link yukuyihindura mukanya'
                      'Your request is under processing, check if you registered correctly. You will get a link for change you password in few time'),
                  TextField(
                    keyboardType: TextInputType.emailAddress,
                    autocorrect: false,
                    autofocus: true,
                    controller: _controller,
                    decoration: const InputDecoration(
                      hintText: 'Enter your email',
                      prefixIcon: Icon(Icons.email),
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextButton(
                        onPressed: () {
                          final email = _controller.text;
                          context.read<AuthBloc>().add(
                                AuthEventForgetPassword(email: email),
                              );
                        },
                        child: Row(
                          // Replace with a Row for horizontal icon + text
                          children: const <Widget>[
                            Icon(Icons.send_and_archive_sharp),
                            Text('Resend me the link!'),
                          ],
                        ),
                      ),
                      TextButton(
                        onPressed: () {
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
          ),
        ),
      ),
    );
  }
}
