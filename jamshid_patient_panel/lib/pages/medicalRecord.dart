import 'dart:io';
import 'package:photo_view/photo_view.dart';
import 'package:dio/dio.dart';
import 'package:doctor_app/api/api.dart';
import 'package:doctor_app/api/api_name.dart';
import 'package:doctor_app/error/snackbar.dart';
import 'package:doctor_app/getIt.dart';
import 'package:doctor_app/model/family/family_profile_list.dart';
import 'package:doctor_app/model/family/family_profile_model.dart';
import 'package:doctor_app/model/medical_record/file_model.dart';
import 'package:doctor_app/model/medical_record/medical_record_list_model.dart';
import 'package:doctor_app/model/medical_record/medical_record_model.dart';
import 'package:doctor_app/model/user_model.dart';
import 'package:doctor_app/pages/medicalRecord/addmedicalRecord.dart';
import 'package:doctor_app/repeatedWidgets/CustomAppBar.dart';
import 'package:doctor_app/repeatedWidgets/CustomBottomAppBar.dart';
import 'package:doctor_app/repeatedWidgets/CustomDrawer.dart';
import 'package:doctor_app/repeatedWidgets/loading.dart';
import 'package:doctor_app/repeatedWidgets/toggleButton.dart';
import 'package:doctor_app/res/color.dart';
import 'package:doctor_app/singleton/global.dart';
import 'package:doctor_app/transulation/translations_delegate_base.dart';
import 'package:flutter/material.dart';
import 'package:doctor_app/res/size.dart';
import 'package:flutter_svg/svg.dart';
import 'package:icofont_flutter/icofont_flutter.dart';
import 'package:intl/intl.dart';
import 'package:menu_button/menu_button.dart';
import 'package:page_transition/page_transition.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:printing/printing.dart';
import 'package:pdf/pdf.dart';
import 'print/generateDocument.dart';

class medicalRecord extends StatefulWidget {
  @override
  _medicalRecordState createState() => _medicalRecordState();
}

class _medicalRecordState extends State<medicalRecord> {
  //int select = 3;
  final GlobalKey<ScaffoldState> _scaffoldkey = new GlobalKey<ScaffoldState>();

  ScrollController _scrollController = ScrollController();

  Printer selectedPrinter;

  PrintingInfo printingInfo;

  int selectedUserId;
  // String selectedUserId;
  String selectedUserName;
  bool toggleLoader = false;

  MedicalRecordListModel medicalRecordListModel;
  FamilyListModel familyListModel;

  Directory _externalDocumentsDirectory;
  Directory _appSupportDirectory;

  @override
  void initState() {
    Printing.info().then((PrintingInfo info) {
      setState(() {
        printingInfo = info;
      });
    });
    super.initState();
    selectedUserId = -2;

//    _scrollController.addListener(() {
//      if (_scrollController.position.atEdge) {
//        if (_scrollController.position.pixels == 0) {
//          //top
//        } else {
//          print("Reached bottom of list view");
//          //bottom
//          if (medicalRecordList != null && _blogs.nextPageUrl != null) {
//            print("blog is not  null");
//            Uri uri = Uri.parse(_blogs.nextPageUrl);
//
//            if (int.parse(uri.queryParameters['page'].toString()) >
//                currentPage) {
//              print("Blog has more list Current Page $currentPage");
//              currentPage = int.parse(uri.queryParameters['page'].toString());
//              getBlogData(_blogs.nextPageUrl);
//            } else {
//              print("Blog has NO more list Current Page $currentPage");
//            }
//          } else {
//            print("blog or next url is NULL");
//          }
//        }
//      }
//    });

    // _getFamilyData();
    getMedicalRecord(loadPrefs: true);
  }

//  _getFamilyData() async {
//    String userId = await UserModel.getUserId;
//    Map body = {
//      'user_id': userId,
//    };
//    var response = await API(
//            showSnackbarForError: true,
//            context: context,
//            scaffold: _scaffoldkey)
//        .post(url: VIEW_ALL_FAMILY_MEMBER_URL, body: body);
//
//    if (response == NO_CONNECTION) {
//      CustomSnackBar.SnackBarInternet(_scaffoldkey, context,
//          btnFun: _getFamilyData);
//      return;
//    }
//
//    if (response is Response) {
//      familyListModel = FamilyListModel.fromJson(response.data);
//
//      familyListModel.familiesModel
//          .insert(0, FamilyProfileModel(patientID: "-1", pName: "Self"));
//
//      familyListModel.familiesModel
//          .insert(0, FamilyProfileModel(patientID: "-2", pName: "All"));
//
//      if (mounted) setState(() {});
//    }
//  }

  getMedicalRecord({bool loadPrefs = false}) async {
    if (loadPrefs) {
      medicalRecordListModel = await MedicalRecordListModel.getMedicalRecordPref();
      medicalRecordListModel?.data?.sort((a, b) {
        var firstDate = a.date;
        var secondDate = b.date;
        return -secondDate.compareTo(firstDate);
      });
      setState(() {});
    }

    String userId = await UserModel.getUserId;
    // int userId = int.parse(temp12);
    int lastPage = 1;
    int index = 1;
    //
    // print("User id $userId");
    for (int _currentPage = 1; _currentPage <= lastPage; _currentPage++) {
      var response = await API(scaffold: _scaffoldkey, context: context, showSnackbarForError: true)
          .post(url: VIEW_MEDICAL_RECORDS_URL + "?page=$_currentPage", body: {'user_id': userId});

      if (response == NO_CONNECTION) {
        CustomSnackBar.SnackBarInternet(_scaffoldkey, context, btnFun: getMedicalRecord);
        return;
      }

      if (response is Response) {
        print("this family data response");
        MedicalRecordListModel _data = MedicalRecordListModel.fromJson(response.data["document"]);
        if (index == 1) {
          index = 2;
          medicalRecordListModel = _data;
          familyListModel = FamilyListModel.fromJson(response.data);

          familyListModel.familiesModel.insert(0, FamilyProfileModel(patientID: -1, pName: "Self"));

          familyListModel.familiesModel.insert(0, FamilyProfileModel(patientID: -2, pName: "All"));
        } else {
          medicalRecordListModel.data.addAll(_data.data);
        }

        lastPage = response.data['document']['last_page'];
        print('//////////////// the value fo lastPage');
        print(lastPage);
        // print("last page is = ${lastPage}");
        // print("Current page is = ${_currentPage}");
      }
    }
    medicalRecordListModel.data.sort((a, b) {
      var firstDate = a.date;
      var secondDate = b.date;
      return -firstDate.compareTo(secondDate);
    });

    MedicalRecordListModel.saveMedicalRecordPref(medicalRecordListModel.toJson());
    setState(() {
      toggleLoader = false;
    });
  }

  deleteMedicalRecord(MedicalRecordModel model) {
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
                    TranslationBase.of(context).deleteMedicalRecord,
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
                    TranslationBase.of(context).comfirmMessageDeleteMedicalRecord,
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
                              _deleteRecord(model);
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

  @override
  Widget build(BuildContext context) {
    Size size1 = MediaQuery.of(context).size;

    return Scaffold(
      key: _scaffoldkey,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(size1.longestSide * 0.15666178),
        child: CustomAppBar(
          hight: size1.longestSide * 0.15666178,
          leadingIcon: _leadingIcon(),
          paddingBottom: size.convert(context, 15),
          parentContext: context,
          color1: Color(0xff1C80A0),
          color2: Color(0xff35D8A6),
          trailingIcon: _addMedicalRecord(),
          centerWigets: Container(
            child: Text(
              TranslationBase.of(context).bMedical_Records,
              style: TextStyle(
                color: appBarIconColor,
                fontFamily: "LatoRegular",
                fontSize: size.convert(context, 14),
              ),
            ),
          ),
        ),
      ),
      body: _bodySelection(),
      drawer: Container(
        width: size.convertWidth(context, 350),
        child: openDrawer(),
      ),
      bottomNavigationBar: CustomBottomBar(
        select: 3,
      ),
    );
  }

  _bodySelection() {
    print("MEDICAL $medicalRecordListModel");
    return medicalRecordListModel == null
        ? Center(
            child: Loading(),
          )
        : medicalRecordListModel.data.length == 0
            ? _noDataBody()
            : _bodyDataList();
  }

  _bodyDataList() {
    List<MedicalRecordModel> records = [];
    if (selectedUserId == -2) {
      records = medicalRecordListModel.data;
    } else {
      records = medicalRecordListModel.data
          .where((record) =>
              selectedUserId == -1 ? record.pateintId == 0 : record.pateintId == selectedUserId)
          .toList();
    }

    return Container(
      margin: EdgeInsets.only(
        top: size.convert(context, 10),
      ),
      child: Column(
        children: <Widget>[
          dropDownWidget(),
          SizedBox(
            height: 10,
          ),
          Expanded(
            child: records.length == 0
                ? _noDataBody()
                : ListView.builder(
                    shrinkWrap: true,
                    itemCount: records.length,
                    physics: ScrollPhysics(),
                    itemBuilder: (BuildContext context, int index) {
                      MedicalRecordModel medicalRecord = records[index];

                      DateTime recordDateTime =
                          medicalRecord.date == null ? null : DateTime.parse(medicalRecord.date);

                      return Stack(
                        children: <Widget>[
                          AnimatedContainer(
                            //color: Colors.green,
                            margin: EdgeInsets.only(
                                right: size.convert(context, 13),
                                left: size.convert(context, 13),
                                bottom: size.convert(context, 13)),
                            duration: Duration(seconds: 1),
                            child: Container(
                              decoration: BoxDecoration(color: portionColor.withOpacity(0.05)),
                              child: Column(
                                children: <Widget>[
                                  Container(
                                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                                    child: Row(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Container(
                                          width: 40,
                                          height: 40,
                                          decoration: BoxDecoration(
                                              color: Color(0xffBABABA),
                                              borderRadius: BorderRadius.circular(5)),
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            children: <Widget>[
                                              RichText(
                                                maxLines: 1,
                                                text: TextSpan(
                                                    text: recordDateTime == null
                                                        ? ""
                                                        : DateFormat.d().format(recordDateTime),
                                                    style: TextStyle(
                                                        fontSize: 12,
                                                        fontFamily: "LatoBold",
                                                        color: Colors.black)),
                                              ),
                                              RichText(
                                                maxLines: 1,
                                                text: TextSpan(
                                                    text: recordDateTime == null
                                                        ? ""
                                                        : DateFormat.MMM().format(recordDateTime),
                                                    style: TextStyle(
                                                        fontSize: 12,
                                                        fontFamily: "LatoBold",
                                                        color: Colors.black)),
                                              )
                                            ],
                                          ),
                                        ),
                                        SizedBox(
                                          width: 15,
                                        ),
                                        Expanded(
                                          child: Container(
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: <Widget>[
                                                Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  children: <Widget>[
                                                    Container(
                                                      width: size.convert(context, 200),
                                                      child: RichText(
                                                        maxLines: 2,
                                                        text: TextSpan(
                                                            text: medicalRecord?.doctorName ?? "",
                                                            style: TextStyle(
                                                                color: buttonColor,
                                                                fontFamily: "LatoBold",
                                                                fontSize: 16)),
                                                      ),
                                                    ),
                                                    medicalRecord.isExpanded
                                                        ? InkWell(
                                                            onTap: () {
                                                              setState(() {
                                                                medicalRecord.isEditProfile =
                                                                    !medicalRecord.isEditProfile;
                                                              });
                                                            },
                                                            child: Container(
                                                              padding: EdgeInsets.symmetric(
                                                                  horizontal:
                                                                      size.convert(context, 15),
                                                                  vertical:
                                                                      size.convert(context, 10)),
                                                              //  color: Colors.blueAccent,

                                                              child: Center(
                                                                child: SvgPicture.asset(
                                                                  "assets/icons/Menugreen.svg",
                                                                  color: buttonColor,
                                                                ),
                                                              ),
                                                            ))
                                                        : Container(
                                                            padding: EdgeInsets.symmetric(
                                                                horizontal:
                                                                    size.convert(context, 15),
                                                                vertical: size.convert(context, 5)),
                                                            child: Center(
                                                              child: SvgPicture.asset(
                                                                  "assets/icons/Menu.svg"),
                                                            )),
                                                  ],
                                                ),
//                                          SizedBox(
//                                            height: 5,
//                                          ),
//                                          Container(
//                                            child: RichText(
//                                              maxLines: 1,
//                                              text: TextSpan(
//                                                text:
//                                                    "No Data For experties in api",
//                                                style: TextStyle(
//                                                    color: Color(0xff7e7e7e),
//                                                    fontFamily: "LatoRegular",
//                                                    fontSize: 12),
//                                              ),
//                                            ),
//                                          ),
                                                SizedBox(
                                                  height: 5,
                                                ),
                                                Container(
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.spaceBetween,
                                                    children: <Widget>[
                                                      RichText(
                                                        text: TextSpan(
                                                            text: medicalRecord?.recordType ?? "",
                                                            style: TextStyle(
                                                                color: Color(0xff7e7e7e),
                                                                fontSize: 12,
                                                                fontFamily: "LatoRegular")),
                                                      ),
                                                      Container(
                                                        child: toggleButton(
                                                          dotColor: buttonColor,
                                                          enableColor: Colors.green,
                                                          value:
                                                              medicalRecord?.allowshareRecords == 0
                                                                  ? false
                                                                  : true,
                                                          onChange: (val) {
                                                            print(
                                                                "this is toggle button change event = ${val}");
                                                            setState(() {
                                                              //  if(medicalRecordListModel?.data[0].allowShareAllRecords == 1 ){
                                                              if (val) {
                                                                medicalRecord?.allowshareRecords =
                                                                    1;

                                                                /// work here for visible record
                                                                disableRecord(1,
                                                                    docId: medicalRecord.docID);
                                                              } else {
                                                                medicalRecord?.allowshareRecords =
                                                                    0;
                                                                disableRecord(1,
                                                                    docId: medicalRecord.docID);
                                                                // }
                                                              }
                                                            });
                                                          },
                                                          buttonWidth:
                                                              size.convertWidth(context, 26),
                                                          buttonHeight: size.convert(context, 15),
                                                          disableHeight: size.convert(context, 10),
                                                          disableWidth:
                                                              size.convertWidth(context, 6.7),
                                                          enableHeight: size.convert(context, 10),
                                                          enableWidth:
                                                              size.convertWidth(context, 6.7),
                                                          disableColor: Colors.red,
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                ),
                                                SizedBox(
                                                  height: 5,
                                                ),
                                                Container(
                                                  child: RichText(
                                                    maxLines: 1,
                                                    text: TextSpan(
                                                        text: medicalRecord?.pateintName,
                                                        style: TextStyle(
                                                            color: Color(0xff7e7e7e),
                                                            fontSize: 12,
                                                            fontFamily: "LatoRegular")),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  _MoreDetails(medicalRecord, recordDateTime),
                                  Divider(
                                    height: 1,
                                    color: portionColor,
                                  ),
                                  SizedBox(
                                    height: size.convert(context, 15),
                                  ),
                                  Container(
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: <Widget>[
                                        InkWell(
                                          onTap: () {
                                            print("Container Expend call");
                                            if (!medicalRecord.isExpanded) {
                                              _getMedicalRecordFiles(medicalRecord);
                                            }
                                            setState(() {
                                              medicalRecord.isExpanded = !medicalRecord.isExpanded;
                                            });
                                          },
                                          child: Container(
                                            // color: Colors.yellow,
                                            padding: EdgeInsets.symmetric(
                                                horizontal: size.convert(context, 10),
                                                vertical: size.convert(context, 10)),
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.end,
                                              children: <Widget>[
                                                SvgPicture.asset(
                                                  "assets/icons/folder.svg",
                                                  color: buttonColor,
                                                ),
                                                SizedBox(
                                                  width: size.convert(context, 10),
                                                ),
                                                Text(
                                                  medicalRecord.isExpanded
                                                      ? TranslationBase.of(context).close
                                                      : TranslationBase.of(context).open,
                                                  style: TextStyle(
                                                      fontFamily: "LatoRegular",
                                                      fontSize: size.convert(context, 10),
                                                      color: buttonColor),
                                                )
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    height: size.convert(context, 15),
                                  )
                                ],
                              ),
                            ),
                          ),
                          (medicalRecord.isEditProfile && medicalRecord.isExpanded)
                              ? TranslationBase.of(context).position == "right"
                                  ? Positioned(
                                      right: size.convertWidth(context, 235),
                                      top: size.convert(context, 45),
                                      child: AnimatedContainer(
                                        height: size.convert(context, 110),
                                        duration: Duration(microseconds: 3),
                                        width: size.convertWidth(context, 140),
                                        decoration: BoxDecoration(color: Colors.white),
                                        child: Column(
                                          children: <Widget>[
                                            GestureDetector(
                                              onTap: () {
                                                getIt<GlobalSingleton>()
                                                    .navigationKey
                                                    .currentState
                                                    .push(PageTransition(
                                                        child: addmedicalRecord(
                                                          buttonText: TranslationBase.of(context)
                                                              .updateRecord,
                                                          medicalRecordModel: medicalRecord,
                                                          doctorName: medicalRecord.doctorName,
                                                          key: UniqueKey(),
                                                        ),
                                                        type: PageTransitionType.bottomToTop))
                                                    .then((val) {
                                                  getMedicalRecord();
                                                });
                                              },
                                              child: Container(
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: size.convert(context, 5),
                                                    vertical: size.convert(context, 15)),
                                                child: Row(
                                                  children: <Widget>[
                                                    SvgPicture.asset(
                                                      "assets/icons/edit.svg",
                                                      color: buttonColor,
                                                    ),
                                                    SizedBox(
                                                      width: size.convert(context, 10),
                                                    ),
                                                    Container(
                                                      child: Text(
                                                        TranslationBase.of(context).editRecord,
                                                        style: TextStyle(
                                                            color: Colors.black,
                                                            fontFamily: "LatoRegular",
                                                            fontSize: size.convert(context, 12)),
                                                      ),
                                                    )
                                                  ],
                                                ),
                                              ),
                                            ),
                                            SizedBox(
                                              height: size.convert(context, 8),
                                            ),
                                            Padding(
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: size.convert(context, 5)),
                                              child: Divider(
                                                height: size.convert(context, 1),
                                                color: portionColor,
                                              ),
                                            ),
                                            GestureDetector(
                                              onTap: medicalRecord.deleting
                                                  ? null
                                                  : () {
                                                      deleteMedicalRecord(medicalRecord);
                                                    },
                                              child: Container(
                                                color: medicalRecord.deleting ? Colors.grey : null,
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: size.convert(context, 5),
                                                    vertical: size.convert(context, 15)),
                                                child: Row(
                                                  children: <Widget>[
                                                    Icon(
                                                      IcoFontIcons.uiDelete,
                                                      color: buttonColor,
                                                      size: size.convert(context, 14),
                                                    ),
                                                    SizedBox(
                                                      width: size.convert(context, 10),
                                                    ),
                                                    Container(
                                                      child: Text(
                                                        TranslationBase.of(context).deleteRecord,
                                                        style: TextStyle(
                                                            color: Colors.black,
                                                            fontFamily: "LatoRegular",
                                                            fontSize: size.convert(context, 12)),
                                                      ),
                                                    )
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ))
                                  : Positioned(
                                      left: size.convertWidth(context, 235),
                                      top: size.convert(context, 45),
                                      child: AnimatedContainer(
                                        height: size.convert(context, 110),
                                        duration: Duration(microseconds: 3),
                                        width: size.convertWidth(context, 140),
                                        decoration: BoxDecoration(color: Colors.white),
                                        child: Column(
                                          children: <Widget>[
                                            GestureDetector(
                                              onTap: () {
                                                getIt<GlobalSingleton>()
                                                    .navigationKey
                                                    .currentState
                                                    .push(PageTransition(
                                                        child: addmedicalRecord(
                                                          buttonText: TranslationBase.of(context)
                                                              .updateRecord,
                                                          medicalRecordModel: medicalRecord,
                                                          doctorName: medicalRecord.doctorName,
                                                          key: UniqueKey(),
                                                        ),
                                                        type: PageTransitionType.bottomToTop))
                                                    .then((val) {
                                                  getMedicalRecord();
                                                });
                                              },
                                              child: Container(
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: size.convert(context, 5),
                                                    vertical: size.convert(context, 15)),
                                                child: Row(
                                                  children: <Widget>[
                                                    SvgPicture.asset(
                                                      "assets/icons/edit.svg",
                                                      color: buttonColor,
                                                    ),
                                                    SizedBox(
                                                      width: size.convert(context, 10),
                                                    ),
                                                    Container(
                                                      child: Text(
                                                        TranslationBase.of(context).editRecord,
                                                        style: TextStyle(
                                                            color: Colors.black,
                                                            fontFamily: "LatoRegular",
                                                            fontSize: size.convert(context, 12)),
                                                      ),
                                                    )
                                                  ],
                                                ),
                                              ),
                                            ),
                                            SizedBox(
                                              height: size.convert(context, 8),
                                            ),
                                            Padding(
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: size.convert(context, 5)),
                                              child: Divider(
                                                height: size.convert(context, 1),
                                                color: portionColor,
                                              ),
                                            ),
                                            GestureDetector(
                                              onTap: medicalRecord.deleting
                                                  ? null
                                                  : () {
                                                      deleteMedicalRecord(medicalRecord);
//                                                      _deleteRecord(
//                                                          medicalRecord);
                                                    },
                                              child: Container(
                                                color: medicalRecord.deleting ? Colors.grey : null,
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: size.convert(context, 5),
                                                    vertical: size.convert(context, 15)),
                                                child: Row(
                                                  children: <Widget>[
                                                    Icon(
                                                      IcoFontIcons.uiDelete,
                                                      color: buttonColor,
                                                      size: size.convert(context, 14),
                                                    ),
                                                    SizedBox(
                                                      width: size.convert(context, 10),
                                                    ),
                                                    Container(
                                                      child: Text(
                                                        TranslationBase.of(context).deleteRecord,
                                                        style: TextStyle(
                                                            color: Colors.black,
                                                            fontFamily: "LatoRegular",
                                                            fontSize: size.convert(context, 12)),
                                                      ),
                                                    )
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ))
                              : SizedBox(),
                        ],
                      );
                    }),
          ),
        ],
      ),
    );
  }

  disableRecord(int op, {int user_Id, int patientId = 0, int docId}) async {
    if (op == 2) {
      setState(() {
        toggleLoader = true;
      });
    }
    // int userId = 0;
    String userId = await UserModel.getUserId;
    // userId = int.parse(userIdtemp);
    // int userId = await UserModel.getUserId;
    Map body;
    if (op == 1)

    /// for single record disble
    {
      body = {"document_id": docId.toString()};
    } else

    /// for all record disble
    {
      body = {"user_id": userId, "family_mamber_id": '0'};
    }

    print(body);
    try {
      var response = await API(showSnackbarForError: true, context: context, scaffold: _scaffoldkey)
          .post(url: op == 1 ? ALLOW_SHARING_THE_RECORED : ALLOW_SHARING_RECORED, body: body);

      if (response is Response) {
        if (op == 2) {
          getMedicalRecord(loadPrefs: true);
        }
        print("response data = ${response.data}");
      }

      if (response == NO_CONNECTION) {
        CustomSnackBar.SnackBarInternet(_scaffoldkey, context);
        return;
      }
    } on SocketException {
      print('it is an SocketException');
      CustomSnackBar.SnackBarInternet(_scaffoldkey, context);
    } catch (e) {
      print('it is CustomSnackBar expection');
      CustomSnackBar.SnackBar_3Error(_scaffoldkey, title: e.toString());
    }
  }

  Widget dropDownWidget() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 15),
      padding: EdgeInsets.only(top: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: <Widget>[
          Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
//                selectedUserId == "-2" ? Container() :
//                Container(
//                  child: toggleLoader ? Loading() : toggleButton(
//                  dotColor: buttonColor,
//                  enableColor : Colors.green,
//                  value: medicalRecordListModel?.data[0].allowShareAllRecords == "0" ? false : true,
//                  onChange: (val) {
//                    print("this is toggle button change event = ${val}");
//                    setState(() {
//                      disableRecord(2);
//                      if(val){
//                       // medicalRecordListModel?.data[0].allowShareAllRecords = "1";
//                      }
//                      else{
//                        //medicalRecordListModel?.data[0].allowShareAllRecords = "0";
//                      }
//
//                    });
//
//                  },
//
////                  buttonWidth: 26,
////                  buttonHeight: 15,
////                  disableHeight: 10,
////                  disableWidth: 6.7,
////                  enableHeight: 10,
////                  enableWidth: 6.7,
//                  disableColor: Colors.red,
//                ),),
                familyListModel == null
                    ? SizedBox(width: 18, height: 18, child: FittedBox(child: Loading()))
                    : Container(
                        width: size.convert(context, 150),
                        height: size.convert(context, 30),
                        child: MenuButton(
                            inContainerHeight: dropDownHeight(),
                            outContainerHeight: dropDownHeight(),
                            topDivider: false,
                            child: Container(
                              color: Colors.transparent,
                              padding: EdgeInsets.symmetric(horizontal: 8),
                              width: size.convert(context, 150),
                              height: size.convert(context, 30),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Expanded(
                                    child: Container(
                                      child: RichText(
                                        maxLines: 1,
                                        text: TextSpan(
                                            text:
                                                selectedUserName ?? TranslationBase.of(context).all,
                                            style: TextStyle(
                                                fontSize: size.convert(context, 14),
                                                fontFamily: "LatoBold",
                                                color: buttonColor)),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    child: Icon(
                                      Icons.keyboard_arrow_down,
                                      color: buttonColor,
                                      size: size.convert(context, 14),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            items: familyListModel?.familiesModel ?? [],
                            itemBuilder: (family) {
                              if (family is FamilyProfileModel) {
                                return SingleChildScrollView(
                                  child: Container(
                                    color: Colors.white,
                                    padding: EdgeInsets.symmetric(horizontal: 8),
                                    //height: size.longestSide*0.04978038067,
                                    //width: size.longestSide*0.229868228,
                                    height: size.convert(context, 30),
                                    width: size.convert(context, 148),
                                    child: Row(
                                      // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        Expanded(
                                          child: Container(
                                            child: RichText(
                                              maxLines: 1,
                                              text: TextSpan(
                                                  text: family.pName,
                                                  style: TextStyle(
                                                      fontSize: size.convert(context, 14),
                                                      fontFamily: "LatoBold",
                                                      color: buttonColor)),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              } else
                                return Container();
                            },
                            decoration: BoxDecoration(
                                border: Border.all(color: buttonColor),
                                borderRadius: const BorderRadius.all(Radius.circular(3.0)),
                                color: Colors.transparent),
                            divider: Container(
                              height: 0.4,
                              color: portionColor,
                            ),
                            onItemSelected: (value) {
                              if (value is FamilyProfileModel) {
                                setState(() {
                                  selectedUserName = value.pName;
                                  selectedUserId = value.patientID;
                                });
                              }
                              // Action when new item is selected
                            },
                            toggledChild: Container()
//                          Container(
//                            color: Colors.transparent,
//                            padding: EdgeInsets.symmetric(horizontal: 8),
//                            width: size.convert(context, 150),
//                            height: size.convert(context, 30),
//                            child: Row(
//                              // mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                              children: <Widget>[
//                                Expanded(
//                                  child: Container(
//                                    child: RichText(
//                                      maxLines: 1,
//                                      text: TextSpan(
//                                          text: "",
//                                          style: TextStyle(
//                                              fontSize:
//                                                  size.convert(context, 14),
//                                              fontFamily: "LatoBold",
//                                              color: buttonColor)),
//                                    ),
//                                  ),
//                                ),
//                              ],
//                            ),
//                          ),
                            ),
                      )
              ],
            ),
          ),
        ],
      ),
    );
  }

  double dropDownHeight() {
    if (familyListModel.familiesModel != null) {
      if (familyListModel.familiesModel.length > 20) {
        return 400;
      } else {
        print("greater then 5");
        print("${(familyListModel.familiesModel.length + 1) * 30.1}");
        return (familyListModel.familiesModel.length) * size.convert(context, 30);
      }
    } else {
      return 0.1;
    }
  }

  _MoreDetails(MedicalRecordModel medicalRecord, DateTime date) {
    if (medicalRecord.isExpanded) {
      List<Widget> recordData = [];
      medicalRecord.files.forEach((doc) {
        int fileBelongTo = checkDoc(doc.document);
        recordData.add(
          GestureDetector(
              onTap: () {
//                      print("Print doc");

                _zoomImage(doc);
              },
              child: Container(
                  height: size.convert(context, 60),
                  width: size.convert(context, 60),
                  child: fileBelongTo == DOC_IS_IMAGE
                      ? Image.network(
                          MEDICAL_RECORD_URL + doc.document,
                          semanticLabel: "Image",
                        )
                      : Image.asset(assetForDoc(fileBelongTo)))),
        );
      });
      return Container(
        padding: EdgeInsets.symmetric(horizontal: size.convert(context, 70)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                      child: Text(
                    "${TranslationBase.of(context).prescription} (${medicalRecord.files.length}) - ${DateFormat.MMMEd().format(date)}",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: size.convert(context, 10),
                      fontFamily: "LatoRegular",
                    ),
                  )),
                  SizedBox(
                    height: size.convert(context, 14),
                  ),
                  Wrap(
                    runSpacing: 10,
                    spacing: 10,
                    children: recordData,

//                  <Widget>[
//                    GestureDetector(
//                        onTap: () {
////                      print("Print doc");
////                      _printDoc("assets/icons/Group 1793.png");
//                        },
//                        child: Container(
//                            child: Image.network())),
//                  ],
                  ),
                  SizedBox(
                    height: size.convert(context, 14),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    } else {
      return Container();
    }
  }

  String _postion() {
    return TranslationBase.of(context).position;
  }

  _zoomImage(FileModel model) {
    int fileBelongTo = checkDoc(model.document);
    return showGeneralDialog(
      context: context,
      pageBuilder: (BuildContext buildContext, Animation<double> animation,
          Animation<double> secondaryAnimation) {
        return Wrap(
          children: <Widget>[
            Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                color: Colors.transparent,
                child: Column(
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        Container(
                          padding: EdgeInsets.only(
                              top: size.convert(context, 20), right: size.convert(context, 10)),
                          child: GestureDetector(
                              onTap: () {
                                getIt<GlobalSingleton>().navigationKey.currentState.pop(context);
                              },
                              child: Icon(
                                Icons.clear,
                                color: Colors.white,
                                size: size.convert(context, 25),
                              )),
                        ),
                      ],
                    ),
                    Container(
                      margin: EdgeInsets.only(top: size.convert(context, 10)),
                      //color: Colors.yellow,
                      height: size.convert(context, 480),
                      width: MediaQuery.of(context).size.width,
                      //color: Colors.red,
                      child: new PhotoView(
                        tightMode: true,
                        imageProvider: fileBelongTo == DOC_IS_IMAGE
                            ? NetworkImage(
                                MEDICAL_RECORD_URL + model.document,
                              )
                            : NetworkImage(
                                MEDICAL_RECORD_URL + model.document,
                              ),
                        // : Image.asset(assetForDoc(fileBelongTo)),

                        minScale: PhotoViewComputedScale.contained,
                        //maxScale: size.convert(context, 480),
                        //customSize: Size(MediaQuery.of(context).size.width,size.convert(context, 480),),
                        backgroundDecoration: BoxDecoration(color: Colors.transparent),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: size.convert(context, 30)),
                      child: GestureDetector(
                        onTap: () {
                          print("Click on Print Doc");
//                          getIt<GlobalSingleton>().navigationKey.currentState.pop(context);
//                          getIt<GlobalSingleton>().navigationKey.currentState.push(context, PageTransition(type: PageTransitionType.rightToLeft,
//                              child: addmedicalRecord(key: UniqueKey(),)));
                          _printDoc(model);
                        },
                        child: Container(
                          height: size.convert(context, 40),
                          margin: EdgeInsets.symmetric(horizontal: size.convert(context, 20)),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(size.convert(context, 5)),
                              color: buttonColor),
                          child: Center(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Container(
                                  child: RichText(
                                    text: TextSpan(
                                        text: TranslationBase.of(context).print,
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: size.convert(context, 12),
                                          fontFamily: "LatoBold",
                                        )),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                )),
          ],
        );
      },
      barrierDismissible: true,
      barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
      barrierColor: Colors.black.withOpacity(0.75),
      transitionDuration: const Duration(milliseconds: 200),
    );
  }

  _printDoc(FileModel model) async {
    print("Print call");
    int fileBelongTo = checkDoc(model.document);
    String documentUrl = MEDICAL_RECORD_URL + model.document;
    print('value of fileBelongTo $fileBelongTo');

    if (fileBelongTo == DOC_IS_IMAGE) {
      try {
        final bool result = await Printing.layoutPdf(
            onLayout: (PdfPageFormat format) async =>
                (await generateDocumentImage(PdfPageFormat.a4, documentUrl)).save());
        _showPrintedToast(result);
        Navigator.pop(context);
      } catch (e) {
        print(e);
        CustomSnackBar.SnackBar_3Error(_scaffoldkey,
            title: "Error $e", leadingIcon: Icons.error_outline);
      }
    } else if (fileBelongTo == DOC_IS_PDF || fileBelongTo == DOC_IS_DOC) {
      var knockDir;
      try {
        if (Platform.isIOS) {
          print("IOS");
          await _requestAppSupportDirectory();
          knockDir = await new Directory('${_appSupportDirectory.path}/doctorapp')
              .create(recursive: true)
              .catchError((err) {
            print(err);
          });
          print(knockDir);
//          File file = new File('${knockDir.path}/file.pdf');
//          print(file);
//          var raf = file.openSync(mode: FileMode.write);
//          print("raf ${raf.path}");
//          raf.writeFromSync(dta);
//          if (raf.toString().isNotEmpty) {
//            showSubmitRequestSnackBar(
//                context, "File Saved Successfully", raf.path, file);
//          } else {}
//          await raf.close();
//           await raf1.close();
        } else {
          await _requestExternalStorageDirectory();
          knockDir = await new Directory('${_externalDocumentsDirectory.path}/doctorapp')
              .create(recursive: true)
              .catchError((err) {
            print(err);
          });
          print(knockDir);
          PermissionStatus permissionResult =
              await PermissionHandler().checkPermissionStatus(PermissionGroup.storage);

          if (permissionResult == PermissionStatus.granted) {
//              File file = new File('${knockDir.path}/$fname');
//              print(file);
//              var raf = file.openSync(mode: FileMode.write);
//              print("raf ${raf.path}");
//              raf.writeFromSync(dta);
//              if (raf.toString().isNotEmpty) {
//                await OpenFile.open(raf.path).catchError((err) {
//                  print(err);
//                });
//              } else {
//              }
//              await raf.close();

          } else {
            await _getPermission();
            _printDoc(model);
          }
        }
//        String extension = model.documents[0].substring(model.documents[0].lastIndexOf('.') + 1).toLowerCase();

        Response response = await Dio().download(documentUrl, '${knockDir.path}/file.pdf');

        print(response.statusCode);
        if (response.statusCode == 200) {
          print('this condtition is true response.statusCode == 200');
          File pdf = File('${knockDir.path}/file.pdf');
          final bool result = await Printing.layoutPdf(onLayout: (_) => pdf.readAsBytesSync());

          _showPrintedToast(result);
          Navigator.pop(context);
        }
      } catch (e) {
        print('well there is error bro');
        print(e);
        CustomSnackBar.SnackBar_3Error(_scaffoldkey,
            title: "Error $e", leadingIcon: Icons.error_outline);
      }
    }

//    getIt<GlobalSingleton>().navigationKey.currentState.push(
//        context,
//        PageTransition(
//            type: PageTransitionType.rightToLeft,
//            child: PrinterPage(
//              medicalRecordModel: model,
//            )));
  }

  _getPermission() async {
    return await PermissionHandler().requestPermissions([PermissionGroup.storage]);
  }

  _requestExternalStorageDirectory() async {
    _externalDocumentsDirectory = await getExternalStorageDirectory();
    print(_externalDocumentsDirectory.path);
  }

  _requestAppSupportDirectory() async {
    _appSupportDirectory = await getApplicationSupportDirectory();
    print(_appSupportDirectory.path);
  }

  void _showPrintedToast(bool printed) {
    if (printed) {
      CustomSnackBar.SnackBar_3Success(_scaffoldkey,
          title: "Document Printed", leadingIcon: Icons.check);
    } else {
      CustomSnackBar.SnackBar_3Error(_scaffoldkey,
          title: "Document not printed", leadingIcon: Icons.check);
    }
  }

  ///No Data

  _noDataBody() {
    return SingleChildScrollView(
      child: Container(
        child: Column(
          children: <Widget>[
            Container(
              padding: EdgeInsets.only(top: size.convert(context, 36)),
              margin: EdgeInsets.symmetric(horizontal: size.convert(context, 80)),
              child: Image.asset(
                "assets/icons/undraw_resume_folder_2_arse.png",
                height: size.convert(context, 152),
              ),
            ),
            Container(
              padding: EdgeInsets.only(top: size.convert(context, 5)),
              child: Text(
                TranslationBase.of(context).allrecordsoneplace,
                style: TextStyle(
                  fontSize: size.convert(context, 12),
                  fontFamily: "LatoBold",
                  color: Colors.black,
                ),
              ),
            ),
            SizedBox(
              height: size.convert(context, 18),
            ),
            Container(
              color: portionColor.withOpacity(0.05),
              padding: EdgeInsets.only(
                  left: size.convert(context, 20),
                  right: size.convert(context, 50),
                  top: size.convert(context, 16),
                  bottom: size.convert(context, 16)),
              child: Column(
                children: <Widget>[
                  Container(
                    child: Row(
                      children: <Widget>[
                        Container(
                          child: Image.asset("assets/icons/done.png"),
                        ),
                        Expanded(
                          child: Container(
                            padding: EdgeInsets.only(left: size.convert(context, 20)),
                            child: RichText(
                              maxLines: 2,
                              text: TextSpan(
                                  text: TranslationBase.of(context).neverloserecords,
                                  style: TextStyle(
                                    fontSize: size.convert(context, 12),
                                    fontFamily: "LatoRegular",
                                    color: buttonColor,
                                  )),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    child: Row(
                      children: <Widget>[
                        Container(
                          child: Image.asset("assets/icons/done.png"),
                        ),
                        Expanded(
                          child: Container(
                            padding: EdgeInsets.only(left: size.convert(context, 20)),
                            child: RichText(
                              maxLines: 2,
                              text: TextSpan(
                                  text: TranslationBase.of(context).accessRecordIOngo,
                                  style: TextStyle(
                                    fontSize: size.convert(context, 12),
                                    fontFamily: "LatoRegular",
                                    color: buttonColor,
                                  )),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    child: Row(
                      children: <Widget>[
                        Container(
                          child: Image.asset("assets/icons/done.png"),
                        ),
                        Expanded(
                          child: Container(
                            padding: EdgeInsets.only(left: size.convert(context, 20)),
                            child: RichText(
                              maxLines: 2,
                              text: TextSpan(
                                  text: TranslationBase.of(context).shareRecords,
                                  style: TextStyle(
                                    fontSize: size.convert(context, 12),
                                    fontFamily: "LatoRegular",
                                    color: buttonColor,
                                  )),
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
            SizedBox(
              height: size.convert(context, 18),
            ),
            _button(),
          ],
        ),
      ),
    );
  }

  _button() {
    return Container(
      child: GestureDetector(
        onTap: _addMedicalRecordNav,
        child: Container(
          height: size.convert(context, 40),
          margin: EdgeInsets.symmetric(horizontal: size.convert(context, 20)),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(size.convert(context, 5)), color: buttonColor),
          child: Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  child: RichText(
                    text: TextSpan(
                        text: TranslationBase.of(context).addMedicalRecordsButtonText,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: size.convert(context, 12),
                          fontFamily: "LatoBold",
                        )),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  _leadingIcon() {
    return Container(
      child: GestureDetector(
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
    );
  }

  _addMedicalRecord() {
    return (medicalRecordListModel != null && (medicalRecordListModel?.data?.length ?? 0) == 0)
        ? Container()
        : GestureDetector(
            onTap: _addMedicalRecordNav,
            child: Text(
              TranslationBase.of(context).addRecord + " +",
              style: TextStyle(
                color: appBarIconColor,
                fontSize: size.convert(context, 12),
                fontFamily: "LatoBold",
              ),
            ),
          );
  }

  _addMedicalRecordNav() async {
    print("Click on add medical records");
    String temp1 = await UserModel.getUserId;
    int userId = int.parse(temp1);
    if (userId == null) {
      CustomSnackBar.SnackBar_3Error(_scaffoldkey,
          title: TranslationBase.of(context).pleaseLogin, leadingIcon: Icons.error_outline);
      return;
    }
    getIt<GlobalSingleton>()
        .navigationKey
        .currentState
        .push(PageTransition(
            type: PageTransitionType.rightToLeft,
            child: addmedicalRecord(
              key: UniqueKey(),
            )))
        .then((val) {
      getMedicalRecord();
    });
  }

  openDrawer() {
    return Drawer(
      child: CustomDrawer(),
    );
  }

  void _deleteRecord(MedicalRecordModel model) async {
    setState(() {
      model.deleting = true;
    });

    var response = await API(scaffold: _scaffoldkey, context: context, showSnackbarForError: true)
        .post(url: DELETE_MEDICAL_RECORD_URL, body: {'medical_records_id': model.docID.toString()});

    setState(() {
      model.deleting = false;
    });

    if (response == NO_CONNECTION) {
      CustomSnackBar.SnackBarInternet(_scaffoldkey, context, btnFun: () {
        _deleteRecord(model);
      });
      return;
    }

    if (response is Response) {
      CustomSnackBar.SnackBar_3Success(_scaffoldkey,
          title: TranslationBase.of(context).medicalRecordDeleted);
      getMedicalRecord();
    }
  }

  void _getMedicalRecordFiles(MedicalRecordModel model) async {
    var response = await API(scaffold: _scaffoldkey, context: context, showSnackbarForError: true)
        .post(
            url: GET_FILES_MEDICAL_RECORD_URL,
            body: {'medical_records_id': model.docID.toString()});

    if (response == NO_CONNECTION) {
      CustomSnackBar.SnackBarInternet(_scaffoldkey, context, btnFun: () {
        _getMedicalRecordFiles(model);
      });
      return;
    }

    if (response is Response) {
      print('this condiotn response is Response is true');
      if (response.data is List) {
        print('and this one');
        model.files = [];
        response.data.forEach((file) {
          model.addFile(FileModel.fromJson(file));
        });
      }
    }
    if (mounted) setState(() {});
  }
}

const int DOC_IS_IMAGE = 1;
const int DOC_IS_VIDEO = 2;
const int DOC_IS_AUDIO = 3;
const int DOC_IS_DOC = 4;
const int DOC_IS_PDF = 5;
const int DOC_IS_OTHER = 6;

List<String> imageExtension = ["jpg", "jpeg", "png", "svg", "jpe", "webp", "gif"];
List<String> videoExtension = [
  "mp4",
  "3gp",
  "mov",
  "flv",
  "wmv",
  "mp4",
  "m4a",
  "m4v",
  "f4v",
  "f4a",
  "m4b",
  "m4r",
  "f4b",
  "mov"
];
List<String> audioExtension = ["mp3", "mov", "aac"];
List<String> wordExtension = ["doc", "docx"];
String pdfExtension = "pdf";

int checkDoc(String doc) {
  String extension = doc.substring(doc.lastIndexOf('.') + 1).toLowerCase();
  print("Extension $extension");
  return imageExtension.contains(extension)
      ? DOC_IS_IMAGE
      : videoExtension.contains(extension)
          ? DOC_IS_VIDEO
          : audioExtension.contains(extension)
              ? DOC_IS_AUDIO
              : extension == pdfExtension
                  ? DOC_IS_PDF
                  : wordExtension.contains(extension)
                      ? DOC_IS_DOC
                      : DOC_IS_OTHER;
//  else if (_checkIsVideo(extension)){
//    return DOC_IS_VIDEO;
//  }
//  else if (_checkIsDoc(extension)){
//    return DOC_IS_DOC;
//  }
//  return DOC_IS_OTHER;
}

String assetForDoc(int fileIs) {
  return "assets/document/" +
      (fileIs == DOC_IS_VIDEO
          ? "video.png"
          : fileIs == DOC_IS_AUDIO
              ? "audio.png"
              : fileIs == DOC_IS_DOC
                  ? "word.png"
                  : fileIs == DOC_IS_PDF
                      ? "pdf.png"
                      : "other.png");
}
