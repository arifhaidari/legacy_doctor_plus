import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:doctor_app/api/api.dart';
import 'package:doctor_app/api/api_name.dart';
import 'package:doctor_app/error/error_message_widget.dart';
import 'package:doctor_app/error/snackbar.dart';
import 'package:doctor_app/getIt.dart';
import 'package:doctor_app/model/family/family_profile_list.dart';
import 'package:doctor_app/model/family/family_profile_model.dart';
import 'package:doctor_app/model/medical_record/medical_record_model.dart';
import 'package:doctor_app/model/user_model.dart';
import 'package:doctor_app/model/doctor/doctor_model.dart';
import 'package:doctor_app/pages/doctorList.dart';
import 'package:doctor_app/pages/medicalRecord.dart';
import 'package:doctor_app/repeatedWidgets/CustomAppBar.dart';
import 'package:doctor_app/repeatedWidgets/CustomBottomAppBar.dart';
import 'package:doctor_app/repeatedWidgets/CustomTextField.dart';
import 'package:doctor_app/singleton/global.dart';
import 'package:doctor_app/transulation/translations_delegate_base.dart';
import 'package:doctor_app/repeatedWidgets/loading.dart';
import 'package:doctor_app/transulation/translations_delegate_base.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:doctor_app/res/size.dart';
import 'package:doctor_app/res/color.dart';
import 'package:flutter_cupertino_date_picker/flutter_cupertino_date_picker.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:page_transition/page_transition.dart';
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'medicalrecordList.dart';

class addmedicalRecord extends StatefulWidget {
  String buttonText;
  String doctorName;

  MedicalRecordModel medicalRecordModel;

  addmedicalRecord({Key key, this.buttonText, this.medicalRecordModel, this.doctorName})
      : super(key: key);

  @override
  _addmedicalRecordState createState() => _addmedicalRecordState();
}

class _addmedicalRecordState extends State<addmedicalRecord> {
  final GlobalKey<ScaffoldState> _scaffoldkey = new GlobalKey<ScaffoldState>();
  bool isrecipt = true;

  TextEditingController doctorNameController;

  FocusNode myFocusNode;
  int patientId = -1;
  // String patientId = "-1";
  DateTime nowDate = DateTime.now();
  String recordDate = DateTime.now().toString().substring(0, 10);
  String errorMessage;
  int selectDoctorId;
  // String selectDoctorId;
  String selectDoctorName;
  List<DoctorModel> _doctorModel;
  var imageFile1;
  List<File> imagesfileList = [];

  UserModel userModel;
  List<FamilyProfileModel> _familyListModel;

  bool submit = false;

  double _progressValue = 0;

  @override
  void initState() {
    selectDoctorName = widget.doctorName;
    super.initState();
    doctorNameController = TextEditingController();
    myFocusNode = FocusNode();
    getData();

    if (widget.medicalRecordModel != null) {
      recordDate = widget.medicalRecordModel?.date;
      doctorNameController.text = widget.medicalRecordModel?.doctorName;
      isrecipt = widget.medicalRecordModel?.recordType == 'Prescription';
    }
  }

  getData() async {
    getSelfData();

    getDoctorList();
  }

  getDoctorList() async {
    _doctorModel = [];
    String temp1 = await UserModel.getUserId;
    int userId = int.parse(temp1);
    // String userId = await UserModel.getUserId;
    var response = await API(scaffold: _scaffoldkey, context: context, showSnackbarForError: true)
        .get(url: MY_DOCTOR_RELATED_APPOINTMENT + userId.toString());

    if (response == NO_CONNECTION) {
      CustomSnackBar.SnackBarInternet(_scaffoldkey, context, btnFun: getDoctorList);
      return;
    }

    if (response is Response) {
      print(".............................");
      print(response.data['doctor_list']);
      getFamilyMembers(response.data['family_member']);
      response.data['doctor_list'].forEach((data) {
        _doctorModel.add(DoctorModel.fromJson(data));
      });
      if (selectDoctorName != null) {
        _doctorModel.forEach((f) {
          print("doctor Name from parent = ${selectDoctorName}");
          print("doctor Name List = ${f.title}${f.doctorName}");
        });
        selectDoctorId = _doctorModel
            .firstWhere((test) => (test.title + " " + test.doctorName) == selectDoctorName)
            .doctorID;
      } else {
        selectDoctorId = _doctorModel[0].doctorID;
        selectDoctorName = _doctorModel[0].title + _doctorModel[0].doctorName;
      }

      print(".............................");
      if (mounted) setState(() {});
    }
  }

  getSelfData() async {
    userModel = await UserModel().fromPrefs();
  }

  getFamilyMembers(var data) async {
    // String userId = await UserModel.getUserId;

    _familyListModel = (data as List).map((i) => FamilyProfileModel.fromJson(i)).toList();
    _familyListModel.insert(0, FamilyProfileModel(patientID: -1, pName: "Self"));
    print(data);
    print(";;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;");

    patientId = -1;
    print("PATINT ID ${widget?.medicalRecordModel?.pateintName}");
    if (widget.medicalRecordModel != null &&
        widget.medicalRecordModel?.pateintName != null &&
        widget.medicalRecordModel?.pateintName != "") {
      if (_familyListModel.firstWhere(
              (family) => family.pName == widget.medicalRecordModel?.pateintName,
              orElse: () => null) !=
          null)
        patientId = _familyListModel
            .firstWhere((family) => family.pName == widget.medicalRecordModel?.pateintName)
            .patientID;
    }

    if (mounted) setState(() {});
  }

  @override
  void dispose() {
//    _editingController.dispose();
    super.dispose();
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
          leadingIcon: _leading(),
          centerWigets: Text(
            widget.medicalRecordModel != null
                ? TranslationBase.of(context).updateRecord
                : TranslationBase.of(context).addMedicalRecord,
            style: TextStyle(
              color: appBarIconColor,
              fontFamily: "LatoRegular",
              fontSize: size.convert(context, 14),
            ),
          ),
        ),
      ),
      body: _body(),
      //bottomNavigationBar: CustomBottomBar(select: 3),
    );
  }

  _leading() {
    return Container(
      child: GestureDetector(
        onTap: () {
          getIt<GlobalSingleton>().navigationKey.currentState.pop(context);
          print("pop call");
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

  _body() {
    return _familyListModel == null
        ? Center(
            child: Loading(),
          )
        : SingleChildScrollView(
            child: Container(
              color: Colors.white,
              child: Column(
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.symmetric(
                        horizontal: size.convert(context, 32), vertical: size.convert(context, 18)),
                    width: MediaQuery.of(context).size.width,
                    height: widget.medicalRecordModel != null
                        ? size.convert(context, 120.0 * 2)
                        : size.convert(context, 140),
                    decoration: BoxDecoration(
                      color: portionColor.withOpacity(0.1),
                    ),
                    child: _fileList(),
                  ),
                  SizedBox(
                    height: size.convert(context, 16),
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 24),
                    child: Row(
                      children: <Widget>[
                        Text(
                          TranslationBase.of(context).recordFor,
                          style: TextStyle(
                            color: portionColor,
                            fontFamily: "LatoRegular",
                            fontSize: size.convert(context, 12),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: size.convert(context, 8),
                  ),
                  Container(
                      margin: EdgeInsets.symmetric(horizontal: 22),
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: size.convert(context, 15)),
                        height: size.convert(context, 50),
                        decoration: BoxDecoration(
                          border: Border.all(
                            width: 1,
                            color: buttonColor,
                          ),
                          borderRadius: BorderRadius.circular(size.convert(context, 5)),
                        ),
                        child: DropdownButton(
                          style: TextStyle(
                            fontSize: size.convert(context, 12),
                            fontFamily: "LatoRegular",
                            color: portionColor,
                          ),
//              focusColor: Colors.blue,
                          isExpanded: true,
                          icon: Icon(Icons.keyboard_arrow_down),
                          hint: Text(widget.medicalRecordModel != null
                              ? widget.medicalRecordModel.pateintName
                              : "Record For"),
                          // Not necessary for Option 1
                          value: patientId,
                          onChanged: widget.medicalRecordModel != null || submit
                              ? null
                              : (newValue) {
                                  setState(() {
                                    patientId = newValue;
                                  });
                                },
                          items: _familyListModel.map((family) {
//                            selectDoctorId = family?.patientID;
//                            selectDoctorName = family?.
                            return DropdownMenuItem(
                              child: new Text(family?.pName ?? ""),
                              value: family.patientID,
                            );
                          }).toList(),
                        ),
                      )
//                  CustomTextField(hints: "Add name to easily identify records",
//                  borderwidth: 1,)
                      ),
                  SizedBox(
                    height: size.convert(context, 16),
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 24),
                    child: Row(
                      children: <Widget>[
                        Text(
                          TranslationBase.of(context).typeOfRecord,
                          style: TextStyle(
                            color: portionColor,
                            fontFamily: "LatoRegular",
                            fontSize: size.convert(context, 12),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: size.convert(context, 8),
                  ),
                  _recordIs(),
                  SizedBox(
                    height: size.convert(context, 16),
                  ),
                  Divider(
                    height: size.convert(context, 1),
                    color: portionColor,
                  ),
                  SizedBox(
                    height: size.convert(context, 16),
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 24),
                    child: Row(
                      children: <Widget>[
                        Text(
                          TranslationBase.of(context).recordDate,
                          style: TextStyle(
                            color: portionColor,
                            fontFamily: "LatoRegular",
                            fontSize: size.convert(context, 12),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: size.convert(context, 8),
                  ),
                  GestureDetector(
//                    onTap: widget.medicalRecordModel != null
//                        ? null
//                        : _datePickerLocalized,
                    child: Container(
                        height: size.convert(context, 50),
                        width: size.convertWidth(context, 360),
                        //margin: EdgeInsets.symmetric(horizontal: size.convertWidth(context, 10)),
                        decoration: BoxDecoration(
                            border: Border.all(
                          color: buttonColor,
                          width: size.convert(context, 1),
                        )),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            SizedBox(
                              width: size.convert(context, 15),
                            ),
                            RichText(
                              text: TextSpan(
                                  text: recordDate,
//                                  text: recordDate == "Record Date"
//                                      ? TranslationBase.of(context)
//                                          .dateOfBirthhints
//                                      : recordDate,
                                  style: TextStyle(
                                    fontSize: size.convert(context, 12),
                                    fontFamily: "LatoRegular",
                                    color: portionColor,
                                  )),
                            ),
                          ],
                        )),
                  ),
                  SizedBox(
                    height: size.convert(context, 16),
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 24),
                    child: Row(
                      children: <Widget>[
                        Text(
                          TranslationBase.of(context).doctor,
                          style: TextStyle(
                            color: portionColor,
                            fontFamily: "LatoRegular",
                            fontSize: size.convert(context, 12),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: size.convert(context, 8),
                  ),

                  Container(
                      margin: EdgeInsets.symmetric(horizontal: 22),
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: size.convert(context, 15)),
                        height: size.convert(context, 50),
                        decoration: BoxDecoration(
                          border: Border.all(
                            width: 1,
                            color: buttonColor,
                          ),
                          borderRadius: BorderRadius.circular(size.convert(context, 5)),
                        ),
                        child: DropdownButton(
                          style: TextStyle(
                            fontSize: size.convert(context, 12),
                            fontFamily: "LatoRegular",
                            color: portionColor,
                          ),
//              focusColor: Colors.blue,
                          isExpanded: true,
                          icon: Icon(Icons.keyboard_arrow_down),
                          hint: Text(selectDoctorName ?? "No Name"),
                          // Not necessary for Option 1
                          value: selectDoctorId,
                          onChanged: _doctorModel == null || submit
                              ? null
                              : (newValue) {
                                  setState(() {
                                    selectDoctorId = newValue;
                                  });
                                },
                          items: _doctorModel.map((doctor) {
                            return DropdownMenuItem(
                              child: new Text("${doctor?.title ?? ""} ${doctor?.doctorName ?? ""}"),
                              value: doctor.doctorID,
                            );
                          }).toList(),
                        ),
                      )
//                  CustomTextField(hints: "Add name to easily identify records",
//                  borderwidth: 1,)
                      ),
//                  Container(
//                      margin: EdgeInsets.symmetric(horizontal: 22),
//                      child: CustomTextField(
//                        hints:
//                            TranslationBase.of(context).addNameIdentifyRecord,
//                        isEnable: widget.medicalRecordModel == null,
//                        borderwidth: 1,
//                        textEditingController: doctorNameController,
//                      )),
                  SizedBox(
                    height: size.convert(context, 16),
                  ),
                  ErrorMessage(
                    message: errorMessage,
                  ),
                  _button(),
                  SizedBox(
                    height: size.convert(context, 16),
                  ),
                ],
              ),
            ),
          );
  }

  _fileList() {
    return Container(
      child: ListView(
        shrinkWrap: true,
        scrollDirection: Axis.vertical,
        padding: EdgeInsets.zero,
        children: <Widget>[
          StaggeredGridView.countBuilder(
            crossAxisCount: 4,
            shrinkWrap: true,
            physics: ScrollPhysics(),
            itemCount: (imagesfileList?.length ?? 0) + 1,
            itemBuilder: (BuildContext context, int index) {
              if (index == 0) {
                return GestureDetector(
                  onTap: () {
                    if (!submit) {
                      _settingModalBottomSheet(context);
                    }
                  },
                  child: DottedBorder(
                    color: buttonColor,
                    dashPattern: [8, 4],
                    strokeWidth: 1,
                    child: Center(
                      child: Container(
                        width: size.convert(context, 94),
                        height: size.convert(context, 94),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(size.convert(context, 5)),
                        ),
                        child: Center(
                          child: Icon(
                            Icons.add,
                            color: buttonColor,
                            size: size.convert(context, 30),
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              } else {
                if (imagesfileList[index - 1] is File) {
                  int fileBelongTo = checkDoc(imagesfileList[index - 1].path);

                  return Container(
                      width: size.convert(context, 100),
                      height: size.convert(context, 100),
                      child: Stack(
                        children: <Widget>[
                          fileBelongTo == DOC_IS_IMAGE
                              ? Image.file(
                                  imagesfileList[index - 1],
                                  semanticLabel: "Image",
                                )
                              : Image.asset(
                                  assetForDoc(fileBelongTo),
                                  fit: BoxFit.cover,
                                ),
                          Positioned(
                            right: 0,
                            top: 0,
                            child: GestureDetector(
                              onTap: () {
                                imagesfileList.removeAt(index - 1);
                                setState(() {});
                              },
                              child: Container(
                                decoration:
                                    BoxDecoration(color: Colors.red[800], shape: BoxShape.circle),
                                padding: EdgeInsets.all(5),
                                child: Icon(
                                  Icons.close,
                                  color: Colors.white,
                                  size: size.convert(context, 20),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ));
                } else {
                  return Container();
                }
              }
            },
            staggeredTileBuilder: (int index) => new StaggeredTile.fit(1),
            mainAxisSpacing: 8.0,
            crossAxisSpacing: 8.0,
          ),
          SizedBox(
            height: size.convert(context, 10),
          ),
          StaggeredGridView.countBuilder(
            crossAxisCount: 4,
            shrinkWrap: true,
            physics: ScrollPhysics(),
            itemCount: (widget.medicalRecordModel?.files?.length ?? 0),
            itemBuilder: (BuildContext context, int index) {
              int fileBelongTo = checkDoc(widget.medicalRecordModel?.files[index].document);

              return Container(
                  width: size.convert(context, 100),
                  height: size.convert(context, 100),
                  child: Stack(
                    children: <Widget>[
                      fileBelongTo == DOC_IS_IMAGE
                          ? Image.network(
                              MEDICAL_RECORD_URL + widget.medicalRecordModel?.files[index].document,
                              semanticLabel: "Image",
                            )
                          : Image.asset(
                              assetForDoc(fileBelongTo),
                            ),
                      Positioned(
                        right: 0,
                        top: 0,
                        child: widget.medicalRecordModel?.files[index].delete
                            ? SizedBox(
                                width: size.convert(context, 20),
                                height: size.convert(context, 20),
                                child: FittedBox(
                                  child: Loading(),
                                ),
                              )
                            : GestureDetector(
                                onTap: () {
                                  _deleteFile(index);
                                },
                                child: Container(
                                  decoration:
                                      BoxDecoration(color: Colors.red[800], shape: BoxShape.circle),
                                  padding: EdgeInsets.all(5),
                                  child: Icon(
                                    Icons.close,
                                    color: Colors.white,
                                    size: size.convert(context, 20),
                                  ),
                                ),
                              ),
                      ),
                    ],
                  ));
            },
            staggeredTileBuilder: (int index) => new StaggeredTile.fit(1),
            mainAxisSpacing: 8.0,
            crossAxisSpacing: 8.0,
          ),
        ],
      ),
    );
  }

  _recordIs() {
    TextStyle unselected = TextStyle(
      color: portionColor,
      fontSize: size.convert(context, 12),
      fontFamily: "LatoRegular",
    );
    TextStyle selected = TextStyle(
      color: buttonColor,
      fontSize: size.convert(context, 12),
      fontFamily: "LatoRegular",
    );
    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: size.convert(context, 24),
      ),
      padding: EdgeInsets.only(top: size.convert(context, 14)),
      child: Row(
        children: <Widget>[
          Container(
            child: GestureDetector(
              onTap: widget.medicalRecordModel != null
                  ? null
                  : () {
                      setState(() {
                        isrecipt = !isrecipt;
                      });
                    },
              child: Container(
                child: Column(
                  children: <Widget>[
                    SvgPicture.asset(
                      "assets/icons/rx.svg",
                      color: isrecipt ? buttonColor : portionColor,
                    ),
                    SizedBox(
                      height: size.convert(context, 6),
                    ),
                    Text(
                      TranslationBase.of(context).prescription,
                      style: isrecipt ? selected : unselected,
                    )
                  ],
                ),
              ),
            ),
          ),
          SizedBox(
            width: size.convert(context, 20),
          ),
          Container(
            child: GestureDetector(
              onTap: widget.medicalRecordModel != null
                  ? null
                  : () {
                      setState(() {
                        isrecipt = !isrecipt;
                      });
                    },
              child: Container(
                child: Column(
                  children: <Widget>[
                    SvgPicture.asset(
                      "assets/icons/health_check.svg",
                      color: !isrecipt ? buttonColor : portionColor,
                    ),
                    SizedBox(
                      height: size.convert(context, 6),
                    ),
                    Text(
                      TranslationBase.of(context).medicalRecord,
                      style: !isrecipt ? selected : unselected,
                    )
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  _button() {
    return Container(
      child: submit
          ? Center(
              child: CircularPercentIndicator(
                backgroundColor: Colors.transparent,
                progressColor: buttonColor,
                percent: _progressValue?.toDouble() ?? 0.0,
                radius: size.convert(context, 40),
                center: Center(
                  child: Text(
                    "${(_progressValue * 100).toInt()}",
                    style: TextStyle(fontSize: size.convert(context, 16), color: buttonColor),
                  ),
                ),
                lineWidth: size.convert(context, 3),
                animation: false,
                animationDuration: 100,
              ),
            )
          : GestureDetector(
              onTap: submit ? null : _validateForm,
              child: Container(
                height: size.convert(context, 40),
                margin: EdgeInsets.symmetric(horizontal: size.convert(context, 20)),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(size.convert(context, 5)),
                    color: submit ? buttonColor.withOpacity(0.8) : buttonColor),
                child: Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        child: RichText(
                          text: TextSpan(
                              text: widget.medicalRecordModel != null
                                  ? TranslationBase.of(context).updateRecord
                                  : TranslationBase.of(context).createRecord,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: size.convert(context, 12),
                                fontFamily: "LatoBold",
                              )),
                        ),
                      ),
                      Container(
                        child: RichText(
                          text: TextSpan(
                              text: "",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: size.convert(context, 12),
                                fontFamily: "LatoRegular",
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

  _settingModalBottomSheet(BuildContext context) {
    print("Bottom sheet");
    return showBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return Container(
            color: Colors.white,
            padding: EdgeInsets.symmetric(
                horizontal: size.convert(context, 22), vertical: size.convert(context, 16)),
            height: size.convert(context, 140),
            child: Column(
              children: <Widget>[
                Container(
                  child: Row(
                    children: <Widget>[
                      Text(
                        TranslationBase.of(context).addARecord,
                        style: TextStyle(
                            fontSize: size.convert(context, 10),
                            fontFamily: "LatoRegular",
                            color: portionColor),
                      )
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    print("Take a Photo");
                    _onImageButtonPressed(ImageSource.camera);
                    getIt<GlobalSingleton>().navigationKey.currentState.pop(context);
                  },
                  child: Container(
                    margin: EdgeInsets.only(top: size.convert(context, 10)),
                    child: Row(
                      children: <Widget>[
                        Container(
                          child: SvgPicture.asset(
                            "assets/icons/image.svg",
                            color: buttonColor,
                            height: size.convert(context, 15),
                            width: size.convert(context, 14),
                            fit: BoxFit.fill,
                          ),
                        ),
                        SizedBox(
                          width: size.convert(context, 12),
                        ),
                        Expanded(
                          child: Container(
                            child: Text(
                              TranslationBase.of(context).takeAPhoto,
                              style: TextStyle(
                                color: Colors.black,
                                fontFamily: "LatoRegular",
                                fontSize: size.convert(context, 12),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    print("Upload from gallery");
                    getIt<GlobalSingleton>().navigationKey.currentState.pop(context);
                    _onImageButtonPressed(ImageSource.gallery);
                  },
                  child: Container(
                    margin: EdgeInsets.only(top: size.convert(context, 10)),
                    child: Row(
                      children: <Widget>[
                        Container(
                          child: SvgPicture.asset(
                            "assets/icons/file-alt.svg",
                            color: buttonColor,
                            height: size.convert(context, 15),
                            width: size.convert(context, 14),
                            fit: BoxFit.fill,
                          ),
                        ),
                        SizedBox(
                          width: size.convert(context, 12),
                        ),
                        Expanded(
                          child: Container(
                            child: Text(
                              TranslationBase.of(context).uploadFromGallery,
                              style: TextStyle(
                                color: Colors.black,
                                fontFamily: "LatoRegular",
                                fontSize: size.convert(context, 12),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    print("Upload file");
                    getIt<GlobalSingleton>().navigationKey.currentState.pop(context);
                    _uploadfile();
                  },
                  child: Container(
                    margin: EdgeInsets.only(top: size.convert(context, 10)),
                    child: Row(
                      children: <Widget>[
                        Container(
                          child: SvgPicture.asset(
                            "assets/icons/ui-image.svg",
                            color: buttonColor,
                            height: size.convert(context, 15),
                            width: size.convert(context, 14),
                            fit: BoxFit.fill,
                          ),
                        ),
                        SizedBox(
                          width: size.convert(context, 12),
                        ),
                        Expanded(
                          child: Container(
                            child: Text(
                              TranslationBase.of(context).uploadFiles,
                              style: TextStyle(
                                color: Colors.black,
                                fontFamily: "LatoRegular",
                                fontSize: size.convert(context, 12),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        });
  }

  _onImageButtonPressed(ImageSource sourceFile) async {
    print("Some thing happen");
    try {
      imageFile1 = await ImagePicker.pickImage(
        source: sourceFile,
      );
//          print(imageFile1.toString());
      imagesfileList.add(imageFile1);
      setState(() {
        print(imagesfileList[0]);
      });
    } catch (e) {
      print("Error " + e.toString());
    }
  }

  _uploadfile() async {
    try {
      File _file = await FilePicker.getFile(type: FileType.custom, allowedExtensions: ["pdf"]);

      String extension = _file.path.substring(_file.path.lastIndexOf(".") + 1);

      print("File Extensin $extension");
      if (!(wordExtension.contains(extension) || extension == pdfExtension)) {
        CustomSnackBar.SnackBar_3Error(_scaffoldkey,
            title: "Only PDF, DOC, DOCX files are suppoerted", leadingIcon: Icons.error_outline);
        return;
      }

      setState(() {
        imagesfileList.add(_file);
      });
    } catch (e) {
      print("File Upload Error " + e.toString());
    }
  }

  _datePickerLocalized() {
    return DatePicker.showDatePicker(
      context,
      pickerTheme: DateTimePickerTheme(
        showTitle: true,
        confirm: Text(
          TranslationBase.of(context).done,
        ),
        cancel: Text(
          TranslationBase.of(context).cancel,
        ),
      ),
      minDateTime: DateTime.utc(1940),
      maxDateTime: DateTime.now(),
      initialDateTime: DateTime.utc(DateTime.now().year - 16, 1, 31),
      dateFormat: false ? "dd-MMMM-yyyy" : "yyyy-MMMM-dd",
      locale: TranslationBase.of(context).selectLanguage == "en"
          ? DateTimePickerLocale.en_us
          : TranslationBase.of(context).selectLanguage == "ar"
              ? DateTimePickerLocale.per
              : DateTimePickerLocale.pas,
      onClose: () => print("----- onClose -----"),
      onCancel: () => print('onCancel'),
      onChange: (dt, List<int> index) {
        if (!mounted) return;
//        setState(() {
//          dateTime = dt;
//        });
      },
      onConfirm: (dt, List<int> index) {
        _datePick(dt);
      },
    );
  }

  _datePick(DateTime newdate) {
    setState(() {
      recordDate = newdate.toString().substring(0, 10);
    });
  }

  _validateForm() {
    setState(() {
      errorMessage = null;
      _progressValue = 0.0;
    });

    if (imagesfileList.length == 0 && (widget.medicalRecordModel?.files?.length ?? 0) == 0) {
      setState(() {
        errorMessage = TranslationBase.of(context).selectFileError;
      });
      return;
    }

    if (recordDate == "Record Date") {
      setState(() {
        errorMessage = TranslationBase.of(context).dateRequiredError;
      });
      return;
    }

    if (selectDoctorName.length < 3) {
      setState(() {
        errorMessage = TranslationBase.of(context).doctorNameRequired;
      });
      return;
    }

    _submitRecord();
  }

  _submitRecord() {
    if (widget.medicalRecordModel != null)
      _updateRecord();
    else
      _addRecord();
  }

  _updateRecord() async {
    setState(() {
      submit = true;
    });

    if (imagesfileList.length > 0) {
      FormData dataFiles = FormData();
      dataFiles.fields.addAll([
        MapEntry('medical_records_id', widget.medicalRecordModel.docID.toString()),
      ]);
      imagesfileList.forEach((file) {
        dataFiles.files.add(
            MapEntry('file[]', MultipartFile.fromFileSync(file.path, filename: '${file.path}')));
      });

      var response = await API(
              showSnackbarForError: false,
              context: context,
              uploadProgressCallback: (value) {
                if (value != _progressValue)
                  setState(() {
                    print(value);
                    _progressValue = value;
                  });
              },
              scaffold: _scaffoldkey)
          .post(url: ADD_FILE_MEDICAL_RECORD_URL, body: dataFiles);

      if (response == NO_CONNECTION) {
        setState(() {
          errorMessage = TranslationBase.of(context).internetError;
        });
        return;
      }
      if (response is Response) {
        _updateField();
      } else {
        setState(() {
          errorMessage = response;
        });
        print(response);
      }
    } else {
      _updateField();
    }
  }

  _updateField() async {
    // int userId = await UserModel.getUserId;
    String temp2 = await UserModel.getUserId;
    int userId = int.parse(temp2);
    // String userId = await UserModel.getUserId;

    FormData dataFields = FormData();
    // print("select doctor id = ${selectDoctorId}");
    dataFields.fields.addAll([
      MapEntry('medical_records_id', widget.medicalRecordModel.docID.toString()),
      MapEntry('user_id', userId.toString()),
      MapEntry('related_to_who', patientId == -1 ? '0' : patientId.toString()),
      MapEntry('doctor_name', selectDoctorName),
//      MapEntry('doctor_name', doctorNameController.text),
      MapEntry('doctor_id', selectDoctorId.toString()),
      MapEntry('records_type', isrecipt ? 'Prescription' : 'Medical Record'),
    ]);

    var response = await API(
            showSnackbarForError: false,
            context: context,
            uploadProgressCallback: (value) {
              if (value != _progressValue)
                setState(() {
                  print(value);
                  _progressValue = value;
                });
            },
            scaffold: _scaffoldkey)
        .post(url: UPDATE_MEDICAL_RECORD_URL, body: dataFields);
    setState(() {
      submit = false;
    });

    print("*****$response");

    if (response == NO_CONNECTION) {
      setState(() {
        errorMessage = TranslationBase.of(context).internetError;
      });
      return;
    }

    if (response is Response) {
      print("POPPPP");
//      getIt<GlobalSingleton>().navigationKey.currentState.of(_scaffoldkey.currentContext).pop("success");
      print("WHy HERE");
      CustomSnackBar.SnackBar_3Success(_scaffoldkey,
          leadingIcon: Icons.check,
          title: widget.medicalRecordModel != null
              ? TranslationBase.of(context).updateMedicalRecord
              : TranslationBase.of(context).addedMedicalRecord);
      getIt<GlobalSingleton>().navigationKey.currentState.pop();
    } else {
      setState(() {
        errorMessage = response;
      });
      print(response);
    }
  }

  _addRecord() async {
    setState(() {
      submit = true;
    });

    String temp3 = await UserModel.getUserId;
    int userId = int.parse(temp3);
    selectDoctorName = _doctorModel.firstWhere((test) => test.doctorID == selectDoctorId).title +
        " " +
        _doctorModel.firstWhere((test) => test.doctorID == selectDoctorId).doctorName;
    // print("selected id = ${selectDoctorId}");
    // print("selectDoctorName = ${selectDoctorName}");
    FormData data = FormData();
    data.fields.addAll([
      MapEntry('user_id', userId.toString()),
      MapEntry('related_to_who', patientId == -1 ? '0' : patientId.toString()),
      MapEntry('doctor_name', selectDoctorName),
//      MapEntry('doctor_name', doctorNameController.text),
      MapEntry('doctor_id', selectDoctorId.toString()),
      MapEntry('records_type', isrecipt ? 'Prescription' : 'Medical Record'),
    ]);
    imagesfileList.forEach((file) {
      data.files
          .add(MapEntry('file[]', MultipartFile.fromFileSync(file.path, filename: '${file.path}')));
    });
//    data.files.addAll(imagesfileList
//        .map((file) => MapEntry('photos',
//            MultipartFile.fromFileSync(file.path, filename: '${file.path}')))
//        .toList());

//    .fromMap({
//    'user_id': userId,
//    'related_to_who': patientId == "-1" ? userId : patientId,
//    'doctor_name': doctorNameController.text,
//    'records_type': isrecipt ? 'Prescription' : 'Medical Record',
//    'photos': imagesfileList
//        .map((file) =>
//    MultipartFile.fromFileSync(file.path, filename: '${file.path}'))
//        .toList()
//    });

    print(data.files.map((file) => file.value).toList());

    var response = await API(
            showSnackbarForError: false,
            context: context,
            uploadProgressCallback: (value) {
              if (value != _progressValue)
                setState(() {
                  print(value);
                  _progressValue = value;
                });
            },
            scaffold: _scaffoldkey)
        .post(url: ADD_MEDICAL_RECORD_URL, body: data);
    setState(() {
      submit = false;
    });

    print("*****$response");

    if (response == NO_CONNECTION) {
      setState(() {
        errorMessage = TranslationBase.of(context).internetError;
      });
      return;
    }

    if (response is Response) {
      print("POPPPP");
      //getIt<GlobalSingleton>().navigationKey.currentState.of(_scaffoldkey.currentContext).pop("success");
      print("WHy HERE");
      CustomSnackBar.SnackBar_3Success(_scaffoldkey,
          leadingIcon: Icons.check,
          title: widget.medicalRecordModel != null
              ? TranslationBase.of(context).updateMedicalRecord
              : TranslationBase.of(context).addedMedicalRecord);
      getIt<GlobalSingleton>().navigationKey.currentState.pop();
    } else {
      setState(() {
        errorMessage = response;
      });
      print(response);
    }
  }

  _deleteFile(int index) async {
    setState(() {
      widget.medicalRecordModel?.files[index].delete = true;
    });
    var response = await API(showSnackbarForError: false, context: context, scaffold: _scaffoldkey)
        .post(
            url: DELETE_MEDICAL_RECORD_FILE_URL,
            body: {'file_id': widget.medicalRecordModel?.files[index].fileId});

    if (response is Response) {
      CustomSnackBar.SnackBar_3Success(_scaffoldkey,
          leadingIcon: Icons.check, title: "File Deleted Successfully");
      setState(() {
        widget.medicalRecordModel.files.removeAt(index);
      });
    }
  }
}
