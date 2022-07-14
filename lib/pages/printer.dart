//import 'dart:async';
//import 'dart:io';
//
//import 'package:flutter/foundation.dart';
//import 'package:flutter/rendering.dart';
//import 'package:flutter/services.dart';
//import 'package:pdf/pdf.dart';
//import 'package:pdf/widgets.dart' as pw;
//
//import 'package:doctor_app/model/medical_record/medical_record_model.dart';
//import 'package:flutter/material.dart';
//import 'package:printing/printing.dart';
//
//class PrinterPage extends StatefulWidget {
//  final MedicalRecordModel medicalRecordModel;
//
//  const PrinterPage({Key key, this.medicalRecordModel}) : super(key: key);
//  @override
//  _PrinterPageState createState() => _PrinterPageState();
//}
//
//class _PrinterPageState extends State<PrinterPage> {
//  final GlobalKey<State<StatefulWidget>> pickWidget = GlobalKey();
//
//  Printer selectedPrinter;
//
//  PrintingInfo printingInfo;
//
//
//  @override
//  void initState() {
//    Printing.info().then((PrintingInfo info) {
//      setState(() {
//        printingInfo = info;
//      });
//    });
//    super.initState();
//  }
//
//  Future<void> _pickPrinter() async {
//    print('Pick printer ...');
//
//    // Calculate the widget center for iPad sharing popup position
//    final RenderBox referenceBox = pickWidget.currentContext.findRenderObject();
//    final Offset topLeft =
//    referenceBox.localToGlobal(referenceBox.paintBounds.topLeft);
//    final Offset bottomRight =
//    referenceBox.localToGlobal(referenceBox.paintBounds.bottomRight);
//    final Rect bounds = Rect.fromPoints(topLeft, bottomRight);
//
//    try {
//      final Printer printer = await Printing.pickPrinter(bounds: bounds);
//      print('Selected printer: $selectedPrinter');
//
//      setState(() {
//        selectedPrinter = printer;
//      });
//    } catch (e) {
//      print(e);
//    }
//  }
//
//  @override
//  Widget build(BuildContext context){
//    return Scaffold(
//      body: Column(children: <Widget>[
//        printingInfo?.canPrint??false?  :Container()
//      ],),
//    );
//  }
//}
