import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:storm/app/models/login_model.dart';
import 'package:storm/common/helper/Cache_Helper.dart';
import 'package:storm/common/helper/constants.dart';
import 'package:storm/common/ui/methods.dart';
import 'package:storm/layout/home_layout.dart';
import 'login_cubit_states.dart';

class LoginCubit extends Cubit<LoginStates> {
  LoginCubit() : super(LoginInitState());

  static LoginCubit get(context) => BlocProvider.of(context);

  bool isPassword = true;
  static bool googleSignInStatus=false;

  void setVis() {
    isPassword = !isPassword;
    emit(LoginChangeVisPassState());
  }

  final googleSignIn = GoogleSignIn();
  Future userGoogleLogin(context) async {
    if (await checkInternet()) {
      final user = await googleSignIn.signIn();
      if (user == null) {
        return;
      } else {
        final googleAuth = await user.authentication;
        final credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );


        FirebaseAuth.instance.signInWithCredential(credential).then((value) {
          if (value.user.uid != null) {
            uId = value.user.uid;
            User user=value.user;
            googleSignInFirstTime(uId,context).then((value) {
              if(value) {
                saveUserRegister(
                  context: context,
                  name: user.displayName,
                  phone: user.phoneNumber,
                  email: user.email,
                  image: user.photoURL,
                  uid: user.uid,
                );
              }
            });
            googleSignInStatus=true;
            Cache_Helper.setData('uid', uId);
            NavigateToAndKill(context, HomeLayout());
          }
          emit(LoginSuccessState(true));
        });
      }
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
      Map<String, dynamic> data =
      LoginModel(name, phone??'01234567890', email, uid, image,'','',true).toMap();
      FirebaseFirestore.instance
          .collection('users')
          .doc('page ${currentPage}')
          .collection('users')
          .doc(uid)
          .set(data)
          .then((value) {
        updatePageSize(context);
        saveUserDataInAllUsers(context: context,email: email,name: name,phone: phone??'01234567890',image: image,uid: uid);
      }).catchError((onError) {
        print(onError.toString());
      });
    } else
      showSnackBar(context);
  }

  Future<bool> googleSignInFirstTime(String uid,context)async
  {
    if(await checkInternet())
      {

            QuerySnapshot<Map<String,dynamic>> data=await FirebaseFirestore.instance
                .collection("users")
                .doc('all users')
                .collection('users')
                .where('uid',isEqualTo: uid)
                .get();

            if(data.docs.length==0)
              return true;

      }else
          showSnackBar(context);

   return false;

  }

  void userLogin(
      {@required context, @required email, @required password}) async {
    if (await checkInternet()) {
      emit(LoginLoadingState());

      FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password)
          .then((value) {
        if (value.user.uid != null) {
          uId = value.user.uid;
          Cache_Helper.setData('uid', uId);
          NavigateToAndKill(context, HomeLayout());
        }
        emit(LoginSuccessState(true));
      }).catchError((onError) {
        toastMessage(msg: 'Username or Password is Incorrect', state: 2);
        emit(LoginErrorState());
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

  int currentPageSize=0;
  void getCurrentPageSize(context)async
  {
    print('currentpage is ${currentPage}');
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


  Future<void> updatePageSize(context)async
  {
    if (await checkInternet()) {
      currentPageSize+=1;
     await FirebaseFirestore.instance
          .collection('users')
          .doc('page ${currentPage}')
          .update({'size':currentPageSize});
    }else
      showSnackBar(context);
  }

  int currentPage=1;
  Future<void> getCurrentPage(context)async
  {
    if (await checkInternet()) {
     DocumentSnapshot<Map<String,dynamic>>data = await FirebaseFirestore.instance
          .collection('users')
          .doc('pageCounter')
          .get();

     currentPage=data.data()['pageCounter'];
     getCurrentPageSize(context);
    }else
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


}
