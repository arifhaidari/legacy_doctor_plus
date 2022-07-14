import 'package:doctor_app/model/doctor/doctor_model.dart';

class Util {
  static double remap(double value, double originalMinValue,
      double originalMaxValue,
      double translatedMinValue, double translatedMaxValue) {
    if (originalMaxValue - originalMinValue == 0) return 0;

    return (value - originalMinValue) /
        (originalMaxValue - originalMinValue) *
        (translatedMaxValue - translatedMinValue) +
        translatedMinValue;
  }
}

double uploadProgressPercentage(int sentBytes, int totalBytes) {
  double __progressValue = Util.remap(
      sentBytes.toDouble(), 0, totalBytes.toDouble(), 0, 1);

  __progressValue = double.parse(__progressValue.toStringAsFixed(2));

    return __progressValue;
}

// class ratingSorting implements Comparable{
//   DoctorModel a;
//
//   ratingSorting({
//     this.a,
//   });
//
//   @override
//   int compareTo(other) {
//     if (this.a == null || other == null) {
//       return null;
//     }
//
//     if (int.parse(this.a.doctorFeedback[0].stars) < int.parse(other.doctorFeedback[0].stars)) {
//       return 1;
//     }
//
//     if (int.parse(this.a.doctorFeedback[0].stars) > int.parse(other.doctorFeedback[0].stars)) {
//       return -1;
//     }
//
//     if (int.parse(this.a.doctorFeedback[0].stars)  int.parse(other.doctorFeedback[0].stars)) {
//       return 0;
//     }
//
//     return null;
//   }
//   }
// }