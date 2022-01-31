import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:storm/app/models/login_model.dart';
import 'package:storm/app/modules/register_screen/cubit/register_cubit_states.dart';
import 'package:storm/common/helper/Cache_Helper.dart';
import 'package:storm/common/helper/constants.dart';
import 'package:storm/common/ui/methods.dart';


class SocialRegisterCubit extends Cubit<SocialRegisterStates> {
  SocialRegisterCubit() : super(SocialRegisterInitalState());

  static SocialRegisterCubit get(context) => BlocProvider.of(context);

  bool isPassword = true;

  void setVis() {
    isPassword = !isPassword;
    emit(SocialRegisterChangeVisPassState());
  }


  void createUserRegister({@required context,@required String name,@required String phone,@required String email,@required String password,}) {
      emit(SocialRegisterLoadingState());

      FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: email,
          password: password
      ).then((value) {
        print(value.user.email + " "+value.user.uid);
        uId = value.user.uid;
        Cache_Helper.setData('uid', uId);
        saveUserRegister(
          uid: value.user.uid,
          email:email,
          name: name,
          phone: phone,
          image:'https://image.freepik.com/free-photo/portrait-smiling-young-man-eyewear_171337-4842.jpg',
          cover: 'https://image.freepik.com/free-photo/confused-lovely-female-teenager-holds-chin-looks-thoughtfully-aside-has-dark-hair-wears-striped-sweater-isolated-white-wall_273609-16546.jpg',
          bio: 'write some bio......',
        );
        NavigateToAndKill(context,SocialLayout());
        emit(SocialRegisterSuccessState(false));
      }).catchError((onError){

        emit(SocialRegisterErrorState());
      });
  }

  void saveUserRegister({
    @required context,
    @required String name,
    @required String phone,
    @required String email,
    @required String uid,
    @required String image,
    @required String cover,
    @required String bio,
  }) {
    emit(SocialRegisterLoadingState());
    Map<String,dynamic> data =LoginModel(name,phone,email,uid,image,cover,bio,false).toMap();
    FirebaseFirestore.instance.collection('users').doc(uid).set(
      data
    ).then((value) {

      emit(SocialRegisterSuccessState(true));
    }).catchError((onError){
      print(onError.toString());
      emit(SocialRegisterErrorState());
    });
  }

}
