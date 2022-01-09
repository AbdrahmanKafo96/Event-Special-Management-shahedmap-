import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:hovering/hovering.dart';
import 'package:intl/intl.dart' as intl;
import 'package:provider/provider.dart';
import 'package:systemevents/CustomWidget/customToast.dart';
import 'package:systemevents/HomeApp/HomePage.dart';
import 'package:systemevents/loginAndRegister/validator.dart';
import 'package:systemevents/provider/Auth.dart';
import 'CreateAccount.dart';
import 'LoginForm.dart';
import 'logopage.dart';

class LoginUi extends StatefulWidget {
  @override
  _LoginUiState createState() => _LoginUiState();
}

enum PageState { reg, login }

class _LoginUiState extends State<LoginUi> {
  DateTime _dateTime;
  dynamic val = PageState.login;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }
  TextEditingController emailController = TextEditingController();

  Future<void> _displayTextInputDialog(BuildContext context) async {
    return showDialog(
      context: context,
      builder: (context) {
        return Directionality(
          textDirection: TextDirection.rtl,
          child: AlertDialog(
            title: Text('طلب كلمة مرور جديدة', style: TextStyle(fontSize: 14),),
            content:  TextFormField(
              keyboardType:TextInputType.emailAddress  ,
              controller:emailController ,
              onChanged: (value){
                Provider.of<UserAuthProvider>(context,listen: false).user.setEmail=emailController.text;
              },
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'البريد الالكتروني مطلوب';
                }
                else if (!ValidatorClass.isValidEmail(value)){
                  return 'البريد الالكتروني غير صالح تحقق من المدخلات';
                }
                else return null;
              },
              decoration: InputDecoration(
                  helperStyle: TextStyle(fontSize: 12),
                  border: OutlineInputBorder(),
                  labelText: 'البريد الإلكتروني',
                  hintText: 'ادخل البريد الإلكتروني'
              ),
            ),
            actions: <Widget>[
              FlatButton(
                child: Text('لا' , style: TextStyle(fontSize: 12),),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              FlatButton(
                color: Colors.green,
                child: Text('ارسال طلب' ,style: TextStyle(fontSize: 12),),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),


            ],
          ),
        );
      },
    );
  }
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Directionality(
          textDirection: TextDirection.rtl,
          child: Scaffold(
              appBar: AppBar(
                centerTitle: true,
                title: Text(
                  val == PageState.login ? " تسجيل الدخول" : 'إنشاء حساب',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              body: Container(
                color: Colors.white,
                child: SingleChildScrollView(
                  padding: EdgeInsets.all(15),
                  child: Form(
                    key: _formKey,
                    child: Column(children: [
                      Logo('logo.png'),
                      val == PageState.login ? LoginForm() : RegistrationForm(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          TextButton(
                            onPressed: () {
                              _displayTextInputDialog(context);
                            },
                            child: Text(
                              'نسيت كلمة المرور!',
                              style: TextStyle(
                                color: Colors.blue, fontSize: 15,
                                decoration: TextDecoration.underline,
                                //decorationStyle: TextDecorationStyle.dashed,
                              ),
                            ),
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
                            child: Text(
                              val == PageState.reg
                                  ? "لدي حساب!"
                                  : 'لا تملك حساب!',
                              style: TextStyle(
                                color: Colors.blue, fontSize: 15,
                                decoration: TextDecoration.underline,
                                //  decorationStyle: TextDecorationStyle.dashed,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 24,
                      ),
                      Container(
                        height: 50,
                        width: MediaQuery.of(context).size.width * 0.75,
                        decoration: BoxDecoration(
                            //     color: Color(0xFF5a8f62),
                            borderRadius: BorderRadius.circular(20)),
                        child: HoverButton(
                          color: Colors.green,
                          onpressed: () async {
                            Map userdata;
                            // L login  , R Register  ...
                            userdata = val == PageState.login
                                ? {
                                    'userState': 'L',
                                    'message_token': await FirebaseMessaging
                                        .instance
                                        .getToken(),
                                    'email': Provider.of<UserAuthProvider>(
                                            context,
                                            listen: false)
                                        .user
                                        .getEmail
                                        .toString(),
                                    'password': Provider.of<UserAuthProvider>(
                                            context,
                                            listen: false)
                                        .user
                                        .getPassword
                                        .toString(),
                                  }
                                : {
                                    'userState': 'R',
                                    'role_id': '2',
                                    'message_token': await FirebaseMessaging
                                        .instance
                                        .getToken(),
                                    'email': Provider.of<UserAuthProvider>(
                                            context,
                                            listen: false)
                                        .user
                                        .getEmail
                                        .toString(),
                                    'password': Provider.of<UserAuthProvider>(
                                            context,
                                            listen: false)
                                        .user
                                        .getPassword
                                        .toString(),
                                    'first_name': Provider.of<UserAuthProvider>(
                                            context,
                                            listen: false)
                                        .user
                                        .getFirstName
                                        .toString(),
                                    'father_name': Provider.of<UserAuthProvider>(
                                            context,
                                            listen: false)
                                        .user
                                        .getFatherName
                                        .toString(),
                                    'family_name': Provider.of<UserAuthProvider>(
                                            context,
                                            listen: false)
                                        .user
                                        .getFamilyName
                                        .toString(),
                                    'country': Provider.of<UserAuthProvider>(
                                            context,
                                            listen: false)
                                        .user
                                        .getCountry
                                        .toString(),
                                    'date_of_birth':
                                        Provider.of<UserAuthProvider>(context,
                                                listen: false)
                                            .user
                                            .getDate_of_birth
                                            .toString(),
                                  };

                            if (val != PageState.login) {
                              if (Provider.of<UserAuthProvider>(context,
                                              listen: false)
                                          .user
                                          .getDate_of_birth ==
                                      null ||
                                  Provider.of<UserAuthProvider>(context,
                                              listen: false)
                                          .user
                                          .getDate_of_birth
                                          .toString() ==
                                      intl.DateFormat('yyyy-MM-dd')
                                          .format(DateTime.now())
                                          .toString()) {
                                showShortToast(
                                    'رجاء ادخل تاريخ الميلاد', Colors.orange);
                              }
                              if (Provider.of<UserAuthProvider>(context,
                                          listen: false)
                                      .user
                                      .getCountry ==
                                  null) {
                                showShortToast(
                                    'رجاء ادخل اسم الدولة', Colors.orange);
                              }
                            }
                            if (_formKey.currentState.validate()) {
                              dynamic result =
                                  await Provider.of<UserAuthProvider>(context,
                                          listen: false)
                                      .login(userdata);

                              if (result == true) {
                                showDialog(
                                  context: context,
                                  barrierDismissible: false,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      contentPadding: EdgeInsets.zero,
                                      backgroundColor: Colors.blue.withOpacity(0),
                                      content: Stack(
                                        children: <Widget>[
                                          Directionality(
                                            child: Container(
                                              decoration: BoxDecoration(
                                                  color: Colors.green
                                                      .withOpacity(0.3),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10.0)),
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.75,
                                              height: MediaQuery.of(context)
                                                      .size
                                                      .height *
                                                  0.3,
                                              alignment:
                                                  AlignmentDirectional.center,
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: <Widget>[
                                                  Center(
                                                    child: SizedBox(
                                                      height: 50.0,
                                                      width: 50.0,
                                                      child:
                                                          CircularProgressIndicator(
                                                        // value:  ,
                                                        color: Colors.white,
                                                        strokeWidth: 7.0,
                                                      ),
                                                    ),
                                                  ),
                                                  Container(
                                                    margin: const EdgeInsets.only(
                                                        top: 25.0),
                                                    child: Center(
                                                      child: Text(
                                                        " قيد الانتظار...",
                                                        style: TextStyle(
                                                            color: Colors.white),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            textDirection: TextDirection.rtl,
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                );
                                Future.delayed(Duration(seconds: 3), () {
                                  Navigator.pop(context); //pop dialog
                                  Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                          builder: (_) => HomePage()));
                                });
                              } else {}
                            }
                          },
                          child: Text(
                            val == PageState.reg ? "إنشاء حساب" : 'تسجيل الدخول',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ]),
                  ),
                ),
              ))
          // This trailing comma makes auto-formatting nicer for build methods.
          ),
    );
  }
}
