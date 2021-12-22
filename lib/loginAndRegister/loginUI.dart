import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart' as intl;
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:systemevents/CustomWidget/customToast.dart';
import 'package:systemevents/HomePage/HomePage.dart';
import 'package:systemevents/provider/Auth.dart';
import 'package:systemevents/singleton/singleton.dart';
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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text(
            " تتبع الحدث",
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        body: Directionality(
            textDirection: TextDirection.rtl,
            child: Container(
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
                          onPressed: () {},
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
                      width: 250,
                      decoration: BoxDecoration(
                          color: Color(0xFF11b719),
                          borderRadius: BorderRadius.circular(20)),
                      child: TextButton(
                        onPressed: () async {



                            Map userdata;
                            // L login  , R Register  ...
                            userdata = val == PageState.login ?{
                              'userState':'L',
                              'message_token':await FirebaseMessaging.instance.getToken(),
                              'email':Provider.of<UserAuthProvider>(context, listen: false).user.getEmail.toString(),
                              'password':Provider.of<UserAuthProvider>(context, listen: false).user.getPassword.toString(),
                            }
                                :
                            {
                              'userState':'R',
                              'role_id': '2',
                              'message_token':await FirebaseMessaging.instance.getToken(),
                              'email': Provider.of<UserAuthProvider>(context, listen: false).user.getEmail.toString(),
                              'password': Provider.of<UserAuthProvider>(context, listen: false).user.getPassword.toString(),
                              'first_name': Provider.of<UserAuthProvider>(context, listen: false).user.getFirstName.toString(),
                              'father_name': Provider.of<UserAuthProvider>(context, listen: false).user.getFatherName.toString(),
                              'family_name': Provider.of<UserAuthProvider>(context, listen: false).user.getFamilyName.toString(),
                              'country': Provider.of<UserAuthProvider>(context, listen: false).user.getCountry.toString(),
                              'date_of_birth': Provider.of<UserAuthProvider>(context, listen: false).user.getDate_of_birth.toString(),
                            };

                            if( val != PageState.login)  {
                              if (Provider.of<UserAuthProvider>(context, listen: false).user.getDate_of_birth == null ||
                                  Provider.of<UserAuthProvider>(context, listen: false).user .getDate_of_birth .toString() == intl.DateFormat('yyyy-MM-dd') .format(DateTime.now()) .toString()) {
                                showShortToast('رجاء ادخل تاريخ الميلاد', Colors.orange);
                              }
                              if (Provider.of<UserAuthProvider>(context, listen: false).user.getCountry == null) {
                                showShortToast('رجاء ادخل اسم الدولة', Colors.orange);
                              }
                            }
                            if (_formKey.currentState.validate()){
                              dynamic result= await Provider.of<UserAuthProvider>(context, listen: false) .login(userdata);

                              print("the result is $result");
                              if(result==true){
                                Navigator.pushReplacement(context,
                                    MaterialPageRoute(builder: (_) => HomePage()));
                              }else{

                              }
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
        );
  }
}
