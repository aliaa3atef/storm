import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:storm/app/modules/chat_screen/chat_screen.dart';
import 'package:storm/app/services/notifications/notifications.dart';
import 'package:storm/common/helper/constants.dart';

import '../../models/notification__chat__model.dart';

class Fcm_Helper {

  static init()
  {
    Fcm_Helper.getNotificationWhenOpenedApp();
    Fcm_Helper.getNotificationWhenBackgroundedApp();
  }

  static void getNotificationWhenOpenedApp(){
    FirebaseMessaging.onMessage.listen((event)async {
      Data data = Data.fromJson(event.data);
      Notifications.data = data;
      if(!ChatScreen.isOpened)
          await Notifications.createNotification(event.notification.title, event.notification.body,data.notificationImage);
    else
      {
            if(uId!=data.receiverUid)
            await Notifications.createNotification(event.notification.title, event.notification.body,data.notificationImage);
      }
    });
  }


  static Future<void> backHandler(RemoteMessage event) async
  {
    if(event.notification!=null)
    {
         Data data = Data.fromJson(event.data);
         Notifications.data = data;
         await Notifications.createNotification(event.notification.title, event.notification.body,data.notificationImage);
    }
  }

  static void getNotificationWhenBackgroundedApp(){
    FirebaseMessaging.onBackgroundMessage(backHandler);
  }

}