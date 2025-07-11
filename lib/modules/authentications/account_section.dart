import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:shahed/modules/authentications/login_section.dart';
import 'package:shahed/modules/authentications/validator.dart';
import 'package:shahed/provider/auth_provider.dart';
import 'package:shahed/widgets/custom_Text_Field.dart';
import '../../shared_data/shareddata.dart';
import 'package:intl/intl.dart';

import '../../theme/colors_app.dart';

class RegistrationForm extends StatefulWidget {
  @override
  _RegistrationFormState createState() => _RegistrationFormState();
}

class _RegistrationFormState extends State<RegistrationForm> {
  final passwordConfController = TextEditingController();
  final firstNameController = TextEditingController();
  final fatherNameController = TextEditingController();
  final familyNameController = TextEditingController();
  String? countryController;

  final date_of_birthController = TextEditingController();
  bool? _passwordConfVisible=false;

  String country1 = "";
  DateTime selectedDate = DateTime(1960);

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

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
            if (value!.isEmpty || value == null)
              return SharedData.getGlobalLang().thisFieldIsRequired();

            if (Provider.of<UserAuthProvider>(context, listen: false)
                    .user
                    .getPassword ==
                null) {
              return SharedData.getGlobalLang().passwordAlertConfirming();
            } else if (Provider.of<UserAuthProvider>(context, listen: false)
                    .user
                    .getPassword
                    .toString() ==
                passwordConfController.text.toString()) {
              return null;
            } else {
              return SharedData.getGlobalLang().passwordsAlertNotConfirming();
            }
          },
          onChanged: (value) {
            Provider.of<UserAuthProvider>(context, listen: false)
                .user
                .setConfPassword = value;
          },
          obsecure: !_passwordConfVisible!,
          editingController: passwordConfController,
          prefixIcon: Icon(
            Icons.password,
          ),
          labelText: SharedData.getGlobalLang().reEnterPassword(),
          hintText: SharedData.getGlobalLang().reEnterPassword(),
          suffixIcon: IconButton(
            icon: Icon(
              // Based on passwordVisible state choose the icon
              _passwordConfVisible! ? Icons.visibility : Icons.visibility_off,
              color: _passwordConfVisible! ?SharedColor.white:SharedColor.grey,
            ),
            onPressed: () {
              // Update the state i.e. toogle the state of passwordVisible variable
              setState(() {
                _passwordConfVisible = !_passwordConfVisible!;
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
                  return ValidatorClass.isValidName(value!);
                },
                onChanged: (value) {
                  Provider.of<UserAuthProvider>(context, listen: false)
                      .user
                      .setFirstName = value;
                },
                editingController: firstNameController,
                labelText: SharedData.getGlobalLang().firstName(),
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
                  return ValidatorClass.isValidName(value!);
                },
                onChanged: (value) {
                  Provider.of<UserAuthProvider>(context, listen: false)
                      .user
                      .setFatherName = value;
                },
                editingController: fatherNameController,

                labelText: SharedData.getGlobalLang().middleName(),
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
                  return ValidatorClass.isValidName(value!);
                },
                onChanged: (value) {
                  Provider.of<UserAuthProvider>(context, listen: false)
                      .user
                      .setFamilyName = value;
                },
                editingController: familyNameController,

                labelText: SharedData.getGlobalLang().familyName(),
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
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                backgroundColor: SharedColor.deepOrange, // background
                foregroundColor: SharedColor.white, // foreground
                ),
                onPressed: () => _selectDate(context),
                icon: Icon(Icons.date_range),
                label: Text(SharedData.getGlobalLang().dateOfBirth()),
              ),
              // child: DateTimePicker(
              //
              //   style: TextStyle(
              //     color: SharedColor.deepOrange
              //   ),
              //
              //   validator: (value) {
              //     if (value.isEmpty || value == null)
              //       return SharedData.getGlobalLang().dateBirthIsRequired();
              //     else
              //       return null;
              //   },
              //   onChanged: (value) {
              //     print(value);
              //     Provider.of<UserAuthProvider>(context, listen: false)
              //         .user
              //         .setDate_of_birth = value;
              //   },
              //   // controller: date_of_birthController,
              //   type: DateTimePickerType.date,
              //
              //   cancelText: SharedData.getGlobalLang().cancel(),
              //   confirmText: SharedData.getGlobalLang().okay(),
              //   dateMask: 'd MMM, yyyy',
              //   enabled: true,
              //   initialValue: "1960-01-01 00:00:00.000",
              //   firstDate: DateTime(1960),
              //   lastDate: DateTime(DateTime.now().year - 12),
              //   calendarTitle: SharedData.getGlobalLang().chooseYourDateBirth(),
              //   icon: Icon(Icons.event),
              //   dateLabelText: SharedData.getGlobalLang().dateOfBirth(),
              //   timeLabelText: SharedData.getGlobalLang().clock(),
              //   textAlign: TextAlign.left,
              //   autovalidate: true,
              //   errorFormatText: SharedData.getGlobalLang().enterCorrectData(),
              //   errorInvalidText: SharedData.getGlobalLang().validDate(),
              //   onSaved: (val) => print('the date is $val'),
              // )
            ),
            Expanded(
              flex: 1,
              child: TextButton.icon(
                onPressed: () {
                  showCountryPicker(
                    context: context,
                    //Optional.  Can be used to exclude(remove) one ore more country from the countries list (optional).
                    exclude: <String>['LY', 'UK'],
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
                  country1 != ""
                      ? country1
                      : SharedData.getGlobalLang().chooseCountry(),
                  style: TextStyle(color: SharedColor.white),
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

  _selectDate(BuildContext context) async {
    final DateTime? selected = await showDatePicker(
      context: context,
      initialDate: selectedDate,

      // validator: (value) {
      //   if (value.isEmpty || value == null)
      //     return SharedData.getGlobalLang().dateBirthIsRequired();
      //   else
      //     return null;
      // },
      // onChanged: (value) {
      //   print(value);
      //   Provider.of<UserAuthProvider>(context, listen: false)
      //       .user
      //       .setDate_of_birth = value;
      // },
      // controller: date_of_birthController,

      cancelText: SharedData.getGlobalLang().cancel(),
      confirmText: SharedData.getGlobalLang().okay(),

      firstDate: DateTime(1930),
      lastDate: DateTime(DateTime.now().year - 11),
      keyboardType: TextInputType.datetime,
      fieldLabelText: SharedData.getGlobalLang().chooseYourDateBirth(),
      fieldHintText: SharedData.getGlobalLang().dateOfBirth(),
      //  calendarTitle: SharedData.getGlobalLang().chooseYourDateBirth(),
      //  icon: Icon(Icons.event),
      // dateLabelText: SharedData.getGlobalLang().dateOfBirth(),
      //timeLabelText: SharedData.getGlobalLang().clock(),

      errorFormatText: SharedData.getGlobalLang().enterCorrectData(),
      errorInvalidText: SharedData.getGlobalLang().validDate(),

      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: Color(SharedColor.darkIntColor),
              onPrimary: SharedColor.deepOrange, // <-- SEE HERE
              onSurface: SharedColor.black, // <-- SEE HERE
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: SharedColor.deepOrange,
                backgroundColor: Color(SharedColor.darkIntColor)// button text color
              ),
            ),
          ),
          child: child!,
        );
      },
    );
    if (selected != null && selected != selectedDate) {
      setState(() {
        selectedDate = selected;
        Provider.of<UserAuthProvider>(context, listen: false)
            .user .setDate_of_birth =  DateFormat("yyyy-MM-dd").format(selected);
      });

    }
  }
}
