import 'package:country_picker/country_picker.dart';
import 'package:date_time_picker/date_time_picker.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:systemevents/loginAndRegister/validator.dart';
import 'package:systemevents/provider/Auth.dart';

import 'LoginForm.dart';

class RegistrationForm extends StatefulWidget {
  @override
  _RegistrationFormState createState() => _RegistrationFormState();
}

class _RegistrationFormState extends State<RegistrationForm> {
  final   passwordConfController = TextEditingController();
  final   firstNameController = TextEditingController();
  final   fatherNameController = TextEditingController();
  final   familyNameController = TextEditingController();
  String  countryController  ;
  final   date_of_birthController = TextEditingController();


  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        LoginForm(),
        SizedBox(height:12,),
        TextFormField(
          validator: (value){
           // print(Provider.of<UserAuth>(context,listen: false).getPassword.toString() );
            if(value.isEmpty || value==null)
              return "هذا الحقل مطلوب";

            if( Provider.of<UserAuthProvider>(context,listen: false).user.getPassword==null){
              return "يجب ان تدخل كلمة المرور قبل التأكيد";
            }
            else if(Provider.of<UserAuthProvider>(context,listen: false).user.getPassword.toString()==
                passwordConfController.text.toString()
            ){
              return null;
            }else{
              return "لا تتطابق كلمتا المرور اللتان تم إدخالهما. يُرجى إعادة المحاولة.";
            }

          },
          onChanged: (value){
            Provider.of<UserAuthProvider>(context,listen: false).user.setConfPassword=value;
          },
          obscureText: true,
          controller:passwordConfController,
          decoration: InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'إعادة إدخال كلمة المرور',
              hintText: 'اعد إدخال كلمة المرور'
          ),
        ),
        SizedBox(height: 12,),
        // TextFormField(
        //   decoration: InputDecoration(
        //       border: OutlineInputBorder(),
        //       labelText: 'اسم المستخدم',
        //       hintText: 'Enter valid mail id as abc@gmail.com'
        //   ),
        // ),
        SizedBox(height: 12,),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Expanded(
           //   flex: 1,
              child: TextFormField(
                validator: (value){
                 return  ValidatorClass.isValidName(value);
                },
                onChanged: (value){
                  Provider.of<UserAuthProvider>(context,listen: false).user.setFirstName=value;
                },
                controller: firstNameController,
                style: TextStyle(fontSize: 14),
                decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'الاسم الاول',
                   // hintText: 'Enter valid mail id as abc@gmail.com'
                ),
              ),
            ),
           SizedBox(width: 1,),
            Expanded(
            //  flex: 1,
              child: TextFormField(
                validator: (value){
                  return  ValidatorClass.isValidName(value);
                },
                onChanged: (value){
                  Provider.of<UserAuthProvider>(context,listen: false).user.setFatherName=value;
                },
                controller: fatherNameController,
                style: TextStyle(fontSize: 14),
                decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'اسم الأب',
                   // hintText: 'Enter valid mail id as abc@gmail.com'
                ),
              ),
            ),
            SizedBox(width: 1,),
            Expanded(
             // flex: 1,
              child: TextFormField(
                validator: (value){
                  return  ValidatorClass.isValidName(value);
                },
                onChanged: (value){
                  Provider.of<UserAuthProvider>(context,listen: false).user.setFamilyName=value;
                },
                controller: familyNameController,
                style: TextStyle(fontSize: 14),
                decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'اسم العائلة',
                    //hintText: 'Enter valid mail id as abc@gmail.com'
                ),
              ),
            ),

          ],
        ),
        SizedBox(height: 24,),
       Row(
         children: [
           Expanded(
             flex: 1,
             child: Directionality(
             textDirection: TextDirection.rtl,
               child: DateTimePicker(
                 validator: (value){
                   if(value.isEmpty || value ==null)
                     return "يجب ادخال تاريخ الميلاد";
                   else
                     return null;
                 },
                 onChanged: (value){

                   Provider.of<UserAuthProvider>(context,listen: false).user.setDate_of_birth=value;
                 },
                // controller: date_of_birthController,
                 type: DateTimePickerType.date,
                 cancelText: "لا",
                 confirmText: 'نعم',
                 dateMask: 'd MMM, yyyy',
                initialValue:"1960-01-01 00:00:00.000"  ,
                 firstDate: DateTime(1930),
                 lastDate: DateTime(DateTime.now().year-12),
                 calendarTitle: 'اختر تاريخ ميلادك',
                 icon: Icon(Icons.event),
                 dateLabelText: 'تاريخ الميلاد',
                 timeLabelText: "ساعة",
                 textAlign: TextAlign.left ,
                 autovalidate:true ,
                  errorFormatText: "ادخل تاريخ صحيح",
                 errorInvalidText: 'تأكد من ادخال تاريخ صحيح',
                 selectableDayPredicate: (date) {
                   // Disable weekend days to select from the calendar
                   if (date.weekday == 6 || date.weekday == 7) {
                     return false;
                   }
                   return true;
                 },

                 // validator: (val) {
                 //   print('the date on validation $val ');
                 //   return null;
                 // },
                 onSaved: (val) => print('the date on save $val'),
               ),
             ),
           ),
           Expanded(
             flex: 1,
             child: TextButton.icon(

               onPressed: () {
                 showCountryPicker(

                   context: context,
                   //Optional.  Can be used to exclude(remove) one ore more country from the countries list (optional).
                   exclude: <String>['KN', 'MF'],
                   //Optional. Shows phone code before the country name.
                   showPhoneCode: true,

                   onSelect: (Country country) {
                   // countryController=country.displayName;
                      Provider.of<UserAuthProvider>(context,listen: false).user.setCountry=country.displayNameNoCountryCode;
                   },
                 );
               },
               icon: Icon(Icons.language),
               label: Text('اختيار الدولة'),
             ),),
         ],
       ),
        SizedBox(height: 24,),
          ],
        );
  }
}
