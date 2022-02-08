import 'package:conditional_builder/conditional_builder.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:storm/app/modules/forgetpassword_screen/forgetpasswor_screen.dart';
import 'package:storm/app/modules/register_screen/register_screen.dart';
import 'package:storm/common/colors/colors.dart';
import 'package:storm/common/ui/DefualtTextButton.dart';
import 'package:storm/common/ui/DefualtTextFormField.dart';
import 'package:storm/common/ui/GoogleSignInButton.dart';
import 'package:storm/common/ui/TitleText.dart';
import 'package:storm/common/ui/methods.dart';

import 'cubit/login_cubit.dart';
import 'cubit/login_cubit_states.dart';

class LoginScreen extends StatelessWidget {
  final TextEditingController email = TextEditingController();
  final TextEditingController pass = TextEditingController();
  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => LoginCubit()..getCurrentPage(context),
      child: BlocConsumer<LoginCubit, LoginStates>(
        listener: (context, state) {},
        builder: (context, state) {
          var cubit = LoginCubit.get(context);
          return Scaffold(
            body: SingleChildScrollView(
              child: Form(
                key: formKey,
                child: Container(
                  height: MediaQuery.of(context).size.height,
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    //mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: double.infinity,

                        margin: EdgeInsets.only(left: 20,right: 20,top: 150,bottom: 5),
                        padding: EdgeInsets.all(5),
                        child: Center(child: TitleText("Hello Again!")),
                      ),
                      Container(
                        width: double.infinity,

                        margin: EdgeInsets.only(left: 10,right: 10,bottom: 15),
                        padding: EdgeInsets.all(10),
                        child: Center(child: Text("Welcome back you've been missed!",style: Theme.of(context).textTheme.subtitle2,),),
                      ),
                      const SizedBox(
                        height: 20.0,
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
                      const SizedBox(
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
                      Align(
                        alignment: AlignmentDirectional.centerEnd,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: InkWell(
                            onTap: (){
                              NavigateTo(context, ForgetPasswordScreen());
                            },
                            child: Text('Forget password?',style: Theme.of(context).textTheme.subtitle1,),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 20.0,
                      ),
                      ConditionalBuilder(
                        condition: state is! LoginLoadingState,
                        builder: (context) => Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(18.0)),
                          child: DefaultButton(
                              fun: () {
                                if (formKey.currentState.validate()) {
                                  cubit.userLogin(
                                      context: context,
                                      email: email.text,
                                      password: pass.text);
                                }
                              },
                              child: Text(
                                'LOGIN',
                                style: Theme.of(context).textTheme.subtitle2,
                              )),
                        ),
                        fallback: (context) => Center(
                          child: CircularProgressIndicator(),
                        ),
                      ),
                      const SizedBox(
                        height: 10.0,
                      ),
                      GoogleSignInButton(),
                      const SizedBox(
                        height: 10.0,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Don\'t Have an Account?',
                            style: Theme.of(context).textTheme.subtitle2,
                          ),
                          TextButton(
                              onPressed: () {
                                NavigateTo(context, RegisterScreen());
                              },
                              child: Text(
                                'Register Now',
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
