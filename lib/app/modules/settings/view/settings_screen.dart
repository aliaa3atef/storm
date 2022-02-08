import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:group_radio_button/group_radio_button.dart';
import 'package:storm/app/modules/profile/view/profile_screen.dart';
import 'package:storm/app/modules/settings/cubit/settings_cubit.dart';
import 'package:storm/app/modules/settings/cubit/settings_states.dart';
import 'package:storm/common/helper/constants.dart';
import 'package:storm/common/icons/icon_broken.dart';
import 'package:storm/common/ui/boxDecoration.dart';

class SettingsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (ctx)=> SettingsCubit()..getUserData(context, uId),
      child: BlocConsumer<SettingsCubit , SettingCubitStates>(
        listener: (context, state) {},
        builder: (context, state) {
          var cubit = SettingsCubit.get(context);
          var model = SettingsCubit.get(context).model;

          return Scaffold(
            appBar: AppBar(
              title: Text("Settings"),
              centerTitle: true,
              elevation: 0,
              leading: IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: Icon(IconBroken.Arrow___Left),
              ),
            ),
            body: state is ! SettingGetUserSuccessState ?
            Center(child: CircularProgressIndicator()):
            ListView(
              primary: true,
              children: [

                InkWell(
                  highlightColor: Theme.of(context).primaryColor,
                  onTap: (){Navigator.push(context, MaterialPageRoute(builder: (ctx)=>ProfileScreen(
                    model.image,
                    model.name,
                    model.bio,
                    model.phone
                  )));},
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        CircleAvatar(
                          child: ClipRRect(
                            borderRadius: BorderRadius.all(Radius.circular(60)),
                            child: CachedNetworkImage(
                              height: 100,
                              width: 100,
                              fit: BoxFit.cover,
                              imageUrl: '${model.image}',
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
                          radius: 40,
                          backgroundColor: Theme.of(context).colorScheme.background,
                        ),
                        const SizedBox(
                          width: 20,
                        ),
                        Column(
                          children: [
                            Text(
                              model.name,
                              style: Theme.of(context).textTheme.headline3,
                            ),
                            SizedBox(height: 10),
                            Text(model.bio,
                                style: Theme.of(context).textTheme.caption),
                          ],
                          crossAxisAlignment: CrossAxisAlignment.start,
                        ),
                      ],
                    ),
                  ),
                ),

                Divider(),

                InkWell(
                  highlightColor: Theme.of(context).primaryColor,
                  onTap: (){
                    final AlertDialog alert = AlertDialog(
                      title: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Choose Theme",
                            style: Theme.of(context).textTheme.headline4,
                          ),
                          Divider(),
                        ],
                      ),
                      backgroundColor: Theme.of(context).backgroundColor,
                      content: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [

                          RadioGroup.builder(
                              groupValue: cubit.selectedItem,
                              onChanged: (val)=> cubit.changeTheme(val),
                              items: cubit.items,
                              itemBuilder: (item)=> RadioButtonBuilder(item),
                          ),

                        ],
                      ),
                    );
                    showDialog(
                        context: context,
                        builder: (_) {
                          return alert;
                        });
                  },
                  child: ContainerUI(
                    child:  Row(
                      children: [
                        Icon(
                          Icons.brightness_4,
                          color: Theme.of(context).colorScheme.onSecondary,
                          size: 30,
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Text(
                          "Theme",
                          style: Theme.of(context).textTheme.headline4,
                        ),
                        Spacer(),
                        Icon(
                          Icons.arrow_forward_ios,
                          size: 16,
                          color: Theme.of(context).colorScheme.onSecondary,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
