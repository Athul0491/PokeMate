import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pokemate/bloc/app_bloc/app_bloc_files.dart';
import 'package:pokemate/bloc/app_bloc/app_events.dart';
import 'package:pokemate/bloc/app_bloc/app_states.dart';
import 'package:pokemate/models/custom_exceptions.dart';
import 'package:pokemate/models/user.dart';
import 'package:pokemate/repositories/auth_repository.dart';
import 'package:pokemate/repositories/database_repository.dart';

class AppBloc extends Bloc<AppEvent, AppState> {
  final AuthRepository _authRepository;
  late DatabaseRepository _databaseRepository;
  late UserData userData;

  AppBloc({required authRepository})
      : _authRepository = authRepository,
        super(Uninitialized(userData: UserData.empty)) {
    userData = _authRepository.getUserData;
    _databaseRepository = DatabaseRepository(uid: userData.uid);
    on<AppStarted>(_onAppStarted);
    on<LoginUser>(_onLoginUser);
    on<SignupUser>(_onSignupUser);
    on<UpdateUserData>(_onUpdateUserData);
    on<LoggedOut>(_onLoggedOut);
  }

  // When the App Starts
  FutureOr<void> _onAppStarted(AppStarted event, Emitter<AppState> emit) async {
    emit(Uninitialized(userData: UserData.empty));
    try {
      userData = _authRepository.getUserData;
      if (userData != UserData.empty) {
        // Authenticated
        // Update DatabaseRepository
        _databaseRepository = DatabaseRepository(uid: userData.uid);
        // Fetch rest of the user details from database
        UserData completeUserData = await _databaseRepository.completeUserData;
        if (completeUserData != UserData.empty) {
          // if db fetch is successful
          userData = completeUserData;
          emit(Authenticated(userData: userData));
        } else {
          // if db fetch fails
          emit(const ErrorOccurred(error: 'Failed to fetch details!'));
        }
      } else {
        emit(Unauthenticated(userData: userData));
      }
    } on Exception catch (e) {
      // If something goes wrong
      emit(ErrorOccurred(error: e.toString()));
    }
  }

  // When the User Logs in
  FutureOr<void> _onLoginUser(LoginUser event, Emitter<AppState> emit) async {
    emit(LoginState.loading);
    try {
      // Login using email and password
      userData = await _authRepository.logInWithCredentials(
          event.email, event.password);
      // Update DatabaseRepository
      _databaseRepository = DatabaseRepository(uid: userData.uid);
      // After login fetch rest of the user details from database
      UserData completeUserData = await _databaseRepository.completeUserData;
      if (completeUserData != UserData.empty) {
        // if db fetch is successful
        userData = completeUserData;
        emit(Authenticated(userData: userData));
      } else {
        // if db fetch fails
        emit(const ErrorOccurred(error: 'Failed to fetch details!'));
      }
    } on Exception catch (e) {
      if (e is UserNotFoundException) {
        emit(LoginState.noUserFound);
      } else if (e is WrongPasswordException) {
        emit(LoginState.wrongPassword);
      } else {
        emit(LoginState.somethingWentWrong);
      }
    }
  }

  // When the User Signs up
  FutureOr<void> _onSignupUser(SignupUser event, Emitter<AppState> emit) async {
    emit(SignupState.loading);
    try {
      // Signup using email and password
      userData = await _authRepository.signUpUsingCredentials(
          event.email, event.password);
      // Update DatabaseRepository
      _databaseRepository = DatabaseRepository(uid: userData.uid);
      // Add User details to db
      UserData newUserData = UserData(
          uid: userData.uid,
          email: event.email,
          name: event.name,
          age: event.age);
      _databaseRepository.updateUserData(newUserData);
      userData = newUserData;
      emit(Authenticated(userData: userData));
    } on Exception catch (e) {
      if (e is EmailAlreadyInUseException) {
        emit(SignupState.userAlreadyExists);
      } else {
        emit(SignupState.somethingWentWrong);
      }
    }
  }

  FutureOr<void> _onUpdateUserData(
      UpdateUserData event, Emitter<AppState> emit) async {
    emit(Uninitialized(userData: UserData.empty));
  }

  FutureOr<void> _onLoggedOut(LoggedOut event, Emitter<AppState> emit) async {
    emit(Uninitialized(userData: UserData.empty));
  }
}
