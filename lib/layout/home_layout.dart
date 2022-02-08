import 'package:conditional_builder/conditional_builder.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:storm/app/models/login_model.dart';
import 'package:storm/common/icons/icon_broken.dart';
import 'package:storm/layout/cubit/home_cubit_states.dart';

import 'cubit/home_cubit.dart';

class HomeLayout extends StatelessWidget {
  bool first = true;
  var cubit;

  LoginModel model;

  @override
  Widget build(BuildContext context) {
    if (first) {
      HomeCubit()..getInstance(context);
      HomeCubit.globalData.getUserData().then((value) {
        model = value;
        print('omar model : ' + model.uid);
      });
      first = false;
    }

    return BlocConsumer<HomeCubit, HomeStates>(
      listener: (context, state) {},
      builder: (context, state) {
        var cubit = HomeCubit.globalData;
        return Scaffold(
          extendBody: true,
          bottomNavigationBar: CurvedNavigationBar(
            color: Theme.of(context).colorScheme.secondary,
            buttonBackgroundColor: Colors.orange[300],
            backgroundColor: Colors.transparent,
            animationDuration: Duration(milliseconds: 200),
            height: 45.0,
            items: [
              Icon(
                IconBroken.Home,
                size: 30.0,
                color: Theme.of(context).colorScheme.onBackground,
              ),
              Icon(
                IconBroken.Chat,
                size: 30.0,
                color: Theme.of(context).colorScheme.onBackground,
              ),
              // Icon(
              //   IconBroken.Plus,
              //   size: 30.0,
              //   color: Theme.of(context).colorScheme.onBackground,
              // ),
              Icon(
                IconBroken.Setting,
                size: 30.0,
                color: Theme.of(context).colorScheme.onBackground,
              ),
            ],
            onTap: (index) {
              cubit.setBottomNavItemIndex(index);
            },
            index: cubit.getBottomNavItemIndex(),
          ),
          body: ConditionalBuilder(
            condition: true, //cubit.getUserData()!=null,
            builder: (context) =>
                cubit.getCurrentScreen(cubit.getBottomNavItemIndex()),
            fallback: (context) => Center(child: CircularProgressIndicator()),
          ),
        );
      },
    );
  }
}
