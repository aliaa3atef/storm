
import 'package:conditional_builder/conditional_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:storm/app/modules/login_screen/login_screen.dart';
import 'package:storm/common/colors/colors.dart';
import 'package:storm/common/ui/DefualtTextButton.dart';
import 'package:storm/common/ui/DefualtTextFormField.dart';
import 'package:storm/common/ui/TitleText.dart';
import 'package:storm/common/ui/methods.dart';

import 'cubit/register_cubit.dart';
import 'cubit/register_cubit_states.dart';

class RegisterScreen extends StatelessWidget {
  final TextEditingController email = TextEditingController();
  final TextEditingController name = TextEditingController();
  final TextEditingController phone = TextEditingController();
  final TextEditingController pass = TextEditingController();
  var keysss = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => RegisterCubit(),
      child: BlocConsumer<RegisterCubit, RegisterStates>(
        listener: (context, state) {},
        builder: (context, state) {
          var cubit = RegisterCubit.get(context);
          return Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.transparent,
            ),
            body: Form(
              key: keysss,
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Register with your email',style: Theme.of(context).textTheme.headline2,),
                      const SizedBox(
                        height: 50.0,
                      ),
                      DefaultTextFormField(
                        hint: 'User Name',
                        validate: (value) {
                          if (value.isEmpty) {
                            return 'User Name Must Not Be Empty';
                          }
                          return null;
                        },
                        prefixicon: Icon(Icons.person),
                        controller: name,
                        type: TextInputType.text,
                      ),
                      const SizedBox(
                        height: 15.0,
                      ),
                      DefaultTextFormField(
                       hint: 'email@example.com',
                        validate: (String value) {
                          if (value.isEmpty) {
                            return 'Email Address Must Not Be Empty';
                          }
                          if(!value.contains('@')||(value.contains('@')&&value.split('@').first.length==0)||!value.contains('.')||(value.contains('.')&&value.split('.').first.length-value.split('@').first.length==1)||value.contains(' ')||value.split('.').last.length==0)
                            return 'Email address must be like email@example.com';
                          return null;
                        },
                        prefixicon: Icon(Icons.email),
                        controller: email,
                        type: TextInputType.emailAddress,
                      ),
                      SizedBox(
                        height: 15.0,
                      ),
                      DefaultTextFormField(
                        isPassword: cubit.isPassword,
                        suffixicon: cubit.isPassword
                            ? Icons.visibility
                            : Icons.visibility_off,
                        sufOnPressed: () {
                          cubit.setVis();
                        },
                        prefixicon: Icon(Icons.lock),
                        controller: pass,
                        type: TextInputType.visiblePassword,
                        hint: 'password',
                        validate: (String value) {
                          if (value.length<6) {
                            return 'Password must be more than 6 characters';
                          }
                          return null;
                        },
                      ),
                      SizedBox(
                        height: 20.0,
                      ),
                      DefaultTextFormField(
                        prefixicon: Icon(Icons.phone),
                        controller: phone,
                        type: TextInputType.phone,
                        hint: 'Phone',
                        validate: (String value) {
                          if (value.length!=11) {
                            return 'Phone must be 11 digit';
                          }
                          return null;
                        },
                      ),
                      SizedBox(
                        height: 30.0,
                      ),
                      ConditionalBuilder(
                        condition: state is !RegisterLoadingState,
                        builder: (context) => DefaultButton(
                            color: basicColor,
                            fun: () {
                              if (keysss.currentState.validate()) {
                                cubit.createUserRegister(
                                  name: name.text,
                                  phone: phone.text,
                                  email: email.text,
                                  password: pass.text,
                                  context: context,
                                );
                              }
                            },
                            child: Text('Register'.toUpperCase() ,style: Theme.of(context).textTheme.bodyText2,)),
                        fallback: (context) => Center(child: CircularProgressIndicator()),
                      ),
                      const SizedBox(
                        height: 10.0,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Already have an account?',
                            style: Theme.of(context).textTheme.subtitle2,
                          ),
                          TextButton(
                              onPressed: () {
                                NavigateTo(context, LoginScreen());
                              },
                              child: Text(
                                'Login now',
                                style: Theme.of(context)
                                    .textTheme
                                    .subtitle1
                                    .copyWith(
                                  color: basicColor,
                                ),
                              ))
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
