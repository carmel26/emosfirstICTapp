import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart' show immutable;

import '../auth_user.dart';

@immutable
abstract class AuthState {
  final bool isLoading;
  final String? laodingText;
  const AuthState({
    required this.isLoading,
    this.laodingText = 'Please wait...!',
  });
}

// class AuthStateLoading extends AuthState {
//    const AuthStateLoading();
// }

class AuthStateInitialized extends AuthState {
  const AuthStateInitialized({required bool isLoading})
      : super(isLoading: isLoading);
}

class AuthStateRegistering extends AuthState {
  final Exception? exception;
  const AuthStateRegistering({required this.exception, required bool isLoading})
      : super(isLoading: isLoading);
}

class AuthStateLoggedIn extends AuthState {
  final AuthUser user;

  const AuthStateLoggedIn({required this.user, required bool isLoading})
      : super(isLoading: isLoading);
}

// need verfication
class AuthStateNeedsVerification extends AuthState {
  const AuthStateNeedsVerification({required bool isLoading})
      : super(isLoading: isLoading);
}

// work on logout
class AuthStateLoggedOut extends AuthState with EquatableMixin {
  final Exception? exception;
  const AuthStateLoggedOut(
      {required this.exception, required bool isLoading, String? laodingText})
      : super(isLoading: isLoading, laodingText: laodingText);

  @override
  List<Object?> get props => [exception, isLoading];
}

// work on forget password
class AuthStateForgetPassword extends AuthState {
  final Exception? exception;
  final bool hasSendEmail;

  const AuthStateForgetPassword(
      {required this.exception,
      required this.hasSendEmail,
      required bool isLoading})
      : super(isLoading: isLoading);
}
