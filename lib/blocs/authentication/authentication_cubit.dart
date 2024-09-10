import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:pre_techwiz/blocs/app_bloc.dart';
import 'package:pre_techwiz/blocs/authentication/authentication_state.dart';
import 'package:pre_techwiz/models/model_user.dart';
import 'package:pre_techwiz/shared/configs/application.dart';
import 'package:pre_techwiz/shared/utilities/common.dart';

class AuthenticationCubit extends Cubit<AuthenticationState> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _database = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  AuthenticationCubit() : super(AuthenticationState.loading);

  Future<void> onCheck() async {
    emit(AuthenticationState.loading);

    User? firebaseUser = _auth.currentUser;

    if (firebaseUser != null) {
      // User is signed in
      UserModel? user = await _getUserFromFirestore(firebaseUser.uid);
      if (user != null) {
        Application.device?.token = await Utils.getDeviceToken();

        await AppBloc.userCubit.onSaveUser(user);

        emit(AuthenticationState.success);
      } else {
        emit(AuthenticationState.fail);
        await onClear();
      }
    } else {
      // User is not signed in
      emit(AuthenticationState.fail);
      await onClear();
    }
  }

  Future<UserModel?> _getUserFromFirestore(String uid) async {
    DocumentSnapshot doc = await _database.collection('users').doc(uid).get();
    if (doc.exists) {
      bool isDisabled = doc.data() is Map
          ? (doc.data() as Map).containsKey('isDisabled')
              ? doc.get('isDisabled') ?? false
              : false
          : false;
      if (isDisabled) {
        return null;
      }
      return UserModel.fromFirestore(doc);
    }
    return null;
  }

  Future<void> onSave(UserModel user) async {
    emit(AuthenticationState.loading);
    await AppBloc.userCubit.onSaveUser(user);
    emit(AuthenticationState.success);
  }

  Future<void> onClear() async {
    emit(AuthenticationState.fail);
    await AppBloc.userCubit.onDeleteUser();
  }

  Future<List> onLogin(
      {required String email, required String password}) async {
    try {
      await EasyLoading.show(
          status: 'Logging in...', maskType: EasyLoadingMaskType.black);

      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      UserModel? user = await _getUserFromFirestore(userCredential.user!.uid);

      if (user != null) {
        await onSave(user);
        return [true, user];
      } else {
        return [false, 'User data not found'];
      }
    } catch (e) {
      return [false, e.toString()];
    } finally {
      await EasyLoading.dismiss();
    }
  }

  Future<List> onRegister({
    required String email,
    required String password,
    required String name,
    String? address,
    File? avatarFile,
  }) async {
    try {
      await EasyLoading.show(
          status: 'Registering...', maskType: EasyLoadingMaskType.black);

      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      String? avatarUrl;
      if (avatarFile != null) {
        avatarUrl = await _uploadAvatar(userCredential.user!.uid, avatarFile);
      }

      UserModel newUser = UserModel(
        id: userCredential.user!.uid,
        name: name,
        email: email,
        address: address!,
        avatar: avatarUrl!,
      );

      await _database
          .collection('users')
          .doc(userCredential.user!.uid)
          .set(newUser.toJson());

      await AppBloc.userCubit.onSaveUser(newUser);
      return [true, newUser];
    } catch (e) {
      return [false, e.toString()];
    } finally {
      await EasyLoading.dismiss();
    }
  }

  Future<String?> _uploadAvatar(String uid, File file) async {
    try {
      Reference ref = _storage.ref().child('avatars').child('$uid.jpg');
      UploadTask uploadTask = ref.putFile(file);
      TaskSnapshot snapshot = await uploadTask;
      return await snapshot.ref.getDownloadURL();
    } catch (e) {
      print('Error uploading avatar: $e');
      return null;
    }
  }

  Future<void> onLogout() async {
    emit(AuthenticationState.loading);
    onClear();
    emit(AuthenticationState.fail);
  }

  Future<void> onDisableUser() async {
    await _database.collection('users').doc(_auth.currentUser!.uid).update({
      'isDisabled': true,
    });
  }

  Future<void> onDeactivate() async {
    emit(AuthenticationState.loading);
    await onDisableUser();
    await AppBloc.userCubit.onDeleteUser();
    emit(AuthenticationState.fail);
  }
}
