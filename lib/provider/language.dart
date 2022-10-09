import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import '../main.dart';

class Language extends ChangeNotifier {
  String _language = language;

  String get getLanguage => _language;

  set setLanguage(String value) {
    _language = value;
    notifyListeners();
  }

  // user profile  translated Strings ...
  String settingsHeading() {
    if (getLanguage == "AR") {
      return "الإعدادات";
    } else if (getLanguage == "EN") {
      return "Settings";
    } else {
      return "الإعدادات";
    }
  }

  String Hello() {
    if (getLanguage == "AR") {
      return "مرحبا";
    } else if (getLanguage == "EN") {
      return "Hello";
    } else {
      return "مرحبا";
    }
  }

  String darkMode() {
    if (getLanguage == "AR") {
      return "الوضع المظلم";
    } else if (getLanguage == "EN") {
      return "Dark mode";
    } else {
      return "الوضع المظلم";
    }
  }

  String languages() {
    if (getLanguage == "AR") {
      return "اللغة";
    } else if (getLanguage == "EN") {
      return "Languages";
    } else {
      return "اللغة";
    }
  }

  String changeLanguage() {
    if (getLanguage == "AR") {
      return "تبديل اللغة";
    } else if (getLanguage == "EN") {
      return "Change Language";
    } else {
      return "تبديل اللغة";
    }
  }

  String profilePage() {
    if (getLanguage == "AR") {
      return "الصفحة الشخصية";
    } else if (getLanguage == "EN") {
      return "Profile Page";
    } else {
      return "الصفحة الشخصية";
    }
  }

  String aboutApp() {
    if (getLanguage == "AR") {
      return "حول التطبيق";
    } else if (getLanguage == "EN") {
      return "About App";
    } else {
      return "حول التطبيق";
    }
  }

  String infoDevelopmentTeam() {
    if (getLanguage == "AR") {
      return "معلومات فريق التطوير";
    } else if (getLanguage == "EN") {
      return "Info Development Team";
    } else {
      return "معلومات فريق التطوير";
    }
  }

  String resetPassword() {
    if (getLanguage == "AR") {
      return 'تعيين كلمة المرور';
    } else if (getLanguage == "EN") {
      return "Reset password";
    } else {
      return 'تعيين كلمة المرور';
    }
  }

  String createNewPassword() {
    if (getLanguage == "AR") {
      return 'إنشاء كلمة مرور';
    } else if (getLanguage == "EN") {
      return "Create new password";
    } else {
      return 'إنشاء كلمة مرور';
    }
  }

  String passwordAlertMessage() {
    if (getLanguage == "AR") {
      return 'يجب أن تكون كلمة المرور الجديدة مختلفة عن كلمة المرور السابقة المستخدمة.';
    } else if (getLanguage == "EN") {
      return "The new password must be different from the previous password.";
    } else {
      return 'يجب أن تكون كلمة المرور الجديدة مختلفة عن كلمة المرور السابقة المستخدمة.';
    }
  }

  String password() {
    if (getLanguage == "AR") {
      return 'كلمة مرور';
    } else if (getLanguage == "EN") {
      return "Password";
    } else {
      return 'كلمة مرور';
    }
  }

  String enterPassword() {
    if (getLanguage == "AR") {
      return 'ادخل كلمة المرور';
    } else if (getLanguage == "EN") {
      return "Enter Password";
    } else {
      return 'ادخل كلمة المرور';
    }
  }

  String reEnterPassword() {
    if (getLanguage == "AR") {
      return 'اعد ادخال كلمة المرور';
    } else if (getLanguage == "EN") {
      return "Re-enter the password";
    } else {
      return 'اعد ادخال كلمة المرور';
    }
  }

  String thisFieldIsRequired() {
    if (getLanguage == "AR") {
      return "هذا الحقل مطلوب";
    } else if (getLanguage == "EN") {
      return "Field is required";
    } else {
      return "هذا الحقل مطلوب";
    }
  }

  String passwordAlertConfirming() {
    if (getLanguage == "AR") {
      return "يجب ان تدخل كلمة المرور قبل التأكيد";
    } else if (getLanguage == "EN") {
      return "You must enter the password before confirming";
    } else {
      return "يجب ان تدخل كلمة المرور قبل التأكيد";
    }
  }

  String passwordsAlertNotConfirming() {
    if (getLanguage == "AR") {
      return "لا تتطابق كلمتا المرور اللتان تم إدخالهما. يُرجى إعادة المحاولة.";
    } else if (getLanguage == "EN") {
      return "The passwords you entered do not match. Please try again.";
    } else {
      return "لا تتطابق كلمتا المرور اللتان تم إدخالهما. يُرجى إعادة المحاولة.";
    }
  }

  String passwordChangedSuccessfully() {
    if (getLanguage == "AR") {
      return "تم تغيير كلمة المرور بنجاح";
    } else if (getLanguage == "EN") {
      return "Password changed successfully";
    } else {
      return "تم تغيير كلمة المرور بنجاح";
    }
  }

  String TryChangingYourPasswordAgain() {
    if (getLanguage == "AR") {
      return 'حاول تغيير كلمة المرور مرة اخرى';
    } else if (getLanguage == "EN") {
      return "Try changing your password again";
    } else {
      return 'حاول تغيير كلمة المرور مرة اخرى';
    }
  }

  String nameMustBeCorrectly() {
    if (getLanguage == "AR") {
      return "يجب ادخال الاسم بشكل صحيح";
    } else if (getLanguage == "EN") {
      return "The name must be entered correctly.";
    } else {
      return "يجب ادخال الاسم بشكل صحيح";
    }
  }

  String passwordContainLessThan24Error() {
    if (getLanguage == "AR") {
      return "يجب أن يكون طول كلمة المرور أقل من 24 وأكثر من 6 خانات";
    } else if (getLanguage == "EN") {
      return "Password length must be less than 24 and more than 6 characters";
    } else {
      return "يجب أن يكون طول كلمة المرور أقل من 24 وأكثر من 6 خانات ";
    }
  }

  String passwordContainCapitalLetterError() {
    if (getLanguage == "AR") {
      return "يجب أن تحتوي كلمة المرور على حرف واحد كبير على الأقل";
    } else if (getLanguage == "EN") {
      return "Password must contain at least one capital letter";
    } else {
      return "يجب أن تحتوي كلمة المرور على حرف واحد كبير على الأقل";
    }
  }

  String passwordContainLowercaseLetterError() {
    if (getLanguage == "AR") {
      return "يجب أن تحتوي كلمة المرور على حرف صغير واحد على الأقل";
    } else if (getLanguage == "EN") {
      return "Password must contain at least one lowercase letter";
    } else {
      return "يجب أن تحتوي كلمة المرور على حرف صغير واحد على الأقل";
    }
  }

  String passwordContainAtLeastOneNumberError() {
    if (getLanguage == "AR") {
      return "يجب أن تحتوي كلمة المرور على رقم واحد على الأقل";
    } else if (getLanguage == "EN") {
      return "The password must contain at least one number.";
    } else {
      return "يجب أن تحتوي كلمة المرور على رقم واحد على الأقل";
    }
  }

  String passwordContainAtLeastSpecialCharacterError() {
    if (getLanguage == "AR") {
      return "يجب أن تحتوي كلمة المرور على رمز خاص واحد على الأقل مثال:@";
    } else if (getLanguage == "EN") {
      return "Password must contain at least one special character. Example: @";
    } else {
      return "يجب أن تحتوي كلمة المرور على رمز خاص واحد على الأقل مثال:@";
    }
  }

  String firstNameIsRequired() {
    if (getLanguage == "AR") {
      return "الاسم الاول مطلوب";
    } else if (getLanguage == "EN") {
      return "First name is required";
    } else {
      return "الاسم الاول مطلوب";
    }
  }

  String firstName() {
    if (getLanguage == "AR") {
      return "الاسم الاول";
    } else if (getLanguage == "EN") {
      return "First name";
    } else {
      return "الاسم الاول";
    }
  }

  String enterFirstName() {
    if (getLanguage == "AR") {
      return "ادخل اسم الاول";
    } else if (getLanguage == "EN") {
      return "Enter first name";
    } else {
      return "ادخل اسم الاول";
    }
  }

  String middleNameRequired() {
    if (getLanguage == "AR") {
      return 'اسم الاب مطلوب';
    } else if (getLanguage == "EN") {
      return "Middle name is required";
    } else {
      return 'اسم الاب مطلوب';
    }
  }

  String middleName() {
    if (getLanguage == "AR") {
      return "اسم الاب";
    } else if (getLanguage == "EN") {
      return "Middle name";
    } else {
      return "اسم الاب";
    }
  }

  String enterMiddleName() {
    if (getLanguage == "AR") {
      return "ادخل اسم الاب";
    } else if (getLanguage == "EN") {
      return "Enter middle name";
    } else {
      return "ادخل اسم الاب";
    }
  }

  String familyNameRequired() {
    if (getLanguage == "AR") {
      return 'اسم العائلة مطلوب';
    } else if (getLanguage == "EN") {
      return "Family name is required";
    } else {
      return 'اسم العائلة مطلوب';
    }
  }

  String familyName() {
    if (getLanguage == "AR") {
      return "اسم العائلة";
    } else if (getLanguage == "EN") {
      return "Family name";
    } else {
      return "اسم العائلة";
    }
  }

  String enterFamilyName() {
    if (getLanguage == "AR") {
      return "ادخل اسم العائلة";
    } else if (getLanguage == "EN") {
      return "Enter family name";
    } else {
      return "ادخل اسم العائلة";
    }
  }

  String dateBirthIsRequired() {
    if (getLanguage == "AR") {
      return "يجب ادخال تاريخ الميلاد";
    } else if (getLanguage == "EN") {
      return "You must enter your date of birth";
    } else {
      return "يجب ادخال تاريخ الميلاد";
    }
  }

  String no() {
    if (getLanguage == "AR") {
      return "لا";
    } else if (getLanguage == "EN") {
      return "No";
    } else {
      return "لا";
    }
  }

  String okay() {
    if (getLanguage == "AR") {
      return "حسنا";
    } else if (getLanguage == "EN") {
      return "Okay";
    } else {
      return "حسنا";
    }
  }

  String chooseYourDateBirth() {
    if (getLanguage == "AR") {
      return 'اختر تاريخ ميلادك';
    } else if (getLanguage == "EN") {
      return "Enter your date of birth";
    } else {
      return 'اختر تاريخ ميلادك';
    }
  }

  String dateOfBirth() {
    if (getLanguage == "AR") {
      return 'تاريخ الميلاد';
    } else if (getLanguage == "EN") {
      return "Date of birth";
    } else {
      return 'تاريخ الميلاد';
    }
  }

  String clock() {
    if (getLanguage == "AR") {
      return "ساعة";
    } else if (getLanguage == "EN") {
      return "Clock";
    } else {
      return "ساعة";
    }
  }

  String enterCorrectData() {
    if (getLanguage == "AR") {
      return "ادخل تاريخ صحيح";
    } else if (getLanguage == "EN") {
      return "Enter correct Data";
    } else {
      return "ادخل تاريخ صحيح";
    }
  }

  String validDate() {
    if (getLanguage == "AR") {
      return 'تأكد من ادخال تاريخ صحيح';
    } else if (getLanguage == "EN") {
      return 'Make sure you entered a valid date';
    } else {
      return 'تأكد من ادخال تاريخ صحيح';
    }
  }

  String fillFields() {
    if (getLanguage == "AR") {
      return 'من فضلك املاء حقول';
    } else if (getLanguage == "EN") {
      return 'Please fill all fields';
    } else {
      return 'من فضلك املاء حقول';
    }
  }

  String editPersonalData() {
    if (getLanguage == "AR") {
      return 'تعديل البيانات الشخصية';
    } else if (getLanguage == "EN") {
      return 'Edit personal Data';
    } else {
      return 'تعديل البيانات الشخصية';
    }
  }

  String savedSuccessfully() {
    if (getLanguage == "AR") {
      return 'تمت عملية الحفظ بنجاح';
    } else if (getLanguage == "EN") {
      return 'Saved successfully';
    } else {
      return 'تمت عملية الحفظ بنجاح';
    }
  }

  String updateSuccessfully() {
    if (getLanguage == "AR") {
      return 'تمت عملية التحديث بنجاح';
    } else if (getLanguage == "EN") {
      return 'Update successfully';
    } else {
      return 'تمت عملية التحديث بنجاح';
    }
  }

  String saveWasNotSuccessful() {
    if (getLanguage == "AR") {
      return 'لم تتم عملية الحفظ بنجاح';
    } else if (getLanguage == "EN") {
      return 'Save was not successful';
    } else {
      return 'لم تتم عملية الحفظ بنجاح';
    }
  }

  String updateWasNotSuccessful() {
    if (getLanguage == "AR") {
      return 'لم تتم عملية التحديث بنجاح';
    } else if (getLanguage == "EN") {
      return 'Update was not successful';
    } else {
      return 'لم تتم عملية التحديث بنجاح';
    }
  }

  String homePage() {
    if (getLanguage == "AR") {
      return 'الصفحة الرئيسية';
    } else if (getLanguage == "EN") {
      return 'Home Page';
    } else {
      return 'الصفحة الرئيسية';
    }
  }

  String logout() {
    if (getLanguage == "AR") {
      return 'تسجيل الخروج';
    } else if (getLanguage == "EN") {
      return 'Logout';
    } else {
      return 'تسجيل الخروج';
    }
  }

  String picturesLibrary() {
    if (getLanguage == "AR") {
      return 'مكتبة الصور';
    } else if (getLanguage == "EN") {
      return 'Pictures library';
    } else {
      return 'مكتبة الصور';
    }
  }

  String cameraLibrary() {
    if (getLanguage == "AR") {
      return 'الكاميرا';
    } else if (getLanguage == "EN") {
      return 'Camera';
    } else {
      return 'الكاميرا';
    }
  }

  String addEvent() {
    if (getLanguage == "AR") {
      return 'اضف حدث';
    } else if (getLanguage == "EN") {
      return 'Add Event';
    } else {
      return 'اضف حدث';
    }
  }

  String connectInternet() {
    if (getLanguage == "AR") {
      return 'اتصل بالانترنت من فضلك';
    } else if (getLanguage == "EN") {
      return 'Please connect to the internet';
    } else {
      return 'اتصل بالانترنت من فضلك';
    }
  }

  String hybrid() {
    if (getLanguage == "AR") {
      return 'هجين';
    } else if (getLanguage == "EN") {
      return 'Hybrid';
    } else {
      return 'هجين';
    }
  }

  String normalDefault() {
    if (getLanguage == "AR") {
      return 'الوضع الافتراضي';
    } else if (getLanguage == "EN") {
      return 'default';
    } else {
      return 'الوضع الافتراضي';
    }
  }

  String satellite() {
    if (getLanguage == "AR") {
      return 'الأقمار الصناعية';
    } else if (getLanguage == "EN") {
      return 'Satellite';
    } else {
      return 'الأقمار الصناعية';
    }
  }

  String terrain() {
    if (getLanguage == "AR") {
      return 'تضاريس';
    } else if (getLanguage == "EN") {
      return 'Terrain';
    } else {
      return 'تضاريس';
    }
  }

  String search() {
    if (getLanguage == "AR") {
      return 'بحث';
    } else if (getLanguage == "EN") {
      return 'Search';
    } else {
      return 'بحث';
    }
  }

  String trackingUnit() {
    if (getLanguage == "AR") {
      return "تتبع الوحدة";
    } else if (getLanguage == "EN") {
      return 'Tracking Unit';
    } else {
      return "تتبع الوحدة";
    }
  } String missionsList() {
    if (getLanguage == "AR") {
      return "قائمة المهام";
    } else if (getLanguage == "EN") {
      return 'Missions List';
    } else {
      return "قائمة المهام";
    }
  }

  String eventList() {
    if (getLanguage == "AR") {
      return "قائمة الأحداث";
    } else if (getLanguage == "EN") {
      return 'Event List';
    } else {
      return "قائمة الأحداث";
    }
  }

  String notifyAgency() {
    if (getLanguage == "AR") {
      return "إبلاغ الجهة";
    } else if (getLanguage == "EN") {
      return 'Notify Agency';
    } else {
      return "إبلاغ الجهة";
    }
  }

  String notifications() {
    if (getLanguage == "AR") {
      return "الإشعارات";
    } else if (getLanguage == "EN") {
      return 'Notifications';
    } else {
      return "الإشعارات";
    }
  }

  String categoryTypeAreRequired() {
    if (getLanguage == "AR") {
      return 'يجب ان تدخل الصنف والنوع';
    } else if (getLanguage == "EN") {
      return 'You must enter the category and type';
    } else {
      return 'يجب ان تدخل الصنف والنوع';
    }
  }

  String checkMessagesApp() {
    if (getLanguage == "AR") {
      return 'تحقق من تطبيق الرسائل';
    } else if (getLanguage == "EN") {
      return 'Check Messages App';
    } else {
      return 'تحقق من تطبيق الرسائل';
    }
  }

  String sendReport() {
    if (getLanguage == "AR") {
      return 'ارسال بلاغ';
    } else if (getLanguage == "EN") {
      return 'Send a report';
    } else {
      return 'ارسال بلاغ';
    }
  }

  String ContactGovernmentAgencies() {
    if (getLanguage == "AR") {
      return "تواصل مع الجهات";
    } else if (getLanguage == "EN") {
      return 'Contact with government agencies';
    } else {
      return "تواصل مع الجهات";
    }
  }

  String chooseCategoryType() {
    if (getLanguage == "AR") {
      return "اختر الصنف والنوع";
    } else if (getLanguage == "EN") {
      return 'Choose category and Type';
    } else {
      return "اختر الصنف والنوع";
    }
  }

  String eventLocation() {
    if (getLanguage == "AR") {
      return 'موقع الحدث';
    } else if (getLanguage == "EN") {
      return 'Event Location';
    } else {
      return 'موقع الحدث';
    }
  }

  String delete() {
    if (getLanguage == "AR") {
      return 'حذف';
    } else if (getLanguage == "EN") {
      return 'Delete';
    } else {
      return 'حذف';
    }
  }

  String cancel() {
    if (getLanguage == "AR") {
      return "إلغاء";
    } else if (getLanguage == "EN") {
      return 'Cancel';
    } else {
      return "إلغاء";
    }
  }

  String alertDeleteEvent() {
    if (getLanguage == "AR") {
      return "؟هل انت متأكد من حذف الحدث ";
    } else if (getLanguage == "EN") {
      return 'Are you sure you want to delete the event?';
    } else {
      return "؟هل انت متأكد من حذف الحدث ";
    }
  }

  String noNotifications() {
    if (getLanguage == "AR") {
      return 'لا توجد إشعارات للعرض';
    } else if (getLanguage == "EN") {
      return 'No notifications to display';
    } else {
      return 'لا توجد إشعارات للعرض';
    }
  }

  String pickImage() {
    if (getLanguage == "AR") {
      return "اختر صورة";
    } else if (getLanguage == "EN") {
      return "Pick Image";
    } else {
      return "اختر صورة";
    }
  }

  String deleteEvent() {
    if (getLanguage == "AR") {
      return "حذف الحدث";
    } else if (getLanguage == "EN") {
      return "Delete event";
    } else {
      return "حذف الحدث";
    }
  }

  String back() {
    if (getLanguage == "AR") {
      return 'رجوع';
    } else if (getLanguage == "EN") {
      return "Back";
    } else {
      return 'رجوع';
    }
  }

  String pickImages() {
    if (getLanguage == "AR") {
      return "اضف صور";
    } else if (getLanguage == "EN") {
      return "Pick images";
    } else {
      return "اضف صور";
    }
  }

  String imageMessage() {
    if (getLanguage == "AR") {
      return "يمكن إضافة 4 صور فقط";
    } else if (getLanguage == "EN") {
      return "You can add just 4 images.";
    } else {
      return "يمكن إضافة 4 صور فقط";
    }
  }

  String saveUpdates() {
    if (getLanguage == "AR") {
      return 'حفظ التعديل';
    } else if (getLanguage == "EN") {
      return "Save Updates";
    } else {
      return 'حفظ التعديل';
    }
  }

  String alertSizeFile() {
    if (getLanguage == "AR") {
      return "حجم الملف اكبر من 10 ميجا";
    } else if (getLanguage == "EN") {
      return "File size is more than 10MB.";
    } else {
      return "حجم الملف اكبر من 10 ميجا";
    }
  }

  String addVideo() {
    if (getLanguage == "AR") {
      return "اضف فيديو";
    } else if (getLanguage == "EN") {
      return "Add video";
    } else {
      return "اضف فيديو";
    }
  }

  String pickVideo() {
    if (getLanguage == "AR") {
      return "قم بالتقاط فيديو للحادثة(اختياري)";
    } else if (getLanguage == "EN") {
      return "Pick video for event (optional)";
    } else {
      return "قم بالتقاط فيديو للحادثة(اختياري)";
    }
  }

  String updateEvent() {
    if (getLanguage == "AR") {
      return "تعديل الحدث";
    } else if (getLanguage == "EN") {
      return "Update Event";
    } else {
      return "تعديل الحدث";
    }
  }

  String mustCreateNewEvent() {
    if (getLanguage == "AR") {
      return 'يجب ان تنشئ حدث جديد';
    } else if (getLanguage == "EN") {
      return 'You must create a new event';
    } else {
      return 'يجب ان تنشئ حدث جديد';
    }
  }

  String createNewEvent() {
    if (getLanguage == "AR") {
      return 'انشئ حدث جديد';
    } else if (getLanguage == "EN") {
      return 'Create a new event';
    } else {
      return 'انشئ حدث جديد';
    }
  }

  String events() {
    if (getLanguage == "AR") {
      return 'الاحداث';
    } else if (getLanguage == "EN") {
      return 'Events';
    } else {
      return 'الاحداث';
    }
  }

  String searchByName() {
    if (getLanguage == "AR") {
      return 'بحث باسم الحدث';
    } else if (getLanguage == "EN") {
      return 'Search by event name';
    } else {
      return 'بحث باسم الحدث';
    }
  }

  String cancelSearch() {
    if (getLanguage == "AR") {
      return 'إلغاء البحث';
    } else if (getLanguage == "EN") {
      return "Cancel Search";
    } else {
      return 'إلغاء البحث';
    }
  }

  String operationSuccess() {
    if (getLanguage == "AR") {
      return 'نجاح العملية';
    } else if (getLanguage == "EN") {
      return "Operation success";
    } else {
      return 'نجاح العملية';
    }
  }

  String skip() {
    if (getLanguage == "AR") {
      return 'تخطئ';
    } else if (getLanguage == "EN") {
      return "Skip";
    } else {
      return 'تخطئ';
    }
  }

  String sentEvenSuccessfully() {
    if (getLanguage == "AR") {
      return 'تم إرسال الحدث بنجاح';
    } else if (getLanguage == "EN") {
      return "Event sent successfully";
    } else {
      return 'تم إرسال الحدث بنجاح';
    }
  }

  String emailRequired() {
    if (getLanguage == "AR") {
      return 'البريد الالكتروني مطلوب';
    } else if (getLanguage == "EN") {
      return 'Email is Required';
    } else {
      return 'البريد الالكتروني مطلوب';
    }
  }

  String emailNotValid() {
    if (getLanguage == "AR") {
      return 'البريد الالكتروني غير صالح تحقق من المدخلات';
    } else if (getLanguage == "EN") {
      return 'Email not valid, check your inputs';
    } else {
      return 'البريد الالكتروني غير صالح تحقق من المدخلات';
    }
  }

  String email() {
    if (getLanguage == "AR") {
      return 'البريد الإلكتروني';
    } else if (getLanguage == "EN") {
      return 'Email';
    } else {
      return 'البريد الإلكتروني';
    }
  }

  String enterYourEmail() {
    if (getLanguage == "AR") {
      return 'ادخل البريد الإلكتروني';
    } else if (getLanguage == "EN") {
      return 'Enter your email';
    } else {
      return 'ادخل البريد الإلكتروني';
    }
  }

  String chooseCountry() {
    if (getLanguage == "AR") {
      return 'اختيار الدولة';
    } else if (getLanguage == "EN") {
      return 'Choose Country';
    } else {
      return 'اختيار الدولة';
    }
  }

  String login() {
    if (getLanguage == "AR") {
      return " تسجيل الدخول";
    } else if (getLanguage == "EN") {
      return 'Login';
    } else {
      return "تسجيل الدخول";
    }
  }

  String createAccount() {
    if (getLanguage == "AR") {
      return 'إنشاء حساب';
    } else if (getLanguage == "EN") {
      return 'Create account';
    } else {
      return 'إنشاء حساب';
    }
  }

  String forgetYourPassword() {
    if (getLanguage == "AR") {
      return 'نسيت كلمة المرور!';
    } else if (getLanguage == "EN") {
      return 'Forget password!';
    } else {
      return 'نسيت كلمة المرور!';
    }
  }

  String sendRequest() {
    if (getLanguage == "AR") {
      return 'ارسال طلب';
    } else if (getLanguage == "EN") {
      return 'Send Request';
    } else {
      return 'ارسال طلب';
    }
  }

  String requestNewPassword() {
    if (getLanguage == "AR") {
      return 'طلب كلمة مرور جديدة';
    } else if (getLanguage == "EN") {
      return 'Request new password';
    } else {
      return 'طلب كلمة مرور جديدة';
    }
  }

  String hasNoAccount() {
    if (getLanguage == "AR") {
      return 'لا تملك حساب!';
    } else if (getLanguage == "EN") {
      return 'I don\'t have an account';
    } else {
      return 'لا تملك حساب!';
    }
  }

  String hasAccount() {
    if (getLanguage == "AR") {
      return "لدي حساب!";
    } else if (getLanguage == "EN") {
      return "I have an account!";
    } else {
      return "لدي حساب!";
    }
  }

  String countryRequired() {
    if (getLanguage == "AR") {
      return 'حقل الدولة مطلوب';
    } else if (getLanguage == "EN") {
      return "Country is required";
    } else {
      return 'حقل الدولة مطلوب';
    }
  }

  String waitMessage() {
    if (getLanguage == "AR") {
      return "انتظر من فضلك..";
    } else if (getLanguage == "EN") {
      return "Please wait...";
    } else {
      return "انتظر من فضلك..";
    }
  }

  String enterDescription() {
    if (getLanguage == "AR") {
      return 'ادخل وصف الحدث هنا.';
    } else if (getLanguage == "EN") {
      return "Enter description here...";
    } else {
      return 'ادخل وصف الحدث هنا.';
    }
  }

  String chooseType() {
    if (getLanguage == "AR") {
      return 'اختار النوع';
    } else if (getLanguage == "EN") {
      return "Choose type";
    } else {
      return 'اختار النوع';
    }
  }

  String chooseCategory() {
    if (getLanguage == "AR") {
      return 'اختار الصنف';
    } else if (getLanguage == "EN") {
      return "Choose category";
    } else {
      return 'اختار الصنف';
    }
  }

  String currentLocation() {
    if (getLanguage == "AR") {
      return 'الموقع الحالي';
    } else if (getLanguage == "EN") {
      return "Current Location";
    } else {
      return 'الموقع الحالي';
    }
  }

  String locateEvent() {
    if (getLanguage == "AR") {
      return "حدد موقع الحدث";
    } else if (getLanguage == "EN") {
      return "Locate the event";
    } else {
      return "حدد موقع الحدث";
    }
  }

  String locationRequired() {
    if (getLanguage == "AR") {
      return 'يجب تحديد موقع الحدث';
    } else if (getLanguage == "EN") {
      return "Location Required";
    } else {
      return 'يجب تحديد موقع الحدث';
    }
  }

  String alertLocationEvent() {
    if (getLanguage == "AR") {
      return "هل انت متأكد من عنوان الحدث ؟";
    } else if (getLanguage == "EN") {
      return "Are you sure of the incident position?";
    } else {
      return "هل انت متأكد من عنوان الحدث ؟";
    }
  }

  String positionSuccessfully() {
    if (getLanguage == "AR") {
      return "تم تحديث موقع الحدث بنجاح";
    } else if (getLanguage == "EN") {
      return "The event location has been successfully updated";
    } else {
      return "تم تحديث موقع الحدث بنجاح";
    }
  }

  // String eventData() {
  //   if (getLanguage == "AR") {
  //     return "بيانات الحدث" ;
  //   } else if (getLanguage == "EN") {
  //     return "Event data";
  //   } else {
  //     return "بيانات الحدث";
  //   }
  // }
  String close() {
    if (getLanguage == "AR") {
      return "إغلاق";
    } else if (getLanguage == "EN") {
      return "Close";
    } else {
      return "إغلاق";
    }
  }

  String addDescription() {
    if (getLanguage == "AR") {
      return "إضافة وصف الحدث";
    } else if (getLanguage == "EN") {
      return "Add Description Event";
    } else {
      return "إضافة وصف الحدث";
    }
  }

  String sendEvent() {
    if (getLanguage == "AR") {
      return 'إرسال الحدث';
    } else if (getLanguage == "EN") {
      return "Send Event";
    } else {
      return 'إرسال الحدث';
    }
  }

  String descRequired() {
    if (getLanguage == "AR") {
      return 'من فضلك ادخل وصف الحدث';
    } else if (getLanguage == "EN") {
      return "Description is required";
    } else {
      return 'من فضلك ادخل وصف الحدث';
    }
  }

  String newEvent() {
    if (getLanguage == "AR") {
      return 'حدث جديد';
    } else if (getLanguage == "EN") {
      return "New Event";
    } else {
      return 'حدث جديد';
    }
  }

  String categoryRequired() {
    if (getLanguage == "AR") {
      return 'يجب ان تختار الصنف';
    } else if (getLanguage == "EN") {
      return "You must choose the category";
    } else {
      return 'يجب ان تختار الصنف';
    }
  }

  String typeRequired() {
    if (getLanguage == "AR") {
      return 'يجب ان تختار النوع';
    } else if (getLanguage == "EN") {
      return "You must choose the type";
    } else {
      return 'يجب ان تختار النوع';
    }
  }

  String imageRequired() {
    if (getLanguage == "AR") {
      return 'يجب ان ترفق صورة للحدث';
    } else if (getLanguage == "EN") {
      return "Image is required at least one picture";
    } else {
      return 'يجب ان ترفق صورة للحدث';
    }
  }

  String next() {
    if (getLanguage == "AR") {
      return 'التالي';
    } else if (getLanguage == "EN") {
      return "Next";
    } else {
      return 'التالي';
    }
  }

  String pickLocation() {
    if (getLanguage == "AR") {
      return 'حدد موقع الحدث';
    } else if (getLanguage == "EN") {
      return "Pick location of event";
    } else {
      return 'حدد موقع الحدث';
    }
  }

  String modifyLocation() {
    if (getLanguage == "AR") {
      return "عدل موقع الحدث";
    } else if (getLanguage == "EN") {
      return "Modify location of event";
    } else {
      return "عدل موقع الحدث";
    }
  }

  String addImages() {
    if (getLanguage == "AR") {
      return "إضافة صور";
    } else if (getLanguage == "EN") {
      return "Add Images";
    } else {
      return "إضافة صور";
    }
  }

  String checkEmailPassword() {
    if (getLanguage == "AR") {
      return "تحقق من البريد الالكتروني وكلمة المرور";
    } else if (getLanguage == "EN") {
      return "Check email and password";
    } else {
      return "تحقق من البريد الالكتروني وكلمة المرور";
    }
  }

  String blockUserMessage() {
    if (getLanguage == "AR") {
      return "لاتستطيع تسجيل الدخول لان حسابك محظور";
    } else if (getLanguage == "EN") {
      return "You cannot login because your account is banned";
    } else {
      return "لاتستطيع تسجيل الدخول لان حسابك محظور";
    }
  }

  String blockEventMessage() {
    if (getLanguage == "AR") {
      return "لاتستطيع ارسال حدث لان حسابك محظور";
    } else if (getLanguage == "EN") {
      return "You can't save an event because your account is banned";
    } else {
      return "لاتستطيع ارسال حدث لان حسابك محظور";
    }
  }

  String blockEditEventMessage() {
    if (getLanguage == "AR") {
      return 'لاتستطيع تعديل الحدث لان حسابك محظور';
    } else if (getLanguage == "EN") {
      return "You can't edit an event because your account is banned";
    } else {
      return 'لاتستطيع تعديل الحدث لان حسابك محظور';
    }
  }

  String emailAlreadyUsed() {
    if (getLanguage == "AR") {
      return 'عفوا البريد الالكتروني مستخدم من قبل';
    } else if (getLanguage == "EN") {
      return 'Sorry, the email is already in use';
    } else {
      return 'عفوا البريد الالكتروني مستخدم من قبل';
    }
  }

  String pleaseCheckYourInputs() {
    if (getLanguage == "AR") {
      return 'عفوا تأكد من المدخلات';
    } else if (getLanguage == "EN") {
      return 'Sorry, check your inputs';
    } else {
      return 'عفوا تأكد من المدخلات';
    }
  }

  String unableAccessSystem() {
    if (getLanguage == "AR") {
      return 'هناك مشكلة في الخادم';
    } else if (getLanguage == "EN") {
      return 'There is a problem with the server, try again';
    } else {
      return 'هناك مشكلة في الخادم';
    }
  }

  String checkInbox() {
    if (getLanguage == "AR") {
      return 'تحقق من بريدك';
    } else if (getLanguage == "EN") {
      return 'Check your mail inbox';
    } else {
      return 'تحقق من بريدك';
    }
  }

  String checkEmailInput() {
    if (getLanguage == "AR") {
      return 'تأكد من صحة البريد المدخل';
    } else if (getLanguage == "EN") {
      return 'your email not valid';
    } else {
      return 'تأكد من صحة البريد المدخل';
    }
  }
  String GPSAccuracy() {
    if (getLanguage == "AR") {
      return "دقة تحديد الموقع";
    } else if (getLanguage == "EN") {
      return 'GPS Accuracy';
    } else {
      return "دقة تحديد الموقع";
    }
  } String lowAccuracy() {
    if (getLanguage == "AR") {
      return "منخفض الدقة";
    } else if (getLanguage == "EN") {
      return 'low Accuracy';
    } else {
      return "منخفض الدقة";
    }
  } String mediumAccuracy() {
    if (getLanguage == "AR") {
      return "متوسط الدقة";
    } else if (getLanguage == "EN") {
      return 'medium Accuracy';
    } else {
      return "متوسط الدقة";
    }
  } String highAccuracy() {
    if (getLanguage == "AR") {
      return "عالي الدقة";
    } else if (getLanguage == "EN") {
      return 'high Accuracy';
    } else {
      return "عالي الدقة";
    }
  } String bestAccuracy() {
    if (getLanguage == "AR") {
      return "أفضل دقة";
    } else if (getLanguage == "EN") {
      return 'best Accuracy';
    } else {
      return "أفضل دقة";
    }
  } String headOfTrackAlert() {
    if (getLanguage == "AR") {
      return "تفعيل تتبع الوحدة";
    } else if (getLanguage == "EN") {
      return 'Activate unit tracking';
    } else {
      return "تفعيل تتبع الوحدة";
    }
  } String bodyOfTrackAlert() {
    if (getLanguage == "AR") {
      return  "هل تريد تفعيل التتبع؟";
    } else if (getLanguage == "EN") {
      return 'Do you want to activate tracking?';
    } else {
      return  "هل تريد تفعيل التتبع؟";
    }
  }
  String enable() {
    if (getLanguage == "AR") {
      return  "تفعيل";
    } else if (getLanguage == "EN") {
      return 'Enable';
    } else {
      return  "تفعيل";
    }
  }
  String enableTrackingUnit() {
    if (getLanguage == "AR") {
      return  "تفعيل تتبع الوحدة";
    } else if (getLanguage == "EN") {
      return 'enable tracking Unit';
    } else {
      return  "تفعيل تتبع الوحدة";
    }
  }
  String activatedSuccessfully() {
    if (getLanguage == "AR") {
      return  "تم التفعيل بنجاح";
    } else if (getLanguage == "EN") {
      return 'activated Successfully';
    } else {
      return  "تم التفعيل بنجاح";
    }
  }
  String deactivatedSuccessfully() {
    if (getLanguage == "AR") {
      return  "تم إلغاء التفعيل بنجاح";
    } else if (getLanguage == "EN") {
      return 'Deactivated successfully';
    } else {
      return  "تم إلغاء التفعيل بنجاح";
    }
  }
  String disable() {
    if (getLanguage == "AR") {
      return  "إيقاف التفعيل";
    } else if (getLanguage == "EN") {
      return 'disable';
    } else {
      return  "إيقاف التفعيل";
    }
  }
  String selectDestination() {
    if (getLanguage == "AR") {
      return  "الرجاء تحديد الوجهة";
    } else if (getLanguage == "EN") {
      return 'please select the destination';
    } else {
      return  "الرجاء تحديد الوجهة";
    }
  }
  String mustEnableTracking() {
    if (getLanguage == "AR") {
      return  "يجب عليك تفعيل تتبع الوحدة الان";
    } else if (getLanguage == "EN") {
      return 'You must activate unit tracking now';
    } else {
      return  "يجب عليك تفعيل تتبع الوحدة الان";
    }
  }
}
