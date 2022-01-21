 import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:systemevents/modules/login/validator.dart';
import 'package:systemevents/provider/auth_provider.dart';
class LoginForm extends StatefulWidget {
  @override
  _LoginFormState createState() => _LoginFormState();
}
class _LoginFormState extends State<LoginForm> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  bool _passwordVisible;
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
      TextFormField(
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
            border: OutlineInputBorder(),
            labelText: 'البريد الإلكتروني',
            hintText: 'ادخل البريد الإلكتروني'
        ),
      ),
      SizedBox(height: 12,),
      TextFormField(
        obscureText: !_passwordVisible,
        keyboardType: TextInputType.text,
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

        decoration: InputDecoration(
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
