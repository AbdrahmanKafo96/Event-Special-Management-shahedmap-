import 'dart:io';
import 'dart:math';
import 'package:date_time_picker/date_time_picker.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hovering/hovering.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:shahed/singleton/singleton.dart';
import 'package:shahed/widgets/checkInternet.dart';
import 'package:shahed/models/witness.dart';
import 'package:shahed/provider/auth_provider.dart';
import 'package:shahed/widgets/customScaffoldMessenger.dart';
import 'package:shahed/widgets/custom_Text_Field.dart';
import 'package:shahed/widgets/custom_app_bar.dart';
import 'package:shahed/widgets/custom_drawer.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../../shared_data/shareddata.dart';
import '../../../widgets/customHoverButton.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>();

  File _image;
  final picker = ImagePicker();
  String _uri;
  var result;
  var firstNameCon = TextEditingController();
  var fatherNameCon = TextEditingController();
  var lastNameCon = TextEditingController();
  var dateCon = TextEditingController(text: "1960-01-01 00:00:00.000");
  String country1 = "";
  bool state = false;
  Witness witness;
  ImagePicker _picker = ImagePicker();
  bool switchPage = false,
      showTextFiled1 = false,
      showTextFiled2 = false,
      showTextFiled3 = false,
      showTextFiled4 = false;

  Future<void> getUID() async {
    Box box = await SharedClass.getBox();
    String uid = box.get('user_id').toString();
    setState(() {
      result = uid;
    });
  }

  @override
  void initState() {
    super.initState();
    getUID().then((value) => checkState(result).then((Witness value) {
          setState(() {
            witness = value;
            if (value != null) {
              state = true;
              _image = null;
              _uri = witness.image != null
                  ? "${SharedClass.routePath}${witness.image}"
                  : null;
              print(_uri);
              setDataForm();
            }
          });
        }));
  }

  @override
  void dispose() {
    super.dispose();
    firstNameCon.dispose();
    fatherNameCon.dispose();
    lastNameCon.dispose();
    dateCon.dispose();
    _uri = null;
    country1 = null;
    witness = null;
    _image = null;
  }

  SizedBox addPaddingWhenKeyboardAppears() {
    final viewInsets = EdgeInsets.fromWindowPadding(
      WidgetsBinding.instance.window.viewInsets,
      WidgetsBinding.instance.window.devicePixelRatio,
    );

    final bottomOffset = viewInsets.bottom;
    const hiddenKeyboard = 0.0; // Always 0 if keyboard is not opened
    final isNeedPadding = bottomOffset != hiddenKeyboard;

    return SizedBox(height: isNeedPadding ? bottomOffset : hiddenKeyboard);
  }

  @override
  Widget build(BuildContext context) {
    checkInternetConnectivity(context);
    return Scaffold(
        resizeToAvoidBottomInset: false,
        drawer: CustomDrawer(),
        key: _scaffoldKey,
        appBar: customAppBar(
          context,
          title: SharedData.getGlobalLang().profilePage(),
          icon: FontAwesomeIcons.solidUser,
        ),
        body: SafeArea(
          child: Stack(
            fit: StackFit.expand,
            children: [
              Container(
                child: Padding(
                  padding: EdgeInsets.only(top: 15),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      InkWell(
                        onTap: pickImage,
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                  blurRadius: 2,
                                  color: Colors.grey.withOpacity(0.5),
                                  spreadRadius: 2)
                            ],
                          ),
                          child: CircleAvatar(
                            child: RichText(
                              text: TextSpan(
                                children: [
                                  TextSpan(
                                      text: state != true
                                          ? "حمل الصورة الشخصية"
                                          : "",
                                      style: TextStyle(
                                          color: Colors.black, fontSize: 12)),
                                  WidgetSpan(
                                    child: state != true
                                        ? Icon(Icons.perm_media_sharp)
                                        : Image.asset(
                                            'assets/images/upload.png'),
                                  ),
                                ],
                              ),
                            ),
                            backgroundColor: Colors.white,
                            backgroundImage: _image == null
                                ? _uri != null
                                    ? NetworkImage(_uri)
                                    : null
                                : FileImage(_image),
                            radius: 80,
                            key: ValueKey(new Random().nextInt(100)),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                // decoration: const BoxDecoration(
                //   color: Colors.white,
                // ),
              ),
              Positioned(
                left: 0,
                bottom: 0,
                child: Hero(
                  tag: 'bottom_sheet',
                  child: Container(
                    decoration: const BoxDecoration(
                      // color: Color(0xff424250),
                      gradient: LinearGradient(
                        colors: [
                          //Color.fromRGBO(36, 36, 36, 0.85),
                          Color(0xFF424250),
                          Color(0xff33333d),
                        ],
                      ),
                      boxShadow: [
                        BoxShadow(
                          spreadRadius: 2.5,
                          blurRadius: 2,
                          color: Colors.black12,
                        ),
                      ],

                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(30),
                          topRight: Radius.circular(30)),
                    ),
                    height: MediaQuery.of(context).size.height * 0.55,
                    width: MediaQuery.of(context).size.width,
                    child: switchPage
                        ? SingleChildScrollView(
                            child: ConstrainedBox(
                                constraints: BoxConstraints(
                                  minHeight:
                                      MediaQuery.of(context).size.height * 0.75,
                                ),
                                child: Column(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(20.0),
                                      child: Form(
                                        key: _formKey,
                                        child: Column(
                                          children: [
                                            showTextFiled1
                                                ? customTextFormField(
                                                    context,
                                                    autofocus: true,
                                                    editingController:
                                                        firstNameCon,
                                                    keyboardType:
                                                        TextInputType.text,
                                                    validator: (value) => value
                                                            .isEmpty
                                                        ? SharedData
                                                                .getGlobalLang()
                                                            .firstNameIsRequired()
                                                        : null,
                                                    prefixIcon: Icon(
                                                      Icons
                                                          .drive_file_rename_outline,
                                                      color: Colors.deepOrange,
                                                    ),
                                                    labelText: SharedData
                                                            .getGlobalLang()
                                                        .firstName(),
                                                    hintText: SharedData
                                                            .getGlobalLang()
                                                        .enterFirstName(),
                                                  )
                                                : SizedBox.shrink(),
                                            SizedBox(
                                              height: 12,
                                            ),
                                            showTextFiled2
                                                ? customTextFormField(context,
                                                    autofocus: true,
                                                    editingController:
                                                        fatherNameCon,
                                                    keyboardType:
                                                        TextInputType.text,
                                                    validator: (value) => value
                                                            .isEmpty
                                                        ? SharedData
                                                                .getGlobalLang()
                                                            .middleNameRequired()
                                                        : null,
                                                    prefixIcon: Icon(
                                                      Icons
                                                          .drive_file_rename_outline,
                                                      color: Colors.deepOrange,
                                                    ),
                                                    labelText: SharedData
                                                            .getGlobalLang()
                                                        .middleName(),
                                                    hintText: SharedData
                                                            .getGlobalLang()
                                                        .enterMiddleName())
                                                : SizedBox.shrink(),
                                            SizedBox(
                                              height: 12,
                                            ),
                                            showTextFiled3
                                                ? customTextFormField(context,
                                                    autofocus: true,
                                                    editingController:
                                                        lastNameCon,
                                                    keyboardType:
                                                        TextInputType.text,
                                                    validator: (value) => value
                                                            .isEmpty
                                                        ? SharedData
                                                                .getGlobalLang()
                                                            .familyNameRequired()
                                                        : null,
                                                    prefixIcon: Icon(
                                                      Icons
                                                          .drive_file_rename_outline,
                                                      color: Colors.deepOrange,
                                                    ),
                                                    labelText: SharedData
                                                            .getGlobalLang()
                                                        .familyName(),
                                                    hintText: SharedData
                                                            .getGlobalLang()
                                                        .enterFamilyName())
                                                : SizedBox.shrink(),
                                            SizedBox(
                                              height: 24,
                                            ),
                                            // Row(
                                            //   children: [
                                            //     Expanded(
                                            //       flex: 1,
                                            //       child: showTextFiled4
                                            //           ? DateTimePicker(
                                            //               style:
                                            //                   Theme.of(context)
                                            //                       .textTheme
                                            //                       .bodyText1,
                                            //               validator: (value) {
                                            //                 if (value.isEmpty ||
                                            //                     value == null)
                                            //                   return SharedData
                                            //                           .getGlobalLang()
                                            //                       .dateBirthIsRequired();
                                            //                 else
                                            //                   return null;
                                            //               },
                                            //               onChanged: (value) {
                                            //                 Provider.of<UserAuthProvider>(
                                            //                             context,
                                            //                             listen:
                                            //                                 false)
                                            //                         .user
                                            //                         .setDate_of_birth =
                                            //                     value;
                                            //               },
                                            //               controller: dateCon,
                                            //               // controller: date_of_birthController,
                                            //               type:
                                            //                   DateTimePickerType
                                            //                       .date,
                                            //               cancelText: SharedData
                                            //                       .getGlobalLang()
                                            //                   .no(),
                                            //               confirmText: SharedData
                                            //                       .getGlobalLang()
                                            //                   .okay(),
                                            //               dateMask:
                                            //                   'd MMM, yyyy',
                                            //               //  initialValue:dateCon.text  ,
                                            //               firstDate:
                                            //                   DateTime(1930),
                                            //               lastDate: DateTime(
                                            //                   DateTime.now()
                                            //                           .year -
                                            //                       12),
                                            //
                                            //               calendarTitle: SharedData
                                            //                       .getGlobalLang()
                                            //                   .chooseYourDateBirth(),
                                            //               icon:
                                            //                   Icon(Icons.event),
                                            //               dateLabelText: SharedData
                                            //                       .getGlobalLang()
                                            //                   .dateOfBirth(),
                                            //               timeLabelText: SharedData
                                            //                       .getGlobalLang()
                                            //                   .clock(),
                                            //               textAlign:
                                            //                   TextAlign.left,
                                            //               autovalidate: true,
                                            //               errorFormatText: SharedData
                                            //                       .getGlobalLang()
                                            //                   .enterCorrectData(),
                                            //               errorInvalidText:
                                            //                   SharedData
                                            //                           .getGlobalLang()
                                            //                       .validDate(),
                                            //
                                            //               // validator: (val) {
                                            //               //   print('the date on validation $val ');
                                            //               //   return null;
                                            //               // },
                                            //               onSaved: (val) => print(
                                            //                   'the date on save $val'),
                                            //             )
                                            //           : SizedBox.shrink(),
                                            //     ),
                                            //   ],
                                            // ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    Container(
                                      margin: EdgeInsets.all(10),
                                      height: 50,
                                      width: double.infinity,
                                      decoration: BoxDecoration(
                                          color: Color(0xFFfe6e00),
                                          borderRadius:
                                              BorderRadius.circular(20)),
                                      child: customHoverButton(
                                        context,
                                        onPressed: () {
                                          checkInternetConnectivity(context)
                                              .then((bool value) async {
                                            if (value) {
                                              var form = _formKey.currentState;
                                              if (form.validate()) {
                                                state == true
                                                    ? updateForm(context)
                                                    : saveData(context);
                                                setState(() {
                                                  switchPage = !switchPage;
                                                  showTextFiled1 = false;
                                                  showTextFiled2 = false;
                                                  showTextFiled3 = false;
                                                  showTextFiled4 = false;
                                                });
                                              } else {
                                                customScaffoldMessenger(
                                                  color: Colors.red,
                                                  context: context,
                                                  text:
                                                      SharedData.getGlobalLang()
                                                          .fillFields(),
                                                );
                                              }
                                            }
                                          });
                                        },
                                        icon: state == true
                                            ? FontAwesomeIcons.penToSquare
                                            : Icons.save,
                                        text: SharedData.getGlobalLang()
                                            .editPersonalData(),
                                      ),
                                    ),
                                    addPaddingWhenKeyboardAppears(),
                                  ],
                                )))
                        : ListView(
                            padding: EdgeInsets.all(25),
                            children: [
                              ListTile(
                                onTap: () {
                                  setState(() {
                                    showTextFiled1 = !showTextFiled1;
                                    switchPage = !switchPage;
                                  });
                                },
                                title: Text(
                                  SharedData.getGlobalLang().firstName(),
                                  style: Theme.of(context).textTheme.headline4,
                                ),
                                leading: Icon(
                                  Icons.drive_file_rename_outline,
                                  color: Colors.white,
                                ),
                                trailing: Icon(
                                  Icons.arrow_forward_ios,
                                  color: Colors.white,
                                ),
                              ),
                              ListTile(
                                onTap: () {
                                  setState(() {
                                    showTextFiled2 = !showTextFiled2;
                                    switchPage = !switchPage;
                                  });
                                },
                                title: Text(
                                  SharedData.getGlobalLang().middleName(),
                                  style: Theme.of(context).textTheme.headline4,
                                ),
                                leading: Icon(
                                  Icons.drive_file_rename_outline,
                                  color: Colors.white,
                                ),
                                trailing: Icon(
                                  Icons.arrow_forward_ios,
                                  color: Colors.white,
                                ),
                              ),
                              ListTile(
                                onTap: () {
                                  setState(() {
                                    showTextFiled3 = !showTextFiled3;
                                    switchPage = !switchPage;
                                  });
                                },
                                title: Text(
                                  SharedData.getGlobalLang().familyName(),
                                  style: Theme.of(context).textTheme.headline4,
                                ),
                                leading: Icon(
                                  Icons.drive_file_rename_outline,
                                  color: Colors.white,
                                ),
                                trailing: Icon(
                                  Icons.arrow_forward_ios,
                                  color: Colors.white,
                                ),
                              ),
                              // ListTile(
                              //   onTap: () {
                              //     setState(() {
                              //       showTextFiled4 = !showTextFiled4;
                              //       switchPage = !switchPage;
                              //     });
                              //   },
                              //   title: Text(
                              //     SharedData.getGlobalLang().dateOfBirth(),
                              //     style: Theme.of(context).textTheme.headline4,
                              //   ),
                              //   leading: Icon(
                              //     Icons.date_range,
                              //     color: Colors.white,
                              //   ),
                              //   trailing: Icon(
                              //     Icons.arrow_forward_ios,
                              //     color: Colors.white,
                              //   ),
                              // ),

                               Container(
                                 margin: EdgeInsets.all(10),
                                 height: 50,
                                 width: double.infinity,
                                 decoration: BoxDecoration(
                                     color: Color(0xFFfe6e00),
                                     borderRadius: BorderRadius.circular(20)),
                                 child: HoverButton(
                                   onpressed: () {
                                     setState(() {
                                       switchPage = !switchPage;
                                       showTextFiled1 = true;
                                       showTextFiled2 = true;
                                       showTextFiled3 = true;
                                       showTextFiled4 = true;
                                     });
                                   },
                                   splashColor: Color(0xFFFF8F00),
                                   hoverTextColor: Color(0xFFFF8F00),
                                   highlightColor: Color(0xFFFF8F00),
                                   color: Color(0xFFfe6e00),
                                   child: Center(
                                       child: Row(
                                           mainAxisAlignment:
                                           MainAxisAlignment.center,
                                           children: [
                                             Padding(
                                               padding: EdgeInsets.only(
                                                   bottom: 3, right: 2, left: 2),
                                               child: Icon(
                                                 state == true
                                                     ? FontAwesomeIcons.penToSquare
                                                     : Icons.save,
                                                 color: Theme.of(context)
                                                     .iconTheme
                                                     .color,
                                               ),
                                             ),
                                             Text(
                                               SharedData.getGlobalLang()
                                                   .editPersonalData(),
                                               style: Theme.of(context)
                                                   .textTheme
                                                   .headline4,
                                             )
                                           ])),
                                 ),
                               )
                            ],
                          ),
                  ),
                ),
              )
            ],
          ),
        ));
  }

  void pickImage() async {
    var image =
        await _picker.pickImage(source: ImageSource.gallery, imageQuality: 50);
    if (image != null) if (image.path != "")
      setState(() {
        _image = File(image.path);

        Provider.of<UserAuthProvider>(context, listen: false)
            .user
            .profilePicture = _image;
        _uri = null;
      });
  }

  Future<void> saveData(BuildContext context) async {
    try {
      //await uploadImage(context);

      if (result != null) {
        Map data = {
          'user_id': result.toString(),
          'first_name': firstNameCon.text,
          'father_name': fatherNameCon.text,
          'family_name': lastNameCon.text,
          'country': Provider.of<UserAuthProvider>(context, listen: false)
              .user
              .getCountry
              .toString(),
          'date_of_birth': Provider.of<UserAuthProvider>(context, listen: false)
              .user
              .getDate_of_birth
              .toString(),
        };

        bool res = await Provider.of<UserAuthProvider>(context, listen: false)
            .saveProfileData(data);
        if (res == true)
          customScaffoldMessenger(
            color: Colors.green,
            context: context,
            text: SharedData.getGlobalLang().savedSuccessfully(),
          );
        else {
          customScaffoldMessenger(
            color: Colors.orange,
            context: context,
            text: SharedData.getGlobalLang().saveWasNotSuccessful(),
          );
        }
      } // end if stm
    } catch (ex) {
      customScaffoldMessenger(
          color: Colors.orange,
          context: context,
          text: SharedData.getGlobalLang().saveWasNotSuccessful());
    }
  }

  void setDataForm() {
    firstNameCon.text = witness != null ? witness.first_name : "";
    fatherNameCon.text = witness != null ? witness.father_name : "";
    lastNameCon.text = witness != null ? witness.family_name : "";
    dateCon.text =
        witness != null ? (witness.date_of_birth) : "1960-01-01 00:00:00.000";
    print(dateCon.text);
    witness != null
        ? Provider.of<UserAuthProvider>(context, listen: false)
            .user
            .setDate_of_birth = dateCon.text
        : Provider.of<UserAuthProvider>(context, listen: false)
            .user
            .setDate_of_birth = "1960-01-01 00:00:00.000";

    country1 = witness != null ? witness.country : "";
    witness != null
        ? Provider.of<UserAuthProvider>(context, listen: false)
            .user
            .setCountry = witness.country
        : Provider.of<UserAuthProvider>(context, listen: false)
            .user
            .setCountry = "";
    _image = null;
  }

  Future<void> updateForm(BuildContext context) async {
    try {
      //await uploadImage(context);

      if (result != null) {
        Map data = {
          'user_id': result.toString(),
          'first_name': firstNameCon.text,
          'father_name': fatherNameCon.text,
          'family_name': lastNameCon.text,
          'country': Provider.of<UserAuthProvider>(context, listen: false)
              .user
              .getCountry
              .toString(),
          'date_of_birth': Provider.of<UserAuthProvider>(context, listen: false)
              .user
              .getDate_of_birth
              .toString(),
        };

        bool res = await Provider.of<UserAuthProvider>(context, listen: false)
            .updateProfileData(data);
        if (res == true)
          customScaffoldMessenger(
              color: Colors.green,
              context: context,
              text: SharedData.getGlobalLang().updateSuccessfully());
        else {
          customScaffoldMessenger(
              color: Colors.orange,
              context: context,
              text: SharedData.getGlobalLang().saveWasNotSuccessful());
        }
      } // end if stm
    } catch (ex) {
      customScaffoldMessenger(
        color: Colors.orange,
        context: context,
        text: SharedData.getGlobalLang().saveWasNotSuccessful(),
      );
    }
  }

  Future<Witness> checkState(result) async {
    Witness res = await Provider.of<UserAuthProvider>(context, listen: false)
        .checkState(result);
    return res;
  }
}
