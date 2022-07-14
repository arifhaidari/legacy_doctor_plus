import 'dart:convert';
import 'package:connectivityswift/connectivityswift.dart';
import 'package:url_launcher/url_launcher.dart' as urlLauncher;
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:doctor_app/api/api.dart';
import 'package:doctor_app/api/api_name.dart';
import 'package:doctor_app/error/snackbar.dart';
import 'package:doctor_app/model/district.dart';
import 'package:doctor_app/model/doctor/doctor_model.dart';
import 'package:doctor_app/model/doctor_speciality_model.dart';
import 'package:doctor_app/model/pending_feedback_model.dart';
import 'package:doctor_app/model/specaility/specailty.dart';
import 'package:doctor_app/model/specaility/speciality_list.dart';
import 'package:doctor_app/model/user_model.dart';
import 'package:doctor_app/pages/notification/notificaionList.dart';
import 'package:doctor_app/repeatedWidgets/CustomDrawer.dart';
import 'package:doctor_app/repeatedWidgets/doctorFeedback.dart';
import 'package:doctor_app/repeatedWidgets/loading.dart';
import 'package:doctor_app/repeatedWidgets/notificationIcon.dart';
import 'package:doctor_app/res/size.dart';
import 'package:doctor_app/singleton/global.dart';
import 'package:doctor_app/singleton/globalProviderClass.dart';
import 'package:doctor_app/testloader.dart';
import 'package:doctor_app/transulation/my_app.dart';
import 'package:flutter/foundation.dart';
import 'package:icofont_flutter/icofont_flutter.dart';
import 'package:doctor_app/pages/Login.dart';
import 'package:doctor_app/pages/blog.dart';
import 'package:doctor_app/pages/doctorList.dart';
import 'package:doctor_app/repeatedWidgets/CustomAppBar.dart';
import 'package:doctor_app/repeatedWidgets/CustomBottomAppBar.dart';
import 'package:doctor_app/repeatedWidgets/CustomTextField.dart';
import 'package:doctor_app/res/color.dart';
import 'package:doctor_app/customeCache.dart';
import 'package:doctor_app/transulation/scope_model_wrapper.dart';
import 'package:doctor_app/transulation/translations_delegate_base.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';

import '../getIt.dart';
import 'doctorDetail.dart';
import 'medicalRecord.dart';
import 'myAppointment.dart';

class HomePage extends StatefulWidget {
  bool pref;
  HomePage({this.pref = true});
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Stream<FileResponse> fileStream;
  //CustomCacheManager customCacheManager ;
  List<SpecialityModel> specailityList;

  double rating = 0.5;
  //int select = 1;
  bool districitExpand = true;
  List<DistrictModel> _districts = [];

  DoctorSpecialityModel doctorSpecialityModel;
  DoctorSpecialityModel doctorSpecialitySearchModel;
  int seletedDistricitId = 0;
  TextEditingController _textEditingController = TextEditingController();
  final GlobalKey<ScaffoldState> _scaffoldkey = new GlobalKey<ScaffoldState>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print("Init Home");
    Connectivityswift().onConnectivityChanged.listen((status) {
      print("this is connectivity status = ${status}");
      if (ConnectivityResult.mobile == status || ConnectivityResult.wifi == status) {
        Future.delayed(Duration.zero, () {
          getDoctorAndSpeciality(context, pref: widget.pref);
          getSpecialityList(context);
          //getDistricts(context);
        });
        getPendingFeedback();
      }
    });

    _textEditingController.addListener(_searchInput);

    Future.delayed(Duration.zero, () {
      getDoctorAndSpeciality(context, pref: widget.pref);
      getSpecialityList(context);
      //getDistricts(context);
    });

    getPendingFeedback();
//
  }

  getPendingFeedback() async {
    String temp = await UserModel.getUserId;
    int userID = int.parse(temp);
    if (!kReleaseMode) {
      //userID = '121';
    }
    var response = await API(context: context, showSnackbarForError: true, scaffold: _scaffoldkey)
        .post(url: PENDING_FEEDBACK_URL, body: {'user_id': userID});
    if (response == NO_CONNECTION) {
      CustomSnackBar.SnackBarInternet(_scaffoldkey, context, btnFun: getSpecialityList);
      return;
    }
    if (response is Response) {
      print("Pending Feedback ${response.data}");
      PendingFeedbackModel model;
      response.data.forEach((json) {
        model = PendingFeedbackModel.fromJson(json);
      });
      if (model != null) {
        showfeedback(model);
      }
    }
  }

  _searchInput() {
    if (_textEditingController.text.length >= 3 && doctorSpecialityModel != null) {
      doctorSpecialitySearchModel = DoctorSpecialityModel();
      doctorSpecialitySearchModel.specialitys = doctorSpecialityModel.specialitys
          .where((speciality) => speciality.specialityName
              .toLowerCase()
              .contains(_textEditingController.text.toLowerCase()))
          .toList();
      doctorSpecialitySearchModel.doctors = doctorSpecialityModel.doctors
          .where((doctor) =>
              doctor.doctorName.toLowerCase().contains(_textEditingController.text.toLowerCase()))
          .toList();
      doctorSpecialitySearchModel.allClinicHospital = doctorSpecialityModel.allClinicHospital
          .where((clinic) =>
              clinic.name.toLowerCase().contains(_textEditingController.text.toLowerCase()))
          .toList();
    } else {
      doctorSpecialitySearchModel = null;
    }
    setState(() {});
  }

  getDoctorAndSpeciality(BuildContext context, {bool pref = true}) async {
    Map<String, dynamic> check = await DoctorSpecialityModel.doctorSpectialityCitygetFromPrefs();
    if (pref && check != null && check.isNotEmpty) {
      doctorSpecialityModel = DoctorSpecialityModel.fromJson(
          await DoctorSpecialityModel.doctorSpectialityCitygetFromPrefs());
      print("....................................");
      print(check);
      print(await DoctorSpecialityModel.doctorSpectialityCitygetFromPrefs());
      print("....................................");
      getDistricts(context);
    } else {
      var response = await API(context: context, showSnackbarForError: true, scaffold: _scaffoldkey)
          .get(url: SPECIALITY_DOCTOR_URL + "/en");
      // .get(url: SPECIALITY_DOCTOR_URL + "/${TranslationBase.of(context).Langkey}");

      if (response == NO_CONNECTION) {
        CustomSnackBar.SnackBarInternet(_scaffoldkey, context, btnFun: getDoctorAndSpeciality);
        return;
      }

      if (response is Response) {
        DoctorSpecialityModel.doctorSpectialityCitysaveInPrefs(response.data);
        doctorSpecialityModel = DoctorSpecialityModel.fromJson(response.data);
        print(response.data);
        getDistricts(context);
        if (mounted) setState(() {});
      }
    }
  }

  getSpecialityList(BuildContext context) async {
    //CustomCacheManager().emptyCache();
    //print(SPECIALITY_DOCTOR_URL+"/${TranslationBase.of(context).Langkey}");
    var file = CustomCacheManager()
        .getSingleFile(SPECIALITY_URL + "/${TranslationBase.of(context).Langkey}", headers: {
      SECRET_KEY: SECRET_VALUE,
      "Content-Type": "application/json",
    });
    if (file != null) {
      var res = file.asStream();
      specailityList = [];
      res.forEach((action) async {
        print(".......................fffffff....................");
        var data = await action.readAsString();
        Map valueMap = json.decode(data);
        print(valueMap);
        if (specailityList.isEmpty) {
          valueMap["specialitys"].forEach((item) {
            specailityList.add(SpecialityModel.fromJson(item));
          });
        }
        print(specailityList[0].specialityName);
        print("length of specailityList = ${specailityList.length}");
        setState(() {});
        print(".......................fffffff....................");
      });
    }
//    List getFromPrefs = await SpecialityModel.getFromPrefs();
//    specailityList = [];
//    getFromPrefs.forEach((json) {
//      specailityList.add(SpecialityModel.fromJson(json));
//    });

//    var response = await API(
//            context: context,
//            showSnackbarForError: true,
//            scaffold: _scaffoldkey)
//        .get(url: SPECIALITY_URL);
//
//    if (response == NO_CONNECTION) {
//      CustomSnackBar.SnackBarInternet(_scaffoldkey, context,
//          btnFun: getDistricts);
//      return;
//    }
//
//    if (response is Response) {
////      _specialityListModel = SpecialityListModel.fromJson(response.data);
//      specailityList = [];
//      if (response.data['specialitys'] is List) {
//        response.data['specialitys'].forEach(
//            (rawJson) => specailityList.add(SpecialityModel.fromJson(rawJson)));
//        SpecialityModel.saveSpecialtyList(response.data['specialitys']);
//
////        fileStream.map((convert){
////          print("image url= ${convert.}");
////        });
//
//      }
//      if (mounted) setState(() {});
//    }
  }

  getDistricts(BuildContext context) async {
    ///For Offline
    // List getFromPrefs = await DistrictModel.getFromPrefs();
    _districts = [];
    _districts.add(DistrictModel(id: -1, districtName: TranslationBase.of(context).select_City));
    seletedDistricitId = -1;
    doctorSpecialityModel.city.forEach((f) {
      _districts.add(f);
    });

//    if(getFromPrefs != null){
//      getFromPrefs.forEach((json) {
//        _districts.add(DistrictModel.fromJson(json));
//      });
//      if (!mounted) return;
//      setState(() {});
//    }
//
//    else{
//      _districts = [];
//    _districts.add(DistrictModel(
//        id: -1, districtName: TranslationBase.of(context).select_City));
//       doctorSpecialityModel.city.forEach((v){
//         _districts.add(v);
//       });
//      DistrictModel.saveInPrefs(doctorSpecialityModel.city);
//      //_districts.add(doctorSpecialityModel.city.map((v) =>v.toJson()).toList());
//    }

    if (_districts.firstWhere((item) => item.id == seletedDistricitId, orElse: () => null) ==
        null) {
      ///the selected district no found in refetched data
      ///reset selected
      seletedDistricitId = -1;
    }

    ///--For Offline

//    var response = await API(
//            context: context,
//            showSnackbarForError: true,
//            scaffold: _scaffoldkey)
//        .get(url: DISTRICT_URL +"/${TranslationBase.of(context).getDistrict}");
//
//    if (response == NO_CONNECTION) {
//      CustomSnackBar.SnackBarInternet(_scaffoldkey, context,
//          btnFun: getDistricts);
//      return;
//    }

//    if (doctorSpecialityModel.city is List) {
//      _districts = [];
//      //if (!mounted) return;
//      _districts.add(DistrictModel(
//
//
//      if (response.data is List) {
//        response.data.forEach((json) {
//          _districts.add(DistrictModel.fromJson(json));
//        });
//
//        DistrictModel.saveInPrefs(response.data);
//      }
//
//      if (mounted) setState(() {});
//    }
  }

  @override
  void dispose() {
    super.dispose();
    _textEditingController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print("Home");
    Size size1 = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: Scaffold(
        key: _scaffoldkey,
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(size1.longestSide * 0.15666178),
          child: CustomAppBar(
            isbottomLine: true,
            hight: size1.longestSide * 0.15666178,
            parentContext: context,
            color1: Color(0xff1C80A0),
            color2: Color(0xff35D8A6),
            trailingIcon: Container(
              child: NotificationIcon(lightColor: false),
            ),
            centerWigets: _logo(),
            leadingIcon: _leadingIcon(),
          ),
        ),
        body: SingleChildScrollView(
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: Stack(
              children: <Widget>[
                _body(context),
                districitExpand ? Container() : _Locationshow(),
                _searchShow(),
              ],
            ),
          ),
        ),
        bottomNavigationBar: CustomBottomBar(
          select: 1,
        ),
        floatingActionButton: Container(
          child: GestureDetector(
            onTap: () {
              print("floatingActionButton");
            },
            child: Container(
              padding: EdgeInsets.only(right: 10),
              height: size.convert(context, 83),
              width: size.convert(context, 83),
              child: FloatingActionButton(
                backgroundColor: Color(0xff19769F),
                elevation: 25,
                onPressed: detailPad,
                child: Padding(
                  padding: const EdgeInsets.all(1.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Icon(
                        Icons.call,
                        size: size.convert(context, 10),
                      ),
                      SizedBox(width: size.convert(context, 5)),
                      Text(
                        TranslationBase.of(context).helpLine,
                        style: TextStyle(
                            fontFamily: "LatoRegular",
                            fontSize: size.convert(context, 10),
                            color: Colors.white),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
        drawer: Container(
          width: size.convertWidth(context, 350),
          child: openDrawer(),
        ),
      ),
    );
  }

  showfeedback(PendingFeedbackModel model) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
            backgroundColor: Colors.transparent,
            child: SingleChildScrollView(
              child: doctorFeedback(
                context: context,
                rating: rating,
                feedbackModel: model,
              ),
            ),
          );
        });
  }

  _body(BuildContext context) {
    Size size1 = MediaQuery.of(context).size;
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          SizedBox(
            height: size.convert(context, 20),
          ),
//          Container(
//           // color: Colors.red,
//            margin: EdgeInsets.symmetric(horizontal: size.convert(context, 30)),
//            child: Row(
//              crossAxisAlignment: CrossAxisAlignment.start,
//              children: <Widget>[
//                Container(
//                  //color:Colors.red,
////                  child: Image.asset("assets/icons/Map_1614.png",
////                    height: size.convert(context, 24),),
////                  child: SvgPicture.asset(
////                    "assets/icons/mapMark.svg",
////                    height: size.convert(context, 40),
////                    width: size.convert(context, 40),
////                  ),
//                ),
//                SizedBox(
//                  width: size.convert(context, 5),
//                ),
//                Expanded(
//                  child: Container(
//                    child: RichText(
//                      textAlign: TextAlign.center,
//                      text: TextSpan(
//                          text: TranslationBase.of(context).your_location,
//                          style: TextStyle(
//                              color: logoColor, fontFamily: "LatoRegular",
//                          fontSize: size.convert(context, 22),
//                          fontWeight: FontWeight.bold)),
//                    ),
//                  ),
//                ),
//              ],
//            ),
//          ),
//          SizedBox(
//            height: size.convert(context, 10),
//          ),
          Container(
            padding: EdgeInsets.only(left: size.convert(context, 5)),
            margin: EdgeInsets.symmetric(horizontal: size.convert(context, 30)),
            //color: Colors.red,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Container(
                  child: RichText(
                    text: TextSpan(
                      text: "",
                      style: TextStyle(
                        color: Colors.black,
                        fontFamily: "LatoRegular",
                        fontSize: size.convert(context, 14),
                        //    decoration: TextDecoration.underline
                      ),
                    ),
                  ),
                ),
                _districts == null
                    ? SizedBox(width: 18, height: 18, child: FittedBox(child: Loading()))
                    : Container(
                        child: GestureDetector(
                          onTap: () {
                            print("show drop down manu");
                            setState(() {
                              districitExpand = !districitExpand;
                            });
                          },
                          child: Container(
                            //color: Colors.yellow,
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
//                                RichText(
//                                  text: TextSpan(
//                                      text: TranslationBase.of(context).yourSelectedProvince ,
//                                      style: TextStyle(
//                                          color: Colors.black,
//                                          fontFamily: "LatoRegular",
//                                          fontSize: size.convert(context, 16))),
//                                ),
                                RichText(
                                  text: TextSpan(
                                      text: _districts
                                              .firstWhere(
                                                  (district) => district.id == seletedDistricitId,
                                                  orElse: () => null)
                                              ?.districtName ??
                                          "",
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontFamily: "LatoRegular",
                                          fontSize: size.convert(context, 16))),
                                ),
                                Icon(
                                  Icons.keyboard_arrow_down,
                                  size: size.convert(context, 20),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
              ],
            ),
          ),
          SizedBox(
            height: size.convert(context, 20),
          ),
          // doctorSpecialityModel == null
          //     ? Center(child: Loading())
          //     :
          Container(
            margin: EdgeInsets.symmetric(horizontal: size.convert(context, 30)),
            height: size.convert(context, 50),
            child: CustomTextField(
              iconWidget: Icon(
                IcoFontIcons.search2,
                size: 17,
              ),
//                    Image.asset(
//                      "assets/icons/searchIcon.png",
//                    ),
              color1: buttonColor,
              textEditingController: _textEditingController,
              hints: TranslationBase.of(context).searchTitle,
            ),
          ),
          SizedBox(
            height: size.convert(context, 20),
          ),
          Container(
            margin: EdgeInsets.symmetric(horizontal: size.convert(context, 30)),
            child: specailityList == null
                ? Center(
                    child: Loading(),
                  )
                : StaggeredGridView.countBuilder(
                    crossAxisCount: 3,
//                  itemCount: _specialityListModel?.specialitys?.length ?? 0,
                    itemCount: specailityList?.length ?? 0,
                    physics: ScrollPhysics(),
                    shrinkWrap: true,
                    itemBuilder: (BuildContext context, int index) {
                      SpecialityModel specialityModel = specailityList[index];
                      return Container(
                        child: GestureDetector(
                          onTap: () {
                            _navigateOnSpecailityTap(specialityModel);
                          },
                          child: Container(
                            // width: 120,
                            height: size.convert(context, 90),
                            decoration: BoxDecoration(
                                border:
                                    Border.all(width: size.convert(context, 1), color: buttonColor),
                                borderRadius: BorderRadius.circular(size.convert(context, 5))),
                            child: Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  CachedNetworkImage(
                                    height: size.convert(context, 30),
                                    imageUrl: SPECIALITY_IMAGE_URL + (specialityModel?.photo ?? ""),
                                    // placeholder: (context, url) => CircularProgressIndicator(),
                                    // errorWidget: (context, url, error) => Icon(Icons.error),
                                  ),
//                                  Image.network(
//                                    SPECIALITY_IMAGE_URL +
//                                        (specialityModel?.photo ?? ""),
//                                    height: size.convert(context, 30),
//                                  ),
//                                Image.asset(
//                                  specialityModel?.photo??"",
//
//                                  height: size.convert(context, 30),
//                                ),
                                  SizedBox(
                                    height: size.convert(context, 10),
                                  ),
                                  Container(
                                    child: RichText(
                                        textAlign: TextAlign.center,
                                        text: TextSpan(children: [
                                          TextSpan(
                                            text: specialityModel?.specialityName ?? '',
                                            style: TextStyle(
                                                fontSize: size.convert(context, 8),
                                                color: Color(0xff7e7e7e),
                                                fontFamily: "LatoRegular"),
                                          ),
                                        ])),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                    staggeredTileBuilder: (int index) => new StaggeredTile.fit(1),
                    mainAxisSpacing: size.convert(context, 10),
                    crossAxisSpacing: size.convert(context, 10),
                  ),

//          GridView.builder( gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//    crossAxisCount: 3),
//            itemBuilder: (BuildContext context, int index){
//            return  Container(
//                width: 100,
//                height: 90,
//                decoration: BoxDecoration(
//                  border: Border.all(
//                    width: 1,
//                    color: appColor
//                  ),
//
//                ),
//                child: Center(
//                  child: Column(
//                    children: <Widget>[
//                      Text("Fgdfgdfgh"),
//                    ],
//                  ),
//                ),
//            );
//          },
//            itemCount: 20,
//            shrinkWrap: true,
//            scrollDirection: Axis.vertical,
//            physics: ScrollPhysics(),
//          ),
          ),
          SizedBox(
            height: size.convert(context, 210),
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
            child: GestureDetector(
              onTap: () {
                print("open drawer ....");
                _scaffoldkey.currentState.openDrawer();
                openDrawer();
              },
              child: Icon(
                IcoFontIcons.navigationMenu,
                color: buttonColor,
                size: size.convert(context, 20),
              ),
            ),
          ),
        ],
      ),
    );
  }

  _logo() {
    return Container(
        child: SvgPicture.asset(
      "assets/icons/logoChange.svg",
      height: 50,
    ));
  }

//  BottomBar(){
//    Color unSelectedColor = Color(0xff7e7e7e);
//    Color SelectedColor = appColor;
//    TextStyle unselectTextstyle = TextStyle(
//      fontFamily: "Lato",
//      fontSize: 12,
//      color: unSelectedColor,
//    );
//    TextStyle selectTextstyle = TextStyle(
//      fontFamily: "Lato",
//      fontSize: 12,
//      color: SelectedColor,
//    );
//    return Container(
//      padding: EdgeInsets.symmetric(horizontal: 10),
//      decoration:BoxDecoration(
//        color: Color(0xfff8f8f8),
//      ),
//      height: 100,
//      child: Row(
//        mainAxisAlignment: MainAxisAlignment.spaceBetween,
//        crossAxisAlignment: CrossAxisAlignment.center,
//        children: <Widget>[
//          GestureDetector(
//            onTap: (){
//              print("1");
//              setState(() {
//                select = 1;
//                Navigator.push(context, PageTransition(type: PageTransitionType.fade, child: HomePage()));
//              });
//            },
//            child: Container(
//              child: Column(
//                mainAxisAlignment: MainAxisAlignment.center,
//                children: <Widget>[
//                  Image.asset("assets/icons/hospital.png",
//                    color: select == 1? appColor : unSelectedColor ,
//                    //height: 20,
//                  ),
//                  SizedBox(height: 5,),
//                  Text("Book Appointment",
//                    style: select == 1 ? selectTextstyle: unselectTextstyle ,)
//                ],
//              ),
//            ),
//          ),
//          GestureDetector(
//            onTap: (){
//              setState(() {
//                select = 2;
//                getIt<GlobalSingleton>().navigationKey.currentState.push(context, PageTransition(type: PageTransitionType.fade, child: myAppointment()));
//              });
//            },
//            child: Container(
//              child: Column(
//                mainAxisAlignment: MainAxisAlignment.center,
//                children: <Widget>[
//                  Image.asset("assets/icons/calendar.png",
//                    color: select == 2? appColor : unSelectedColor ,
//                  ),
//                  SizedBox(height: 5,),
//                  Text("My Appointments",
//                    style: select == 2 ? selectTextstyle: unselectTextstyle ,)
//                ],
//              ),
//            ),
//          ),
//
//          GestureDetector(
//            onTap: (){
//              setState(() {
//                select = 3;
//                getIt<GlobalSingleton>().navigationKey.currentState.push(context, PageTransition(type: PageTransitionType.fade, child: medicalRecord()));
//              });
//            },
//            child: Container(
//              child: Column(
//                mainAxisAlignment: MainAxisAlignment.center,
//                children: <Widget>[
//                  Image.asset("assets/icons/record.png",
//                    color: select == 3? appColor : unSelectedColor ,
//                  ),
//                  SizedBox(height: 5,),
//                  Text("Medical Records",
//                    style: select == 3 ? selectTextstyle: unselectTextstyle ,)
//                ],
//              ),
//            ),
//          ),
//          GestureDetector(
//            onTap: (){
//              setState(() {
//                select = 4;
//                getIt<GlobalSingleton>().navigationKey.currentState.push(context, PageTransition(type: PageTransitionType.fade, child: Blog()));
//              });
//
//            },
//            child: Container(
//              child: Column(
//                mainAxisAlignment: MainAxisAlignment.center,
//                children: <Widget>[
//                  Image.asset("assets/icons/blog.png",
//                    color: select == 4? appColor : unSelectedColor ,
//                  ),
//                  SizedBox(height: 5,),
//                  Text("View Blogs",
//                    style: select == 4 ? selectTextstyle: unselectTextstyle ,)
//                ],
//              ),
//            ),
//          ),
//        ],
//      ),
//    );
//  }

  _searchShow() {
    Size sizem = MediaQuery.of(context).size;
    return _textEditingController.text.length < 3
        ? SizedBox()
        : Positioned(
            top: MediaQuery.of(context).size.longestSide * 0.21,
            child: Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  color: Color(0xffFFFFFF),
                  border: Border.all(color: Color(0xff707070), width: 0.2),
                  boxShadow: [
                    BoxShadow(
                        color: Color(0xff7E7E7E).withOpacity(0.2), blurRadius: 5, spreadRadius: 2)
                  ]),
              width: MediaQuery.of(context).size.width - 40,
              constraints: BoxConstraints(maxHeight: sizem.height / 2, minHeight: 0),
              margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: ListView(
                padding: EdgeInsets.zero,
                scrollDirection: Axis.vertical,
                physics: ScrollPhysics(),
                shrinkWrap: true,
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                    color: Colors.grey[300],
                    child: Text(
                      TranslationBase.of(context).doctor,
                      style: TextStyle(color: Colors.black, fontFamily: "LatoRegular"),
                    ),
                  ),
                  doctorSpecialitySearchModel.doctors.length == 0
                      ? Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                          child: Text(
                            TranslationBase.of(context).noDoctorMatched,
                            style: TextStyle(
                              fontFamily: "LatoRegular",
                              fontSize: 12,
                            ),
                          ),
                        )
                      : ListView.separated(
                          shrinkWrap: true,
                          physics: ScrollPhysics(),
                          itemCount: doctorSpecialitySearchModel?.doctors?.length ?? 0,
                          itemBuilder: (BuildContext context, int index) {
                            return Container(
                              child: GestureDetector(
                                onTap: () {
                                  _navigateOnDoctorTap(doctorSpecialitySearchModel?.doctors[index]);
                                },
                                child: Container(
                                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                                    child: Text(
                                      doctorSpecialitySearchModel?.doctors[index].doctorName,
                                      style: TextStyle(
                                        fontFamily: "LatoRegular",
                                        fontSize: 12,
                                      ),
                                    )),
                              ),
                            );
                          },
                          separatorBuilder: (BuildContext context, int index) {
                            return Container(
                              margin: EdgeInsets.symmetric(horizontal: size.convert(context, 10)),
                              height: 1,
                              color: portionColor.withOpacity(0.1),
                              //color: Color(0xff7E7E7E),
                            );
                          },
                        ),
                  Container(
                    padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                    color: Colors.grey[300],
                    child: Text(
                      TranslationBase.of(context).speciality,
                      style: TextStyle(color: Colors.black, fontFamily: "LatoRegular"),
                    ),
                  ),
                  doctorSpecialitySearchModel.specialitys.length == 0
                      ? Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                          child: Text(
                            TranslationBase.of(context).noSpecialityMatched,
                            style: TextStyle(
                              fontFamily: "LatoRegular",
                              fontSize: 12,
                            ),
                          ),
                        )
                      : ListView.separated(
                          shrinkWrap: true,
                          physics: ScrollPhysics(),
                          itemCount: doctorSpecialitySearchModel?.specialitys?.length ?? 0,
                          itemBuilder: (BuildContext context, int index) {
                            return Container(
                              child: GestureDetector(
                                onTap: () {
                                  _navigateOnSpecailityTap(
                                      doctorSpecialitySearchModel?.specialitys[index]);
                                },
                                child: Container(
                                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                                    child: Text(
                                      doctorSpecialitySearchModel
                                          ?.specialitys[index].specialityName,
                                      style: TextStyle(
                                        fontFamily: "LatoRegular",
                                        fontSize: 12,
                                      ),
                                    )),
                              ),
                            );
                          },
                          separatorBuilder: (BuildContext context, int index) {
                            return Container(
                              margin: EdgeInsets.symmetric(horizontal: size.convert(context, 10)),
                              height: 1,
                              color: portionColor.withOpacity(0.1),
                              //color: Color(0xff7E7E7E),
                            );
                          },
                        ),
                  Container(
                    padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                    color: Colors.grey[300],
                    child: Text(
                      TranslationBase.of(context).clinic,
                      style: TextStyle(color: Colors.black, fontFamily: "LatoRegular"),
                    ),
                  ),
                  doctorSpecialitySearchModel.allClinicHospital.length == 0
                      ? Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                          child: Text(
                            TranslationBase.of(context).noClinicMatched,
                            style: TextStyle(
                              fontFamily: "LatoRegular",
                              fontSize: 12,
                            ),
                          ),
                        )
                      : ListView.separated(
                          shrinkWrap: true,
                          physics: ScrollPhysics(),
                          itemCount: doctorSpecialitySearchModel?.allClinicHospital?.length ?? 0,
                          itemBuilder: (BuildContext context, int index) {
                            return Container(
                              child: GestureDetector(
                                onTap: () {
                                  _navigateOnClinicTap(
                                      doctorSpecialitySearchModel?.allClinicHospital[index].id);
                                },
                                child: Container(
                                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                                    child: Text(
                                      doctorSpecialitySearchModel?.allClinicHospital[index].name,
                                      style: TextStyle(
                                        fontFamily: "LatoRegular",
                                        fontSize: 12,
                                      ),
                                    )),
                              ),
                            );
                          },
                          separatorBuilder: (BuildContext context, int index) {
                            return Container(
                              margin: EdgeInsets.symmetric(horizontal: size.convert(context, 10)),
                              height: 1,
                              color: portionColor.withOpacity(0.1),
                              //color: Color(0xff7E7E7E),
                            );
                          },
                        ),
                ],
              ),
            ),
          );
  }

  _Locationshow() {
    print(districitExpand);
    return Positioned(
      top: size.convert(context, 25),
      child: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            color: Color(0xffFFFFFF),
            border: Border.all(color: Color(0xff707070), width: 0.2),
            boxShadow: [
              BoxShadow(color: Color(0xff7E7E7E).withOpacity(0.2), blurRadius: 5, spreadRadius: 2)
            ]),
        width: MediaQuery.of(context).size.width - 60,
        height: 150,
        margin: EdgeInsets.symmetric(horizontal: 28, vertical: 10),
        child: ListView.separated(
          shrinkWrap: true,
          physics: ScrollPhysics(),
          itemCount: _districts.length,
          itemBuilder: (BuildContext context, int index) {
            return Container(
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    seletedDistricitId = _districts[index].id;
                    districitExpand = !districitExpand;
                  });
                },
                child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    child: Text(
                      _districts[index].districtName ?? "",
                      style: TextStyle(
                        fontFamily: "LatoRegular",
                        fontSize: size.convert(context, 14),
                      ),
                    )),
              ),
            );
          },
          separatorBuilder: (BuildContext context, int index) {
            return Container(
              margin: EdgeInsets.symmetric(horizontal: size.convert(context, 10)),
              height: 1,
              color: portionColor.withOpacity(0.1),
              //color: Color(0xff7E7E7E),
            );
          },
        ),
      ),
    );
  }

  _onFloatingPress() async {
    urlLauncher.launch("tel:0093784999906}");
//    OneSignal.shared.consentGranted(false);
//    OSPermissionSubscriptionState ss = await OneSignal.shared.getPermissionSubscriptionState();
//    OneSignal.shared.sendTag('user_id', await UserModel.getUserId);
////    OneSignal.shared.setExternalUserId(await UserModel.getUserId);
//
//    print(ss.permissionStatus);
//    print(ss.permissionStatus.status);
//    print(ss.permissionStatus.jsonRepresentation());
//    print(ss.permissionStatus.provisional);
//    print(ss.subscriptionStatus);
//    print(ss.subscriptionStatus.jsonRepresentation());
//    print(ss.subscriptionStatus.userId);
//    print(ss.subscriptionStatus.pushToken);
//    print(ss.subscriptionStatus.subscribed);
//    print(ss.subscriptionStatus.userSubscriptionSetting);
//    print(ss.emailSubscriptionStatus.subscribed);
//    print(ss.emailSubscriptionStatus.emailAddress);
//    print(ss.emailSubscriptionStatus.emailUserId);
  }

  void _navigateOnDoctorTap(DoctorModel model) {
    print("doctorId: ${model.doctorID}");
    getIt<GlobalSingleton>().navigationKey.currentState.push(PageTransition(
        child: doctorDetail(doctorId: model.doctorID),
        type: PageTransitionType.leftToRightWithFade));
  }

  void _navigateOnSpecailityTap(SpecialityModel model) {
    getIt<GlobalSingleton>().navigationKey.currentState.push(PageTransition(
        type: PageTransitionType.bottomToTop,
        child: doctorList(
          districtName: seletedDistricitId != -1
              ? _districts.firstWhere((district) => district.id == seletedDistricitId).districtName
              : null,
          specialityModel: model,
        )));
  }

  void _navigateOnClinicTap(int clinicId) {
    getIt<GlobalSingleton>().navigationKey.currentState.push(PageTransition(
        type: PageTransitionType.bottomToTop,
        child: doctorList(
          districtName: seletedDistricitId != -1
              ? _districts.firstWhere((district) => district.id == seletedDistricitId).districtName
              : null,
          clinicID: clinicId,
        )));
  }
}

//TranslationBase.of(context).next_page
//ScopedModelDescendant<AppModel>(
//builder: (context, child, model) => MaterialButton(
//onPressed: () {
//model.changeDirection("ur");
//},
//height: 60.0,
//color: const Color.fromRGBO(119, 31, 17, 1.0),
//child: new Text(
//TranslationBase.of(context).subTitle,
//style: new TextStyle(
//color: Colors.white,
//fontSize: 20.0,
//fontWeight: FontWeight.w300,
//letterSpacing: 0.3,
//),
//),
//)
//),
