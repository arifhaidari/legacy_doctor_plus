import 'dart:async';

import 'package:doctor_app/api/api.dart';
import 'package:doctor_app/api/api_name.dart';
import 'package:doctor_app/getIt.dart';
import 'package:doctor_app/model/user_model.dart';
import 'package:doctor_app/pages/blog.dart';
import 'package:doctor_app/pages/drawerMenu/familyProfile.dart';
import 'package:doctor_app/pages/drawerMenu/myDoctor.dart';
import 'package:doctor_app/pages/drawerMenu/updateProfile.dart';
import 'package:doctor_app/pages/home.dart';
import 'package:doctor_app/pages/signIn.dart';
import 'package:doctor_app/repeatedWidgets/circularImage.dart';
import 'package:doctor_app/res/color.dart';
import 'package:doctor_app/res/size.dart';
import 'package:doctor_app/res/string.dart';
import 'package:doctor_app/singleton/global.dart';
import 'package:doctor_app/transulation/scope_model_wrapper.dart';
import 'package:doctor_app/transulation/translations_delegate_base.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:page_transition/page_transition.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:scoped_model/scoped_model.dart';

class CustomDrawer extends StatefulWidget {
  @override
  _CustomDrawerState createState() => _CustomDrawerState();
}

class _CustomDrawerState extends State<CustomDrawer> {
  String language = "un";
  AppModel appModel = AppModel();
  int selectedIndex = 0;
  bool showLanguages = false;
  Color selectedIndexColor = appColor.withOpacity(0.3);
  Divider _divider= Divider(
  thickness: 0.5,
  color: Colors.white,
  );
  SizedBox bottomSpace = SizedBox(height:0,);
  SizedBox upperSpace = SizedBox(height:10,);
  String selectedFlag = "";
  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      decoration: BoxDecoration(
          gradient: LinearGradient(
        colors: [Color(0xff19769f), Color(0xff35d8a6)],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      )),
      child: SingleChildScrollView(
        child: FutureBuilder(
          future: UserModel.getUserId,
          builder: (context, snapshot) {

            print(snapshot.data);
//            if(!snapshot.hasData)
//              return Container();

            bool loginUser = snapshot.data !=null;

            return Column(
              children: <Widget>[
                SizedBox(
                  height: size.convert(context, 80),
                ),
                loginUser ? _userProfile():Container(),
                SizedBox(
                  height: size.convert(context, 20),
                ),

                loginUser ? Column(
                  children: <Widget>[
                    Container(
                      child: InkWell(
                        onTap: () {
                          setState(() {
                            selectedIndex = 1;
                          });
                          getIt<GlobalSingleton>().navigationKey.currentState.pop();
                          getIt<GlobalSingleton>().navigationKey.currentState.push(

                              PageTransition(
                                  child: updateProfile(),
                                  type: PageTransitionType.rightToLeft));
                        },
                        child: Container(
                          height: size.convert(context, 30),
                          color: selectedIndex == 1 ? selectedIndexColor : Colors.transparent,
                          padding: EdgeInsets.symmetric(
                              horizontal: size.convert(context, 28)),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Container(
                                child: Row(
                                  children: <Widget>[
                                    SvgPicture.asset("assets/icons/profileIcon.svg"),
                                    SizedBox(width: size.convertWidth(context, 8),),
                                    Text(
                                      TranslationBase.of(context).myProfile,
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontFamily: "LatoRegular",
                                        fontSize: size.convert(context, 12),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Icon(
                                Icons.arrow_forward_ios,
                                color: Colors.white,
                                size: size.convert(context, 14),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                    bottomSpace,
                    _divider,
                    upperSpace,
                    Container(
                      child: InkWell(
                        onTap: () {
                          setState(() {
                            selectedIndex = 2;
                          });

                          getIt<GlobalSingleton>().navigationKey.currentState.pop(context);
                          getIt<GlobalSingleton>().navigationKey.currentState.push(

                              PageTransition(
                                  type: PageTransitionType.rightToLeft,
                                  child: myDoctor()));
                        },
                        child: Container(
                          height: size.convert(context, 30),
                          color: selectedIndex == 2 ? selectedIndexColor : Colors.transparent,

                          padding: EdgeInsets.symmetric(
                              horizontal: size.convert(context, 28)),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Container(
                                child: Row(
                                  children: <Widget>[
                                    SvgPicture.asset("assets/icons/map-doctor.svg"),
                                    SizedBox(width: size.convertWidth(context, 8),),
                                    Text(
                                    TranslationBase.of(context).myDoctor,
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontFamily: "LatoRegular",
                                        fontSize: size.convert(context, 12),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Icon(
                                Icons.arrow_forward_ios,
                                color: Colors.white,
                                size: size.convert(context, 14),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                    bottomSpace,
                    _divider,
                    upperSpace,
                    Container(
                      child: InkWell(
                        onTap: () {
                          setState(() {
                            selectedIndex=3;
                          });

                          getIt<GlobalSingleton>().navigationKey.currentState.pop();
                          getIt<GlobalSingleton>().navigationKey.currentState.push(

                              PageTransition(
                                  child: familyProfile(),
                                  type: PageTransitionType.rightToLeft));
                        },
                        child: Container(
                          height: size.convert(context, 30),
                          color: selectedIndex == 3 ? selectedIndexColor : Colors.transparent,
                          padding: EdgeInsets.symmetric(
                              horizontal: size.convert(context, 28)),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Container(
                                child: Row(
                                  children: <Widget>[
                                    SvgPicture.asset("assets/icons/family.svg"),
                                    SizedBox(width: size.convertWidth(context, 8),),
                                    Text(
                            TranslationBase.of(context).familyProfile,
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontFamily: "LatoRegular",
                                        fontSize: size.convert(context, 12),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Icon(
                                Icons.arrow_forward_ios,
                                color: Colors.white,
                                size: size.convert(context, 14),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),

                  ],
                ):Column(children: <Widget>[
                  Container(
                    child: InkWell(
                      onTap: () {
                        setState(() {
                          selectedIndex = 4;
                        });
                        getIt<GlobalSingleton>().navigationKey.currentState.pop();
                        getIt<GlobalSingleton>().navigationKey.currentState.push(

                            PageTransition(
                                child: signIn(),
                                type: PageTransitionType.rightToLeft));


                      },
                      child: Container(
                        height: size.convert(context, 30),
                        color: selectedIndex == 4 ? selectedIndexColor : Colors.transparent,
                        padding: EdgeInsets.symmetric(
                            horizontal: size.convert(context, 28)),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Container(
                              child: Text(
                                TranslationBase.of(context).login,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontFamily: "LatoRegular",
                                  fontSize: size.convert(context, 12),
                                ),
                              ),
                            ),
                            Icon(
                              Icons.arrow_forward_ios,
                              color: Colors.white,
                              size: size.convert(context, 14),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
//                  SizedBox(
//                    height: size.convert(context, 9),
//                  ),
//                  Divider(
//                    height: size.convert(context, 4),
//                    color: Colors.white,
//                  ),
//                  SizedBox(
//                    height: size.convert(context, 22),
//                  ),
//                  Container(
//                    child: GestureDetector(
//                      onTap: () {
//                        getIt<GlobalSingleton>().navigationKey.currentState.pop(context);
//                        getIt<GlobalSingleton>().navigationKey.currentState.push(
//                            context,
//                            PageTransition(
//                                type: PageTransitionType.rightToLeft,
//                                child: myDoctor()));
//                      },
//                      child: Container(
//                        margin: EdgeInsets.symmetric(
//                            horizontal: size.convert(context, 28)),
//                        child: Row(
//                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                          children: <Widget>[
//                            Container(
//                              child: Text(
//                                "My Doctors",
//                                style: TextStyle(
//                                  color: Colors.white,
//                                  fontFamily: "LatoRegular",
//                                  fontSize: size.convert(context, 12),
//                                ),
//                              ),
//                            ),
//                            Icon(
//                              Icons.arrow_forward_ios,
//                              color: Colors.white,
//                              size: size.convert(context, 14),
//                            )
//                          ],
//                        ),
//                      ),
//                    ),
//                  ),
//                  SizedBox(
//                    height: size.convert(context, 9),
//                  ),
//                  Divider(
//                    height: size.convert(context, 4),
//                    color: Colors.white,
//                  ),
//                  SizedBox(
//                    height: size.convert(context, 22),
//                  ),
//                  Container(
//                    child: GestureDetector(
//                      onTap: () {
//                        getIt<GlobalSingleton>().navigationKey.currentState.pop(context);
//                        getIt<GlobalSingleton>().navigationKey.currentState.push(
//                            context,
//                            PageTransition(
//                                child: familyProfile(),
//                                type: PageTransitionType.rightToLeft));
//                      },
//                      child: Container(
//                        margin: EdgeInsets.symmetric(
//                            horizontal: size.convert(context, 28)),
//                        child: Row(
//                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                          children: <Widget>[
//                            Container(
//                              child: Text(
//                                "Family Profiles",
//                                style: TextStyle(
//                                  color: Colors.white,
//                                  fontFamily: "LatoRegular",
//                                  fontSize: size.convert(context, 12),
//                                ),
//                              ),
//                            ),
//                            Icon(
//                              Icons.arrow_forward_ios,
//                              color: Colors.white,
//                              size: size.convert(context, 14),
//                            )
//                          ],
//                        ),
//                      ),
//                    ),
//                  ),

                ],),

                bottomSpace,
                _divider,
                upperSpace,
                Container(
                  child: InkWell(
                    onTap: () {
                      setState(() {
                        selectedIndex =5;
                      });
                      getIt<GlobalSingleton>().navigationKey.currentState.pop();
                      getIt<GlobalSingleton>().navigationKey.currentState.push(

                          PageTransition(
                              type: PageTransitionType.bottomToTop, child: Blog()));
                    },
                    child: Container(
                      height: size.convert(context, 30),
                      color: selectedIndex == 5 ? selectedIndexColor : Colors.transparent,
                      padding: EdgeInsets.symmetric(
                          horizontal: size.convert(context, 28)),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Container(
                            child: Row(
                              children: <Widget>[
                                SvgPicture.asset("assets/icons/blogger-b.svg"),
                                SizedBox(width: size.convertWidth(context, 8),),
                                Text(
                                  TranslationBase.of(context).viewBlog,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontFamily: "LatoRegular",
                                    fontSize: size.convert(context, 12),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Icon(
                            Icons.arrow_forward_ios,
                            color: Colors.white,
                            size: size.convert(context, 14),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
                bottomSpace,
                _divider,
                upperSpace,
                Container(
                    child: InkWell(
                      splashColor: selectedIndexColor,
                      onTap: () {
                        print("working....");
                        setState(() {
                          showLanguages = !showLanguages;
                        });
                      },

                        child: AnimatedContainer(
                          height: size.convert(context, 30),
                          duration: Duration(microseconds: 5),
                          margin: EdgeInsets.symmetric(
                              horizontal: size.convert(context, 28)),
                          child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Container(
                                    child: Row(
                                      children: <Widget>[
                                        SvgPicture.asset("assets/icons/awesome-language.svg"),
                                        SizedBox(width: size.convertWidth(context, 8),),
                                        Text(
                                          TranslationBase.of(context).language,
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontFamily: "LatoRegular",
                                            fontSize: size.convert(context, 12),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  //Image.asset(TranslationBase.of(context).selectedFlag),
                                  Row(
                                    children: <Widget>[
                                      Text(
                                        selectlanguage()??"",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontFamily: "LatoRegular",
                                          fontSize: size.convert(context, 12),
                                        ),
                                      ),
                                        SizedBox(width: size.convert(context, 3),),
                                      Image.asset(TranslationBase.of(context).selectedFlag),
                                      Icon(
                                        !showLanguages ?Icons.keyboard_arrow_down : Icons.keyboard_arrow_up,
                                        color: Colors.white,
                                        size: size.convert(context, 22),
                                      ),
                                    ],
                                  )
                                ],
                              ),
                        ),

                    ),
                  ),
                bottomSpace,
                _divider,
                showLanguages?upperSpace:SizedBox(height: 0,),
                showLanguages ? Container(
                  child: Column(children: <Widget>[
                    Container(
                      height: size.convert(context, 30),
                      color: selectedIndex==62?selectedIndexColor:Colors.transparent,
                      padding: EdgeInsets.symmetric(
                          horizontal: size.convert(context, 28)),
                      child: ScopedModelDescendant<AppModel>(
                        builder: (context, child, model) {
                          return InkWell(
                            splashColor: selectedIndexColor,
                            onTap: () {
                              setState(() {
                                selectedIndex = 62;
                              });
                              Future.delayed(Duration(seconds: 1),(){

                                //getIt<GlobalSingleton>().navigationKey.currentState.pop(context);
                                model.changeDirection("en");
                                _changeLang("en");
                                languageSelect.setLanguage("en");
                                Navigator.pushReplacement(context, PageTransition(
                                    child: HomePage(pref: false),type: PageTransitionType.fade
                                ));
                              },);
                            },
                            child: Container(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Text("English",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontFamily: "LatoRegular",
                                          fontSize: size.convert(context, 12),
                                        )),
                                    Image.asset(
                                        "assets/icons/enIcon.png"),
                                  ],
                                )),
                          );
                        },
                      ),
                    ),
                    bottomSpace,
                    _divider,
                    upperSpace,
                    Container(
                      height: size.convert(context, 30),
                      color: selectedIndex==63?selectedIndexColor:Colors.transparent,
                      padding: EdgeInsets.symmetric(
                          horizontal: size.convert(context, 28)),
                      child: ScopedModelDescendant<AppModel>(
                        builder: (context, child, model) {
                          return InkWell(
                            splashColor: selectedIndexColor,
                            onTap: () {
                              setState(() {
                                selectedIndex = 63;
                              });
                              Future.delayed(Duration(seconds: 1),(){
                                //getIt<GlobalSingleton>().navigationKey.currentState.pop(context);
                                model.changeDirection("ur");
                                languageSelect.setLanguage("ur");
                                _changeLang("pa");
                                Navigator.pushReplacement(context, PageTransition(
                                    child: HomePage(pref: false),type: PageTransitionType.fade
                                ));
                              },);
                            },
                            child: Container(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Text("پشتو",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontFamily: "LatoRegular",
                                          fontSize: size.convert(context, 12),
                                        )),
                                    Image.asset(
                                      "assets/icons/afhanflag.png",),
                                  ],
                                )
                            ),
                          );
                        },
                      ),
                    ),
                    bottomSpace,
                    _divider,
                    upperSpace,
                    Container(
                      height: size.convert(context, 30),
                      color: selectedIndex==61?selectedIndexColor:Colors.transparent,
                      padding: EdgeInsets.symmetric(
                          horizontal: size.convert(context, 28)),
                      child: ScopedModelDescendant<AppModel>(
                        builder: (context, child, model) {
                          return InkWell(
                            splashColor: selectedIndexColor,
                            onTap: () {
                              setState(() {
                                selectedIndex = 61;
                              });
                              Future.delayed(Duration(seconds: 1),(){
                                //getIt<GlobalSingleton>().navigationKey.currentState.pop(context);
                                model.changeDirection("ar");
                                languageSelect.setLanguage("ar");
                                _changeLang("fa");
                                Navigator.pushReplacement(context, PageTransition(
                                    child: HomePage(pref: false),type: PageTransitionType.fade
                                ));
                              },);
                            },
                            child: Container(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Text("دری",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontFamily: "LatoRegular",
                                          fontSize: size.convert(context, 12),
                                        )),
                                    Image.asset("assets/icons/afhanflag.png"),
                                  ],)
                            ),
                          );
                        },
                      ),
                    ),
                    bottomSpace,
                    _divider,
                    upperSpace,
                  ],),
                ):Container(),
               showLanguages?SizedBox():upperSpace,
                FutureBuilder(
                  future: UserModel.getUserId,
                  builder: (context, snapshot) {
                    if(snapshot.data==null) return Container();
                    return Column(
                      children: <Widget>[
                        Container(
                          child: InkWell(

                            onTap: () {
                              setState(() {
                                selectedIndex = 7;
                              });

                              _logout();
                            },
                            child: Container(
                              height: size.convert(context, 30),
                              color: selectedIndex == 7 ? selectedIndexColor : Colors.transparent,
                              padding: EdgeInsets.symmetric(
                                  horizontal: size.convert(context, 28)),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Container(
                                    child: Row(
                                      children: <Widget>[
                                        SvgPicture.asset("assets/icons/account-logout.svg"),
                                        SizedBox(width: size.convertWidth(context, 8),),
                                        Text(
                                          TranslationBase.of(context).logout,
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontFamily: "LatoRegular",
                                            fontSize: size.convert(context, 12),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Icon(
                                    Icons.arrow_forward_ios,
                                    color: Colors.white,
                                    size: size.convert(context, 14),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                        bottomSpace,
                        _divider,
                        upperSpace,
                      ],
                    );
                  }
                ),

              ],
            );
          }
        ),
      ),
    );
  }

  String selectlanguage(){
    if(TranslationBase.of(context).selectLanguage == "en"){
      return TranslationBase.of(context).english;
    }
    else if(TranslationBase.of(context).selectLanguage=="ar"){
      return TranslationBase.of(context).dari;
    }
    else if(TranslationBase.of(context).selectLanguage=="ur"){
      return TranslationBase.of(context).pashto;
    }
  }

  Widget _userProfile() {
    return  FutureBuilder<UserModel>(
        future: UserModel().fromPrefs(),
        builder: (context, snapshot) {
          if (snapshot.data == null || snapshot.data == "") return Container(
            width: size.convert(context, 45),
            height: size.convert(context, 45),
          );

          UserModel userModel = snapshot.data;

          return Column(
            children: <Widget>[
              Container(
                margin:
                EdgeInsets.symmetric(
                    horizontal: size.convertWidth(context, 45)),
                child: Row(
                  children: <Widget>[
                    Container(
                      child: circularImage(
                          imageUrl: "$USER_IMAGE_URL${userModel.pic}",
                          h: size.convert(context, 45),
                          w: size.convert(context, 45)),
                    ),
                    SizedBox(
                      width: size.convert(context, 5),
                    ),
                    Container(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Container(
                            child: RichText(
                              text: TextSpan(
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: size.convert(context, 12),
                                    fontFamily: "LatoItalic",
                                  ),
                                  text: userModel?.name??"Name not provided"),
                            ),
                          ),
                          SizedBox(
                            height: size.convert(context, 5),
                          ),
                          Container(
                            child: RichText(
                              text: TextSpan(
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: size.convert(context, 10),
                                    fontFamily: "LatoReglar",
                                  ),
                                  text: userModel?.phone),
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
              SizedBox(
                height: size.convert(context, 10),
              ),
              Container(
                child: LinearPercentIndicator(
                  //fillColor: Colors.green,
                  progressColor: Colors.green,
                  //linearStrokeCap: LinearStrokeCap.round,
                  width: size.convertWidth(context, 209),
                  lineHeight: size.convert(context, 11),
                  percent: userModel?.name!=null && userModel?.name!=""?1.0:0.0,
                  backgroundColor: Colors.white,
                  alignment: MainAxisAlignment.center,
                  trailing: Text(
                    userModel?.name!=null && userModel?.name!=""?"100%":"0%",
                    style: TextStyle(
                      fontFamily: "LatoRegular",
                      fontSize: size.convert(context, 10),
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: size.convert(context, 24),
              ),
              Container(
                child: userModel?.name==null || userModel?.name==""? InkWell(
                  onTap: () {
                    getIt<GlobalSingleton>().navigationKey.currentState.pop();
                    getIt<GlobalSingleton>().navigationKey.currentState.push(

                        PageTransition(
                            child: updateProfile(),
                            type: PageTransitionType.rightToLeft));
                  },
                  child: Container(
                    width: size.convert(context, 160),
                    height: size.convert(context, 35),
                    padding: EdgeInsets.all(size.convert(context, 10)),
                    decoration: BoxDecoration(
                        color: Colors.transparent,
                        borderRadius: BorderRadius.circular(
                            size.convert(context, 5)),
                        border: Border.all(color: Color(0xff5fe5bc), width: 1)),
                    child: Center(
                      child: Text(
                        "Complete your profile",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: size.convert(context, 12),
                          fontFamily: "LatoRegular",
                        ),
                      ),
                    ),
                  ),
                ):SizedBox(),
              ),
            ],
          );

        });

  }

  _logout(){
    getIt<GlobalSingleton>().navigationKey.currentState.pop();
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
            child: Container(
              height: size.convert(context, size.convert(context, 157)),
              width: size.convertWidth(context, 334),
              child: Column(
                children: <Widget>[
                  SizedBox(
                    height: size.convert(context, 26),
                  ),
                  Text(
                    TranslationBase.of(context).logout,
                    style: TextStyle(
                      fontSize: size.convert(context, 14),
                      fontFamily: "LatoBold",
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(
                    height: size.convert(context, 18),
                  ),
                  Text(
                    TranslationBase.of(context).logoutConfirmMessage,
                    style: TextStyle(
                      color: portionColor,
                      fontFamily: "LatoRegular",
                      fontSize: size.convert(context, 12),
                    ),
                  ),
                  SizedBox(
                    height: size.convert(context, 24),
                  ),
                  Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Container(
                          child: GestureDetector(
                            onTap: () {
                              print("press Confirm Logout");
//                              Navigator.pop(context);
                              UserModel.logout(context);

                            },
                            child: Container(
                              width: size.convertWidth(context, 87),
                              height: size.convert(context, 35),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(
                                      size.convert(context, 5)),
                                  border:
                                      Border.all(width: 1, color: buttonColor)),
                              child: Center(
                                child: Text(
                                  TranslationBase.of(context).yes,
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: size.convert(context, 12),
                                    fontFamily: "LatoRegular",
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: size.convertWidth(context, 26),
                        ),
                        Container(
                          child: InkWell(
                            onTap: () {
                              print("press No Logout");
                              getIt<GlobalSingleton>().navigationKey.currentState.pop(context);

                            },
                            child: Container(
                              width: size.convertWidth(context, 87),
                              height: size.convert(context, 35),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(
                                      size.convert(context, 5)),
                                  border:
                                      Border.all(width: 1, color: buttonColor)),
                              child: Center(
                                child: Text(
                                  TranslationBase.of(context).no,
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: size.convert(context, 12),
                                    fontFamily: "LatoRegular",
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          );
        });
  }

    /// ur customize for pashto
    /// ar customize for persian
    /// en customize fot english

_changeLang(String lang) async {
    String userId = await UserModel.getUserId;
   Map postBody ={
     "user_type":"user",
     "lang_type":lang,
     "id":userId
   };

    if(userId!=null){
      var response = await simpleApi().post(url: CHANGE_LANG, body: postBody);
      print(response.toString());
    }
    print(CHANGE_LANG);
    print(postBody);


}
}
