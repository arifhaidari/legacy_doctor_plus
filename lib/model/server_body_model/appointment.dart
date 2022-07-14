
import 'package:doctor_app/model/appointment/appointment_detail_model.dart';
import 'package:doctor_app/model/doctor/doctor_model.dart';

class CreateAppointment{
  DoctorModel doctor;
  String time;
  String date;

  AppointmentDetailModel appointmentDetailModel;

  CreateAppointment({this.doctor, this.time, this.date,this.appointmentDetailModel});

  Map<String,dynamic> toJsonForServer(){
    return {
      'DocotsID':doctor.doctorID,
      'date_of_appointment':date,
      'time_of_appointment':time
    };
  }

}