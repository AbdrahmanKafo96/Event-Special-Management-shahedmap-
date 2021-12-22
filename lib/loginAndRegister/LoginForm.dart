 import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:systemevents/loginAndRegister/validator.dart';
import 'package:systemevents/provider/Auth.dart';
class LoginForm extends StatefulWidget {
  @override
  _LoginFormState createState() => _LoginFormState();
}
class _LoginFormState extends State<LoginForm> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Column(
    children: [
      TextFormField(
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
            border: OutlineInputBorder(),
            labelText: 'البريد الإلكتروني',
            hintText: 'ادخل البريد الإلكتروني'
        ),
      ),
      SizedBox(height: 12,),
      TextFormField(
        validator: (value){
          String result=ValidatorClass.isValidPassword(value);
         if(result == "" )
           return null ;
         else{
           return result;
         }
        },
        onChanged: (value){
          Provider.of<UserAuthProvider>(context,listen: false).user.setPassword=passwordController.text;
        },
        controller: passwordController,
        obscureText: true,
        decoration: InputDecoration(
            border: OutlineInputBorder(),
            labelText: 'كلمة المرور',
            hintText: 'ادخل كلمة المرور'
        ),
      ),
    ],
    );
  }
  @override
  void dispose() {
    // Clean up the controller when the widget is removed from the
    // widget tree.

    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }
}
