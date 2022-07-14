import 'dart:io';

import 'package:doctor_app/res/color.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class circularImage extends StatelessWidget {
  String imageUrl;
  double h;
  double w;
  bool assetImage;
  bool fileImage;
  File file;

  circularImage(
      {this.file, this.imageUrl, this.fileImage, this.h, this.w, this.assetImage = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: h == null ? 24 : h,
      width: w == null ? 24 : w,
      decoration: BoxDecoration(
          color: buttonColor,
          shape: BoxShape.circle,
          image: imageUrl == null
              ? null
              : DecorationImage(
                  image: fileImage ?? false
                      ? FileImage(file)
                      : assetImage
                          ? AssetImage(imageUrl)
                          : NetworkImage(imageUrl),
                  fit: BoxFit.cover)),
    );
  }
}

class circularAssetImage extends StatelessWidget {
  String imageUrl;
  double h;
  double w;

  circularAssetImage({this.imageUrl, this.h, this.w});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: h == null ? 24 : h,
      width: w == null ? 24 : w,
      decoration: BoxDecoration(
          color: buttonColor,
          shape: BoxShape.circle,
          image: imageUrl == null
              ? null
              : DecorationImage(image: AssetImage(imageUrl), fit: BoxFit.cover)),
    );
  }
}
