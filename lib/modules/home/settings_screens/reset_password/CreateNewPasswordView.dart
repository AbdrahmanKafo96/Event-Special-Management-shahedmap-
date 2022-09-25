import 'package:flutter/material.dart';
import 'package:hovering/hovering.dart';
import 'package:provider/provider.dart';
import 'package:shahed/widgets/checkInternet.dart';
import 'package:shahed/widgets/custom_Text_Field.dart';
import 'package:shahed/widgets/custom_app_bar.dart';
import 'package:shahed/widgets/custom_toast.dart';
import 'package:shahed/modules/authentications/validator.dart';
import 'package:shahed/provider/auth_provider.dart';
import 'package:shahed/singleton/singleton.dart';
import 'package:shahed/widgets/custom_drawer.dart';

class CreateNewPasswordView extends StatefulWidget {
  @override
  State<CreateNewPasswordView> createState() => _CreateNewPasswordViewState();
}

class _CreateNewPasswordViewState extends State<CreateNewPasswordView> {
  final passwordController = TextEditingController();
  final confPasswordController = TextEditingController();
  bool _passwordVisible, _confPasswordVisible;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _passwordVisible = false;
    _confPasswordVisible = false;
  }

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        child: Scaffold(
          drawer: CustomDrawer(),
          appBar: customAppBar(context,
              title: 'تعيين كلمة المرور', icon: Icons.lock_reset),
          body: Container(
            height: double.maxFinite,
            decoration: BoxDecoration(
                color: Color(0xff424250),
                borderRadius: BorderRadius.all(
                  Radius.circular(24),
                )),
            margin: EdgeInsets.all(10),
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 16,
                  ),
                  Text(
                    'إنشاء كلمة مرور',
                    style: Theme.of(context).textTheme.headline3,
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  Text(
                    'يجب أن تكون كلمة المرور الجديدة مختلفة عن كلمة المرور السابقة المستخدمة.',
                    style: Theme.of(context).textTheme.subtitle2,
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  Text(
                    'كلمة مرور',
                    style: Theme.of(context).textTheme.bodyText1,
                  ),
                  SizedBox(
                    height: 4,
                  ),
                  customTextFormField(context,
                      obsecure: !_passwordVisible,
                      keyboardType: TextInputType.text, validator: (value) {
                    String result = ValidatorClass.isValidPassword(value);
                    if (result == "")
                      return null;
                    else {
                      return result;
                    }
                  }, onChanged: (value) {
                    Provider.of<UserAuthProvider>(context, listen: false)
                        .user
                        .setPassword = passwordController.text;
                  },
                      editingController: passwordController,
                      helperStyle: TextStyle(fontSize: 14),
                      suffixIcon: IconButton(
                        icon: Icon(
                          // Based on passwordVisible state choose the icon
                          _passwordVisible
                              ? Icons.visibility
                              : Icons.visibility_off,
                          color: Colors.grey,
                        ),
                        onPressed: () {
                          // Update the state i.e. toogle the state of passwordVisible variable
                          setState(() {
                            _passwordVisible = !_passwordVisible;
                          });
                        },
                      ),
                      labelText: 'كلمة المرور',
                      hintText: 'ادخل كلمة المرور'),
                  SizedBox(
                    height: 16,
                  ),
                  Text(
                    'إعادة ادخال كلمة المرور',
                    style: Theme.of(context).textTheme.bodyText1,
                  ),
                  SizedBox(
                    height: 4,
                  ),
                  customTextFormField(
                    // autocorrect: true,
                    context,
                    validator: (value) {
                      // print(Provider.of<UserAuth>(context,listen: false).getPassword.toString() );
                      if (value.isEmpty || value == null)
                        return "هذا الحقل مطلوب";

                      if (Provider.of<UserAuthProvider>(context, listen: false)
                              .user
                              .getPassword ==
                          null) {
                        return "يجب ان تدخل كلمة المرور قبل التأكيد";
                      } else if (Provider.of<UserAuthProvider>(context,
                                  listen: false)
                              .user
                              .getPassword
                              .toString() ==
                          confPasswordController.text.toString()) {
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
                    obsecure: !_confPasswordVisible,
                    editingController: confPasswordController,

                    helperStyle: TextStyle(fontSize: 14),

                    labelText: 'إعادة إدخال كلمة المرور',
                    //  hintText: 'اعد إدخال كلمة المرور',

                    suffixIcon: IconButton(
                      icon: Icon(
                        // Based on passwordVisible state choose the icon
                        _confPasswordVisible
                            ? Icons.visibility
                            : Icons.visibility_off,
                        color: Colors.grey,
                      ),
                      onPressed: () {
                        // Update the state i.e. toogle the state of passwordVisible variable
                        setState(() {
                          _confPasswordVisible = !_confPasswordVisible;
                        });
                      },
                    ),
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Container(
                      height: 50,
                      width: MediaQuery.of(context).size.width * 0.75,
                      decoration:
                          BoxDecoration(borderRadius: BorderRadius.circular(20)),
                      child: HoverButton(
                        splashColor: Color(0xFFFF8F00),
                        hoverTextColor: Color(0xFFFF8F00),
                        highlightColor: Color(0xFFFF8F00),
                        color: Color(0xFFfe6e00),
                        onpressed: () async {
                          checkInternetConnectivity(context)
                              .then((bool value) async {
                            if (value) {
                              if (_formKey.currentState.validate()) {
                                var prefs = await Singleton.getBox();
                                String email = prefs.get('email');
                                int user_id = prefs.get('user_id');

                                var result = await Provider.of<UserAuthProvider>(
                                        context,
                                        listen: false)
                                    .resetPassword(
                                        passwordController.text.toString(),
                                        confPasswordController.text.toString(),
                                        user_id.toString(),
                                        email,
                                        context);
                                if (result == true) {
                                  // Navigator.of(context).pop();
                                  showShortToast(
                                      'تم تغيير كلمة المرور بنجاح', Colors.green);
                                } else {
                                  showShortToast(
                                      'حاول تغيير كلمة المرور مرة اخرى',
                                      Colors.red);
                                }
                              }
                            }
                          });
                        },
                        child: Text(
                          'إعادة ضبط كلمة المرور',
                          style: Theme.of(context).textTheme.headline4,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ));
  }
}
