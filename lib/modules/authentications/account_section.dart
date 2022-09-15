import 'package:intl/intl.dart';
import 'package:country_picker/country_picker.dart';
import 'package:date_time_picker/date_time_picker.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:systemevents/modules/authentications/login_section.dart';
import 'package:systemevents/modules/authentications/validator.dart';
import 'package:systemevents/provider/auth_provider.dart';
import 'dart:ui' as ui;

import 'package:systemevents/widgets/custom_Text_Field.dart';

class RegistrationForm extends StatefulWidget {
  @override
  _RegistrationFormState createState() => _RegistrationFormState();
}

class _RegistrationFormState extends State<RegistrationForm> {
  final passwordConfController = TextEditingController();
  final firstNameController = TextEditingController();
  final fatherNameController = TextEditingController();
  final familyNameController = TextEditingController();
  String countryController;

  final date_of_birthController = TextEditingController();
  bool _passwordVisible;

  String country1 = "";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _passwordVisible = false;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        LoginForm(),
        SizedBox(
          height: 12,
        ),
        customTextFormField(
          context,
          validator: (value) {
            // print(Provider.of<UserAuth>(context,listen: false).getPassword.toString() );
            if (value.isEmpty || value == null) return "هذا الحقل مطلوب";

            if (Provider.of<UserAuthProvider>(context, listen: false)
                    .user
                    .getPassword ==
                null) {
              return "يجب ان تدخل كلمة المرور قبل التأكيد";
            } else if (Provider.of<UserAuthProvider>(context, listen: false)
                    .user
                    .getPassword
                    .toString() ==
                passwordConfController.text.toString()) {
              return null;
            } else {
              return "لا تتطابق كلمتا المرور اللتان تم إدخالهما. يُرجى إعادة المحاولة.";
            }
          },
          onChanged: (value) {
            Provider.of<UserAuthProvider>(context, listen: false)
                .user
                .setConfPassword = value;
          },
          obsecure: !_passwordVisible,
          editingController: passwordConfController,
          prefixIcon: Icon(
            Icons.password,
          ),
          labelText: 'إعادة إدخال كلمة المرور',
          hintText: 'اعد إدخال كلمة المرور',
          suffixIcon: IconButton(
            icon: Icon(
              // Based on passwordVisible state choose the icon
              _passwordVisible ? Icons.visibility : Icons.visibility_off,
            ),
            onPressed: () {
              // Update the state i.e. toogle the state of passwordVisible variable
              setState(() {
                _passwordVisible = !_passwordVisible;
              });
            },
          ),
        ),
        SizedBox(
          height: 12,
        ),

        // SizedBox(height: 12,),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Expanded(
              //   flex: 1,
              child: customTextFormField(
                context,
                validator: (value) {
                  return ValidatorClass.isValidName(value);
                },
                onChanged: (value) {
                  Provider.of<UserAuthProvider>(context, listen: false)
                      .user
                      .setFirstName = value;
                },
                editingController: firstNameController,
                labelText: 'الاسم الاول',
                // hintText: 'Enter valid mail id as abc@gmail.com'
              ),
            ),
            SizedBox(
              width: 1,
            ),
            Expanded(
              //  flex: 1,
              child: customTextFormField(
                context,
                validator: (value) {
                  return ValidatorClass.isValidName(value);
                },
                onChanged: (value) {
                  Provider.of<UserAuthProvider>(context, listen: false)
                      .user
                      .setFatherName = value;
                },
                editingController: fatherNameController,

                labelText: 'اسم الأب',
                // hintText: 'Enter valid mail id as abc@gmail.com'
              ),
            ),
            SizedBox(
              width: 1,
            ),
            Expanded(
              flex: 1,
              child: customTextFormField(
                context,
                validator: (value) {
                  return ValidatorClass.isValidName(value);
                },
                onChanged: (value) {
                  Provider.of<UserAuthProvider>(context, listen: false)
                      .user
                      .setFamilyName = value;
                },
                editingController: familyNameController,

                labelText: 'اسم العائلة',
                //hintText: 'Enter valid mail id as abc@gmail.com'
              ),
            ),
          ],
        ),
        SizedBox(
          height: 24,
        ),
        Row(
          children: [
            Expanded(
              flex: 1,
              child: DateTimePicker(
                style: Theme.of(context).textTheme.bodyText1,
                validator: (value) {
                  if (value.isEmpty || value == null)
                    return "يجب ادخال تاريخ الميلاد";
                  else
                    return null;
                },
                onChanged: (value) {
                  Provider.of<UserAuthProvider>(context, listen: false)
                      .user
                      .setDate_of_birth = value;
                },
                // controller: date_of_birthController,
                type: DateTimePickerType.date,

                cancelText: "لا",
                confirmText: 'نعم',
                dateMask: 'd MMM, yyyy',
                enabled: true,
                initialValue: "1960-01-01 00:00:00.000",
                firstDate: DateTime(1960),
                lastDate: DateTime(DateTime.now().year - 12),
                calendarTitle: 'اختر تاريخ ميلادك',
                icon: Icon(Icons.event),
                dateLabelText: 'تاريخ الميلاد',
                timeLabelText: "ساعة",
                textAlign: TextAlign.left,
                autovalidate: true,
                errorFormatText: "ادخل تاريخ صحيح",
                errorInvalidText: 'تأكد من ادخال تاريخ صحيح',
                onSaved: (val) => print('the date is $val'),
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
                      Provider.of<UserAuthProvider>(context, listen: false)
                          .user
                          .setCountry = country.displayNameNoCountryCode;
                      setState(() {
                        country1 = country.displayNameNoCountryCode.toString();
                      });
                    },
                  );
                },
                icon: Icon(Icons.language),
                label: Text(
                  country1 != "" ? country1 : 'اختيار الدولة',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ],
        ),
        SizedBox(
          height: 24,
        ),
      ],
    );
  }
}
