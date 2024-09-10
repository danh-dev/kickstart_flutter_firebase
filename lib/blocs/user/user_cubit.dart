import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pre_techwiz/models/model_user.dart';

class UserCubit extends Cubit<UserModel?> {
  final FirebaseFirestore _database = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  UserCubit() : super(null);

  Future<UserModel?> onLoadUser() async {
    User? currentUser = _auth.currentUser;
    if (currentUser != null) {
      DocumentSnapshot doc =
          await _database.collection('users').doc(currentUser.uid).get();
      if (doc.exists) {
        UserModel user = UserModel.fromFirestore(doc);
        emit(user);
        return user;
      }
    }
    emit(null);
    return null;
  }

  Future<void> onFetchUser() async {
    User? currentUser = _auth.currentUser;
    if (currentUser != null) {
      DocumentSnapshot doc =
          await _database.collection('users').doc(currentUser.uid).get();
      if (doc.exists) {
        UserModel user = UserModel.fromFirestore(doc);
        emit(user);
      }
    }
  }

  Future<void> onSaveUser(UserModel user) async {
    await _database.collection('users').doc(user.id).set(user.toJson());
    emit(user);
  }

  Future<void> onDeleteUser() async {
    emit(null);
  }

  Future<bool> onUpdateUser({
    required String name,
    required String email,
    required String address,
    File? newAvatarFile,
  }) async {
    try {
      User? currentUser = _auth.currentUser;
      if (currentUser != null) {
        String? newAvatarUrl;
        if (newAvatarFile != null) {
          newAvatarUrl = await _uploadAvatar(currentUser.uid, newAvatarFile);
        }

        UserModel updatedUser =
            (state ?? UserModel(id: currentUser.uid)).copyWith(
          name: name,
          email: email,
          address: address,
          avatar: newAvatarUrl ?? state?.avatar,
        );

        await _database
            .collection('users')
            .doc(currentUser.uid)
            .update(updatedUser.toJson());

        if (email != currentUser.email) {
          await currentUser.updateEmail(email);
        }

        emit(updatedUser);
        return true;
      }
      return false;
    } catch (e) {
      print('Error updating user: $e');
      return false;
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

  Future<bool> onChangePassword(String newPassword) async {
    try {
      User? currentUser = _auth.currentUser;
      if (currentUser != null) {
        await currentUser.updatePassword(newPassword);
        return true;
      }
      return false;
    } catch (e) {
      print('Error changing password: $e');
      return false;
    }
  }
}
