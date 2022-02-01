import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:storm/common/colors/colors.dart';
import 'package:storm/common/ui/methods.dart';

import '../../models/notification__chat__model.dart';


class Notifications {
  static Data data ;
  static init()
  {
    AwesomeNotifications().initialize("resource://drawable/ic_launcher", [
      NotificationChannel(
        channelKey: 'basic_channel',
        channelName: 'chat_channel',
        channelShowBadge: true,
        defaultColor: basicColor,
        importance: NotificationImportance.High,
        enableVibration: true,

      )
    ],
    );


    AwesomeNotifications().actionStream.listen((event) {
      openChatScreen(getCurrentContext(),data);
    });

  }

  static Future<void> createNotification(title, body,image) async {

    await AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: 1,
        channelKey: 'basic_channel',
        title: title,
        body: body,
        bigPicture: image!=''? image : null ,
        notificationLayout: image!=''? NotificationLayout.BigPicture : null,
        displayOnBackground: true,
        displayOnForeground: true,
      ),
    );

  }


}
