import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:provider/provider.dart';
import 'package:shahed/provider/language.dart';
import 'package:shahed/provider/style_data.dart';
import 'package:shahed/shared_data/shareddata.dart';
import 'package:shahed/singleton/singleton.dart';
import 'package:shahed/widgets/custom_app_bar.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shahed/widgets/custom_drawer.dart';

import '../../../main.dart';
import '../../../widgets/customDirectionality.dart';

class AppSettings extends StatefulWidget {
  @override
  State<AppSettings> createState() => _AppSettingsState();
}

class _AppSettingsState extends State<AppSettings> {
  List<String> _languages = ['AR', "EN"];
  String _selectedLanguage;
  bool _darkMode = false;
  Box _box;
  Language _language=SharedClass.getLanguage();
  DarkThemePreference darkThemePreference =   DarkThemePreference();
  var themeChange ;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    SharedClass.getBox().then((value) async {
      setState(() {
        _box=value;
        _language.getLanguage;
        _darkMode=value.get(darkThemePreference.THEME_STATUS);
       // _darkMode=darkMode;
      });
    });
  }

  @override
  Widget build(BuildContext context) {

    themeChange= Provider.of<DarkThemeProvider>(context);

    return   Scaffold(
        drawer: CustomDrawer(),
        //backgroundColor: _darkMode?Colors.black:Colors.white,
        appBar:customAppBar(context,title:_language.settingsHeading()  ,icon: FontAwesomeIcons.gear),
        body: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.all(5),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[

                Card(
                  color: Color(0xFF424250),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    children: [
                      ListTile(
                        title: Text(_language.changeLanguage() , style: Theme.of(context).textTheme.headline4,),
                        leading: Icon(
                          FontAwesomeIcons.language,
                          color: Colors.green,
                        ),
                        trailing: DropdownButton(
                          dropdownColor: Colors.deepOrange,
                          hint: Text(_language.languages() , style: Theme.of(context).textTheme.bodyText1,),
                          value: _selectedLanguage,
                          onChanged: (newVal)  {
                            _box.put("language", newVal);

                          //  _language.setLanguage=newVal;
                            setState(() {
                              language=newVal;
                              SharedData.getGlobalLang().setLanguage=newVal  ;
                              _selectedLanguage = newVal;
                            });
                            ShahedApp.restartApp(context);
                          },
                          items: _languages.map((lang) {
                            return DropdownMenuItem(
                              child: Text(lang),
                              value: lang,
                            );
                          }).toList(),
                        ),
                      ),
                      ListTile(
                        title: Text(_language.darkMode() , style: Theme.of(context).textTheme.headline4,),
                        leading: Icon(
                          FontAwesomeIcons.brush,
                          color: Colors.black,
                        ),
                        trailing: Switch(
                          activeColor: Colors.deepOrange,
                          value: _darkMode,
                          onChanged: (val){
                          //_pref.setBool('darkMode', val);

                            setState(() {
                              themeChange.darkTheme = val;
                              _darkMode=val;
                            });
                          },
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
    );
  }
}

