import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:pokemate/models/user.dart';

@immutable
abstract class AppState extends Equatable {
  const AppState([List props = const []]) : super();
}

class Uninitialized extends AppState {
  final UserData userData;

  const Uninitialized({required this.userData});

  @override
  String toString() => 'Uninitialized';

  @override
  List<Object?> get props => [toString()];
}

class Unauthenticated extends AppState {
  final UserData userData;

  const Unauthenticated({required this.userData});

  @override
  String toString() => 'Unauthenticated';

  @override
  List<Object?> get props => [toString()];
}

class Authenticated extends AppState {
  final UserData userData;

  const Authenticated({required this.userData});

  @override
  String toString() => 'Authenticated';

  @override
  List<Object?> get props => [toString()];
}

class ErrorOccurred extends AppState {
  final String error;

  const ErrorOccurred({required this.error});

  @override
  String toString() => 'ErrorOccurred';

  @override
  List<Object?> get props => [toString()];
}

class LoginPageStates extends AppState {
  final String message;

  const LoginPageStates({required this.message});

  static LoginPageStates loading = const LoginPageStates(message: 'Loading');

  static LoginPageStates success = const LoginPageStates(message: 'Successful');

  static LoginPageStates noUserFound =
      const LoginPageStates(message: 'No user found for that email');

  static LoginPageStates wrongPassword =
      const LoginPageStates(message: 'Wrong Password provided for that user');

  static LoginPageStates somethingWentWrong =
      const LoginPageStates(message: 'Something went wrong, Please try again');

  @override
  List<Object?> get props => [message];
}

class SignupPageStates extends AppState {
  final String message;

  const SignupPageStates({required this.message});

  static SignupPageStates loading = const SignupPageStates(message: 'Loading');

  static SignupPageStates success = const SignupPageStates(message: 'Successful');

  static SignupPageStates userAlreadyExists =
      const SignupPageStates(message: 'Email is already in use');

  static SignupPageStates somethingWentWrong =
      const SignupPageStates(message: 'Something went wrong, Please try again');

  @override
  List<Object?> get props => [message];
}
