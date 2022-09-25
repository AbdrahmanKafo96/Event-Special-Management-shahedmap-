import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shahed/modules/authentications/validator.dart';
import 'package:shahed/provider/auth_provider.dart';
import 'package:shahed/widgets/custom_Text_Field.dart';

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
        customTextFormField(context,
            keyboardType: TextInputType.emailAddress,

            editingController: emailController, onChanged: (value) {
          Provider.of<UserAuthProvider>(context, listen: false).user.setEmail =
              emailController.text;
        }, validator: (value) {
          if (value == null || value.isEmpty) {
            return 'البريد الالكتروني مطلوب';
          } else if (!ValidatorClass.isValidEmail(value)) {
            return 'البريد الالكتروني غير صالح تحقق من المدخلات';
          } else
            return null;
        },
            prefixIcon: Icon(Icons.alternate_email_outlined),
            labelText: 'البريد الإلكتروني',
            hintText: 'ادخل البريد الإلكتروني'),
        SizedBox(
          height: 12,
        ),
        customTextFormField(context,
            obsecure: !_passwordVisible,
            keyboardType: TextInputType.text,
            validator: (value) {
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
            prefixIcon: Icon(Icons.password),
            suffixIcon: IconButton(
              icon: Icon(
                // Based on passwordVisible state choose the icon
                _passwordVisible ? Icons.visibility : Icons.visibility_off,
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
