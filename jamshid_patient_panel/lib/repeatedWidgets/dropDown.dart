import 'package:doctor_app/res/color.dart';
import 'package:doctor_app/transulation/translations_delegate_base.dart';
import 'package:flutter/material.dart';
import 'package:doctor_app/res/size.dart';
import 'package:menu_button/menu_button.dart';
class dropDown extends StatefulWidget {
  double width;
  double height;
  String selectedItem;
  List itemList;
  Function onItemSelect;
  Color ContColor;
  Color BorderColor;
  Color selectedColor;
  double paddingTop;
  dropDown({this.paddingTop,this.selectedColor,this.BorderColor,this.ContColor,this.onItemSelect,this.width,this.height,this.selectedItem,this.itemList});
  @override
  _dropDownState createState() => _dropDownState();
}

class _dropDownState extends State<dropDown> {
  @override
  Widget build(BuildContext context) {
    return Container(
      //margin: EdgeInsets.symmetric(horizontal: 10),
      padding:  EdgeInsets.only(top: widget.paddingTop ?? 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: <Widget>[
          Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                Container(
                  width: widget.width ?? size.convert(context, 150),
                  height: widget.height ?? size.convert(context, 30),
                  child: MenuButton(
                      inContainerHeight: dropDownHeight(),
                      outContainerHeight: dropDownHeight(),
                    topDivider: true,
                    child: Container(
                        color: Colors.white,
                      padding: EdgeInsets.symmetric(horizontal: 8),
                      width: widget.width ?? size.convert(context, 150),
                      height: widget.height ?? size.convert(context, 30),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Expanded(
                            child: Container(
                              child: RichText(
                                maxLines: 1,
                                text: TextSpan(
                                    text: widget.selectedItem,
                                    style: TextStyle(
                                        fontSize: size.convert(context, 14),
                                        fontFamily: "LatoBold",
                                        color: widget.selectedColor ??buttonColor
                                    )
                                ),
                              ),
                            ),
                          ),
                          Container(
                            child: Icon(Icons.keyboard_arrow_down, color: buttonColor, size: size.convert(context, 14),),
                          ),
                        ],
                      ),
                    ),
                    items: widget.itemList ?? [TranslationBase.of(context).filterSelf,TranslationBase.of(context).filterFamily],
                    itemBuilder: (val){
                      return  Container(
                        color: Colors.white,
                        padding: EdgeInsets.symmetric(horizontal: 8),
                        //height: size.longestSide*0.04978038067,
                        //width: size.longestSide*0.229868228,
                        height: widget.height ?? size.convert(context, 30),
                        width: widget.width??size.convert(context, 148),
                        child: Row(
                          // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Expanded(
                              child: Container(
                                child: RichText(
                                  maxLines: 1,
                                  text: TextSpan(
                                      text: val,
                                      style: TextStyle(
                                          fontSize: size.convert(context, 14),
                                          fontFamily: "LatoBold",
                                          color: buttonColor
                                      )
                                  ),
                                ),
                              ),
                            ),

                          ],
                        ),
                      );
                    },
                    decoration: BoxDecoration(
                        border: Border.all(color: widget.BorderColor ?? buttonColor),
                        borderRadius: const BorderRadius.all(Radius.circular(3.0)),
                        color: widget.ContColor ?? Colors.transparent
                    ),
                    divider: Container(
                      height: 0.4,
                      color: Colors.white.withOpacity(0.1),
                    ),
                    onItemSelected: (value) {
                      setState(() {
                        widget.selectedItem = value;
                        widget.onItemSelect(value);
                      });
                      // Action when new item is selected
                    },
                    toggledChild: Container(
                      color: Colors.transparent,
                      padding: EdgeInsets.symmetric(horizontal: 8),
                      width: widget.width ?? size.convert(context, 150),
                      height: widget.height ?? size.convert(context, 30),
                      child: Row(
                        // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Expanded(
                            child: Container(
                              child: RichText(
                                maxLines: 1,
                                text: TextSpan(
                                    text: widget.selectedItem,
                                    style: TextStyle(
                                        fontSize: size.convert(context, 14),
                                        fontFamily: "LatoBold",
                                        color: widget.selectedColor??buttonColor
                                    )
                                ),
                              ),
                            ),
                          ),

                        ],
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),

        ],
      ),
    );
  }
  double dropDownHeight(){
    if(widget.itemList!=null){
      if(widget.itemList.length>5){
        return 200;
      }
      else{
        print("greater then 5");
        print("${(widget.itemList.length+1)*30.1}");
        return (widget.itemList.length)*30.0;
      }
    }
    else{
      return 0.1;
    }
  }
}

