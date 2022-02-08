import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:storm/app/models/login_model.dart';
import 'package:storm/app/modules/settings/cubit/settings_states.dart';
import 'package:storm/common/ui/methods.dart';

class SettingsCubit extends Cubit<SettingCubitStates>{

  SettingsCubit() : super(SettingCubitInitState());

  static SettingsCubit get(context) => BlocProvider.of(context);

  var selectedItem = 'Dark Mode';
  List<String> items = ["Light Mode","Dark Mode","System Mode"];


  void changeTheme(val){
    selectedItem = val;
    emit(SettingCubitChangeThemeState());
  }

  LoginModel model;
  void getUserData(BuildContext context , String uid) async {
    if(await checkInternet())
    {
      emit(SettingGetUserLoadingState());

      await FirebaseFirestore.instance
        .collection("users")
        .doc('all users')
        .collection('users')
        .where('uid',isEqualTo: uid)
        .get().then((value) {
        model = LoginModel.fromJson(value.docs[0].data());
        print(model.toMap());
        emit(SettingGetUserSuccessState());
      }).catchError((error) {
        print(error.toString());
        emit(SettingGetUserErrorState(error.toString()));
      });
    }else
    showSnackBar(context);
  }

}