import 'package:doctor_app/api/api_name.dart';
import 'package:doctor_app/getIt.dart';
import 'package:doctor_app/model/blog_model.dart';
import 'package:doctor_app/repeatedWidgets/CustomAppBar.dart';
import 'package:doctor_app/repeatedWidgets/circularImage.dart';
import 'package:doctor_app/res/color.dart';
import 'package:doctor_app/singleton/global.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_svg/svg.dart';
import 'package:icofont_flutter/icofont_flutter.dart';
import 'package:page_transition/page_transition.dart';
import 'package:doctor_app/res/size.dart';

import 'blog.dart';
import 'home.dart';
import 'medicalRecord.dart';
import 'myAppointment.dart';

class blogDetail extends StatefulWidget {
  BlogModel blog;

  blogDetail({@required this.blog});

  @override
  _blogDetailState createState() => _blogDetailState();
}

class _blogDetailState extends State<blogDetail> {

  GlobalKey<ScaffoldState> _scaffoldkey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      key: _scaffoldkey,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(size.longestSide * 0.15666178),
        child: CustomAppBar(
          hight: size.longestSide * 0.15666178,
          parentContext: context,
          color1: Color(0xff1C80A0),
          color2: Color(0xff35D8A6),
          leadingIcon: _leading(),
          trailingIcon: _trailing(),
          centerWigets: _logo(),
        ),
      ),
      body: _body(),
    );
  }

  _body() {
    Size size1 = MediaQuery.of(context).size;
    return SingleChildScrollView(
      child: Container(
        margin:
            EdgeInsets.symmetric(horizontal: size1.longestSide * 0.014641288),
        padding: EdgeInsets.only(top: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            _heroImage(),
            SizedBox(
              height: 5,
            ),
            Container(
//          color: Colors.red,
              height: size1.longestSide * 0.0585651537,
              child: RichText(
                  maxLines: 2,
                  text: TextSpan(
                      text: widget.blog.postTitle,
                      style: TextStyle(
                          color: Colors.black,
                          fontFamily: "LatoBold",
                          fontSize: 17,
                          fontWeight: FontWeight.bold))),
            ),
//            SizedBox(
//              height: 5,
//            ),
//            Container(
//              //color: Colors.red,
//              child: Row(
//                //crossAxisAlignment: CrossAxisAlignment.start,
//                mainAxisAlignment: MainAxisAlignment.start,
//                children: <Widget>[
////                  circularImage(imageUrl: widget.blog["image2"],
////                  ),
//                  SizedBox(
//                    width: 10,
//                  ),
//                  Container(
//                    child: RichText(
//                      text: TextSpan(
//                          text: "No Name",
//                          style: TextStyle(
//                              color: Color(0xff19769F),
//                              fontSize: 14,
//                              fontFamily: "LatoRegular")),
//                    ),
//                  ),
//                  SizedBox(
//                    width: 15,
//                  ),
//                  Expanded(
//                    child: Container(
//                      child: Row(
//                        children: <Widget>[
//                          Container(
//                            width:
//                            size.convert(context, 4),
//                            height:
//                            size.convert(context, 4),
//                            decoration: BoxDecoration(
//                                color: portionColor
//                                    .withOpacity(0.8),
//                                shape: BoxShape.circle),
//                          ),
//                          SizedBox(
//                            width:
//                            size.convert(context, 5),
//                          ),
//                          RichText(
//                            maxLines: 1,
//                            text: TextSpan(
//                                text: "0 min",
//                                style: TextStyle(
//                                    color: portionColor
//                                        .withOpacity(
//                                        0.8))),
//                          ),
//                        ],
//                      ),
//                    ),
//                  ),
//                ],
//              ),
//            ),
            SizedBox(
              height: 15,
            ),
            Container(
              child: RichText(
                text: TextSpan(
                  text: widget.blog.postBody,
                  style: TextStyle(
                      color: Colors.grey,
                      fontFamily: "LatoRegular",
                      fontSize: 14),
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
          ],
        ),
      ),
    );
  }

  _logo() {
    return Container(
        child: SvgPicture.asset("assets/icons/new_Logo_white.svg",
          height: 50,
        )
    );
  }

  _trailing() {
    return Container(
      height: size.convert(context, 45),
      width: size.convertWidth(context, 40),
      decoration: BoxDecoration(
          //shape: BoxShape.circle,
          //color: Colors.blue
          ),
      child: Stack(
        alignment: Alignment.center,
        children: <Widget>[
          Container(
            child: Icon(
              IcoFontIcons.notification,
              color: appBarIconColor,
              size: size.convert(context, 26),
            ),
          ),
          Positioned(
            left: size.convertWidth(context, 23),
            top: size.convert(context, 6),
            child: Container(
              //alignment: Alignment.topRight,
              height: size.convert(context, 14),
              width: size.convert(context, 14),
              decoration: BoxDecoration(
                color: Colors.red,
                shape: BoxShape.circle,
              ),
            ),
          ),
        ],
      ),
    );
  }

  _leading() {
    return Container(
      height: size.convert(context, 45),
      child: Stack(
        alignment: Alignment.center,
        children: <Widget>[
          Container(
            child: GestureDetector(
              onTap: () {
                getIt<GlobalSingleton>().navigationKey.currentState.pop();
                print("pop call");
              },
              child: Container(
                child: SvgPicture.asset("assets/icons/back.svg",
                  color: appBarIconColor,
                ),

                //child: Image.asset("assets/icons/backarrow.png"),
              ),
            ),
          ),
        ],
      ),
    );
  }

  _heroImage() {
    Size size = MediaQuery.of(context).size;
    return Container(
      child: Hero(
        tag: "detail${widget.blog.postId}",
        child: Container(
          height: size.longestSide * 0.415812591,
          width: size.width - 20,
          child: Image.network(
            BLOG_IMAGE_URL+widget.blog.postImg,
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}
