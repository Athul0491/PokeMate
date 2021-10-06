import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pokemate/models/custom_exceptions.dart';
import 'package:pokemate/models/user.dart';

class DatabaseRepository {
  final String uid;

  DatabaseRepository({required this.uid});

  final FirebaseFirestore db = FirebaseFirestore.instance;

  CollectionReference<UserData> get usersRef =>
      db.collection('users').withConverter<UserData>(
        fromFirestore: (snapshot, _) => UserData.fromJson(snapshot.data()!),
        toFirestore: (user, _) => user.toJson(),
      );

  Future<UserData> get completeUserData async {
    try{
      UserData userDataNew = await usersRef
          .doc(uid)
          .get()
          .then((value) => value.data() ?? UserData.empty);
      return userDataNew;
    } on Exception catch (_) {
      // TODO: If this doesn't work, throw SomethingWentWrong()
      return UserData.empty;
    }
  }

  Future<void> updateUserData(UserData userData) async {
    await usersRef.doc(uid).set(userData);
  }

  Future<void> deleteUser() async {
    await usersRef.doc(uid).delete();
  }
}