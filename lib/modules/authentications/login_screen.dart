import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:hovering/hovering.dart';
import 'package:intl/intl.dart' as intl;
import 'package:platform_device_id/platform_device_id.dart';
import 'package:provider/provider.dart';
import 'package:systemevents/modules/home/mainpage.dart';
import 'package:systemevents/modules/authentications/login_section.dart';
import 'package:systemevents/singleton/singleton.dart';
import 'package:systemevents/widgets/checkInternet.dart';
import 'package:systemevents/widgets/custom_Text_Field.dart';
import 'package:systemevents/widgets/custom_app_bar.dart';
import 'package:systemevents/widgets/custom_toast.dart';
import 'package:systemevents/modules/authentications/validator.dart';
import 'package:systemevents/provider/auth_provider.dart';
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

  Future<void> _displayTextInputDialog(BuildContext context) async {
    final _formKey = GlobalKey<FormState>();
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(
            'طلب كلمة مرور جديدة',
            style: TextStyle(fontSize: 14),
          ),
          content: Form(
            key: _formKey,
            child: customTextFormField(context,
                keyboardType: TextInputType.emailAddress,
                editingController: emailController, onChanged: (value) {
              Provider.of<UserAuthProvider>(context, listen: false)
                  .user
                  .setEmail = emailController.text;
            }, validator: (value) {
              if (value == null || value.isEmpty) {
                return 'البريد الالكتروني مطلوب';
              } else if (!ValidatorClass.isValidEmail(value)) {
                return 'البريد الالكتروني غير صالح تحقق من المدخلات';
              } else
                return null;
            },
                helperStyle: TextStyle(fontSize: 12),
                labelText: 'البريد الإلكتروني',
                hintText: 'ادخل البريد الإلكتروني'),
          ),
          actions: <Widget>[
            TextButton(
              child: Text(
                'لا',
                style: TextStyle(fontSize: 12),
              ),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            TextButton(
              //color: Colors.green,
              child: Text(
                'ارسال طلب',
                style: TextStyle(fontSize: 12),
              ),
              onPressed: () {
                if (_formKey.currentState.validate()) ;
                {
                  Provider.of<UserAuthProvider>(context, listen: false)
                      .forgotpassword(emailController.text.toString());
                  Navigator.pop(context);
                }
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        child: Scaffold(
            appBar: customAppBar(
              title: val == PageState.login ? " تسجيل الدخول" : 'إنشاء حساب',
            ),
            body: SafeArea(
              child: Stack(
                children: [
                  Container(
                    decoration: const BoxDecoration(
                     color: Color(0XFF424250)
                    ),
                    height: double.infinity,
                    // decoration: BoxDecoration(
                    //   color: Colors.black,
                    //   // image: DecorationImage(
                    //   //   image: AssetImage("assets/images/univ.jpg"),
                    //   //   fit: BoxFit.cover,
                    //   // ),
                    // ),
                    //     color: Colors.white,
                    child: Card(
                      margin: EdgeInsets.all(10),
                      color: Color(0XFF33333d),
                      shape: RoundedRectangleBorder(
                        side: BorderSide(
                          color: Colors.grey.withOpacity(0.5),
                          width: 1,
                        ),
                        borderRadius: BorderRadius.circular(25),
                      ),
                      child: Container(
                          padding: EdgeInsets.all(10),
                          // margin: EdgeInsets.all(20),
                          // decoration: BoxDecoration(
                          //     color: Color.fromRGBO(36, 36, 36, 0.85),
                          //     borderRadius: BorderRadius.circular(25)
                          // ),
                          child: SingleChildScrollView(
                            child: Form(
                              key: _formKey,
                              child: Column(children: [
                                Logo('logoa.png'),
                                val == PageState.login
                                    ? LoginForm()
                                    : RegistrationForm(),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    TextButton(
                                      onPressed: () {
                                        _displayTextInputDialog(context);
                                      },
                                      child: Row(
                                        children: [
                                          Padding(
                                            padding: EdgeInsets.only(
                                                bottom: 5, right: 1, left: 1),
                                            child:
                                                Icon(Icons.lock_reset_outlined),
                                          ),
                                          Text(
                                            'نسيت كلمة المرور!',
                                            style: TextStyle(
                                              color: Colors.orange,
                                              fontSize: 14,
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
                                            child: Icon(Icons.person),
                                          ),
                                          Text(
                                            val == PageState.reg
                                                ? "لدي حساب!"
                                                : 'لا تملك حساب!',
                                            style: TextStyle(
                                              color: Colors.orange,
                                              fontSize: 14,
                                              decoration:
                                                  TextDecoration.underline,
                                            ),
                                          ),
                                        ],
                                      ),
//                                       child: Text(
//                                         val == PageState.reg ? "لدي حساب!" : 'لا تملك حساب!',

//                                       ),
                                    ),
                                  ],
                                ),
                                Container(
                                  height: 50,
                                  width:
                                      MediaQuery.of(context).size.width * 0.75,
                                  decoration: BoxDecoration(
//     color: Color(0xFF5a8f62),
                                      borderRadius: BorderRadius.circular(20)),
                                  child: HoverButton(
                                    onpressed: () async {
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
                                              'رجاء ادخل تاريخ الميلاد',
                                              Colors.orange);
                                        }
                                        if (Provider.of<UserAuthProvider>(
                                                    context,
                                                    listen: false)
                                                .user
                                                .getCountry ==
                                            null) {
                                          showShortToast('رجاء ادخل اسم الدولة',
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
                                                                    " قيد الانتظار...",
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
                                              await Singleton.getBox();
                                              Future.delayed(
                                                  Duration(seconds: 3), () {
                                                Navigator.pop(
                                                    context); //pop dialog
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
                                    splashColor: Color(0xFFFF8F00),
                                    hoverTextColor: Color(0xFFFF8F00),
                                    highlightColor: Color(0xFFFF8F00),
                                    color: Color(0xFFfe6e00),
                                    child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Padding(
                                            padding: EdgeInsets.only(
                                                bottom: 3, right: 2, left: 2),
                                            child: Icon(
                                              FontAwesomeIcons.signIn,
                                              color: Theme.of(context)
                                                  .iconTheme
                                                  .color,
                                            ),
                                          ),
                                          Text(
                                            val == PageState.reg
                                                ? "إنشاء حساب"
                                                : 'تسجيل الدخول',
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ]),
                                  ),
                                ),
                              ]),
                            ),
                          )),
                    ),
                  ),
                ],
              ),
            )));
  }
}
