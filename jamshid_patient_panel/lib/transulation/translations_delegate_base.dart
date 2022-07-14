import 'dart:async';

import 'package:flutter/foundation.dart' show SynchronousFuture;
import 'package:flutter/material.dart';

class TranslationBase {
  TranslationBase(this.locale);

  final Locale locale;

  static TranslationBase of(BuildContext context) {
    return Localizations.of<TranslationBase>(context, TranslationBase);
  }

  static Map<String, Map<String, String>> _localizedValues = {
    'en': {
      "yourSelectedProvince": "Your selected province is",
      "deleteMedicalRecord": "Delete medical record",
      "comfirmMessageDeleteMedicalRecord": "Are you sure to delete medical record ?",
      "from": "From:",
      "noDoctorMatched": "No Doctor Found",
      "speciality": "Speciality",
      "noSpecialityMatched": "No Speciality matched",
      "clinic": "Clinic",
      "noClinicMatched": "No clinic matched",
      "patients": "Patients",
      "comfirmMessageDeleteRecord": "Are you sure to delete record ?",
      "read": "Read",
      "notifications": "Notifications",
      "forgetPassword": "Forget Password?",
      "thankFeedback": "Thank You For Your Feedback!",
      "signIn": "Sign in",
      "createNewAccount": "Create new account",
      "haveAnAccountSignIn": "Have an Account? Sign in",
      "today": "Today",
      "slots": "slots",
      "noTimeSlotAvailable": "No time slot available",
      "afternoon": "Afternoon",
      "evening": "Evening",
      "night": "Night",
      "min": "min",
      "good": "Good",
      "bad": "Bad",
      "upcoming": "UpComing",
      "current": "Current",
      "expire": "Expire",
      "getDistrict": "en",
      "Langkey": "en",
      "currencySymbol": "AFN",
      "free": "Free",
      "fee": "Fee",
      "comfirmMessageCancelAppointment": "Are you sure to cancel appointment ?",
      "appointments": "Appointments",
      "review": "Review",
      "YearOfExperience": "years experience",
      "all": "All",
      "Father": "Father",
      "Mother": "Mother",
      "Brother": "Brother",
      "Sister": "Sister",
      "Wife": "Wife",
      "Son": "Son",
      "Daughter": "Daughter",
      "Friend": "Friend",
      "Other": "Other",
      "viewAccount": "View Account:",
      "oldPassword": "Old Password",
      "select_City": "Select Province",
      "comment": "Comment",
      "familyProfileDeleted": "Family Profile Deleted",
      "chat": "Chat",
      "sendMessage": "Send Message",
      "sendPassword": "A New Password has been sent to your phone number",
      "bothGender": "Both",
      "availableAll": "All",
      "noAppointmentFound": "No Appointment Found",
      "localization": "en_us",
      "login": "Login",
      "allSlotBooked": "All time slots are booked.\n "
          "Please book appointment for future Date",
      "services": "Services",
      "education": "Education",
      "specialization": "Specialization",
      "professionalMembership": "Professional membership",
      "otherInformaion": "Other Information",
      "selectatimeslot": "Select a time slot",
      "updateMedicalRecord": "Medical Record Updated Successfully",
      "addedMedicalRecord": "Medical Record Added Successfully",
      "close": "Close",
      "addRecord": "Add Record",
      'english': "English",
      'dari': "dari",
      'pashto': "Pashto",
      'selectedFlag': "assets/icons/enIcon.png",
      'no_result_found': "No search result found yet",
      'ShowingTop': 'Showing top',
      'In': 'in',
      'allDistrict': 'All District',
      'selectLanguage': 'en',
      "numberHint": "e.g 0771234567",
      "number": "Number",
      "doctorLocation": "Showing top 499 Gynecologists in Kabul",
      "experience": "Experience",
      "year": "Year(s)",
      "appointmentcanceled": "Your appointment successfully canceled",
      "addARecord": "Add a record",
      "takeAPhoto": "Take a photo",
      "uploadFromGallery": "Upload from gallery",
      "uploadFiles": "Upload files",
      "print": "Print",
      "updateRecord": "Update Record",
      "position": "left",
      "addMedicalRecord": "Add Medical Record",
      "recordFor": "Record For",
      "typeOfRecord": "Type of record",
      "medicalRecord": "Medical Record",
      "prescription": "Prescription",
      "recordDate": "Record date",
      "doctor": "Doctor",
      "addNameIdentifyRecord": "Add name identify Records",
      "createRecord": "Create Record",
      "open": "Open",
      "editRecord": "Edit Record",
      "deleteRecord": "Delete Record",
      "submit": "Submit",
      "addyourfeedback": "add your feedback",
      "doctorFeedBackMessage":
          "A highly personable, competent, able to put patients as ease and establish subtle and superior diagnostic skill.",
      "yes": "Yes",
      "no": "No",
      "logoutConfirmMessage": "Are you sure want to logout ?",
      "addMedicalRecordsButtonText": "Add medical records",
      "shareRecords": "Share your medical records with doctors",
      "accessRecordIOngo": "Access prescriptions, reports and more",
      "neverloserecords": "Never lose your medical records",
      "allrecordsoneplace": "All your medical records in one place",
      "noBookmarkedDoctors": "You have no bookmarked doctors",
      "favoriteDoctor": "Favorite a doctor for having an easy access to them whenever in need",
      "enterPasswordAgain": "Enter password again",
      "accountPassword": "Account Password",
      "completeyourProfile": "Complete Your Profile",
      "addNewProfile": "Add New",
      "select_family_member": "Select Family Member",
      "updateProfile": "Update Profile",
      "createProfile": "Create Profile",
      "bookingInformation": "Booking Information",
      "appointmentBooked": "Appointment booked!",
      "sentMessageDoneAppointment":
          "We have sent you an Notification with your appointment details. We will also send timely appointment reminders",
      "done": "Done",
      "cancel": "Cancel",
      "dateOfBirthhints": "Enter Date of Birth",
      "dateOfBirth": "Date of Birth",
      "bookingFor": "Booking for",
      "namehints": "Name",
      "relationshiphints": "Relationship",
      "dateandTime": "Date and Time",
      "someOneElse": "Some One Else",
      "enterPatentDetailsPageheader": "Select Patient",
      "messagesent": "Message has been sent to",
      "edit": "(Edit)",
      "enterVerificationCode": "Please enter the 6-digit verification code sent to",
      "selectNetwork": "Select your mobile network",
      "resentotp": "RESENTOTP",
      "verifyandSignUp": "Verify and Sign up",
      "needHelp": "Need help? Call us",
      "salaam": "Salaam",
      "etisalat": "Etisalat",
      "mtn": "MTN",
      "awcc": "AWCC",
      "roshan": "Roshan",
      "edit": "Please enter the 6-digit verification code sent to",
      "loginSignUpText": "login / Sign up",
      "numberhints": "Number",
      "passwordhints": "Enter password",
      "repasswordhints": "Confirm password",
      "continuebuttonText": "Continue",
      "afterNoon": "After Noon",
      "noBookingFee": "(No Booking Fee)",
      "bookAppointmentbuttontext": "Book Appointment ",
      "availableToday": "Available today",
      "availableNext3day": "Available next 3 days",
      "male": "Male",
      "female": "Female",
      "apply": "Apply",
      "reset": "Reset",
      "filter": "Filter",
      "morning": "Morning",
      "gender": "Gender",
      "myProfile": "My Profile",
      "myDoctor": "My Doctor",
      "familyProfile": "Family Profiles",
      "viewBlog": "View Blog",
      "blog_list": "Blogs",
      "language": "Language",
      "logout": "Logout",
      "filterSelf": "Self",
      "filterFamily": "Family",
      "serverNotResponding": "Internet connection issue. Please try again",
      "methodNotAllowed": "Method Not Allowed",
      "contactSupport": "Contact Support",
      "invalidNumber": "Number must be 10 digits",
      "invalidUserName": "Invalid User Name",
      "invaliddateOfBirth": "Invalid Date of Birth",
      "profileUpdatedSuccess": "Profile Updated Success",
      "invalidConfirmPassword": "Invalid Confirm Password",
      "retry": "Retry",
      "internetError": "No Internet Connection",
      "passwordShort": "Password to short",
      "cancel_Appointment": "Cancel Appointment",
      "reschdule": "Reschedule",
      "bMy_Appointments": "My Appointments",
      "bMedical_Records": "Medical Records",
      "Nangarhar": "Nangarhar",
      "Herat": "Herat",
      "kandahar": "kandahar",
      "kabul": "kabul",
      "helpLine": "Helpline",
      "locationhints": "USE CURRENT LOCATION",
      "searchTitle": "Doctors, hospitals, specialties, services, diseases",
      'title': 'Hello World',
      'subTitle': 'Sub Title',
      'next_page': 'Next Page',
      'your_location': 'Best Doctor, Best Treatment.',
      'internet': 'No Internet Connection',
      'invalid_number': 'Invalid Phone Number',
      'invalid_password': 'Invalid Password',
      'password_short': 'Password to short',
      // 'retry': 'Retry',
      'invalid_user_name': 'Incorrect Name',
      'date_of_birth': 'Incorrect Date of Birth',
      'profile_updated_success': 'Profile Updated Successfully',
      'contact_support': 'Contact Support',
      'familyAddedSuccess': 'Successfully Added Family Memeber ',
      'selectFileError': 'Add atleast one file',
      'provideDateError': 'Date is Required',
      'doctorNameRequired': 'Doctor Name is Required',
      'invalid_conform_password': 'Confirm Password not matched',
      'select_time': 'Please Select Time',
      'appointmnetcanceled': 'Appointment Cancelled',
      'pleaseLogin': 'Only Authenticated Memeber is allowed',
      'medicalRecordDeleted': 'Medical Record Deleted',
      'availability': 'Availability',
      'coderesend': 'OTP code send again',
      'bookmarkSuccess': 'Doctor Bookmarked',
      'unbookmarkSuccess': 'Successfully Removed Doctor Form Bookmarked',
      "patientsWereHappyWith": "Patients were happy with",
      "overallExperience": "Overall\nExperience",
      "doctorCheckup": "Doctor\nCheckup",
      "staffBehavior": "Staff\nBehavior",
      "clinicEnvironment": "Clinic \nEnvironment"
    },
    'ar': {
      "yourSelectedProvince": "ولایت انتخاب شده شما",
      "deleteMedicalRecord": "سوانح صحی را حذف کنید",
      "comfirmMessageDeleteMedicalRecord": "مطمئن هستید تا سوانح صحی حذف شود؟",
      "from": "از ",
      "noDoctorMatched": "داکتر مطابقت ندارد",
      "speciality": "تخصص",
      "noSpecialityMatched": "تخصص مطابقت ندارد",
      "clinic": "معاینه خانه",
      "noClinicMatched": "معاینه خانه مطابقت ندارد",
      "patients": "بیماران",
      "comfirmMessageDeleteRecord": "مطمئن هستید تا سوانح حذف شود؟",
      "read": "خواندن",
      "notifications": "اطلاعیه",
      "forgetPassword": "رمز را فراموش کرده اید؟",
      "thankFeedback": "تشکر از نظر شما",
      "signIn": "داخل شوید",
      "createNewAccount": "حساب جدید باز کنید",
      "haveAnAccountSignIn": "حساب دارید؟ داخل شوید",
      "today": "امروز",
      "slots": "وقت ملاقات",
      "noTimeSlotAvailable": "وقت ملاقات دریافت نشد",
      "afternoon": "بعد از ظهر",
      "evening": "عصر",
      "night": "شب",
      "min": "دقیقه",
      "good": "خوب",
      "bad": "بد",
      "upcoming": "پیشرو",
      "current": "اکنون",
      "expire": "منقضی ",
      "getDistrict": "fa",
      "Langkey": "fa",
      "currencySymbol": "افغانی",
      "free": "رایگان",
      "fee": "فیس",
      "comfirmMessageCancelAppointment": "مطمئن هستید که قرار ملاقات را لغو کنید؟",
      "appointments": "ملاقات ها",
      "review": "ارزیابی",
      "YearOfExperience": "سال تجربه",
      "reschdule": "دوباره ملاقات بگیرید",
      "all": "همه",
      "Father": "پدر",
      "Mother": "مادر",
      "Brother": "برادر",
      "Sister": "خواهر",
      "Wife": "همسر",
      "Son": "پسر",
      "Daughter": "دختر",
      "Friend": "دوست",
      "Other": "دیگر",
      "viewAccount": "حساب را ببینید:",
      "oldPassword": "رمز قبلی",
      "select_City": "ولایت",
      "comment": "اظهار نظر",
      "familyProfileDeleted": "پروفایل خانواده گی حذف شد",
      "chat": "مکالمه",
      "sendMessage": "پيام ارسال کنید",
      "sendPassword": "گذرواژه جدیدی به شماره تلفن شما ارسال شده است",
      "bothGender": "هر دو",
      "availableAll": "همه",
      "noAppointmentFound": "قرار ملاقات وجود ندارد",
      "localization": "per",
      "login": "داخل شوید",
      "allSlotBooked": "تمام اوقات گرفته شده لطفا بعدا قرار ملاقات بگیرید",
      "services": "خدمات",
      "education": "تحصیلات",
      "specialization": "تخصص",
      "professionalMembership": "عضويت مسلکی",
      "otherInformaion": "معلومات دیگر",
      "selectatimeslot": "وقت بگیرید",
      "updateMedicalRecord": "سوابق پزشکی با موفقیت به روز شد",
      "addedMedicalRecord": "سوانح صحی به موفقیت اپدیت شد",
      "close": "بستن",
      "addRecord": " سوانح را اضافه کنید",
      "english": "انگلیسی",
      "dari": "دری",
      "pashto": "پشتو",
      "selectedFlag": "assets/icons/afhanflag.png",
      'no_result_found': "نتیجه جستجو یافت نشد",
      "ShowingTop": "نشان دادن بالا",
      "In": " در",
      "allDistrict": "همه ولسوالی ها",
      "selectLanguage": "ar",
      "numberHint": "به عنوان مثال 0771234567",
      "number": "شماره ",
      "doctorLocation": "۴۹۹ داکتران ورزیده نسائی ولادی در کابل",
      "experience": "تجربه کاری",
      "year": "سال",
      "appointmentcanceled": "قرار ملاقات شما با موفقیت لغو شد",
      "addARecord": "ریکارد را اضافه کنید",
      "takeAPhoto": "عکس بگیرید",
      "uploadFromGallery": "از البم بالا کنید",
      "uploadFiles": "فایل را اپلود کنید",
      "print": "چاپ",
      "updateRecord": "ویرایش سوانح صحی",
      "position": "right",
      "addMedicalRecord": "سوانح صحی را اضافه کنید",
      "recordFor": "مریض",
      "typeOfRecord": "نوع ریکارد",
      "medicalRecord": "دیگر اسناد صحی",
      "prescription": " نسخه",
      "deleteRecord": "ضبط را حذف کنید",
      "recordDate": "تاریخ ثبت",
      "doctor": "داکتر",
      "addNameIdentifyRecord": "ریکارد اسم تشخیص شده را اضافه کنید",
      "createRecord": "ذخیره ریکارد",
      "open": "باز کن",
      "editRecord": "ایدیت ریکارد",
      "submit": "ارسال",
      "addyourfeedback": "نظرتان را شریک کنید",
      "doctorFeedBackMessage":
          "یک فرد کاملاً پرسنل ، شایسته و قادر به قرار دادن بیماران به آسانی و مهارت تشخیصی ظریف و برتر است.",
      "yes": "بلی",
      "no": "نخیر",
      "logoutConfirmMessage": "مطمئن هستید که خارج شوید؟",
      "addMedicalRecordsButtonText": "سوانح صحی را اضافه کنید",
      "shareRecords": "سوانح صحی خویش را با داکتران شریک نماید",
      "accessRecordIOngo": "دسترسی به نسخه ها، راپور، معاینات و معلومات بیشتر تان",
      "neverloserecords": "معلومات تان را برای همیش حفظ نماید",
      "allrecordsoneplace": "تمام سوانح صحی تان در یک مکان",
      "noBookmarkedDoctors": "شما تاکنون داکتر را انتخاب نکرده اید",
      "favoriteDoctor": "داکتران قابل پسند خویش را انتخاب نمائید تا در صورت ضرورت در دست رس باشند",
      "enterPasswordAgain": "رمز عبوری را دوباره داخل کنید",
      "accountPassword": "رمز حساب",
      "completeyourProfile": "مشخصات خویش را تکمیل نمائید",
      "addNewProfile": "ایجاد کردن",
      "select_family_member": "انتخاب اقارب",
      "updateProfile": "ویرایش پروفایل",
      "createProfile": "ایجاد پروفایل",
      "bookingInformation": "معلومات قرار ملاقات",
      "appointmentBooked": "قرار ملاقات گرفته شد",
      "sentMessageDoneAppointment":
          "جزییات قرار ملاقات به شما فرستاده شد. اطلاعیه یادوری نیز فرستاده خواهد شد",
      "done": "شد",
      "cancel": "لغو",
      "dateOfBirthhints": "تاریخ تولد را داخل کنید",
      "dateOfBirth": "تاریخ تولد",
      "bookingFor": "برای شخصی که قرار ملاقات گرفته میشود",
      "namehints": " اسم",
      "relationshiphints": "رابطه",
      "dateandTime": "تاریخ و زمان",
      "someOneElse": "کسی دیگر",
      "enterPatentDetailsPageheader": "انتخاب بیمار",
      "messagesent": "به شخص پيام داده شد",
      "edit": "ویرایش کنید",
      "enterVerificationCode": "لطفاً کود شش عددی دریافت شده را داخل کنید",
      "selectNetwork": "شبکه تلفن خود را انتخاب کنید",
      "resentotp": "ارسال دوبارهء او تی پی",
      "verifyandSignUp": "تایید و حساب تان را باز کنید",
      "needHelp": "کمک نیاز دارید؟ در تماس شوید",
      "salaam": "سلام",
      "etisalat": "اتصالات",
      "mtn": "ایم ټي این",
      "awcc": "افغان بیسیم",
      "roshan": "روشن",
      "Please enter the 6-digit verification code sent to":
          "لطفاً کود شش عددی دریافت شده را داخل کنید",
      "loginSignUpText": "ورود / ثبت نام",
      "numberhints": "شماره",
      "passwordhints": "رمز را وارد کنید",
      "repasswordhints": "رمز را تاید کنید",
      "continuebuttonText": "تداوم",
      "afterNoon": "بعد از ظهر",
      "noBookingFee": "(وقت گرفتن هزینه ندارد)",
      "bookAppointmentbuttontext": " قرار ملاقات بگیرید ",
      "availableToday": "امروز در دسترس است",
      "availableNext3day": "در سه روز در دسترس می باشد",
      "male": "ذکور",
      "female": "اناث",
      "apply": "درخواست دادن",
      "reset": "تنظیم مجدد",
      "filter": "فلتر",
      "morning": "صبح",
      "gender": "جنسیت",
      "myProfile": "مشخصات من",
      "myDoctor": "داکتر من",
      "familyProfile": "مشخصات فامیلی",
      "viewBlog": "مشاهده بلاگ ها",
      "blog_list": "وبلاگ",
      "language": "لسان",
      "logout": "خارج شوید",
      "filterSelf": "خودم",
      "filterFamily": "خانواده",
      "serverNotResponding": "مشکلی در اتصال انترنت وجود دارد٬ لطفا دوباره کوشش کنید",
      "methodNotAllowed": "میتود اجازه ندارد",
      "contactSupport": "تماس حمایوی",
      "invalidNumber": "شماره باید ده عدد باشد",
      "invalidUserName": "اسم کاربر درست نمی باشد",
      "invaliddateOfBirth": "تاریخ تولد درست نمی باشد",
      "profileUpdatedSuccess": "پروفایل شما به موفقت جدید شد",
      "invalidConfirmPassword": "رمز شما درست نمی باشد",
      "retry": "دوباره کوشش کنید",
      "internetError": "مسئله اینترنت",
      "passwordShort": "رمز خیلی کوتاه است",
      "cancel_Appointment": "قرار ملاقات را لغو کنید",
      "rescdule": "دوباره ملاقات بگیرید",
      "bMy_Appointments": "قرار ملاقات های من",
      "bMedical_Records": "سوانح صحی",
      "Nangarhar": "ننگرهار",
      "Herat": "هرات",
      "kandahar": "کندهار",
      "kabul": "کابل",
      "helpLine": "تماس کمک",
      "locationhints": "محل فعلی تان را استفاده کنید",
      "searchTitle": "دوکتوران، شفاخانه ها، متخصصین، خدمات، بیماری",
      'title': 'سلام',
      'subTitle': 'عنوان عرفی',
      'next_page': 'صفحه بعدی',
      'your_location': 'بهترین داکتر، بهترین درمان',
      'internet': ' ',
      'invalid_number': 'شمارهء نادرست',
      'invalid_password': 'رمز نادرست',
      'password_short': 'رمز خیلی کوتاه است',
      // 'retry': 'دوباره کوشش کنید',
      'profile_updated_success': 'نمایه با موفقیت به روز شد',
      'invalid_user_name': 'اسم نادرست',
      'date_of_birth': 'تاریخ تولد نادرست میباشد',
      'contact_support': 'تماس حمایوی',
      'select_time': 'لطفاً وقت را تعیین کنید',
      'familyAddedSuccess': 'با موفقیت عضو خانواده اضافه شد',
      'selectFileError': 'کم از کم یک فایل اضافه نمائید',
      'provideDateError': 'تاریخ حتمی می باشد',
      'doctorNameRequired': 'اسم داکتر حتمی می باشد',
      'invalid_conform_password': 'رمز تایید شده مطابقت ندارد',
      'appointmnetcanceled': 'قرار ملاقات لغو شد',
      'pleaseLogin': 'تنها عضو مسؤول اجازه دارد',
      'medicalRecordDeleted': 'سوانح صحی حذف شد',
      'availability': 'دسترسی',
      'coderesend': 'کود OTP دوباره ارسال شد',
      'bookmarkSuccess': 'دکتر علامت گذاری شده',
      'unbookmarkSuccess': 'داکتر منتخب از لست حذف گردید',
      "patientsWereHappyWith": " بیماران رضایت داشتن از داکتر:",
      "overallExperience": "تجربه عمومی",
      "doctorCheckup": "معاینه داکتر",
      "staffBehavior": "برخورد کارمندان",
      "clinicEnvironment": "محیط معاینه خانه"
    },
    'ur': {
      "yourSelectedProvince": "ستاسو ټاکل شوی ولایت ",
      "deleteMedicalRecord": "طبي ریکارډ حذف کړئ",
      "comfirmMessageDeleteMedicalRecord": "ایا تاسو ډاډه یاست چې طبي ریکارډ حذف کړئ؟",
      "from": "له:",
      "noDoctorMatched": "هیڅ متخصص ونه موندل شو",
      "speciality": "ځانګړتیا",
      "noSpecialityMatched": "هیڅ خاصیت ندی برابر شوی",
      "clinic": "کلینیک",
      "noClinicMatched": "هیڅ کلینیک ندی",
      "patients": "ناروغان",
      "comfirmMessageDeleteRecord": "ایا تاسو ډاډه یاست چې ریکارډ حذف کړئ؟",
      "read": "ولولئ",
      "notifications": "خبرتیاوې",
      "forgetPassword": "پټ نوم مو هیر کړی؟",
      "thankFeedback": "مننه چې نظر مو راسره شریک کړ",
      "signIn": "ننوزئ",
      "createNewAccount": "نوی حساب جوړ کړه",
      "haveAnAccountSignIn": "اکاونټ لری؟ ننوزئ",
      "today": "نن",
      "slots": "سلاټونه",
      "noTimeSlotAvailable": "د وخت وخت نشته",
      "afternoon": "غرمه",
      "evening": "ماښام",
      "night": "شپه",
      "min": "دقیقه",
      "good": "ښه",
      "bad": "بد",
      "upcoming": "راتلونکي",
      "current": "اوسنی",
      "expire": "له نېټې اوښتی",
      "getDistrict": "fa",
      "Langkey": "pa",
      "currencySymbol": "افغانی",
      "free": "وړیا",
      "fee": "فیس",
      "comfirmMessageCancelAppointment": "ډاډه یاست چې خپل ملاقات لغو کړئ؟",
      "appointments": "ټاکنې",
      "review": "بېا کتنه",
      "YearOfExperience": "کاله تجربه",
      "all": "ټول",
      "Father": "پلار",
      "Mother": "مور",
      "Brother": "ورور",
      "Sister": "خور",
      "Wife": "مېرمن",
      "Son": "زوی",
      "Daughter": "لور",
      "Friend": "ملګری",
      "Other": "نور",
      "oldPassword": "مخکېنې پټ نوم",
      "select_City": "ولایت",
      "comment": "څرګندونه",
      "familyProfileDeleted": "د کورنۍ پروفایل ړنګ شو",
      "chat": "چیټ",
      "sendMessage": "پیغام ولېږئ",
      "sendPassword": "ستاسو د تلیفون شمیره ته نوی شفر استول شوی دی",
      "bothGender": "دواړه",
      "availableAll": "ټول",
      "noAppointmentFound": "هیڅ ټاکنه ونه موندل شوه",
      "localization": "pas",
      "login": "د ننه کیدل",
      "allSlotBooked": "د هر وخت سلاټونه ثبت شوي.\n "
          "مهرباني وکړئ د راتلونکي نیټې لپاره ناسته وکړئ",
      "services": "خدمات",
      "education": "تعلیم",
      "specialization": "تخصص",
      "professionalMembership": "مسلکي غړیتوب",
      "otherInformaion": "نور معلومات",
      "selectatimeslot": "وخت وټاکئ",
      "updateMedicalRecord": "سوابق پزشکی با موفقیت به روز شد",
      "addedMedicalRecord": "سوابق پزشکی با موفقیت اضافه شد",
      "close": "بندول",
      "addRecord": "+ سوانح اضافه کړئ",
      'english': "انګلیسي",
      'dari': "دري",
      'pashto': "پښتو",
      'selectedFlag': "assets/icons/afhanflag.png",
      'no_result_found': "د جستجو کومه پایله ونه موندل شوه",
      'ShowingTop': 'پورته ښیې',
      'In': 'په',
      'allDistrict': 'ټوله ولسوالۍ',
      'selectLanguage': 'ur',
      "numberHint": "د مثال په توګه 0771234567 ",
      "number": "شمیره",
      "doctorLocation": "په کابل کې د ښځینه وریجو لوړ پوړي 99 Showing ښیې",
      "experience": "کاري تجربه",
      "year": "کاله",
      "viewAccount": "حساب وګورئ:",
      "appointmentcanceled": "ستاسو ټاکنه په بریالیتوب سره لغوه شوه",
      "addARecord": "ریکارډ اضافه کړئ",
      "takeAPhoto": "انځور واخله",
      "uploadFromGallery": "له ګالري څخه اپلوډ",
      "uploadFiles": "فایلونه اپلوډ کړئ",
      "print": "چاپ",
      "updateRecord": "ریکارډ اپډیټ کړي",
      "position": "right",
      "addMedicalRecord": "عددي طبي ریکارډ",
      "recordFor": "مریض",
      "typeOfRecord": "د چمتووالي ریکارډ",
      "medicalRecord": "طبي اسناد",
      "prescription": "نسخه",
      "recordDate": "د ثبت نیټه",
      "doctor": "ډاکټر",
      "addNameIdentifyRecord": "د شمیرو نوم ثبت کول پیژندل",
      "createRecord": "ریکار ثبت کړئ ",
      "open": "خلاص",
      "editRecord": "ریکارډ",
      "deleteRecord": "حذف شوی ریکارډ",
      "submit": "وسپارئ",
      "addyourfeedback": "خپل نظر وليکئ",
      "doctorFeedBackMessage":
          "د هغې ګوډاګیان ، کمپیکټ ، د جوش پیر پیرټونه ، لکه مستحکم بریسلټ او عالي تشخیصی سکیل.",
      "yes": "هو",
      "no": " نه",
      "logoutConfirmMessage": "ایا تاسو غواړئ چې ووځئ؟",
      "addMedicalRecordsButtonText": "عددي طبي ریکارډونه",
      "shareRecords": "صحي معلومات مو د خپل ډاکټر سره شریک کړئ",
      "accessRecordIOngo": "خپلو نسخو، راپورونو، معایناتو او نورو معلوماتو ته لاس رسی ولرئ",
      "neverloserecords": "خپل معلومات د تل لپاره خوندي کړئ",
      "allrecordsoneplace": "ستاسو د صحي معلوماتو بنډل",
      "noBookmarkedDoctors": "تاسو هیڅ بک مارک شوي ډاکټران نلرئ",
      "favoriteDoctor": "یو ډاکټر غوره کړئ دوی ته اسانه لاسرسي لپاره هرکله چې اړتیا وي",
      "enterPasswordAgain": "پټ نوم بیاځلې داخل کړئ",
      "accountPassword": "د حساب پټ نوم",
      "completeyourProfile": "خپل پروفایل بشپړ کړئ",
      "addNewProfile": "اضافه کول",
      "select_family_member": "غړی انتخابول",
      "updateProfile": "مشخصات سمول",
      "createProfile": "پروفایل جوړ کړئ ",
      "bookingInformation": "مشخصات",
      "appointmentBooked": "وخت واخيستل شو",
      "sentMessageDoneAppointment":
          "ستاسو د ليدنې جزییات تاسو ته په پیغام کې درواستول شو همدارنګه، ستاسو د ملاقات  وخت به د پیغام لہ لرې در په یادوو",
      "done": "وشو",
      "cancel": "لغو",
      "dateOfBirthhints": "د زیږون نیټه دننه کړئ",
      "dateOfBirth": "د زېږېدلو نېټه",
      "bookingFor": "ناروغ",
      "namehints": "نوم",
      "relationshiphints": "اړيکه",
      "dateandTime": "نیټه او وخت",
      "someOneElse": "بل څوک",
      "enterPatentDetailsPageheader": "څوک ناروغ دی؟",
      "messagesent": "پیغام استول شوی",
      "edit": "(سمول)",
      "enterVerificationCode": "مهرباني وکړئ لیږل شوي 6 عددي تایید کوډ داخل کړئ",
      "selectNetwork": "خپل ګرځنده جال غوره کړئ",
      "resentotp": "خفه otp",
      "verifyandSignUp": "تصدیق او لاسلیک کول",
      "needHelp": "مرستې ته اړتیا لرئ؟ زنګ ووهئ",
      "salaam": "سلام",
      "etisalat": "اتصالات",
      "mtn": "MTN",
      "awcc": "AWCC",
      "roshan": "روشن",
      "edit": "مهرباني وکړئ لیږل شوي 6 عددي تایید کوډ داخل کړئ",
      "loginSignUpText": "ننوتل / ننوتل",
      "numberhints": "شمیره",
      "passwordhints": "پټ نوم داخل کړئ",
      "repasswordhints": "پټ نوم تاييد کړئ",
      "continuebuttonText": "دوام ورکړئ",
      "afterNoon": "ماسپښین",
      "noBookingFee": "(وړیا وخت اخیتسل)",
      "bookAppointmentbuttontext": " د لیدو وخت واخلئ ",
      "availableToday": "نن ورځ شتون لري",
      "availableNext3day": "په راتلونکو 3 ورځو کې شتون لري",
      "male": "نارينه",
      "female": "ښځينه",
      "apply": "غوښتنه وکړئ",
      "reset": "بیا تنظیمول",
      "filter": "غوښتنه وکړئ",
      "morning": "سهار",
      "gender": "جنس",
      "myProfile": "زما مشخصات",
      "myDoctor": "زما ډاکټر",
      "familyProfile": "کورني مشخصات",
      "viewBlog": "بلاګونه وګورئ",
      "blog_list": "بلاګ",
      "language": "ژبه",
      "logout": "وتل",
      "filterSelf": "په خپله",
      "filterFamily": "کورنۍ",
      "serverNotResponding": "انټرنېټ مو ستونزه لري، لطفاً بیاځلې هڅه وکړئ",
      "methodNotAllowed": "میتود ته اجازه نشته",
      "contactSupport": "ملاتړ نه ملاتړ",
      "invalidNumber": "شمیره باید 10 عددي وي ",
      "invalidUserName": "د کارونکي ناباوره نوم",
      "invaliddateOfBirth": "ناببره تاریخ",
      "profileUpdatedSuccess": "پېژندڅېره تازه شوه",
      "invalidConfirmPassword": "ناباوره شفر",
      "retry": "بیا هڅه وکړئ",
      "internetError": "د انټرنیټ اتصال نشته",
      "passwordShort": "لنډ پاسورډ",
      "cancel_Appointment": "خپل ملاقات لغوه کړئ",
      "reschdule": "بیاځلې وخت واخلئ",
      "bMy_Appointments": "زما وخت",
      "bMedical_Records": "روغتيایي سوانح",
      "Nangarhar": "ننګرهار",
      "Herat": "هرات",
      "kandahar": "کندهار",
      "kabul": "کابل",
      "helpLine": "لارښود",
      "locationhints": "اوسنی ځای وکاروئ",
      "searchTitle": "ډاکټران، روغتونونه، متخصصین، خدمات، وضعیت",
      'title': 'سلام نړی',
      'subTitle': 'فرعي سرلیک',
      'next_page': 'بل مخ',
      'your_location': "غوره داکټر، غوره درملنه",
      'internet': 'د انټرنیټ اتصال نشته',
      'invalid_number': 'د تلیفون غلط شمیره',
      'invalid_password': 'بې اعتباره پټنوم',
      'password_short': 'لنډ پاسورډ',
      // 'retry': 'بیا هڅه وکړئ',
      'invalid_user_name': 'غلط نوم',
      'date_of_birth': 'د زیږون نیټه غلطه ده',
      'profile_updated_success': 'پېژندڅېره په بریالیتوب سره تازه شوه',
      'contact_support': 'د ملاتړ ملاتړ',
      'familyAddedSuccess': 'په بریالیتوب سره د کورنۍ میمبر اضافه شوه',
      'selectFileError': 'لږترلږه یوه فایل اضافه کړئ',
      'provideDateError': 'نیټه ضروري ده',
      'doctorNameRequired': 'د ډاکټر نوم اړین دی',
      'invalid_conform_password': 'تایید کړه چې رمز ندی',
      'select_time': 'مهرباني وکړئ وخت وټاکئ',
      'appointmnetcanceled': 'ټاکنه لغوه شوه',
      'pleaseLogin': 'یوازې مستند میمبر اجازه لريd',
      'medicalRecordDeleted': 'د طبي ثبت حذف شو',
      'availability': 'شتون',
      'coderesend': 'د OTP کوډ بیا لیږل',
      'bookmarkSuccess': 'د ډاکټر کتاب',
      'unbookmarkSuccess': 'با موفقیت با حذف فرم دکتر نشانک شد',
      "patientsWereHappyWith": "له ډاکټر څخه رضایت",
      "overallExperience": "بشپړ رضایت",
      "doctorCheckup": "د ډاکټر معاینه",
      "staffBehavior": "د کارکوونکو چلند",
      "clinicEnvironment": "محیط معاینه خانه"
    },
  };

  String get yourSelectedProvince {
    return _localizedValues[locale.languageCode]['yourSelectedProvince'];
  }

  String get deleteMedicalRecord {
    return _localizedValues[locale.languageCode]['deleteMedicalRecord'];
  }

  String get comfirmMessageDeleteMedicalRecord {
    return _localizedValues[locale.languageCode]['comfirmMessageDeleteMedicalRecord'];
  }

  String get from {
    return _localizedValues[locale.languageCode]['from'];
  }

  String get noDoctorMatched {
    return _localizedValues[locale.languageCode]['noDoctorMatched'];
  }

  String get speciality {
    return _localizedValues[locale.languageCode]['speciality'];
  }

  String get noSpecialityMatched {
    return _localizedValues[locale.languageCode]['noSpecialityMatched'];
  }

  String get clinic {
    return _localizedValues[locale.languageCode]['clinic'];
  }

  String get noClinicMatched {
    return _localizedValues[locale.languageCode]['noClinicMatched'];
  }

  String get patients {
    return _localizedValues[locale.languageCode]['patients'];
  }

  String get comfirmMessageDeleteRecord {
    return _localizedValues[locale.languageCode]['comfirmMessageDeleteRecord'];
  }

  String get read {
    return _localizedValues[locale.languageCode]['read'];
  }

  String get notifications {
    return _localizedValues[locale.languageCode]['notifications'];
  }

  String get forgetPassword {
    return _localizedValues[locale.languageCode]['forgetPassword'];
  }

  String get thankFeedback {
    return _localizedValues[locale.languageCode]['thankFeedback'];
  }

  String get signIn {
    return _localizedValues[locale.languageCode]['signIn'];
  }

  String get createNewAccount {
    return _localizedValues[locale.languageCode]['createNewAccount'];
  }

  String get haveAnAccountSignIn {
    return _localizedValues[locale.languageCode]['haveAnAccountSignIn'];
  }

  String get today {
    return _localizedValues[locale.languageCode]['today'];
  }

  String get slots {
    return _localizedValues[locale.languageCode]['slots'];
  }

  String get noTimeSlotAvailable {
    return _localizedValues[locale.languageCode]['noTimeSlotAvailable'];
  }

  String get afternoon {
    return _localizedValues[locale.languageCode]['afternoon'];
  }

  String get evening {
    return _localizedValues[locale.languageCode]['evening'];
  }

  String get night {
    return _localizedValues[locale.languageCode]['night'];
  }

  String get min {
    return _localizedValues[locale.languageCode]['min'];
  }

  String get good {
    return _localizedValues[locale.languageCode]['good'];
  }

  String get bad {
    return _localizedValues[locale.languageCode]['bad'];
  }

  String get upcoming {
    return _localizedValues[locale.languageCode]['upcoming'];
  }

  String get current {
    return _localizedValues[locale.languageCode]['current'];
  }

  String get expire {
    return _localizedValues[locale.languageCode]['expire'];
  }

  String get getDistrict {
    return _localizedValues[locale.languageCode]['getDistrict'];
  }

  String get Langkey {
    return _localizedValues[locale.languageCode]['Langkey'];
  }

  String get currencySymbol {
    return _localizedValues[locale.languageCode]['currencySymbol'];
  }

  String get free {
    return _localizedValues[locale.languageCode]['free'];
  }

  String get fee {
    return _localizedValues[locale.languageCode]['fee'];
  }

  String get comfirmMessageCancelAppointment {
    return _localizedValues[locale.languageCode]['comfirmMessageCancelAppointment'];
  }

  String get appointments {
    return _localizedValues[locale.languageCode]['appointments'];
  }

  String get review {
    return _localizedValues[locale.languageCode]['review'];
  }

  String get YearOfExperiencel {
    return _localizedValues[locale.languageCode]['YearOfExperience'];
  }

  String get all {
    return _localizedValues[locale.languageCode]['all'];
  }

  String get Father {
    return _localizedValues[locale.languageCode]['Father'];
  }

  String get Mother {
    return _localizedValues[locale.languageCode]['Mother'];
  }

  String get Brother {
    return _localizedValues[locale.languageCode]['Brother'];
  }

  String get Sister {
    return _localizedValues[locale.languageCode]['Sister'];
  }

  String get Wife {
    return _localizedValues[locale.languageCode]['Wife'];
  }

  String get Son {
    return _localizedValues[locale.languageCode]['Son'];
  }

  String get Daughter {
    return _localizedValues[locale.languageCode]['Daughter'];
  }

  String get Friend {
    return _localizedValues[locale.languageCode]['Friend'];
  }

  String get Other {
    return _localizedValues[locale.languageCode]['Other'];
  }

  String get clinicEnvironment {
    return _localizedValues[locale.languageCode]['clinicEnvironment'];
  }

  String get staffBehavior {
    return _localizedValues[locale.languageCode]['staffBehavior'];
  }

  String get doctorCheckup {
    return _localizedValues[locale.languageCode]['doctorCheckup'];
  }

  String get overallExperience {
    return _localizedValues[locale.languageCode]['overallExperience'];
  }

  String get patientsWereHappyWith {
    return _localizedValues[locale.languageCode]['patientsWereHappyWith'];
  }

  String get viewAccount {
    return _localizedValues[locale.languageCode]['viewAccount'];
  }

  String get oldPassword {
    return _localizedValues[locale.languageCode]['oldPassword'];
  }

  String get select_City {
    return _localizedValues[locale.languageCode]['select_City'];
  }

  String get comment {
    return _localizedValues[locale.languageCode]['comment'];
  }

  String get familyProfileDeleted {
    return _localizedValues[locale.languageCode]['familyProfileDeleted'];
  }

  String get chat {
    return _localizedValues[locale.languageCode]['chat'];
  }

  String get sendMessage {
    return _localizedValues[locale.languageCode]['sendMessage'];
  }

  String get sendPassword {
    return _localizedValues[locale.languageCode]['sendPassword'];
  }

  String get bothGender {
    return _localizedValues[locale.languageCode]['bothGender'];
  }

  String get availableAll {
    return _localizedValues[locale.languageCode]['availableAll'];
  }

  String get noAppointmentFound {
    return _localizedValues[locale.languageCode]['noAppointmentFound'];
  }

  String get localization {
    return _localizedValues[locale.languageCode]['login'];
  }

  String get login {
    return _localizedValues[locale.languageCode]['login'];
  }

  String get services {
    return _localizedValues[locale.languageCode]['services'];
  }

  String get education {
    return _localizedValues[locale.languageCode]['education'];
  }

  String get specialization {
    return _localizedValues[locale.languageCode]['specialization'];
  }

  String get professionalMembership {
    return _localizedValues[locale.languageCode]['professionalMembership'];
  }

  String get otherInformaion {
    return _localizedValues[locale.languageCode]['otherInformaion'];
  }

  String get selectatimeslot {
    return _localizedValues[locale.languageCode]['selectatimeslot'];
  }

  String get allSlotBooked {
    return _localizedValues[locale.languageCode]['allSlotBooked'];
  }

  String get unbookmarkSuccess {
    return _localizedValues[locale.languageCode]['unbookmarkSuccess'];
  }

  String get bookmarkSuccess {
    return _localizedValues[locale.languageCode]['bookmarkSuccess'];
  }

  String get updateMedicalRecord {
    return _localizedValues[locale.languageCode]['updateMedicalRecord'];
  }

  String get addedMedicalRecord {
    return _localizedValues[locale.languageCode]['addedMedicalRecord'];
  }

  String get close {
    return _localizedValues[locale.languageCode]['close'];
  }

  String get addRecord {
    return _localizedValues[locale.languageCode]['addRecord'];
  }

  String get english {
    return _localizedValues[locale.languageCode]['english'];
  }

  String get dari {
    return _localizedValues[locale.languageCode]['dari'];
  }

  String get pashto {
    return _localizedValues[locale.languageCode]['pashto'];
  }

  String get selectedFlag {
    return _localizedValues[locale.languageCode]['selectedFlag'];
  }
  //

  String get noResultFound {
    return _localizedValues[locale.languageCode]['no_result_found'];
  }

  String get ShowingTop {
    return _localizedValues[locale.languageCode]['ShowingTop'];
  }

  String get In {
    return _localizedValues[locale.languageCode]['In'];
  }

  String get allDistrict {
    return _localizedValues[locale.languageCode]['allDistrict'];
  }

  String get selectLanguage {
    return _localizedValues[locale.languageCode]['selectLanguage'];
  }

  String get coderesend {
    return _localizedValues[locale.languageCode]['coderesend'];
  }

  String get availability {
    return _localizedValues[locale.languageCode]['availability'];
  }

  String get medicalRecordDeleted {
    return _localizedValues[locale.languageCode]['medicalRecordDeleted'];
  }

  String get numberHint {
    return _localizedValues[locale.languageCode]['numberHint'];
  }

  String get number {
    return _localizedValues[locale.languageCode]['number'];
  }

  String get doctorLocation {
    return _localizedValues[locale.languageCode]['doctorLocation'];
  }

  String get experience {
    return _localizedValues[locale.languageCode]['experience'];
  }

  String get year {
    return _localizedValues[locale.languageCode]['year'];
  }

  String get appointmentcanceled {
    return _localizedValues[locale.languageCode]['appointmentcanceled'];
  }

  String get addARecord {
    return _localizedValues[locale.languageCode]['addARecord'];
  }

  String get takeAPhoto {
    return _localizedValues[locale.languageCode]['takeAPhoto'];
  }

  String get uploadFromGallery {
    return _localizedValues[locale.languageCode]['uploadFromGallery'];
  }

  String get uploadFiles {
    return _localizedValues[locale.languageCode]['uploadFiles'];
  }

  String get recordDate {
    return _localizedValues[locale.languageCode]['recordDate'];
  }

  String get print {
    return _localizedValues[locale.languageCode]['print'];
  }

  String get updateRecord {
    return _localizedValues[locale.languageCode]['updateRecord'];
  }

  String get position {
    return _localizedValues[locale.languageCode]['position'];
  }

  String get addMedicalRecord {
    return _localizedValues[locale.languageCode]['addMedicalRecord'];
  }

  String get recordFor {
    return _localizedValues[locale.languageCode]['recordFor'];
  }

  String get typeOfRecord {
    return _localizedValues[locale.languageCode]['typeOfRecord'];
  }

  String get medicalRecord {
    return _localizedValues[locale.languageCode]['medicalRecord'];
  }

  String get prescription {
    return _localizedValues[locale.languageCode]['prescription'];
  }

  String get doctor {
    return _localizedValues[locale.languageCode]['doctor'];
  }

  String get addNameIdentifyRecord {
    return _localizedValues[locale.languageCode]['addNameIdentifyRecord'];
  }

  String get createRecord {
    return _localizedValues[locale.languageCode]['createRecord'];
  }

  String get open {
    return _localizedValues[locale.languageCode]['open'];
  }

  String get editRecord {
    return _localizedValues[locale.languageCode]['editRecord'];
  }

  String get deleteRecord {
    return _localizedValues[locale.languageCode]['deleteRecord'];
  }

  String get submit {
    return _localizedValues[locale.languageCode]['submit'];
  }

  String get addyourfeedback {
    return _localizedValues[locale.languageCode]['addyourfeedback'];
  }

  String get doctorFeedBackMessage {
    return _localizedValues[locale.languageCode]['doctorFeedBackMessage'];
  }

  String get addMedicalRecordsButtonText {
    return _localizedValues[locale.languageCode]['addMedicalRecordsButtonText'];
  }

  String get yes {
    return _localizedValues[locale.languageCode]['yes'];
  }

  String get no {
    return _localizedValues[locale.languageCode]['no'];
  }

  String get logoutConfirmMessage {
    return _localizedValues[locale.languageCode]['logoutConfirmMessage'];
  }

  String get shareRecords {
    return _localizedValues[locale.languageCode]['shareRecords'];
  }

  String get accessRecordIOngo {
    return _localizedValues[locale.languageCode]['accessRecordIOngo'];
  }

  String get neverloserecords {
    return _localizedValues[locale.languageCode]['neverloserecords'];
  }

  String get allrecordsoneplace {
    return _localizedValues[locale.languageCode]['allrecordsoneplace'];
  }

  String get noBookmarkedDoctors {
    return _localizedValues[locale.languageCode]['noBookmarkedDoctors'];
  }

  String get favoriteDoctor {
    return _localizedValues[locale.languageCode]['favoriteDoctor'];
  }

  String get enterPasswordAgain {
    return _localizedValues[locale.languageCode]['enterPasswordAgain'];
  }

  String get accountPassword {
    return _localizedValues[locale.languageCode]['accountPassword'];
  }

  String get completeyourProfile {
    return _localizedValues[locale.languageCode]['completeyourProfile'];
  }

  String get invaliddateOfBirth {
    return _localizedValues[locale.languageCode]['invaliddateOfBirth'];
  }

  String get addNewProfile {
    return _localizedValues[locale.languageCode]['addNewProfile'];
  }

  String get selectFamilyMember {
    return _localizedValues[locale.languageCode]['select_family_member'];
  }

  String get updateProfile {
    return _localizedValues[locale.languageCode]['updateProfile'];
  }

  String get createProfile {
    return _localizedValues[locale.languageCode]['createProfile'];
  }

  String get bookingInformation {
    return _localizedValues[locale.languageCode]['bookingInformation'];
  }

  String get appointmentBooked {
    return _localizedValues[locale.languageCode]['appointmentBooked'];
  }

  String get sentMessageDoneAppointment {
    return _localizedValues[locale.languageCode]['sentMessageDoneAppointment'];
  }

  String get done {
    return _localizedValues[locale.languageCode]['done'];
  }

  String get cancel {
    return _localizedValues[locale.languageCode]['cancel'];
  }

  String get dateOfBirth {
    return _localizedValues[locale.languageCode]['dateOfBirth'];
  }

  String get dateOfBirthhints {
    return _localizedValues[locale.languageCode]['dateOfBirthhints'];
  }

  String get bookingFor {
    return _localizedValues[locale.languageCode]['bookingFor'];
  }

  String get namehints {
    return _localizedValues[locale.languageCode]['namehints'];
  }

  String get relationshiphints {
    return _localizedValues[locale.languageCode]['relationshiphints'];
  }

  String get dateandTime {
    return _localizedValues[locale.languageCode]['dateandTime'];
  }

  String get someOneElse {
    return _localizedValues[locale.languageCode]['someOneElse'];
  }

  String get enterPatentDetailsPageheader {
    return _localizedValues[locale.languageCode]['enterPatentDetailsPageheader'];
  }

  String get messagesent {
    return _localizedValues[locale.languageCode]['messagesent'];
  }

  String get edit {
    return _localizedValues[locale.languageCode]['edit'];
  }

  String get enterVerificationCode {
    return _localizedValues[locale.languageCode]['enterVerificationCode'];
  }

  String get resentotp {
    return _localizedValues[locale.languageCode]['resentotp'];
  }

  String get verifyandSignUp {
    return _localizedValues[locale.languageCode]['verifyandSignUp'];
  }

  String get needHelp {
    return _localizedValues[locale.languageCode]['needHelp'];
  }

  String get salaam {
    return _localizedValues[locale.languageCode]['salaam'];
  }

  String get etisalat {
    return _localizedValues[locale.languageCode]['etisalat'];
  }

  String get mtn {
    return _localizedValues[locale.languageCode]['mtn'];
  }

  String get awcc {
    return _localizedValues[locale.languageCode]['awcc'];
  }

  String get roshan {
    return _localizedValues[locale.languageCode]['roshan'];
  }

  String get selectNetwork {
    return _localizedValues[locale.languageCode]['selectNetwork'];
  }

  String get loginSignUpText {
    return _localizedValues[locale.languageCode]['loginSignUpText'];
  }

  String get numberhints {
    return _localizedValues[locale.languageCode]['numberhints'];
  }

  String get passwordhints {
    return _localizedValues[locale.languageCode]['passwordhints'];
  }

  String get repasswordhints {
    return _localizedValues[locale.languageCode]['repasswordhints'];
  }

  String get continuebuttonText {
    return _localizedValues[locale.languageCode]['continuebuttonText'];
  }

  String get afterNoon {
    return _localizedValues[locale.languageCode]['afterNoon'];
  }

  String get noBookingFee {
    return _localizedValues[locale.languageCode]['noBookingFee'];
  }

  String get bookAppointmentbuttontext {
    return _localizedValues[locale.languageCode]['bookAppointmentbuttontext'];
  }

  String get availableToday {
    return _localizedValues[locale.languageCode]['availableToday'];
  }

  String get availableNext3day {
    return _localizedValues[locale.languageCode]['availableNext3day'];
  }

  String get male {
    return _localizedValues[locale.languageCode]['male'];
  }

  String get female {
    return _localizedValues[locale.languageCode]['female'];
  }

  String get apply {
    return _localizedValues[locale.languageCode]['apply'];
  }

  String get reset {
    return _localizedValues[locale.languageCode]['reset'];
  }

  String get filter {
    return _localizedValues[locale.languageCode]['filter'];
  }

  String get morning {
    return _localizedValues[locale.languageCode]['morning'];
  }

  String get gender {
    return _localizedValues[locale.languageCode]['gender'];
  }

  String get myProfile {
    return _localizedValues[locale.languageCode]['myProfile'];
  }

  String get myDoctor {
    return _localizedValues[locale.languageCode]['myDoctor'];
  }

  String get familyProfile {
    return _localizedValues[locale.languageCode]['familyProfile'];
  }

  String get viewBlog {
    return _localizedValues[locale.languageCode]['viewBlog'];
  }

  String get blogList {
    return _localizedValues[locale.languageCode]['blog_list'];
  }

  String get language {
    return _localizedValues[locale.languageCode]['language'];
  }

  String get logout {
    return _localizedValues[locale.languageCode]['logout'];
  }

  String get filterSelf {
    return _localizedValues[locale.languageCode]['filterSelf'];
  }

  String get filterFamily {
    return _localizedValues[locale.languageCode]['filterFamily'];
  }

  String get methodNotAllowed {
    return _localizedValues[locale.languageCode]['methodNotAllowed'];
  }

  String get serverNotResponding {
    return _localizedValues[locale.languageCode]['serverNotResponding'];
  }

  String get invalidNumber {
    return _localizedValues[locale.languageCode]['invalidNumber'];
  }

  String get invalidUserName {
    return _localizedValues[locale.languageCode]['invalidUserName'];
  }

  String get contactSupport {
    return _localizedValues[locale.languageCode]['contactSupport'];
  }

  String get invalidConfirmPassword {
    return _localizedValues[locale.languageCode]['invalidConfirmPassword'];
  }

  String get profileUpdatedSuccess {
    return _localizedValues[locale.languageCode]['profileUpdatedSuccess'];
  }

  String get retry {
    return _localizedValues[locale.languageCode]['retry'];
  }

  String get internetError {
    return _localizedValues[locale.languageCode]['internetError'];
  }

  String get cancel_Appointment {
    return _localizedValues[locale.languageCode]['cancel_Appointment'];
  }

  String get passwordShort {
    return _localizedValues[locale.languageCode]['passwordShort'];
  }

  String get reschdule {
    return _localizedValues[locale.languageCode]['reschdule'];
  }

  String get kandahar {
    return _localizedValues[locale.languageCode]['kandahar'];
  }

  String get bMy_Appointments {
    return _localizedValues[locale.languageCode]['bMy_Appointments'];
  }

  String get bMedical_Records {
    return _localizedValues[locale.languageCode]['bMedical_Records'];
  }

  String get Nangarhar {
    return _localizedValues[locale.languageCode]['Nangarhar'];
  }

  String get Herat {
    return _localizedValues[locale.languageCode]['Herat'];
  }

  String get kabul {
    return _localizedValues[locale.languageCode]['kabul'];
  }

  String get helpLine {
    return _localizedValues[locale.languageCode]['helpLine'];
  }

  String get pleaseLogin {
    return _localizedValues[locale.languageCode]['pleaseLogin'];
  }

  String get appointmnetcanceled {
    return _localizedValues[locale.languageCode]['appointmnetcanceled'];
  }

  String get familyAddedSuccess {
    return _localizedValues[locale.languageCode]['familyAddedSuccess'];
  }

  String get doctorNameRequired {
    return _localizedValues[locale.languageCode]['doctorNameRequired'];
  }

  String get dateRequiredError {
    return _localizedValues[locale.languageCode]['provideDateError'];
  }

  String get selectFileError {
    return _localizedValues[locale.languageCode]['selectFileError'];
  }

  String get pleaseSelectTime {
    return _localizedValues[locale.languageCode]['select_time'];
  }

  String get title {
    return _localizedValues[locale.languageCode]['title'];
  }

  String get locationhints {
    return _localizedValues[locale.languageCode]['locationhints'];
  }

  String get searchTitle {
    return _localizedValues[locale.languageCode]['searchTitle'];
  }

  String get subTitle {
    return _localizedValues[locale.languageCode]['subTitle'];
  }

  String get next_page {
    return _localizedValues[locale.languageCode]['next_page'];
  }

  String get your_location {
    return _localizedValues[locale.languageCode]['your_location'];
  }
}

class TranslationBaseDelegate extends LocalizationsDelegate<TranslationBase> {
  const TranslationBaseDelegate();

  @override
  bool isSupported(Locale locale) => ['en', 'ar', 'ur'].contains(locale.languageCode);

  @override
  Future<TranslationBase> load(Locale locale) {
    // Returning a SynchronousFuture here because an async "load" operation
    // isn't needed to produce an instance of DemoLocalizations.
    return SynchronousFuture<TranslationBase>(TranslationBase(locale));
  }

  @override
  bool shouldReload(TranslationBaseDelegate old) => false;
}
