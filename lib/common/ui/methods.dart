import 'package:connectivity/connectivity.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:storm/app/models/notification__chat__model.dart';
import 'package:storm/app/modules/chat_screen/chat_screen.dart';
import 'package:storm/app/modules/login_screen/cubit/login_cubit.dart';
import 'package:storm/app/modules/login_screen/login_screen.dart';
import 'package:storm/common/helper/Cache_Helper.dart';
import 'package:storm/common/helper/constants.dart';

void Logout(context) async
{

  Cache_Helper.removeData('uid');
  if(LoginCubit.googleSignInStatus) {
    GoogleSignIn().signOut();
    LoginCubit.googleSignInStatus=false;
  }
  FirebaseAuth.instance.signOut();
  NavigateToAndKill(context, LoginScreen());

}

Future<bool> checkInternet() {
  return Connectivity().checkConnectivity().then((ConnectivityResult value) {
    return  value != ConnectivityResult.none;
  });
}


void  showSnackBar(context) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    backgroundColor: Colors.red,
    content: Row(
      children:  const [
        Icon(Icons.info_outline,),
        SizedBox(width: 10.0,),
        Text('No Internet Connection')
      ],
    ),
  ),
  );
}

void NavigateTo(context, widget) {
  Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => widget,
      ));
}

void NavigateToAndKill(context, widget) {
  Navigator.pushAndRemoveUntil(
    context,
    MaterialPageRoute(
      builder: (context) => widget,
    ),
        (route) => false,

  );
}


void toastMessage ({@required String msg,@required int state})
{
  Fluttertoast.showToast(
      msg: msg,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 5,
      backgroundColor: stateColor(state),
      textColor: Colors.white,
      fontSize: 16.0
  );
}

Color stateColor(int state)
{
  // 0 for success and 1 for warning and else for error
  if(state == 0)return Colors.green;
  else if (state == 1) return Colors.yellow;
  else return Colors.red;
}

GlobalKey navigatorKey = GlobalKey<NavigatorState>();

BuildContext getCurrentContext()
{
  return navigatorKey.currentContext;
}

void openChatScreen(context,Data data){

  if(uId!=data.receiverUid)
    {
      Cache_Helper.removeData('uid');
      uId=null;
      NavigateToAndKill(context, LoginScreen());
    }else
      {
        NavigateTo(context, ChatScreen(data.name, data.image, data.uid));
    }
}
