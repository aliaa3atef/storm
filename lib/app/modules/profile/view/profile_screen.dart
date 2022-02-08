import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:storm/app/modules/profile/cubit/profile_cubit.dart';
import 'package:storm/app/modules/profile/cubit/profile_states.dart';
import 'package:storm/app/modules/settings/cubit/settings_cubit.dart';
import 'package:storm/common/colors/colors.dart';
import 'package:storm/common/icons/icon_broken.dart';
import 'package:storm/common/ui/boxDecoration.dart';

class ProfileScreen extends StatelessWidget {
  final img, name, bio, phone;

  ProfileScreen(this.img, this.name, this.bio, this.phone);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (ctx)=> ProfileCubit()),
        BlocProvider(create: (ctx)=> SettingsCubit()),
      ],
      child: BlocConsumer<ProfileCubit, ProfileCubitStates>(
        listener: (context, state) {},
        builder: (context, state) {

          var Profile = ProfileCubit.get(context);
          var settings = SettingsCubit.get(context);

          return Scaffold(
            appBar: AppBar(
              title: Text("Profile"),
              centerTitle: true,
              elevation: 0,
              leading: IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: Icon(IconBroken.Arrow___Left),
              ),
            ),
            body: SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              child: Column(
                children: [
                  Container(
                    height: 170,
                    child: Stack(
                      alignment: Alignment.bottomCenter,
                      children: [
                        const SizedBox(
                          height: 20,
                        ),
                        Align(
                          child: CircleAvatar(
                            child: ClipRRect(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(100)),
                              child: CachedNetworkImage(
                                height: 150,
                                width: 150,
                                fit: BoxFit.cover,
                                imageUrl: '$img',
                                placeholder: (context, url) => Image.asset(
                                  'assets/images/loading.gif',
                                  fit: BoxFit.cover,
                                  width: double.infinity,
                                  height: 100,
                                ),
                                errorWidget: (context, url, error) =>
                                    Icon(Icons.error_outline),
                              ),
                            ),
                            radius: 80,
                            backgroundColor:
                                Theme.of(context).colorScheme.background,
                          ),
                          alignment: Alignment.topCenter,
                        ),
                        CircleAvatar(
                          child: IconButton(
                              onPressed: () {
                                Profile.pickProfileImage().then((value) {
                                  if (Profile.fileProfileImage != null)
                                    Profile.uploadProfileImage(
                                      context: context,
                                      name: Profile.nameController.text,
                                      phone: Profile.phoneController.text,
                                      bio: Profile.bioController.text,
                                    );
                                });
                              },
                              icon: Icon(
                                IconBroken.Camera,
                                size: 18,
                                color: Theme.of(context).colorScheme.onBackground,
                              )),
                          radius: 18,
                          backgroundColor:
                              Theme.of(context).colorScheme.primaryVariant,
                        ),
                      ],
                    ),
                  ),
                  Divider(),
                  buildContainer(
                      context: context,
                      icon: IconBroken.Profile,
                      title: "Name",
                      body: name,
                      dialogTitle: "Edit Name",
                      controller: Profile.nameController,
                      press: () {
                        Profile.updateUserName(name: Profile.nameController.text);
                      }),
                  buildContainer(
                      context: context,
                      icon: IconBroken.Info_Circle,
                      title: "Bio",
                      body: bio,
                      dialogTitle: "Edit Bio",
                      controller: Profile.bioController,
                      press: () {
                        Profile.updateUserBio(bio: Profile.bioController.text);
                      }),
                  buildContainer(
                      context: context,
                      icon: IconBroken.Call,
                      title: "phone",
                      body: phone,
                      dialogTitle: "Edit Phone",
                      controller: Profile.phoneController,
                      press: ()=> Profile.updateUserPhone(phone: Profile.phoneController.text),
                      ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget buildContainer(
      {BuildContext context,
      IconData icon,
      String title,
      String body,
      String dialogTitle,
      Function press,
      TextEditingController controller}) {
    return ContainerUI(
      child: Row(
        children: [
          Icon(
            icon,
            color: Theme.of(context).primaryColor,
          ),
          SizedBox(
            width: 10,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: Theme.of(context).textTheme.caption,
              ),
              SizedBox(
                height: 10,
              ),
              Text(body, style: Theme.of(context).textTheme.headline5)
            ],
          ),
          Spacer(),
          buildAlertDialog(
            context: context,
            title: dialogTitle,
            hint: body,
            controller: controller,
            press: press,
          ),
        ],
      ),
    );
  }

  Widget buildAlertDialog(
      {BuildContext context,
      String title,
      Function press,
      String hint,
      TextEditingController controller}) {
    return IconButton(
        onPressed: () {
          AlertDialog alert = AlertDialog(
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.headline4,
                ),
                Divider(
                  color: basicColor,
                ),
              ],
            ),
            backgroundColor: Theme.of(context).backgroundColor,
            content: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: controller,
                  decoration: InputDecoration(
                    hintText: hint,
                    hintStyle: Theme.of(context).textTheme.caption,
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: BorderSide(
                        color: basicColor,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: BorderSide(
                        color: Theme.of(context).colorScheme.onBackground,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                TextButton(onPressed: press, child: Text("OK")),
              ],
            ),
          );
          showDialog(
              context: context,
              builder: (_) {
                return alert;
              });
        },
        icon: Icon(
          IconBroken.Edit,
          color: Theme.of(context).primaryColor,
        ));
  }
}
