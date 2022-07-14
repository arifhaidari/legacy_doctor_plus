// const String BASE_URL = "https://doctorplus.io";
// const String BASE_URL = "http://18.220.250.81";
const String BASE_URL = "https://doctorplus.af";
//const String BASE_URL = "http://192.168.10.228:8000";
//https://doctorplus.io

// const String CHAT_FILE_URL = BASE_URL + "/doctor/public/chat/file/";
// const String CHAT_VOICE_URL = BASE_URL + "/doctor/public/chat/voice/";

const String CHAT_FILE_URL = BASE_URL + "/chat/file/";
const String CHAT_VOICE_URL = BASE_URL + "/chat/voice/";

const String _DOCUMENT_URL = BASE_URL + "/images/";
// const String _DOCUMENT_URL = BASE_URL + "/doctor/public/images";
const String MEDICAL_RECORD_URL = _DOCUMENT_URL + "medicalrecords/";
// const String MEDICAL_RECORD_URL = _DOCUMENT_URL + "/medicalrecords/";
//http://fsh.af/document/pateint/
//http://fsh.af/doctor/public/images/doctor
//http://fsh.af/doctor/public/images/medicalrecords/

const String IMAGE_URL = BASE_URL + "/images";
// const String IMAGE_URL = BASE_URL + "/doctor/public/images";
const String FAMILY_IMAGE_URL = IMAGE_URL + "/pateint/";
const String DOCTOR_IMAGE_URL = IMAGE_URL + "/doctor/";
const String USER_IMAGE_URL = IMAGE_URL + "/user/";
const String SPECIALITY_IMAGE_URL = IMAGE_URL + "/specialities/";
const String BLOG_IMAGE_URL = IMAGE_URL + "/blog/";

const String API_URL = BASE_URL + "/api/";

const String NO_CONNECTION = 'no_connection';
const String CHECK_INTERNET_CONNECTION = 'www.google.com';

const String SECRET_KEY = "DoctorPlusAPPKEY";
// const String SECRET_KEY = "DoctorPlus_APP_KEY";
// const String SECRET_VALUE = "_!_@_#_D_o_c_t_o_r_P_l_u_s_#_@_!_";
// const String SECRET_VALUE = "!@_#_\$_D_o_c_t_o_r_P_l_u_s_\$_#_@_!_";
const String SECRET_VALUE = "_!_@_#_\$_D_o_c_t_o_r_P_l_u_s_\$_#_@_!_";

///GET
const String UNREAD_NOTIFICATION_URL = API_URL + "user-get-all-unread-notification/";
const String ALL_NOTIFICATION_URL = API_URL + "user-get-all-notification/";
const String READ_ALL_NOTIFICATION_URL = API_URL + "user-update-read-notification/";

const String SPECIALITY_URL = API_URL + "get-All-Spaciality";
const String SPECIALITY_DOCTOR_URL = API_URL + "get-All-Spaciality-and-doctors";
const String BOOKMARK_DOCTOR_URL = API_URL + "bookmark-doctor";
const String UN_BOOKMARK_DOCTOR_URL = API_URL + "cancel-bookmark-doctor";
const String DISTRICT_URL = API_URL + "get-All-District";
//const String DOCTORS_URL = API_URL + "get-All-Doctors";
const String FILTER_URL = API_URL + "search-by-filter";
// const String SPEC_STAR_DOCTOR_URL = API_URL + "get-Spac-star-avail-of-doctor-by-id";  //not used in the app
// const String DOCTORS_BY_SPECIALITY_AND_DISTRICT_URL =
//     API_URL + "search-Doctor-by-spaciality-and-district";
const String DOCTOR_INFO_URL = API_URL + "get-doctor-info/";
const String BLOG_URL = API_URL + "get-All-Blogs";
const String GET_DOCTOR_SAVED_CLINIC_URL = API_URL + "doctor-view-save-clinic/";

///PUT
///DELETE
///POST
const String FORGET_PASSWORD_URL = API_URL + "forgot-password";
const String PHONE_NUMBER_URL = API_URL + "send-number";
const String LOGIN_URL = API_URL + "login";
const String PHONE_VERIFICATION_URL = API_URL + "check-verification-code";
// const String VERIFY_PHONE_FOR_FORGET = API_URL + "api-goes-here";
const String UPDATE_NEW_PASSWORD = API_URL + "user-update-pass";
// Map body = {'phone_number': widget.number, 'new_password': _controller.text};
const String REGISTER_URL = API_URL + "user-register";

const String BOOK_APPOINTMENT_DOCTOR_AVAILABILITY_URL = API_URL + "book-Appointment";
const String CREATE_STORE_APPOINTMENT_URL = API_URL + "store-Appointment";
const String UPDATE_STORE_APPOINTMENT_URL = API_URL + "update-appointment-user";
const String VIEW_BLOG_URL = API_URL + "";

///Patient
const String MY_PROFILE_URL = API_URL + "patient-profile";
const String UPDATE_PATIENT_PROFILE_URL = API_URL + "update-patient-profile";
const String MY_DOCTOR_URL = API_URL + "my-doctor";
const String ADD_FAMILY_MEMBER_URL = API_URL + "add-family-member";
const String UPDATE_FAMILY_MEMBER_URL = API_URL + "update-family-member";
const String VIEW_ALL_FAMILY_MEMBER_URL = API_URL + "view-all-family-member";
const String ALL_APPOINTMENT_LIST_URL = API_URL + "all-appointment-list";
const String MY_APPOINTMENT_LIST_URL = API_URL + "my-appointment-list";
const String FAMILY_APPOINTMENT_LIST_URL = API_URL + "family-appointment-list";
const String CANCEL_APPOINTMENT_URL = API_URL + "cancel-appointment";
const String ADD_MEDICAL_RECORD_URL = API_URL + "add-medical-records";
const String UPDATE_MEDICAL_RECORD_URL = API_URL + "update-medical-records";
const String ADD_FILE_MEDICAL_RECORD_URL = API_URL + "add-new-files-to-records";
const String DELETE_MEDICAL_RECORD_FILE_URL = API_URL + "user-delete-files-of-record";
const String VIEW_MEDICAL_RECORDS_URL = API_URL + "view-all-medical-records";
const String DELETE_MEDICAL_RECORD_URL = API_URL + "delete-medical-records";
const String DELETE_FAMILY_PROFILE_URL = API_URL + "delete-family-member";
const String GET_FILES_MEDICAL_RECORD_URL = API_URL + "view-files-of-record";
const String PENDING_FEEDBACK_URL = API_URL + "pending-feedback";

const String GET_APPOINTMENT_URL = API_URL + "get-appointment";
const String SUBMIT_FEEDBACK_URL = API_URL + "store-feedback";

const String GET_ALL_PREVIOUS_MESSAGES_URL = API_URL + "user-get-all-message";
const String SEND_VOICE_URL = API_URL + "user-send-voice";
const String SEND_MESSAGE_URL = API_URL + "user-send-text";
const String SEND_FILE_URL = API_URL + "user-send-file";
const String DELETE_CHAT_URL = API_URL + "user-delete-text-chat/";
const String MY_DOCTOR_RELATED_APPOINTMENT = API_URL + "my-doctor-related-appointment/";
const String ALLOW_SHARING_THE_RECORED = API_URL + "allow-sharing-the-record";
const String ALLOW_SHARING_RECORED = API_URL + "allow-sharing-record";
const String CHANGE_LANG = API_URL + "change-lang";
const String list_family_member_get_appointment = API_URL + "list-family-member-get-appointment";
