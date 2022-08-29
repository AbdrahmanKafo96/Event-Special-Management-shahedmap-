import 'package:flutter/material.dart';
import 'package:systemevents/widgets/customCard.dart';
import 'package:systemevents/singleton/singleton.dart';
class Settings extends StatefulWidget {
  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  bool state=false;
  @override
  void initState() {
    super.initState();
    Singleton.getPrefInstance().then((value){
      if(value.getInt('role_id')==4){
        setState(() {
          state=true;
        });
      }
    });
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Container(

        padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 2.0),
        child: GridView.count(
          crossAxisCount: 2,
          padding: EdgeInsets.all(3.0),
          children: <Widget>[
            if(state==false)dashboardItem(context,"الصفحة الشخصية", Icons.account_circle,'ProfilePage' ),
            if(state==false)dashboardItem(context,"تعيين كلمة المرور", Icons.lock_clock,'ResetPage'),
             dashboardItem(context,"الاعدادت", Icons.settings,'ThemeApp'),
             dashboardItem(context,"حول التطبيق", Icons.info,'About'),
          ],
        ),
      ),
    );
  }

  viewPage(   BuildContext ctx ,String view){
    return Navigator.of(ctx).pushNamed( view ,arguments: (route) => false,);
  }

  Widget  dashboardItem( BuildContext ctx,String title, IconData icon ,String routName) {
    return InkWell(
          //highlightColor: Colors.blueGrey,
          //hoverColor: Colors.black,
          onTap: () {
            viewPage(ctx ,routName);
          },
      child:customCard(icon , title),
    );
  }
}
