import 'package:conditional_builder/conditional_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:storm/app/modules/register_screen/cubit/register_cubit.dart';
import 'package:storm/app/modules/register_screen/cubit/register_cubit_states.dart';
import 'package:storm/common/ui/DefualtTextButton.dart';
import 'package:storm/common/ui/DefualtTextFormField.dart';
import 'package:storm/common/ui/TitleText.dart';

class RegisterScreen extends StatelessWidget {
  final TextEditingController email = TextEditingController();
  final TextEditingController name = TextEditingController();
  final TextEditingController phone = TextEditingController();
  final TextEditingController pass = TextEditingController();
  var keysss = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SocialRegisterCubit(),
      child: BlocConsumer<SocialRegisterCubit, SocialRegisterStates>(
        listener: (context, state) {},
        builder: (context, state) {
          var cubit = SocialRegisterCubit.get(context);
          return Scaffold(
            appBar: AppBar(),
            body: Form(
              key: keysss,
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TitleText('Register'),
                      SizedBox(
                        height: 30.0,
                      ),
                      DefaultTextFormField(
                        hint: 'User Name',
                        validate: (value) {
                          if (value.isEmpty) {
                            return 'Enter the Username';
                          }
                          return null;
                        },
                        prefixicon: Icon(Icons.person),
                        controller: name,
                        type: TextInputType.text,
                      ),
                      SizedBox(
                        height: 15.0,
                      ),
                      DefaultTextFormField(
                        hint: 'Email',
                        validate: (value) {
                          if (value.isEmpty) {
                            return 'Enter the Email';
                          }
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
                        type: TextInputType.emailAddress,
                        hint: 'password',
                        validate: (value) {
                          if (value.isEmpty) {
                            return 'Enter the Password';
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
                        validate: (value) {
                          if (value.isEmpty) {
                            return 'Enter the Phone';
                          }
                          return null;
                        },
                      ),
                      SizedBox(
                        height: 15.0,
                      ),


                      ConditionalBuilder(
                        condition: state is !SocialRegisterLoadingState,
                        builder: (context) => DefualtButton(
                            color: Colors.amber,
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
                            child: Text('Register')),
                        fallback: (context) => Center(child: CircularProgressIndicator()),
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
