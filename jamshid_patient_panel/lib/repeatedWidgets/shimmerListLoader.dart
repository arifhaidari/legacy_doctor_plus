import 'package:doctor_app/repeatedWidgets/circularImage.dart';
import 'package:doctor_app/res/color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cupertino_date_picker/flutter_cupertino_date_picker.dart';
import 'package:shimmer/shimmer.dart';
class ShimmerList extends StatelessWidget {
  int itemCount;
  ShimmerList({this.itemCount});
  @override
  Widget build(BuildContext context) {
    int offset = 0;
    int time = 800;

    return SafeArea(
      child: ListView.separated(
        separatorBuilder: (BuildContext context, int index){
          return SizedBox(height: 10,);
        },
        itemCount: itemCount??3,
        itemBuilder: (BuildContext context, int index) {
          offset += 5;
          time = 800 + offset;
          print(time);
          return  Shimmer.fromColors(
                highlightColor: portionColor.withOpacity(0.5),
                baseColor: portionColor,
                child: Container(
                    height: 160,
                    margin: EdgeInsets.symmetric(
                        horizontal:
                        13),
                    padding: EdgeInsets.symmetric(
                        horizontal:
                        10,
                        vertical: 15),
                    color: portionColor.withOpacity(0.1),
                    //height: 132,
                    child: Row(
                      crossAxisAlignment:
                      CrossAxisAlignment.start,
                      mainAxisAlignment:
                      MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Expanded(
                          child: InkWell(
                            onTap: () {

                            },
                            child: Container(
                              child: Row(
                                crossAxisAlignment:
                                CrossAxisAlignment.start,
                                children: <Widget>[

                                  SizedBox(
                                    width: 10,
                                  ),
                                  Container(
                                    child: Column(
                                      crossAxisAlignment:
                                      CrossAxisAlignment
                                          .start,
                                      children: <Widget>[
                                        Container(
                                          child: RichText(
                                            maxLines: 1,
                                            text: TextSpan(
                                                text: "",
                                                style:
                                                TextStyle(
                                                  //color: buttonColor,
                                                  fontSize: 14,
                                                  fontFamily:
                                                  "Lato-Regular",
                                                )),
                                          ),
                                        ),
                                        SizedBox(
                                            height: 4
                                        ),
                                        Container(
                                            height: 15,
                                            width: 170,
                                            child: ListView.separated(
                                              itemBuilder:  (BuildContext context, int spIndex){
                                                return RichText(
                                                  maxLines: 2,
                                                  text: TextSpan(text: "",
                                                      style: TextStyle(
                                                          fontFamily:
                                                          "LatoRegular",
                                                          fontSize: 10,
                                                          color: Color(
                                                              0xff000000))
                                                  ),
                                                );
                                              }, separatorBuilder: (BuildContext context, int spIndex){
                                              return Container(
                                                width: 3,
                                              );
                                            },
                                              itemCount: 0,
                                              physics: ScrollPhysics(),
                                              shrinkWrap: true,
                                              scrollDirection: Axis.horizontal,

                                            )
                                        ),
                                        SizedBox(
                                            height: 4
                                        ),
                                        Row(
                                          children: <Widget>[
//                                  Container(
//                                    child:
////                                    Image.asset(
////                                      "assets/icons/Map_1614.png",
////                                      height: 15,
////                                    ),
//                                  ),
                                            SizedBox(
                                              width: 5,
                                            ),
                                            Align(
                                              alignment: Alignment
                                                  .centerLeft,
                                              child: Text("",
                                                  style: TextStyle(
//                                            color: Color(
//                                                0xff7e7e7e),
                                                      fontSize:
                                                      10,
                                                      fontFamily:
                                                      "Lato-Regular")),
                                            ),
                                          ],
                                        ),
                                        SizedBox(
                                            height: 15
                                        ),
                                        Column(
                                          crossAxisAlignment:
                                          CrossAxisAlignment
                                              .start,
                                          children: <Widget>[
                                            Container(
                                              // color: Colors.deepOrange,
                                              child: Row(
                                                children: <
                                                    Widget>[
                                                  Container(
                                                    child:
                                                    RichText(
                                                      maxLines:
                                                      1,
                                                      text: TextSpan(
                                                          text: "",
                                                          style: TextStyle(
                                                            fontFamily:
                                                            "LatoRegular",
                                                            fontSize:
                                                            11,
//                                                  color:
//                                                  Colors.black,
                                                          )),
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ),
                                            SizedBox(
                                                height:3
                                            ),
                                            Container(
                                              //color: Colors.deepOrange,
                                              child: Row(
                                                children: <
                                                    Widget>[
                                                  Container(
                                                    child:
                                                    RichText(
                                                      text: TextSpan(
                                                          text: "",
                                                          style: TextStyle(
                                                            //color:
//                                                  Colors.black,
                                                            fontSize:
                                                            11,
                                                            fontFamily:
                                                            "LatoRegular",
                                                          )),
                                                    ),
                                                  ),
                                                  Container(
                                                    child:
                                                    RichText(
                                                      text: TextSpan(
                                                          text: "",
                                                          style: TextStyle(
//                                                  color:
//                                                  Color(0xff7e7e7e),
                                                            fontSize:
                                                            11,
                                                            fontFamily:
                                                            "LatoRegular",
                                                          )),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        Container(
                          child: Column(
                            crossAxisAlignment:
                            CrossAxisAlignment.end,
                            children: <Widget>[

                              SizedBox(
                                  height:4
                              ),
                              Container(
                                child: RichText(
                                  textAlign: TextAlign.center,
                                  text: TextSpan(
                                      text: "",
                                      style: TextStyle(
                                        fontFamily:
                                        "LatoRegular",
                                        fontSize: 10,
//                                color:
//                                buttonColor
                                      )
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 38,
                              ),
//                    Container(
//                      child: GestureDetector(
//                        onTap: () {
//
//                        },
//                        child: Container(
//                          height: 30,
//                          width: 150,
//                          decoration: BoxDecoration(
//                              borderRadius:
//                              BorderRadius
//                                  .circular(2),
//                              color: buttonColor),
//                          child: Center(
//                            child: Text("",
//                              style: TextStyle(
//                                fontFamily:
//                                "LatoRegular",
//                                fontSize: 10,
//                                color: Colors.white,
//                              ),
//                            ),
//                          ),
//                        ),
//                      ),
//                    ),
                            ],
                          ),
                        ),
                      ],
                    )),
                period: Duration(milliseconds: time),
              );
        },
      ),
    );
  }
}

class serachFieldShimmerLoader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    int offset = 0;
    int time = 800;

    return SafeArea(
      child:   Shimmer.fromColors(
            highlightColor: portionColor.withOpacity(0.5),
            baseColor: portionColor,
            child: Container(
                height: 60,

                color: portionColor.withOpacity(0.1),
                //height: 132,

            ),
            period: Duration(milliseconds: time),
          )
    );
  }
}

