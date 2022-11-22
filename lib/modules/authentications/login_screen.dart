import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:hovering/hovering.dart';
import 'package:intl/intl.dart' as intl;
import 'package:platform_device_id/platform_device_id.dart';
import 'package:provider/provider.dart';
import 'package:shahed/modules/home/mainpage.dart';
import 'package:shahed/modules/authentications/login_section.dart';
import 'package:shahed/shared_data/shareddata.dart';
import 'package:shahed/singleton/singleton.dart';
import 'package:shahed/widgets/checkInternet.dart';
import 'package:shahed/widgets/custom_Text_Field.dart';
import 'package:shahed/widgets/custom_app_bar.dart';
import 'package:shahed/widgets/custom_dialog.dart';
import 'package:shahed/widgets/custom_toast.dart';
import 'package:shahed/modules/authentications/validator.dart';
import 'package:shahed/provider/auth_provider.dart';
import '../../widgets/customHoverButton.dart';
import 'account_section.dart';
import 'logo.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class LoginUi extends StatefulWidget {
  @override
  _LoginUiState createState() => _LoginUiState();
}

enum PageState { reg, login }

class _LoginUiState extends State<LoginUi> {
  dynamic val = PageState.login;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
  }

  TextEditingController emailController = TextEditingController();
  TextEditingController recoverAccountController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        child:  Scaffold(
              appBar: customAppBar(
                context,
                // title: val == PageState.login
                //     ? SharedData.getGlobalLang().login()
                //     : SharedData.getGlobalLang().createAccount(),
              ),
              body: SafeArea(
                child: Stack(
                  children: [
                    Container(
                      decoration: const BoxDecoration(color: Color(0xff33333d)),
                      height: double.infinity,
                      child: Card(
                        margin: EdgeInsets.all(10),
                        color: Color(0xFF424250),
                        shape: RoundedRectangleBorder(
                          side: BorderSide(
                            color: Colors.grey.withOpacity(0.5),
                            width: 1,
                          ),
                          borderRadius: BorderRadius.circular(25),
                        ),
                        child: Container(
                            padding: EdgeInsets.all(10),
                            child: SingleChildScrollView(
                              child: Form(
                                key: _formKey,
                                child: Column(
                                    children: [
                                SharedData.getGlobalLang().getLanguage=="AR"?  Logo('logoa.png'):Logo('logoe.png'),
                                  val == PageState.login
                                      ? LoginForm()
                                      : RegistrationForm(),
                                  FittedBox(
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: [
                                        TextButton(
                                          onPressed: () {
                                            final formKey = GlobalKey<FormState>();
                                            customReusableShowDialog(
                                              context,
                                              SharedData.getGlobalLang()
                                                  .requestNewPassword(),
                                              widget: Form(
                                                key: formKey,
                                                child: customTextFormField(context,
                                                    keyboardType:
                                                        TextInputType.emailAddress,
                                                    editingController:
                                                        recoverAccountController,
                                                    onChanged: (value) {
                                                  Provider.of<UserAuthProvider>(
                                                              context,
                                                              listen: false)
                                                          .user
                                                          .setEmail =
                                                      emailController.text;
                                                }, validator: (value) {
                                                  if (value == null ||
                                                      value.isEmpty) {
                                                    return SharedData
                                                            .getGlobalLang()
                                                        .emailRequired();
                                                  } else if (!ValidatorClass
                                                      .isValidEmail(value)) {
                                                    return SharedData
                                                            .getGlobalLang()
                                                        .emailNotValid();
                                                  } else
                                                    return null;
                                                },
                                                    //onTap: onTap,
                                                    // helperStyle: helperStyle,
                                                    labelText:
                                                        SharedData.getGlobalLang()
                                                            .email(),
                                                    hintText:
                                                        SharedData.getGlobalLang()
                                                            .enterYourEmail()),
                                              ),
                                              // formKey: formKey,

                                              actions: <Widget>[
                                                TextButton(
                                                  child: Text(
                                                    SharedData.getGlobalLang()
                                                        .cancel(),
                                                    style: TextStyle(

                                                        color: Colors.white),
                                                  ),
                                                  onPressed: () {
                                                    Navigator.pop(context);
                                                  },
                                                ),
                                                Container(
                                                  decoration: BoxDecoration(
                                                    color: Colors.deepOrange,
                                                    borderRadius: BorderRadius.all(
                                                        Radius.circular(5)),
                                                  ),
                                                  child: TextButton(
                                                    //color: Colors.green,
                                                    child: Text(
                                                      SharedData.getGlobalLang()
                                                          .sendRequest(),
                                                      style:
                                                          TextStyle(fontSize: 12),
                                                    ),
                                                    onPressed: () {
                                                      if (formKey.currentState
                                                          .validate()) {
                                                        Provider.of<UserAuthProvider>(
                                                                context,
                                                                listen: false)
                                                            .forgotpassword(
                                                                recoverAccountController
                                                                    .text
                                                                    .toString());
                                                        Navigator.pop(context);
                                                      }
                                                    },
                                                  ),
                                                ),
                                              ],
                                            );
                                          },
                                          child: Row(
                                            children: [
                                              Padding(
                                                padding: EdgeInsets.only(
                                                    bottom: 5, right: 1, left: 1),
                                                child: Icon(
                                                  Icons.lock_reset_outlined,
                                                  color: Colors.white,
                                                ),
                                              ),

                                                Text(
                                                  SharedData.getGlobalLang()
                                                      .forgetYourPassword(),
                                                  style: TextStyle(
                                                    color: Colors.orange,

                                                    decoration:
                                                        TextDecoration.underline,
                                                  ),
                                              ),
                                            ],
                                          ),
//
                                        ),
                                        TextButton(
                                          onPressed: () {
                                            setState(() {
                                              if (val == PageState.login)
                                                val = PageState.reg;
                                              else
                                                val = PageState.login;
                                            });
                                          },
                                          child: Row(
                                            children: [
                                              Padding(
                                                padding: EdgeInsets.only(
                                                    bottom: 5, right: 1, left: 1),
                                                child: Icon(
                                                  Icons.person,
                                                  color: Colors.white,
                                                ),
                                              ),
                                              Text(
                                                val == PageState.reg
                                                    ? SharedData.getGlobalLang()
                                                        .hasAccount()
                                                    : SharedData.getGlobalLang()
                                                        .hasNoAccount(),
                                                style: TextStyle(
                                                  color: Colors.orange,
                                                  fontSize: 14,
                                                  decoration:
                                                      TextDecoration.underline,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    height: 50,
                                    width:
                                        MediaQuery.of(context).size.width * 0.75,
                                    decoration: BoxDecoration(
//     color: Color(0xFF5a8f62),
                                        borderRadius: BorderRadius.circular(20)),
                                    child: customHoverButton(
                                      context,
                                      onPressed: () async {

                                        Map userdata;
// L login  , R Register  ...
                                        userdata = val == PageState.login
                                            ? {
                                                'userState': 'L',
                                                'message_token':
                                                    await FirebaseMessaging
                                                        .instance
                                                        .getToken(),
                                                'device_name':
                                                    await PlatformDeviceId
                                                        .getDeviceId,
                                                'email':
                                                    Provider.of<UserAuthProvider>(
                                                            context,
                                                            listen: false)
                                                        .user
                                                        .getEmail
                                                        .toString(),
                                                'password':
                                                    Provider.of<UserAuthProvider>(
                                                            context,
                                                            listen: false)
                                                        .user
                                                        .getPassword
                                                        .toString(),
                                              }
                                            : {
                                                'userState': 'R',
                                                'role_id': '2',
                                                'device_name':
                                                    await PlatformDeviceId
                                                        .getDeviceId,
                                                'message_token':
                                                    await FirebaseMessaging
                                                        .instance
                                                        .getToken(),
                                                'email':
                                                    Provider.of<UserAuthProvider>(
                                                            context,
                                                            listen: false)
                                                        .user
                                                        .getEmail
                                                        .toString(),
                                                'password':
                                                    Provider.of<UserAuthProvider>(
                                                            context,
                                                            listen: false)
                                                        .user
                                                        .getPassword
                                                        .toString(),
                                                'first_name':
                                                    Provider.of<UserAuthProvider>(
                                                            context,
                                                            listen: false)
                                                        .user
                                                        .getFirstName
                                                        .toString(),
                                                'father_name':
                                                    Provider.of<UserAuthProvider>(
                                                            context,
                                                            listen: false)
                                                        .user
                                                        .getFatherName
                                                        .toString(),
                                                'family_name':
                                                    Provider.of<UserAuthProvider>(
                                                            context,
                                                            listen: false)
                                                        .user
                                                        .getFamilyName
                                                        .toString(),
                                                'country':
                                                    Provider.of<UserAuthProvider>(
                                                            context,
                                                            listen: false)
                                                        .user
                                                        .getCountry
                                                        .toString(),
                                                'date_of_birth':
                                                    Provider.of<UserAuthProvider>(
                                                            context,
                                                            listen: false)
                                                        .user
                                                        .getDate_of_birth
                                                        .toString(),
                                              };

                                        if (val != PageState.login) {
                                          if (Provider.of<UserAuthProvider>(
                                                          context,
                                                          listen: false)
                                                      .user
                                                      .getDate_of_birth ==
                                                  null ||
                                              Provider.of<UserAuthProvider>(
                                                          context,
                                                          listen: false)
                                                      .user
                                                      .getDate_of_birth
                                                      .toString() ==
                                                  intl.DateFormat('yyyy-MM-dd')
                                                      .format(DateTime.now())
                                                      .toString()) {
                                            showShortToast(
                                                SharedData.getGlobalLang()
                                                    .dateBirthIsRequired(),
                                                Colors.orange);
                                          }
                                          if (Provider.of<UserAuthProvider>(
                                                      context,
                                                      listen: false)
                                                  .user
                                                  .getCountry ==
                                              null) {
                                            showShortToast(
                                                SharedData.getGlobalLang()
                                                    .countryRequired(),
                                                Colors.orange);
                                          }
                                        }
                                        if (_formKey.currentState.validate()) {
                                          checkInternetConnectivity(context)
                                              .then((bool value) async {
                                            if (value) {
                                              dynamic result = await Provider.of<
                                                          UserAuthProvider>(
                                                      context,
                                                      listen: false)
                                                  .login(userdata);

                                              if (result == true) {
                                                showDialog(
                                                  context: context,
                                                  barrierDismissible: false,
                                                  builder:
                                                      (BuildContext context) {
                                                    return AlertDialog(
                                                      contentPadding:
                                                          EdgeInsets.zero,
                                                      backgroundColor: Colors.blue
                                                          .withOpacity(0),
                                                      content: Stack(
                                                        children: <Widget>[
                                                          Container(
                                                            decoration:
                                                                BoxDecoration(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          10.0),
                                                              color: Colors
                                                                  .deepOrangeAccent
                                                                  .withOpacity(
                                                                      0.7),
                                                            ),
                                                            width: MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width *
                                                                0.75,
                                                            height: MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .height *
                                                                0.3,
                                                            alignment:
                                                                AlignmentDirectional
                                                                    .center,
                                                            child: Column(
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .center,
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .center,
                                                              children: <Widget>[
                                                                Center(
                                                                  child: SizedBox(
                                                                    height: 50.0,
                                                                    width: 50.0,
                                                                    child:
                                                                        CircularProgressIndicator(
                                                                      color: Colors
                                                                          .white,
                                                                      strokeWidth:
                                                                          7.0,
                                                                    ),
                                                                  ),
                                                                ),
                                                                Container(
                                                                  margin: const EdgeInsets
                                                                          .only(
                                                                      top: 25.0),
                                                                  child: Center(
                                                                    child: Text(
                                                                      SharedData
                                                                              .getGlobalLang()
                                                                          .waitMessage(),
                                                                      style: Theme.of(
                                                                              context)
                                                                          .textTheme
                                                                          .bodyText1,
                                                                    ),
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    );
                                                  },
                                                );
                                                await SharedClass.getBox();
                                                Future.delayed(
                                                    Duration(seconds: 3), () {
                                                  Navigator.pop(
                                                      context); //pop dialog
                                                  // final provider = Provider.of<NavigationProvider>(context);
                                                  // provider.setNavigationItem(NavigationItem.home);
                                                  Navigator.pushReplacement(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (_) =>
                                                              MainPage()));
                                                });
                                              }
                                            }
                                          });
                                        }
                                      },
                                      icon:  FontAwesomeIcons
                                          .arrowRightFromBracket,
                                      text:val == PageState.reg
                                          ? SharedData.getGlobalLang()
                                          .createAccount()
                                          : SharedData.getGlobalLang()
                                          .login(),
                                    ),
                                  ),
                                ]),
                              ),
                            )),
                      ),
                    ),
                  ],
                ),
              )
        ));
  }
}
