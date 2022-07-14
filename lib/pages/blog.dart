import 'package:dio/dio.dart';
import 'package:doctor_app/api/api.dart';
import 'package:doctor_app/api/api_name.dart';
import 'package:doctor_app/error/snackbar.dart';
import 'package:doctor_app/getIt.dart';
import 'package:doctor_app/model/blog_list_model.dart';
import 'package:doctor_app/repeatedWidgets/CustomAppBar.dart';
import 'package:doctor_app/repeatedWidgets/CustomDrawer.dart';
import 'package:doctor_app/res/color.dart';
import 'package:doctor_app/res/size.dart';
import 'package:doctor_app/singleton/global.dart';
import 'package:doctor_app/transulation/translations_delegate_base.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/svg.dart';
import 'package:icofont_flutter/icofont_flutter.dart';
import 'package:page_transition/page_transition.dart';

import 'blogDetail.dart';

class Blog extends StatefulWidget {
  int val;

  Blog({this.val});

  @override
  _BlogState createState() => _BlogState();
}

class _BlogState extends State<Blog> {
  GlobalKey<ScaffoldState> _scaffoldkey = GlobalKey<ScaffoldState>();
  BlogListModel _blogs;

  int currentPage = 1;
  ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    getBlogData(BLOG_URL);
    _scrollController.addListener(() {
      if (_scrollController.position.atEdge) {
        if (_scrollController.position.pixels == 0) {
          //top
        } else {
          print("Reached bottom of list view");
          //bottom
          if (_blogs != null && _blogs.nextPageUrl != null) {
            print("blog is not  null");
            Uri uri = Uri.parse(_blogs.nextPageUrl);

            if (int.parse(uri.queryParameters['page'].toString()) > currentPage) {
              print("Blog has more list Current Page $currentPage");
              currentPage = int.parse(uri.queryParameters['page'].toString());
              getBlogData(_blogs.nextPageUrl);
            } else {
              print("Blog has NO more list Current Page $currentPage");
            }
          } else {
            print("blog or next url is NULL");
          }
        }
      }
    });
  }

  getBlogData(String url) async {
    var response = await API(context: context, scaffold: _scaffoldkey, showSnackbarForError: true)
        .get(url: url);

    if (response == NO_CONNECTION) {
      CustomSnackBar.SnackBarInternet(_scaffoldkey, context, btnFun: () {
        getBlogData(url);
      });
      return;
    }

    if (response is Response) {
      if (_blogs == null)
        _blogs = BlogListModel.fromJson(response.data);
      else {
        BlogListModel _dummyModel = BlogListModel.fromJson(response.data);
        _blogs.currentPage = _dummyModel.currentPage;
        _blogs.nextPageUrl = _dummyModel.nextPageUrl;
        _blogs.blogs.addAll(_dummyModel.blogs);
      }
      setState(() {});
    }
  }

  _leading() {
    return Container(
      child: GestureDetector(
        onTap: () {
          getIt<GlobalSingleton>().navigationKey.currentState.pop();
        },
        child: Container(
          child: SvgPicture.asset(
            "assets/icons/back.svg",
            color: appBarIconColor,
          ),

          //child: Image.asset("assets/icons/backarrow.png"),
        ),
      ),
    );
  }

  _center() {
    return Container(
      child: RichText(
        text: TextSpan(
            text: TranslationBase.of(context).blogList,
            style: TextStyle(fontSize: 18, fontFamily: "LatoRegular", color: Colors.white)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Size size1 = MediaQuery.of(context).size;
    return Scaffold(
      key: _scaffoldkey,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(size1.longestSide * 0.15666178),
        child: CustomAppBar(
          paddingBottom: size.convert(context, 15),
          hight: size1.longestSide * 0.15666178,
          parentContext: context,
          color1: Color(0xff1C80A0),
          color2: Color(0xff35D8A6),
          leadingIcon: _leading(),
          centerWigets: _center(),
        ),
      ),
      // PreferredSize(
      //   preferredSize: Size.fromHeight(size1.longestSide * 0.15666178),
      //   child: CustomAppBar(
      //     hight: size1.longestSide * 0.15666178,
      //     parentContext: context,
      //     color1: Color(0xff1C80A0),
      //     color2: Color(0xff35D8A6),
      //     leadingIcon: _leadingIcon(),
      //     trailingIcon: NotificationIcon(lightColor: true),
      //     centerWigets: _logo(),
      //   ),
      // ),
      body: _body(),
      // drawer: Container(
      //   width: size.convertWidth(context, 350),
      //   child: openDrawer(),
      // ),
    );
  }

  _logo() {
    return Container(
        child: SvgPicture.asset(
      "assets/icons/new_Logo_white.svg",
      height: 50,
    ));
  }

  _body() {
    return _blogs == null
        ? Center(
            child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation(buttonColor),
          ))
        : Container(
            margin: EdgeInsets.symmetric(
                horizontal: size.convert(context, 10), vertical: size.convert(context, 10)),
            child: ListView.separated(
              itemCount: _blogs.blogs.length,
              controller: _scrollController,
              itemBuilder: (BuildContext context, int index) {
                return Hero(
                  tag: "detail${_blogs.blogs[index].postId}",
                  child: GestureDetector(
                    onTap: () {
                      print("navigate to detail screen $index");
                      getIt<GlobalSingleton>().navigationKey.currentState.push(PageTransition(
                          type: PageTransitionType.fade,
                          child: blogDetail(
                            blog: _blogs.blogs[index],
                          )));
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: size.convert(context, 20),
                          vertical: size.convert(context, 20)),
                      decoration: BoxDecoration(color: portionColor.withOpacity(0.1)),
                      child: Row(
                        children: <Widget>[
                          Container(
                            child: Image.network(
                              BLOG_IMAGE_URL + _blogs.blogs[index].postImg,
                              width: 120,
                              height: 120,
                              fit: BoxFit.cover,
                            ),
                          ),
                          SizedBox(
                            width: size.convert(context, 15),
                          ),
                          Expanded(
                            child: Container(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Container(
                                    child: Text(_blogs.blogs[index].postTitle,
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontFamily: "LatoBold",
                                            fontSize: size.convert(context, 16))),
                                  ),
                                  SizedBox(
                                    height: size.convert(context, 12),
                                  ),
                                  Container(
                                    child: Text(
                                      _blogs.blogs[index].postBody,
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                          color: portionColor,
                                          fontFamily: "LatoRegular",
                                          fontSize: size.convert(context, 14)),
                                    ),
                                  ),
//                                  SizedBox(
//                                    height: size.convert(context, 12),
//                                  ),
//                                  Container(
//                                    //color: Colors.red,
//                                    child: Row(
//                                      //crossAxisAlignment: CrossAxisAlignment.start,
//                                      mainAxisAlignment:
//                                          MainAxisAlignment.start,
//                                      children: <Widget>[
////                                  circularImage(
////                                    imageUrl: ,
////                                  ),
//                                        SizedBox(
//                                          width: size.convert(context, 5),
//                                        ),
//                                        Container(
//                                          child: Text("No Name",
//                                              maxLines: 1,
//                                              style: TextStyle(
//                                                  color: Color(0xff19769F),
//                                                  fontSize:
//                                                      size.convert(context, 14),
//                                                  fontFamily: "LatoRegular")),
//                                        ),
//                                        SizedBox(
//                                          width: size.convertWidth(context, 10),
//                                        ),
//                                        Expanded(
//                                          child: Container(
//                                            child: Row(
//                                              children: <Widget>[
//                                                Container(
//                                                  width:
//                                                      size.convert(context, 4),
//                                                  height:
//                                                      size.convert(context, 4),
//                                                  decoration: BoxDecoration(
//                                                      color: portionColor
//                                                          .withOpacity(0.8),
//                                                      shape: BoxShape.circle),
//                                                ),
//                                                SizedBox(
//                                                  width:
//                                                      size.convert(context, 5),
//                                                ),
//                                                RichText(
//                                                  maxLines: 1,
//                                                  text: TextSpan(
//                                                      text: "0 min",
//                                                      style: TextStyle(
//                                                          color: portionColor
//                                                              .withOpacity(
//                                                                  0.8))),
//                                                ),
//                                              ],
//                                            ),
//                                          ),
//                                        ),
//                                      ],
//                                    ),
//                                  )
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                );
              },
              separatorBuilder: (BuildContext context, int index) {
                return SizedBox(
                  height: size.convert(context, 10),
                );
              },
            ),
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

  openDrawer() {
    return Drawer(
      child: CustomDrawer(),
    );
  }

  _leadingIcon() {
    return Container(
      height: size.convert(context, 45),
      child: Stack(
        alignment: Alignment.center,
        children: <Widget>[
          Container(
            child: InkWell(
              onTap: () {
                print("open drawer ....");
                _scaffoldkey.currentState.openDrawer();
                openDrawer();
              },
              child: Icon(
                IcoFontIcons.navigationMenu,
                color: appBarIconColor,
                size: size.convert(context, 20),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
