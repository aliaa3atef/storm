
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:storm/app/models/login_model.dart';
import 'package:storm/app/models/message_model.dart';
import 'package:storm/app/models/notification__chat__model.dart';
import 'package:storm/app/modules/chat_screen/cubit/chat_cubit_states.dart';
import 'package:storm/common/helper/constants.dart';
import 'package:storm/common/helper/diohelper.dart';


class ChatCubit extends Cubit<ChatCubitStates> {
  ChatCubit() : super(ChatCubitInitState());

  static ChatCubit get(context) => BlocProvider.of(context);

  LoginModel model;

  void getUserData(LoginModel userModel)
  {
    model=userModel;
  }

  String receiverDeviceToken;
  void getUserToken(receiverUid)
  {
    FirebaseFirestore.instance
        .collection('users')
        .doc(receiverUid)
        .collection('token')
        .doc('token')
        .get()
        .then((value) {
      print(value.data().entries.elementAt(0).value.toString());
      receiverDeviceToken = value.data().entries.elementAt(0).value.toString();
    });
  }

  void sendMessage(
      {
        @required message,
        @required receiverId,
      })
  {
    emit(ChatCubitSendMessageLoadingState());
    FirebaseFirestore.instance
        .collection('users')
        .doc(receiverId)
        .collection('chats')
        .doc(uId)
        .collection('messages')
        .add(MessageModel(DateTime.now().toString(),message,receiverId,uId,'','').toMap())
        .catchError((onError){
      print(onError.toString());
      emit(ChatCubitSendMessageErrorState());
    });
    FirebaseFirestore.instance
        .collection('users')
        .doc(uId)
        .collection('chats')
        .doc(receiverId)
        .collection('messages')
        .add(MessageModel(DateTime.now().toString(),message,receiverId,uId,'','').toMap())
        .then((value) {
      emit(ChatCubitSendMessageSuccessState());
    })
        .catchError((onError){
      print(onError.toString());
      emit(ChatCubitSendMessageErrorState());
    });
  }

  List<MessageModel> chat=[];
  void getMessages({
    @required receiverId
  })
  {
    FirebaseFirestore.instance
        .collection('users')
        .doc(uId)
        .collection('chats')
        .doc(receiverId)
        .collection('messages')
        .orderBy('dateTime')
        .snapshots()
        .listen((event) {
      chat=[];
      event.docs.forEach((element) {
        chat.add(MessageModel.fromJson(element.data()));
      });

      emit(ChatCubitGetMessagesSuccessState());
    });
  }


  XFile selectedMessageImage;
  File fileMessageImage;

  Future<void> pickMessageImage(bool camera,receiverId) async {
    Permission.storage.request().then((value) async {
      if(value.isGranted)
      {
        selectedMessageImage =  await ImagePicker().pickImage(source:camera?ImageSource.camera: ImageSource.gallery,imageQuality: 30);
        if (selectedMessageImage != null) {
          {
            fileMessageImage = File(selectedMessageImage.path);
            uploadMessageImage(receiverId);
          }
        } else {
          print('something went wrong');
        }
      }

    });

  }

  XFile selectedMessageVideo;
  File fileMessageVideo;

  Future<void> pickMessageVideo(bool camera,receiverId) async {
    Permission.storage.request().then((value) async {
      if(value.isGranted)
      {
        selectedMessageVideo =  await ImagePicker().pickVideo(source:camera?ImageSource.camera: ImageSource.gallery,maxDuration: Duration(minutes: 2));
        if (selectedMessageVideo != null) {
          {
            fileMessageVideo = File(selectedMessageVideo.path);
            uploadMessageVideo(receiverId);
          }
        } else {
          print('something went wrong');
        }
      }

    });

  }

  String messageVideo;

  void uploadMessageVideo(receiverId) {
    emit(ChatCubitUploadingMessageVideoState());
    firebase_storage.FirebaseStorage.instance
        .ref()
        .child('messages/${Uri
        .file(fileMessageVideo.path)
        .pathSegments
        .last}')
        .putFile(fileMessageVideo)
        .then((value) {
      fileMessageVideo = null;
      value.ref.getDownloadURL().then((value) {
        messageVideo = value.toString();
        sendVideoToChat(video: messageVideo.toString(),receiverId: receiverId,hasVideo: true);
      }).catchError((onError) {
        print('error on add message image ' + onError.toString());
      });
    }).catchError((onError) {
      print('error on get download url ' + onError.toString());
    });

  }

  String messageImage;

  void uploadMessageImage(receiverId) {
    emit(ChatCubitUploadingMessageImageState());
    firebase_storage.FirebaseStorage.instance
        .ref()
        .child('messages/${Uri
        .file(fileMessageImage.path)
        .pathSegments
        .last}')
        .putFile(fileMessageImage)
        .then((value) {
      fileMessageImage = null;
      value.ref.getDownloadURL().then((value) {
        messageImage = value.toString();
        sendImageToChat(image: messageImage.toString(),receiverId: receiverId,hasImage: true);
      }).catchError((onError) {
        print('error on add message image ' + onError.toString());
      });
    }).catchError((onError) {
      print('error on get download url ' + onError.toString());
    });

  }


  void sendImageToChat(
      {
        @required String image,
        @required String receiverId,
        @required bool hasImage
      })
  {
    emit(ChatCubitSendMessageLoadingState());
    FirebaseFirestore.instance
        .collection('users')
        .doc(receiverId)
        .collection('chats')
        .doc(uId)
        .collection('messages')
        .add(MessageModel(DateTime.now().toString(),'',receiverId,uId,image,'').toMap())
        .catchError((onError){
      print(onError.toString());
      emit(ChatCubitSendMessageErrorState());
    });
    FirebaseFirestore.instance
        .collection('users')
        .doc(uId)
        .collection('chats')
        .doc(receiverId)
        .collection('messages')
        .add(MessageModel(DateTime.now().toString(),'',receiverId,uId,image,'').toMap())
        .then((value) {
      emit(ChatCubitSendMessageSuccessState());
      sendNotification(image,receiverId,'',);

    })
        .catchError((onError){
      print(onError.toString());
      emit(ChatCubitSendMessageErrorState());
    });
  }

  void sendVideoToChat(
      {
        @required String video,
        @required String receiverId,
        @required bool hasVideo
      })
  {
    emit(ChatCubitSendMessageLoadingState());
    FirebaseFirestore.instance
        .collection('users')
        .doc(receiverId)
        .collection('chats')
        .doc(uId)
        .collection('messages')
        .add(MessageModel(DateTime.now().toString(),'',receiverId,uId,'',video).toMap())
        .catchError((onError){
      print(onError.toString());
      emit(ChatCubitSendMessageErrorState());
    });
    FirebaseFirestore.instance
        .collection('users')
        .doc(uId)
        .collection('chats')
        .doc(receiverId)
        .collection('messages')
        .add(MessageModel(DateTime.now().toString(),'',receiverId,uId,'',video).toMap())
        .then((value) {
      emit(ChatCubitSendMessageSuccessState());
      //sendNotification(video,receiverId,'',);

    })
        .catchError((onError){
      print(onError.toString());
      emit(ChatCubitSendMessageErrorState());
    });
  }



  void sendNotification(image,receiverId,String text,)
  {
    if(image!='')
    {
      var notification = NotificationModel(title: 'message from '+model.name,body: 'has an image');
      var data =Data(uid: uId,image: model.image,name: model.name,receiverUid:receiverId,notificationImage: image );
      var notificationModel = NotificationChatModel(to:receiverDeviceToken ,notification: notification,data: data);
      DioHelper.setData(data: notificationModel.toJson());
    }else
    {
      var notification = NotificationModel(title: 'message from '+model.name,body: text);
      var data =Data(uid: uId,image: model.image,name: model.name,receiverUid:receiverId,notificationImage: '' );
      var notificationModel = NotificationChatModel(to:receiverDeviceToken ,notification: notification,data: data);
      DioHelper.setData(data: notificationModel.toJson());
    }
  }


}