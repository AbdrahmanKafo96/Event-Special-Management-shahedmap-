import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:systemevents/widgets/customToast.dart';
import 'package:systemevents/modules/login/validator.dart';
import 'package:systemevents/provider/auth_provider.dart';
import 'package:systemevents/singleton/singleton.dart';

class CreateNewPasswordView extends StatefulWidget {
  @override
  State<CreateNewPasswordView> createState() => _CreateNewPasswordViewState();
}

class _CreateNewPasswordViewState extends State<CreateNewPasswordView> {
  final passwordController = TextEditingController();
  final confPasswordController = TextEditingController();
  bool _passwordVisible , _confPasswordVisible;
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
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
          appBar: AppBar(
            centerTitle: true,
            title: Text(
              'تعيين كلمة المرور',
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
            child: Form(
              key: _formKey,

              child: ListView(
                shrinkWrap: true,
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
                  'يجب أن تكون كلمة المرور الجديدة مختلفة عن كلمة المرور السابقة المستخدمة.',
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
                TextFormField(
                 // autofocus: true,
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
                      border: OutlineInputBorder(),
                      labelText: 'كلمة المرور',
                      hintText: 'ادخل كلمة المرور'
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
                TextFormField(
                  autocorrect: true,

                  validator: (value){
                    // print(Provider.of<UserAuth>(context,listen: false).getPassword.toString() );
                    if(value.isEmpty || value==null)
                      return "هذا الحقل مطلوب";

                    if( Provider.of<UserAuthProvider>(context,listen: false).user.getPassword==null){
                      return "يجب ان تدخل كلمة المرور قبل التأكيد";
                    }
                    else if(Provider.of<UserAuthProvider>(context,listen: false).user.getPassword.toString()==
                        confPasswordController.text.toString()
                    ){
                      return null;
                    }else{
                      return "لا تتطابق كلمتا المرور اللتان تم إدخالهما. يُرجى إعادة المحاولة.";
                    }

                  },
                  onChanged: (value){
                    Provider.of<UserAuthProvider>(context,listen: false).user.setConfPassword=value;
                  },
                  obscureText: !_confPasswordVisible,
                  controller:confPasswordController,
                  decoration: InputDecoration(
                    helperStyle: TextStyle(fontSize: 14),
                    border: OutlineInputBorder(),
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

                ),
                SizedBox(
                  height: 16,
                ),
                ElevatedButton(
                  onPressed: () async {
                   if(_formKey.currentState.validate()){
                     var prefs= await Singleton.getPrefInstance();
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
      ),
    ));
  }
}
