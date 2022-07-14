import 'dart:async';

import 'package:dio/dio.dart';
import 'package:doctor_app/api/api_name.dart';
import 'package:doctor_app/model/medical_record/medical_record_model.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/widgets.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

import '../medicalRecord.dart';

Future<pw.Document> generateDocumentImage(
    PdfPageFormat format, String imageURL) async {
  final pw.Document doc = pw.Document();

  final PdfImage docImage = await pdfImageFromImageProvider(
      pdf: doc.document,
      image: NetworkImage(imageURL),
      onError: (dynamic exception, StackTrace stackTrace) {
        print('Unable to download image');
      });


  doc.addPage(pw.Page(
  clip: true,
  build: (pw.Context context) {
    return pw.Container(
      width: docImage.width.toDouble(),
      height: docImage.height.toDouble(),
      child: pw.Image(docImage),
    ); // Center
  }),

  );

  return doc;
}

//Future<pw.Document> generateDocumentPDF(
//    PdfPageFormat format, String filePath) async {
//  final pw.Document doc = pw.Document();
//
//    doc.addPage(pw.Page(build: (pw.Context context) {
//      return pw.Container(
//        width: docImage.width.toDouble(),
//        height: docImage.height.toDouble(),
//        child: pw.Image(docImage),
//      ); // Center
//    }));
//
//  return doc;
//}
