import 'package:dio/dio.dart';
import 'package:doctor_app/api/api.dart';
import 'package:doctor_app/api/api_name.dart';
import 'package:doctor_app/error/snackbar.dart';
import 'package:doctor_app/getIt.dart';
import 'package:doctor_app/model/family/family_profile_list.dart';
import 'package:doctor_app/model/family/family_profile_model.dart';
import 'package:doctor_app/model/user_model.dart';
import 'package:doctor_app/pages/drawerMenu/addNewProfile.dart';
import 'package:doctor_app/repeatedWidgets/CustomAppBar.dart';
import 'package:doctor_app/repeatedWidgets/loading.dart';
import 'package:doctor_app/singleton/global.dart';
import 'package:doctor_app/transulation/translations_delegate_base.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:icofont_flutter/icofont_flutter.dart';
import 'package:doctor_app/res/size.dart';
import 'package:doctor_app/res/color.dart';
import 'package:page_transition/page_transition.dart';

class familyProfile extends StatefulWidget {
  @override
  _familyProfileState createState() => _familyProfileState();
}

class _familyProfileState extends State<familyProfile> {
  final GlobalKey<ScaffoldState> _scaffoldkey = new GlobalKey<ScaffoldState>();
  bool ismale = true;
  bool isself = true;
  int currentPage = 1;

  FamilyListModel _familyListModel;
  bool firstServerCallSuccess = false;

  ScrollController _scrollController = ScrollController();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    print("getting data again");
    _getFamilyList(VIEW_ALL_FAMILY_MEMBER_URL, reset: true);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _scrollController.addListener(() {
      if (_scrollController.position.atEdge) {
        if (_scrollController.position.pixels == 0) {
          //top
        } else {
          print("Reached bottom of list view");
          //bottom
          if (_familyListModel != null && _familyListModel.nextPageUrl != null) {
            print("_familyListModel is not  null");
            Uri uri = Uri.parse(_familyListModel.nextPageUrl);

            if (int.parse(uri.queryParameters['page'].toString()) > currentPage) {
              print("_familyListModel has more list Current Page $currentPage");
              currentPage = int.parse(uri.queryParameters['page'].toString());
              _getFamilyList(_familyListModel.nextPageUrl);
            } else {
              print("_familyListModel has NO more list Current Page $currentPage");
            }
          } else {
            print("_familyListModel or next url is NULL");
          }
        }
      }
    });
  }

  _getFamilyList(String url, {bool reset = false}) async {
    if (!firstServerCallSuccess) {
      _familyListModel = await FamilyListModel.getFamilyProfile();
      setState(() {});
    }

    String tempUserId = await UserModel.getUserId;
    int userId = int.parse(tempUserId);

    Map body = {'user_id': userId};
    var response = await API(context: context, scaffold: _scaffoldkey, showSnackbarForError: true)
        .post(url: url, body: body);

    if (response == NO_CONNECTION) {
      CustomSnackBar.SnackBarInternet(_scaffoldkey, context, btnFun: () {
        _getFamilyList(url);
      });
      return;
    }

    if (response is Response) {
      if (_familyListModel == null || reset || !firstServerCallSuccess) {
        _familyListModel = FamilyListModel.fromJson(response.data);
        FamilyListModel.saveFamilyProfile(response.data);
        firstServerCallSuccess = true;
      } else {
        FamilyListModel _dummyModel = FamilyListModel.fromJson(response.data);
        _familyListModel.currentPage = _dummyModel.currentPage;
        _familyListModel.nextPageUrl = _dummyModel.nextPageUrl;
        _familyListModel.familiesModel.addAll(_dummyModel.familiesModel);
      }
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size1 = MediaQuery.of(context).size;
    return Scaffold(
      key: _scaffoldkey,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(size1.longestSide * 0.15666178),
        child: CustomAppBar(
          hight: size1.longestSide * 0.15666178,
          paddingBottom: size.convert(context, 15),
          parentContext: context,
          color1: Color(0xff1C80A0),
          color2: Color(0xff35D8A6),
          //trailingIcon: _trailing(),
          centerWigets: _logo(),
          leadingIcon: _leadingIcon(),
          trailingIcon: Container(
            child: GestureDetector(
              onTap: () {
                print("Add New Profile");
                getIt<GlobalSingleton>().navigationKey.currentState.push(
                      PageTransition(
                          type: PageTransitionType.leftToRight,
                          child: addNewProfile(
                            key: UniqueKey(),
                            buttonText: TranslationBase.of(context).createProfile,
                          )),
                    );
              },
              child: _trailingWidget(),
            ),
          ),
        ),
      ),
      body: _body(),
      //drawer: openDrawer(),
    );
  }

  _body() {
    return ListView.separated(
        padding: EdgeInsets.zero,
        itemBuilder: (context, index) {
          return customTile(_familyListModel.familiesModel[index]);
        },
        separatorBuilder: (context, index) => SizedBox(
              height: 10,
            ),
        controller: _scrollController,
        itemCount: _familyListModel?.familiesModel?.length ?? 0);
  }

  customTile(FamilyProfileModel profileModel) {
    print(profileModel?.pPhoto ?? "this is null");
    print(FAMILY_IMAGE_URL + profileModel.pPhoto);
//    print(FAMILY_IMAGE_URL + profileModel.pPhoto);
    return GestureDetector(
      onTap: () {
        print("Update Profile");
        getIt<GlobalSingleton>().navigationKey.currentState.push(
              PageTransition(
                  type: PageTransitionType.leftToRight,
                  child: addNewProfile(
                    key: UniqueKey(),
                    buttonText: TranslationBase.of(context).updateProfile,
                    profileModel: profileModel,
                  )),
            );
      },
      child: Container(
        padding: EdgeInsets.only(
          top: size.convert(context, 12),
          bottom: size.convert(context, 12),
          left: size.convert(context, 22),
          right: size.convert(context, 22),
        ),
        color: portionColor.withOpacity(0.05),
        child: Stack(
          fit: StackFit.loose,
          children: <Widget>[
            Row(
              children: <Widget>[
                Container(
                  width: size.convert(context, 62),
                  height: size.convert(context, 62),
                  decoration: BoxDecoration(color: Colors.blue, shape: BoxShape.circle),
                  child: profileModel?.pPhoto == null ||
                          profileModel?.pPhoto == "" ||
                          profileModel?.pPhoto == "female.png" ||
                          profileModel?.pPhoto == "male.png"
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(200),
                          child: profileModel.gender == 1
                              ? Image.asset(
                                  "assets/icons/maleIcon.png",
                                  fit: BoxFit.cover,
                                )
                              : Image.asset(
                                  "assets/icons/femaleIcon.png",
                                  fit: BoxFit.cover,
                                ))
                      : ClipRRect(
                          borderRadius: BorderRadius.circular(200),
                          child: Image.network(
                            FAMILY_IMAGE_URL + profileModel.pPhoto,
                            fit: BoxFit.cover,
                          )),
                ),
                SizedBox(
                  width: size.convert(context, 16),
                ),
                Expanded(
                  child: Container(
                    child: Column(
                      //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            Expanded(
                              child: Text(
                                profileModel?.pName ?? "",
                                style: TextStyle(
                                  fontFamily: "LatoRegular",
                                  fontSize: size.convert(context, 12),
                                  color: portionColor,
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: size.convert(context, 10),
                        ),
                        Text(
                          profileModel?.pRelation ?? "",
                          style: TextStyle(
                            fontFamily: "LatoRegular",
                            fontSize: size.convert(context, 12),
                            color: portionColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            TranslationBase.of(context).position == "right"
                ? Align(
                    alignment: Alignment.centerLeft,
                    child: profileModel.deleting
                        ? Center(
                            child: Loading(),
                          )
                        : IconButton(
                            padding: EdgeInsets.zero,
                            icon: Icon(Icons.delete_outline),
                            color: Colors.red[700],
                            iconSize: size.convert(context, 24),
                            onPressed: () {
                              deleteRecordDialog(profileModel);
                            },
                          ),
                  )
                : Align(
                    alignment: Alignment.centerRight,
                    child: profileModel.deleting
                        ? Center(
                            child: Loading(),
                          )
                        : IconButton(
                            padding: EdgeInsets.zero,
                            icon: Icon(Icons.delete_outline),
                            color: Colors.red[700],
                            iconSize: size.convert(context, 24),
                            onPressed: () {
                              deleteRecordDialog(profileModel);
                            },
                          ),
                  ),
          ],
        ),
      ),
    );
  }

  _logo() {
    return Container(
      child: Text(
        TranslationBase.of(context).familyProfile,
        style: TextStyle(
          fontSize: size.convert(context, 14),
          fontFamily: "LatoRegular",
          color: appBarIconColor,
        ),
      ),
    );
  }

  _leadingIcon() {
    return Container(
      child: GestureDetector(
        onTap: () {
          getIt<GlobalSingleton>().navigationKey.currentState.pop(context);
        },
        child: Icon(
          IcoFontIcons.longArrowLeft,
          color: appBarIconColor,
          size: size.convert(context, 25),
        ),
      ),
    );
  }

  _trailingWidget() {
    return Container(
      child: Text(
        TranslationBase.of(context).addNewProfile + " +",
        style: TextStyle(
          color: appBarIconColor,
          fontSize: size.convert(context, 12),
          fontFamily: "LatoRegular",
        ),
      ),
    );
  }

  deleteRecordDialog(FamilyProfileModel profile) {
    //getIt<GlobalSingleton>().navigationKey.currentState.pop(context);
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
                    TranslationBase.of(context).deleteRecord,
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
                    TranslationBase.of(context).comfirmMessageDeleteRecord,
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
                              _deleteFamilyMember(profile);
                              Navigator.pop(context);
                            },
                            child: Container(
                              width: size.convertWidth(context, 87),
                              height: size.convert(context, 35),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(size.convert(context, 5)),
                                  border: Border.all(width: 1, color: buttonColor)),
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
                              Navigator.pop(context);
                            },
                            child: Container(
                              width: size.convertWidth(context, 87),
                              height: size.convert(context, 35),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(size.convert(context, 5)),
                                  border: Border.all(width: 1, color: buttonColor)),
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

  void _deleteFamilyMember(FamilyProfileModel profile) async {
    setState(() {
      profile.deleting = true;
    });

    // print("deleted id = "+profile.patientID);

    var response = await API(scaffold: _scaffoldkey, context: context, showSnackbarForError: true)
        .post(url: DELETE_FAMILY_PROFILE_URL, body: {'family_member_id': profile.patientID});

    setState(() {
      profile.deleting = false;
    });

    if (response == NO_CONNECTION) {
      CustomSnackBar.SnackBarInternet(_scaffoldkey, context, btnFun: () {
        _deleteFamilyMember(profile);
      });
      return;
    }

    if (response is Response) {
      CustomSnackBar.SnackBar_3Success(_scaffoldkey,
          title: TranslationBase.of(context).familyProfileDeleted);
      _familyListModel.familiesModel.remove(profile);

      FamilyListModel.saveFamilyProfile(_familyListModel.toJson());
    }
  }
}
