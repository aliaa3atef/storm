import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:storm/common/icons/icon_broken.dart';

class ImageViewer extends StatelessWidget {
  dynamic image;

  ImageViewer(this.image);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        leading: IconButton(
          icon: Icon(IconBroken.Arrow___Left_2),
          iconSize: 30.0,
          color: Colors.white,
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Container(
        child: PhotoView(
          imageProvider:
              image is File ? FileImage(image) : CachedNetworkImageProvider(image),

        ),
      ),
    );
  }
}
