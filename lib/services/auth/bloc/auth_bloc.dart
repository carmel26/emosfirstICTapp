import 'package:bloc/bloc.dart';
import 'package:todoapp/services/auth/auth_provider.dart';
import 'package:todoapp/services/auth/bloc/auth_event.dart';
import 'package:todoapp/services/auth/bloc/auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc(AuthProvider provider)
      : super(const AuthStateInitialized(isLoading: true)) {
    //  send email verification
    on<AuthEventSendEmailVerification>(
      (event, emit) async {
        await provider.sendEmailVerification();
        emit(state);
      },
    );

    // on auth event register
    on<AuthEventRegister>(
      (event, emit) async {
        final email = event.email;
        final password = event.password;
        emit(const AuthStateNeedsVerification(isLoading: true));
        try {
          final user = await provider.createUser(
            email: email,
            password: password,
          );
          if (!user.isEmailVerified) {
            await provider.sendEmailVerification();
            emit(const AuthStateNeedsVerification(isLoading: false));
          } else {
            emit(const AuthStateNeedsVerification(isLoading: false));
          }
          print("Okayyy");
        } on Exception catch (e) {
          emit(AuthStateRegistering(exception: e, isLoading: false));
        }
      },
    );

    // initialize
    on<AuthEventInitialize>((event, emit) async {
      await provider.initializeApplication();
      final user = provider.currentUser;
      if (user == null) {
        emit(const AuthStateLoggedOut(
          exception: null,
          isLoading: false,
        ));
      } else if (!user.isEmailVerified) {
        emit(const AuthStateNeedsVerification(isLoading: false));
      } else {
        emit(AuthStateLoggedIn(user: user, isLoading: false));
      }
    });

    on<AuthEventShouldRegister>(
      (event, emit) {
        emit(const AuthStateRegistering(exception: null, isLoading: false));
      },
    );

    // login
    on<AuthEventLogIn>((event, emit) async {
      emit(const AuthStateLoggedOut(
          exception: null,
          isLoading: true,
          laodingText: 'Please wait until you get access on your data...'));

      final email = event.email;
      final password = event.password;

      try {
        final user = await provider.logIn(email: email, password: password);
        // check if email address is verified

        if (!user.isEmailVerified) {
          emit(const AuthStateLoggedOut(exception: null, isLoading: false));
          emit(const AuthStateNeedsVerification(isLoading: false));
        } else {
          emit(const AuthStateLoggedOut(exception: null, isLoading: false));
          emit(AuthStateLoggedIn(user: user, isLoading: false));
        }
      } on Exception catch (e) {
        emit(AuthStateLoggedOut(exception: e, isLoading: false));
      }
    });
    // logout
    on<AuthEventLogOut>(
      (event, emit) async {
        try {
          await provider.logOut();
          emit(const AuthStateLoggedOut(exception: null, isLoading: false));
        } on Exception catch (e) {
          emit(AuthStateLoggedOut(exception: e, isLoading: false));
        }
      },
    );

    on<AuthEventForgetPassword>(
      (event, emit) async {
        emit(const AuthStateForgetPassword(
            exception: null, hasSendEmail: false, isLoading: false));
        final email = event.email;
        if (email == null) {
          return; //user want just to go to forget-password screen
        }

        // user want to actually send a forget password email
        emit(const AuthStateForgetPassword(
            exception: null, hasSendEmail: false, isLoading: false));

        bool didSendEmail;
        Exception? exception;
        try {
          await provider.sendPasswordReset(toEmail: email);
          didSendEmail = true;
          exception = null;
        } on Exception catch (e) {
          didSendEmail = false;
          exception = e;
        }

        emit(AuthStateForgetPassword(
            exception: exception,
            hasSendEmail: didSendEmail,
            isLoading: false));
      },
    );
  }
}
