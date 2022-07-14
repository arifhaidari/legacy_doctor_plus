import 'package:dio/dio.dart';
import 'package:doctor_app/api/api.dart';
import 'package:doctor_app/api/api_name.dart';
import 'package:doctor_app/error/error_message_widget.dart';
import 'package:doctor_app/getIt.dart';
import 'package:doctor_app/model/pending_feedback_model.dart';
import 'package:doctor_app/model/user_model.dart';
import 'package:doctor_app/repeatedWidgets/CustomTextField.dart';
import 'package:doctor_app/repeatedWidgets/circularImage.dart';
import 'package:doctor_app/repeatedWidgets/radioButton.dart';
import 'package:doctor_app/res/color.dart';
import 'package:doctor_app/res/size.dart';
import 'package:doctor_app/singleton/global.dart';
import 'package:doctor_app/transulation/translations_delegate_base.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';

import 'loading.dart';

class doctorFeedback extends StatefulWidget {
  BuildContext context;
  double rating;
  Function onchange;
  Color txtColor;

  PendingFeedbackModel feedbackModel;

  doctorFeedback(
      {this.feedbackModel,
      this.txtColor,
      this.context,
      this.rating,
      this.onchange});

  @override
  _doctorFeedbackState createState() => _doctorFeedbackState();
}

class _doctorFeedbackState extends State<doctorFeedback> {
  TextEditingController _controllerComment = TextEditingController();

  bool submit = false;
  bool feedbackSubmitted = false;

  bool overAllExperience = true;
  bool doctorCheckup = true;
  bool staffBehaviour = true;
  bool clinicEnvironment = true;

  String errorMessage;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size.convertWidth(context, 384),
      height: size.convert(context, 455),
      color: Colors.transparent,
      child: Stack(
        alignment: Alignment.bottomLeft,
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(size.convert(context, 7)),
              color: Colors.white,
            ),
            width: size.convertWidth(context, 320),
            height: size.convert(context, 440),
            child: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  SizedBox(
                    height: size.convert(context, 20),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(
                        horizontal: size.convert(context, 15)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Expanded(
                          child: Container(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Row(
                                  children: <Widget>[
                                    Expanded(
                                      child: Text(
                                        "${widget?.feedbackModel?.docTitle ?? ""} ${widget?.feedbackModel?.doctorName ?? ""}",
                                        style: TextStyle(
                                          color: buttonColor,
                                          fontFamily: "LatoBold",
                                          fontSize: size.convert(context, 14),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: size.convert(context, 5),
                                ),
                                Container(
                                  child: Row(
                                    children: <Widget>[
                                      Expanded(
                                        child: Text(
                                          widget?.feedbackModel?.expert ?? "",
                                          style: TextStyle(
                                            color: portionColor,
                                            fontFamily: "LatoRegular",
                                            fontSize: size.convert(context, 12),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                        Container(
                          child: circularImage(
                            imageUrl: widget?.feedbackModel?.doctorPicture == null ? null : DOCTOR_IMAGE_URL + widget?.feedbackModel?.doctorPicture,
                            h: size.convert(context, 55),
                            assetImage: false,
                            w: size.convert(context, 55),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: size.convert(context, 17),
                  ),
                  Divider(
                    height: 1,
                    color: portionColor,
                  ),
                  SizedBox(
                    height: size.convert(context, 17),
                  ),
                  feedbackSubmitted ?  _feedbackSubmitted():_writeFeedback() ,
                ],
              ),
            ),
          ),
          Positioned(
            top: size.convert(context, 1),
            right: size.convert(context, 1),
            child: GestureDetector(
              onTap: () {
                print("close feedback");
                getIt<GlobalSingleton>().navigationKey.currentState.pop();
              },
              child: Container(
                width: size.convert(context, 28),
                height: size.convert(context, 28),
                decoration:
                    BoxDecoration(color: buttonColor, shape: BoxShape.circle),
                child: Center(
                  child: Icon(
                    Icons.clear,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _writeFeedback() {
    return Column(
      children: <Widget>[
        Container(
          padding: EdgeInsets.symmetric(horizontal: size.convert(context, 15)),
          child: RichText(
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
            text: TextSpan(
                text: widget?.feedbackModel?.doctorShortBiography ?? "",
                style: TextStyle(
                  fontSize: size.convert(context, 12),
                  fontFamily: "LatoRegular",
                  color: portionColor,
                )),
          ),
        ),
        SizedBox(
          height: size.convert(context, 15),
        ),
        Container(
          padding: EdgeInsets.symmetric(horizontal: size.convert(context, 15)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Row(
                children: <Widget>[
                  Container(
                    child: SvgPicture.asset(
                      "assets/icons/ratingNew.svg",
                      height: size.convert(context, 24),
                      width: size.convert(context, 24),
                    ),
                  ),
                  SizedBox(width: 12,),
                  Text(
                    TranslationBase.of(context).overallExperience,
                    style: TextStyle(
                        fontFamily: "LatoBold",
                        color: buttonColor,
                        fontSize: size.convert(context, 12)),
                  ),
                ],
              ),
              radioButton(
                onchange: (val) {
                  overAllExperience = val;
                },
              ),
            ],
          ),
        ),
        SizedBox(
          height: size.convert(context, 10),
        ),
        Container(
          padding: EdgeInsets.symmetric(horizontal: size.convert(context, 15)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Row(
                children: <Widget>[
                  Container(
                    child: SvgPicture.asset(
                      "assets/icons/doctorNew.svg",
                      height: size.convert(context, 24),
                      width: size.convert(context, 24),
                    ),
                  ),
                  SizedBox(width:  17,),
                  Text(
                    TranslationBase.of(context).doctorCheckup,
                    style: TextStyle(
                        fontFamily: "LatoBold",
                        color: buttonColor,
                        fontSize: size.convert(context, 12)),
                  ),
                ],
              ),
              radioButton(
                onchange: (val) {
                  doctorCheckup = val;
                },
              ),
            ],
          ),
        ),
        SizedBox(
          height: size.convert(context, 10),
        ),
        Container(
          padding: EdgeInsets.symmetric(horizontal: size.convert(context, 15)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Row(
                children: <Widget>[
                  Container(
                    child: SvgPicture.asset(
                      "assets/icons/staffNew.svg",
                      height: size.convert(context, 24),
                      width: size.convert(context, 24),
                    ),
                  ),
                  SizedBox(width: 15),
                  Text(
                    TranslationBase.of(context).staffBehavior,
                    style: TextStyle(
                        fontFamily: "LatoBold",
                        color: buttonColor,
                        fontSize: size.convert(context, 12)),
                  ),
                ],
              ),
              radioButton(
                onchange: (val) {
                  staffBehaviour = val;
                },
              ),
            ],
          ),
        ),
        SizedBox(
          height: size.convert(context, 10),
        ),
        Container(
          padding: EdgeInsets.symmetric(horizontal: size.convert(context, 15)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Row(
                children: <Widget>[
                  Container(
                    child: SvgPicture.asset(
                      "assets/icons/filledoutlineNew.svg",
                      height: size.convert(context, 24),
                      width: size.convert(context, 24),
                    ),
                  ),
                  SizedBox(width: 12,),
                      RichText(
                        textAlign: TextAlign.start,
                        text: TextSpan(
                          text: TranslationBase.of(context).clinicEnvironment,
                          style: TextStyle(
                              fontFamily: "LatoBold",
                              color: buttonColor,
                              fontSize: size.convert(context, 12)),
                        ),
                      ),
//                  Text(
//
//                  ),
                ],
              ),
              radioButton(
                onchange: (val) {
                  clinicEnvironment = val;
                },
              ),
            ],
          ),
        ),
        SizedBox(
          height: size.convert(context, 12),
        ),
        Padding(
          padding:  EdgeInsets.symmetric(horizontal: 10),
          child: CustomTextField(
            hints: TranslationBase.of(context).comment,
            textEditingController: _controllerComment,
            obscureText: false,
          ),
        ),
        SizedBox(
          height: size.convert(context, 6),
        ),
        ErrorMessage(
          message: errorMessage,
          bottomPadding: false,
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: size.convert(context, 28)),
          child: Divider(
            height: 1,
            color: portionColor,
          ),
        ),
        SizedBox(
          height: size.convert(context, errorMessage!=null? 0 :16),
        ),
        submit? Center(child: Loading(),) : Container(
          child: GestureDetector(
            onTap: _submitFeedback,
            child: Container(
              width: size.convertWidth(context, 126),
              height: size.convert(context, 35),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(size.convert(context, 3)),
                color: buttonColor,
              ),
              child: Center(
                child: Text(
                  TranslationBase.of(context).submit,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: size.convert(context, 10),
                    fontFamily: "LatoBold",
                  ),
                ),
              ),
            ),
          ),
        ),
        SizedBox(
          height: size.convert(context, errorMessage!=null? 0 :16),
        ),
      ],
    );
  }

  Widget _feedbackSubmitted() {
    return Text(
      TranslationBase.of(context).thankFeedback,
      style: TextStyle(
          fontFamily: "LatoBold",
          color: buttonColor,
          fontSize: size.convert(context, 14)),
    );
  }

  void _submitFeedback() async {
    setState(() {
      submit = true;
      errorMessage = null;
    });

    Map body = {
      'patient_id' : 0,
      'appointment_id': widget.feedbackModel.appID,
      'doctor_id': widget.feedbackModel.doctorID,
      'user_id': widget.feedbackModel.userId,
      'overall_experience': overAllExperience ? "1" : '0',
      'doctor_checkup': doctorCheckup ? "1" : '0',
      'staff_behavior': staffBehaviour ? "1" : '0',
      'clinic_environment': clinicEnvironment ? "1" : '0',
      'comment': _controllerComment.text,
    };

    print(body);

    var response = await API(context: context, showSnackbarForError: false)
        .post(url: SUBMIT_FEEDBACK_URL, body: body);
    setState(() {
      submit = false;
    });

    if (response == NO_CONNECTION) {
      setState(() {
        errorMessage = TranslationBase.of(context).internetError;
      });
      return;
    }

    if (response is Response) {
      setState(() {
        feedbackSubmitted = true;
      });
    } else {
      setState(() {
        errorMessage = response;
      });
    }
  }
}
