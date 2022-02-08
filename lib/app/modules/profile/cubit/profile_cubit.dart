import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:storm/app/models/login_model.dart';
import 'package:storm/app/modules/profile/cubit/profile_states.dart';
import 'package:storm/app/modules/settings/cubit/settings_cubit.dart';
import 'package:storm/common/helper/constants.dart';
import 'package:storm/common/ui/methods.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;


class ProfileCubit extends Cubit<ProfileCubitStates>{

  ProfileCubit() : super(ProfileCubitInitState());

  static ProfileCubit get(context) => BlocProvider.of(context);

  TextEditingController nameController = TextEditingController();
  TextEditingController bioController = TextEditingController();
  TextEditingController phoneController = TextEditingController();


  XFile selectedProfile;
  File fileProfileImage;

  Future<void> pickProfileImage() async {
    selectedProfile =
    await ImagePicker().pickImage(source: ImageSource.gallery,imageQuality: 15);
    if (selectedProfile != null) {
      {
        fileProfileImage = File(selectedProfile.path);
      }
    } else {
      print('something went wrong');
    }
  }

  String profileImage;

  void uploadProfileImage(
      {@required String name, @required String phone, @required String bio,context}) {

    var cubit = SettingsCubit.get(context);

    emit(EditProfileUploadingProfileImageState());
    firebase_storage.FirebaseStorage.instance
        .ref()
        .child('users/profile_images/${Uri
        .file(fileProfileImage.path)
        .pathSegments
        .last}')
        .putFile(fileProfileImage)
        .then((value) {
      fileProfileImage = null;
      value.ref.getDownloadURL().then((value) {
        profileImage = value.toString();
        FirebaseFirestore.instance
            .collection("users")
            .doc('all users')
            .collection('users').doc(uId)
            .update(LoginModel(
            name,
            phone,
            cubit.model.email,
            cubit.model.uid,
            profileImage,
            cubit.model.cover,
            bio,
            cubit.model.isEmailVarified)
            .toMap())
            .then((value) {
          cubit.getUserData(context , uId);
          toastMessage(msg: 'Image will be here soon', state: 0);
        }).catchError((onError) {
          print('error on add profile image ' + onError.toString());
        });
      }).catchError((onError) {
        print('error on get download url ' + onError.toString());
      });
    }).catchError((onError) {
      print('error on get download url ' + onError.toString());
    });
  }


  void updateUserName(
      {@required String name , context}) {
    var cubit = SettingsCubit.get(context);

    emit(UpdateUserNameState());

    FirebaseFirestore.instance
        .collection("users")
        .doc('all users')
        .collection('users').doc(uId)
        .update(LoginModel(
        name,
        cubit.model.phone,
        cubit.model.email,
        cubit.model.uid,
        cubit.model.image,
        cubit.model.cover,
        cubit.model.bio,
        cubit.model.isEmailVarified)
        .toMap()).then((value) {
      cubit.getUserData(context , uId);
      emit(UpdateUserNameSuccessState());
      toastMessage(msg: 'Name Updated Successfully', state: 0);
    }).catchError((onError) {
      toastMessage(msg: 'Name is Not Updated', state: 2);
      print(onError.toString());
    });
  }

  void updateUserBio(
      {@required String bio , context}) {
    var cubit = SettingsCubit.get(context);

    emit(UpdateUserBioState());

    FirebaseFirestore.instance
        .collection("users")
        .doc('all users')
        .collection('users').doc(uId)
        .update(LoginModel(
        cubit.model.name,
        cubit.model.phone,
        cubit.model.email,
        cubit.model.uid,
        cubit.model.image,
        cubit.model.cover,
        bio,
        cubit.model.isEmailVarified)
        .toMap()).then((value) {
      cubit.getUserData(context , uId);
      emit(UpdateUserBioSuccessState());
      toastMessage(msg: 'Bio Updated Successfully', state: 0);
    }).catchError((onError) {
      toastMessage(msg: 'Bio is Not Updated', state: 2);
      print(onError.toString());
    });
  }

  void updateUserPhone(
      {@required String phone , context}) {
    var cubit = SettingsCubit.get(context);

    emit(UpdateUserPhoneState());

    FirebaseFirestore.instance
        .collection("users")
        .doc('all users')
        .collection('users').doc(uId)
        .update(LoginModel(
        cubit.model.name,
        phone,
        cubit.model.email,
        cubit.model.uid,
        cubit.model.image,
        cubit.model.cover,
        cubit.model.bio,
        cubit.model.isEmailVarified)
        .toMap()).then((value) {
      cubit.getUserData(context , uId);
      emit(UpdateUserPhoneSuccessState());
      toastMessage(msg: 'Phone Updated Successfully', state: 0);
    }).catchError((onError) {
      toastMessage(msg: 'Phone is Not Updated', state: 2);
      print(onError.toString());
    });
  }

}