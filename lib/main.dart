import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:storm/layout/cubit/home_cubit.dart';
import 'package:storm/layout/cubit/home_cubit_states.dart';
import 'package:storm/layout/home_layout.dart';

import 'app/modules/login_screen/login_screen.dart';
import 'common/helper/Cache_Helper.dart';
import 'common/helper/blocobcerver.dart';
import 'common/helper/constants.dart';
import 'common/themes/theme.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  Bloc.observer = MyBlocObserver();
  await Cache_Helper.init();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {

  Widget startScreen;

  @override
  Widget build(BuildContext context) {
    getStartScreen();
    return BlocProvider(
      create: (context) => HomeCubit(),

      child: BlocConsumer<HomeCubit, HomeStates>(
        listener: (context, state) {},
        builder: (context, state) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: lightTheme,
            darkTheme: darkTheme,
            themeMode: ThemeMode.dark,
            home: startScreen,
          );
        },
      ),
    );
  }

  void getStartScreen()
  {
    if(Cache_Helper.getData('uid')!=null) {
      startScreen = HomeLayout();
      uId=Cache_Helper.getData('uid');
    } else
      startScreen = LoginScreen();
  }
}
