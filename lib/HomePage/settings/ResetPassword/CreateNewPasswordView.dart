import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:systemevents/CustomWidget/customToast.dart';
import 'package:systemevents/provider/Auth.dart';
import 'package:systemevents/singleton/singleton.dart';

class CreateNewPasswordView extends StatefulWidget {
  @override
  State<CreateNewPasswordView> createState() => _CreateNewPasswordViewState();
}

class _CreateNewPasswordViewState extends State<CreateNewPasswordView> {
  final passwordController = TextEditingController();
  final confPasswordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'رجوع',
            style: TextStyle(color: Colors.white),
          ),
          //leadingWidth: 30,
          leading: IconButton(
            icon: Icon(Icons.arrow_back ,color: Colors.white,),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: ListView(
            children: [
              SizedBox(
                height: 16,
              ),
              Text(
                'إنشاء كلمة مرور',
                style: Theme.of(context).textTheme.headline4,
              ),
              SizedBox(
                height: 16,
              ),
              Text(
                'يجب أن تكون كلمة مرورك الجديدة مختلفة عن كلمات المرور السابقة المستخدمة.',
                style: Theme.of(context).textTheme.subtitle1,
              ),
              SizedBox(
                height: 16,
              ),
              Text(
                'كلمة مرور',
                style: Theme.of(context).textTheme.subtitle1,
              ),
              SizedBox(
                height: 4,
              ),
              Container(
                height: 70,
                child: TextFormField(
                  controller: passwordController,
                  style: TextStyle(color: Colors.black),
                  obscureText: true,
                  decoration: InputDecoration(
                  // helperText: 'Must be at least 8 characters.',
                    helperStyle: TextStyle(fontSize: 14),
                    suffixIcon: IconButton(
                      icon: Icon(Icons.visibility_off),
                      onPressed: () {
                        //change icon
                      },
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 16,
              ),
              Text(
                'إعادة ادخال كلمة المرور',
                style: Theme.of(context).textTheme.subtitle1,
              ),
              SizedBox(
                height: 4,
              ),
              Container(
                height: 70,
                child: TextFormField(
                  controller: confPasswordController,
                  style: TextStyle(color: Colors.black),
                  obscureText: true,
                  decoration: InputDecoration(
                   // helperText: 'Both passwords must match.',
                    helperStyle: TextStyle(fontSize: 14),
                    suffixIcon: IconButton(
                      icon: Icon(Icons.visibility_off),
                      onPressed: () {
                        //change icon
                      },
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 16,
              ),
              ElevatedButton(
                onPressed: () async {
                  var prefs= await Singleton.getPrefInstace();
                  String email=prefs.getString('email');
                  int user_id=prefs.getInt('user_id');

               var result=  await Provider.of<UserAuthProvider>(context,listen: false).
                  resetPassword(passwordController.text.toString(),confPasswordController.text.toString()
                  ,user_id.toString(),email,context
                  );
                  if(result ==true){
                  Navigator.of(context).pop();
                  showShortToast(
                      'تم تغيير كلمة المرور بنجاح', Colors.green);

                  } else {
                  showShortToast(
                  'حاول تغيير كلمة المرور مرة اخرى', Colors.red);
                  }
                },
                child: Text(
                  'إعادة ضبط كلمة المرور',
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
