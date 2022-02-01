
import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:storm/app/models/login_model.dart';
import 'package:storm/app/modules/chats_screen/chats_screen.dart';
import 'package:storm/common/helper/constants.dart';
import 'package:storm/layout/cubit/home_cubit_states.dart';

class HomeCubit extends Cubit<HomeStates> {
  HomeCubit() : super(HomeInitState());
  static  HomeCubit globalData;
   bool _getInstanceFirstTime = true;

   ThemeData currentTheme = null;

   void getCurrentTheme(context)
   {
   }


   void getInstance(context) {
    if(_getInstanceFirstTime) {
      globalData = BlocProvider.of(context);
      _getInstanceFirstTime=false;
    }
  }

  int _bottomNavItemIndex = 0;
  void setBottomNavItemIndex(int index) {
      _bottomNavItemIndex = index;
      emit(HomeBottomNavIndexState());
  }

  int getBottomNavItemIndex() {
    return _bottomNavItemIndex;
  }

  LoginModel _model ;

  LoginModel getUserData() {
    emit(HomeGetUserLoadingState());
    FirebaseFirestore.instance.collection('users').doc(uId).get().then((value) {
      _model = LoginModel.fromJson(value.data());
      emit(HomeGetUserSuccessState());
      return _model;
    }).catchError((onError) {
      print(onError.toString());
      emit(HomeGetUserErrorState());
    });
    return null;
  }

  List _screens = [
     ChatsScreen(),
    // UsersChatScreen(),
    // NewPostScreen(),
    // ProfileScreen(),
  ];

  Widget getCurrentScreen(int index)
  {
    return _screens[index];
  }



  void setDeviceToken(){
    FirebaseFirestore.instance
        .collection('users')
        .doc(uId)
        .collection('token')
        .doc('token')
        .set({'token':token});
  }


}
