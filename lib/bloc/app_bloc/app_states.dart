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

class LoginState extends AppState {
  final String message;

  const LoginState({required this.message});

  static LoginState loading = const LoginState(message: 'Loading');

  static LoginState success = const LoginState(message: 'Successful');

  static LoginState noUserFound =
      const LoginState(message: 'No user found for that email');

  static LoginState wrongPassword =
      const LoginState(message: 'Wrong Password provided for that user');

  static LoginState somethingWentWrong =
      const LoginState(message: 'Something went wrong, Please try again');

  @override
  List<Object?> get props => [message];
}

class SignupState extends AppState {
  final String message;

  const SignupState({required this.message});

  static SignupState loading = const SignupState(message: 'Loading');

  static SignupState success = const SignupState(message: 'Successful');

  static SignupState userAlreadyExists =
      const SignupState(message: 'Email is already in use');

  static SignupState somethingWentWrong =
      const SignupState(message: 'Something went wrong, Please try again');

  @override
  List<Object?> get props => [message];
}
