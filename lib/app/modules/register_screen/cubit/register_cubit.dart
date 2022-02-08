
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:storm/app/models/login_model.dart';
import 'package:storm/app/modules/register_screen/cubit/register_cubit_states.dart';
import 'package:storm/common/helper/Cache_Helper.dart';
import 'package:storm/common/helper/constants.dart';
import 'package:storm/common/ui/methods.dart';
import 'package:storm/layout/home_layout.dart';


class RegisterCubit extends Cubit<RegisterStates> {
  RegisterCubit() : super(RegisterInitalState());

  static RegisterCubit get(context) => BlocProvider.of(context);

  bool isPassword = true;

  void setVis() {
    isPassword = !isPassword;
    emit(RegisterChangeVisPassState());
  }

  int currentPage=1;
  void getCurrentPage(context)async
  {
    if (await checkInternet()) {
      FirebaseFirestore.instance
          .collection('users')
          .doc('pageCounter')
          .get()
          .then((value) {
            currentPage=value.data()['pageCounter'];
            getCurrentPageSize(context);
      });
    }else
        showSnackBar(context);

  }

  void updatePageSize(context)async
  {
    if (await checkInternet()) {
      currentPageSize+=1;
      FirebaseFirestore.instance
          .collection('users')
          .doc('page ${currentPage}')
          .update({'size':currentPageSize});
    }else
      showSnackBar(context);
  }

  int currentPageSize=0;
  void getCurrentPageSize(context)async
  {
    if (await checkInternet()) {
      FirebaseFirestore.instance
          .collection('users')
          .doc('page ${currentPage}')
          .get()
          .then((value) {
        currentPageSize = value.data()['size'];
      });
    }else
      showSnackBar(context);

  }

  void createUserRegister({
    @required context,
    @required String name,
    @required String phone,
    @required String email,
    @required String password,
  }) async {
    if (await checkInternet()) {
      emit(RegisterLoadingState());
      FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password)
          .then((value) {
        print(value.user.email + " " + value.user.uid);
        uId = value.user.uid;
        Cache_Helper.setData('uid', uId);
        saveUserRegister(
          context: context,
          uid: value.user.uid,
          email: email,
          name: name,
          phone: phone,
          image:
          'https://image.freepik.com/free-photo/portrait-smiling-young-man-eyewear_171337-4842.jpg',
        );
        NavigateToAndKill(context, HomeLayout());
        emit(RegisterSuccessState(false));
      }).catchError((onError) {
        toastMessage(msg: 'Invalid Data', state: 2);
        emit(RegisterErrorState());
      });
    } else
      showSnackBar(context);
  }

  void saveUserRegister({
    @required context,
    @required String name,
    @required String phone,
    @required String email,
    @required String uid,
    @required String image,
  }) async {
    if (await checkInternet()) {

        if(await currentPageNotAvailable(currentPage,context))
        {
          currentPage+=1;
          await updatePageCounter(currentPage,context);
          await createNewPage(context);
        }
        emit(RegisterLoadingState());
        Map<String, dynamic> data =
        LoginModel(
            name,
            phone,
            email,
            uid,
            image,
            '',
            '',
            false).toMap();
        FirebaseFirestore.instance
            .collection('users')
            .doc('page ${currentPage}')
            .collection('users')
            .doc(uId)
            .set(data)
            .then((value) {
          emit(RegisterSuccessState(true));
          updatePageSize(context);
          saveUserDataInAllUsers(context: context,email: email,name: name,phone: phone,image: image,uid: uid);
        }).catchError((onError) {
          toastMessage(msg: 'Something Went Wrong', state: 2);
          emit(RegisterErrorState());
        });

    } else
      showSnackBar(context);
  }

  Future<void> saveUserDataInAllUsers({@required context,
    @required String name,
    @required String phone,
    @required String email,
    @required String uid,
    @required String image,}) async {
    if (await checkInternet()) {


      Map<String, dynamic> data =
      LoginModel(
          name,
          phone,
          email,
          uid,
          image,
          '',
          '',
          false).toMap();
      FirebaseFirestore.instance
          .collection('users')
          .doc('all users')
          .collection('users')
          .doc(uId)
          .set(data)
          .then((value) {
      }).catchError((onError) {
        toastMessage(msg: 'Something Went Wrong', state: 2);
      });
    } else
      showSnackBar(context);
  }

  Future<void> createNewPage(context)async{
    if(await checkInternet())
      {
        await FirebaseFirestore.instance
            .collection('users')
            .doc('page ${currentPage}')
            .set({'size': 0 });
        getCurrentPageSize(context);
      }else
        showSnackBar(context);
  }

  Future<void> updatePageCounter(currentPage,context)async
  {
    if(await checkInternet())
      {
        await FirebaseFirestore.instance
            .collection('users')
            .doc('pageCounter')
            .update(
          {'pageCounter': currentPage}
        );
      }else
        showSnackBar(context);
  }

  Future<bool> currentPageNotAvailable(int currentPage,context)async
  {
    if(await checkInternet())
      {
        DocumentSnapshot<Map<String,dynamic>> data = await FirebaseFirestore.instance
            .collection('users')
            .doc('page ${currentPage}')
            .get();

        return (data.data()['size']==20);
      }else
        showSnackBar(context);
  }
}
