
import 'package:better_player/better_player.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:conditional_builder/conditional_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:storm/app/models/message_model.dart';
import 'package:storm/app/modules/chat_screen/cubit/chat_cubit.dart';
import 'package:storm/app/modules/chat_screen/cubit/chat_cubit_states.dart';
import 'package:storm/common/colors/colors.dart';
import 'package:storm/common/helper/constants.dart';
import 'package:storm/common/icons/icon_broken.dart';
import 'package:storm/common/ui/ImageViewer.dart';
import 'package:storm/common/ui/Video_Player.dart';
import 'package:storm/common/ui/methods.dart';
import 'package:storm/layout/cubit/home_cubit.dart';
import 'package:video_player/video_player.dart';

class ChatScreen extends StatelessWidget {
  String receiverImage;
  String receiverName;
  String receiverId;
  var messageController = TextEditingController();
  var bottomSheetKey = GlobalKey<ScaffoldState>();
  static bool isOpened = false;
  ChatScreen.empty();
  ChatScreen(this.receiverName, this.receiverImage, this.receiverId);


  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async{
         isOpened = false;
      return true ;
    },

        child: BlocProvider(
          create: (context) => ChatCubit()..getMessages(receiverId: receiverId),
          child: BlocConsumer<ChatCubit,ChatCubitStates>(
            listener: (context, state) {
            },
            builder: (context, state) {
              isOpened=true;
              var cubit = ChatCubit.get(context);
            //  cubit.getUserData(HomeCubit.globalData.getUserData());
              cubit.getUserToken(receiverId);
              return Scaffold(
                appBar: AppBar(
                  titleSpacing: 0.0,
                  title: Row(
                    children: [
                      CircleAvatar(
                        backgroundImage: CachedNetworkImageProvider(receiverImage),
                        radius: 25.0,
                      ),
                      SizedBox(
                        width: 10.0,
                      ),
                      Text(
                        receiverName,
                        style: TextStyle(
                          fontSize: 18.0,
                        ),
                      ),
                    ],
                  ),
                ),
                body: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: LayoutBuilder(builder: (context, constraints) {
                    var height = constraints.constrainHeight();
                    var width = constraints.constrainWidth();

                    return Column(
                      children: [
                        Container(
                          height: height - 40.0,
                          child: ConditionalBuilder(
                            condition: cubit.chat.length > 0,
                            builder: (context) {
                              var chat = List.from(cubit.chat.reversed);
                              return Padding(
                                padding: const EdgeInsets.only(bottom: 5.0),
                                child: ListView.separated(
                                    shrinkWrap: true,
                                    reverse: true,
                                    itemBuilder: (context, index) {
                                      if (chat[index].receiverUid != uId)
                                        return senderMessage(chat[index],context,width);

                                      return receiverMessage(chat[index],context,width);
                                    },
                                    separatorBuilder: (context, index) => SizedBox(
                                      height: 5.0,
                                    ),
                                    itemCount: chat.length),
                              );
                            },
                            fallback: (context) =>
                                Center(child: Text('No Messages Until Now')),
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.zero,
                          height: 40.0,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(14.0),
                            border: Border.all(
                              color: Colors.grey,
                              width: 1.0,
                            ),
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Expanded(
                                child: Container(
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                      color: Colors.grey[300],
                                      borderRadius: BorderRadius.only(
                                        bottomLeft: Radius.circular(13.0),
                                        topLeft: Radius.circular(13.0),
                                      )),
                                  child: TextFormField(
                                    controller: messageController,
                                    textAlignVertical: TextAlignVertical.top,
                                    textAlign: TextAlign.left,
                                    style: TextStyle(fontSize: 15.0),
                                    decoration: InputDecoration(
                                      border: InputBorder.none,
                                      contentPadding:
                                      EdgeInsets.symmetric(horizontal: 5.0),
                                      hintText: 'Write your message here........ ',
                                    ),
                                  ),
                                ),
                              ),
                              Container(
                                clipBehavior: Clip.antiAliasWithSaveLayer,
                                decoration: BoxDecoration(
                                    color: Colors.grey[300],
                                    borderRadius: BorderRadius.only(
                                      bottomRight: Radius.circular(13.0),
                                      topRight: Radius.circular(13.0),
                                    )),
                                child: Row(
                                  children: [
                                    Stack(
                                      alignment: Alignment.center,
                                      children: [
                                        IconButton(
                                          onPressed: () {
                                            showBottomSheet(context: context, builder: (context)=>bottomSheetChooseBuilder(context)) ;
                                          },
                                          color: basicColor,
                                          icon: Icon(IconBroken.Camera),
                                        ),
                                        if(state is ChatCubitUploadingMessageImageState||state is ChatCubitUploadingMessageVideoState)
                                          Padding(
                                            padding: const EdgeInsets.symmetric(vertical: 2.5),
                                            child: CircularProgressIndicator(strokeWidth: 1.5),
                                          ),
                                      ],
                                    ),
                                    IconButton(
                                      onPressed: () {
                                        if (messageController.text != '' &&
                                            messageController.text != null) {
                                          cubit.sendMessage(
                                            message: messageController.text,
                                            receiverId: receiverId,
                                          );
                                          cubit.sendNotification('',receiverId,messageController.text);
                                        }
                                        messageController.text = '';
                                      },
                                      color: basicColor,
                                      icon: Icon(IconBroken.Send),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    );
                  }),
                ),
              );
            },
          ),


    )
    );
  }

  Widget receiverMessage(MessageModel model,context,width) {
    return Align(
      alignment: AlignmentDirectional.topStart,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
        decoration: BoxDecoration(
          color: Colors.grey[300],
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: model.text!=''? Text(
          model.text,
          textAlign: TextAlign.center,
        ): InkWell(
          onTap: (){
            if(model.image!='')
            NavigateTo(context, ImageViewer(model.image));
          },
          child:model.image!=''? Container(
            height: 300.0,
            width: width-100.0,
            padding: EdgeInsets.all(0.0),
            clipBehavior: Clip.antiAliasWithSaveLayer,
            decoration: BoxDecoration(
              image: DecorationImage(
                fit: BoxFit.cover,
                image: CachedNetworkImageProvider(model.image??''),
              ),
              borderRadius: BorderRadius.circular(10.0),
            ),
          ):Container(
          height: 300.0,
          width: width - 100.0,
          padding: EdgeInsets.all(0.0),
          clipBehavior: Clip.antiAliasWithSaveLayer,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: Video_Player(videoPlayerController: VideoPlayerController.network(model.video),),
        ),
        )
      ),
    );
  }

  Widget senderMessage(MessageModel model,context,width) {
    return Align(
      alignment: AlignmentDirectional.topEnd,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
        decoration: BoxDecoration(
          color: basicColor,
          borderRadius: BorderRadius.circular(10.0),
        ),
        child:model.text!=''? Text(
          model.text,
          textAlign: TextAlign.center,
        ): InkWell(
          onTap: (){
            if(model.image!='')
            NavigateTo(context, ImageViewer(model.image));
          },
          child:model.image!=''? Container(
            height: 300.0,
            width: width - 100.0,
            padding: EdgeInsets.all(0.0),
            clipBehavior: Clip.antiAliasWithSaveLayer,
            decoration: BoxDecoration(
              image: DecorationImage(

                fit: BoxFit.cover,
                image: CachedNetworkImageProvider(model.image??'',scale: .5),
              ),
              borderRadius: BorderRadius.circular(10.0),
            ),
          ): Container(
            height: 300.0,
            width: width - 100.0,
            padding: EdgeInsets.all(0.0),
            clipBehavior: Clip.antiAliasWithSaveLayer,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.0),
            ),
            child: BetterPlayer.network(
              model.video,
              betterPlayerConfiguration: BetterPlayerConfiguration(
                autoDispose: false,
                autoDetectFullscreenAspectRatio: false,
                autoDetectFullscreenDeviceOrientation: false,
                expandToFill: false,
                deviceOrientationsOnFullScreen: [DeviceOrientation.portraitUp]

            ),),
          ),
        ),
      ),
    );
  }

  Widget bottomSheetChooseBuilder(context){
    var cubit = ChatCubit.get(context);
    return Container(
      height: 80.0,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: InkWell(
              onTap: (){
                Navigator.pop(context);
                showBottomSheet(context: context, builder: (context)=>bottomSheetBuilder(context,false));
              },
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Icon(IconBroken.Camera),
                    SizedBox(width:10.0),
                    Text('Video')
                  ],
                ),
              ),
            ),
          ),
          Divider(height: 2.0,),
          Expanded(
            child: InkWell(
              onTap: (){
                Navigator.pop(context);
                showBottomSheet(context: context, builder: (context)=>bottomSheetBuilder(context,true));
              },
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Icon(IconBroken.Image),
                    SizedBox(width: 10.0,),
                    Text('Photo')
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget bottomSheetBuilder(context,bool image){
    var cubit = ChatCubit.get(context);
    return Container(
      height: 80.0,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: InkWell(
              onTap: (){
                if(image)
                cubit.pickMessageImage(true,receiverId);
              else
                cubit.pickMessageVideo(true,receiverId);
                Navigator.pop(context);
              },
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Icon(IconBroken.Camera),
                    SizedBox(width:10.0),
                    Text('Camera')
                  ],
                ),
              ),
            ),
          ),
          Divider(height: 2.0,),
          Expanded(
            child: InkWell(
              onTap: (){
                if(image)
                cubit.pickMessageImage(false,receiverId);
                else 
                  cubit.pickMessageVideo(false,receiverId);

                Navigator.pop(context);
              },
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Icon(IconBroken.Image),
                    SizedBox(width: 10.0,),
                    Text('Gallery')
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

}
