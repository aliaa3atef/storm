
import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:storm/app/models/login_model.dart';
import 'package:storm/app/modules/all_users/view/all_users_screen.dart';
import 'package:storm/app/modules/chats_screen/chats_screen.dart';
import 'package:storm/app/modules/settings/view/settings_screen.dart';
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

    Future<LoginModel>  getUserData()async {
    emit(HomeGetUserLoadingState());
      DocumentSnapshot<Map<String,dynamic>> value = await FirebaseFirestore.instance.collection('users').doc('all users').collection('users').doc(uId).get();
      _model = LoginModel.fromJson(value.data());
      emit(HomeGetUserSuccessState());
      return _model;

    }

  List _screens = [
    AllUsersScreen(),
    ChatsScreen(),
    SettingsScreen(),
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
