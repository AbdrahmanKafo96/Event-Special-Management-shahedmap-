import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:provider/provider.dart';
import 'package:systemevents/provider/language.dart';
import 'package:systemevents/provider/style_data.dart';
import 'package:systemevents/singleton/singleton.dart';
import 'package:systemevents/widgets/change_theme_button_widget.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:systemevents/widgets/custom_drawer.dart';
 

class AppSettings extends StatefulWidget {
  @override
  State<AppSettings> createState() => _AppSettingsState();
}

class _AppSettingsState extends State<AppSettings> {
  List<String> _languages = ['AR', "EN"];
  String _selectedLanguage;
  bool _darkMode = false;
  Box _box;
  Language _language=Singleton.getLanguage();
  DarkThemePreference darkThemePreference =   DarkThemePreference();
  var themeChange;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    Singleton.getBox().then((value) async {
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
    return Scaffold(
      drawer: CustomDrawer(),
      //backgroundColor: _darkMode?Colors.black:Colors.white,
      appBar: AppBar( flexibleSpace: Container(
        decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color(0xFF00695C) ,
                Color(0xFF4DB6AC),
              ],
            )),
      ),),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Card(
                margin: const EdgeInsets.all(0),
                color: Colors.green,
                child: ListTile(
                  leading: Icon(
                    Icons.settings,
                    color: Colors.white,
                    size: 33,
                  ),
                  title: Text(
                    _language.hSettings(),
                    style: Theme.of(context)
                        .textTheme
                        .headline4
                        .copyWith(color: Colors.white),
                  ),
                ),
              ),
            ),
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                children: [
                  ListTile(
                    title: Text("تبديل اللغة"),
                    leading: Icon(
                      FontAwesomeIcons.language,
                      color: Colors.green,
                    ),
                    trailing: DropdownButton(
                      hint: Text("اللغة"),
                      value: _selectedLanguage,
                      onChanged: (newVal) {
                        _box.put("language", newVal);
                        _language.setLanguage=newVal;
                        setState(() {
                          _selectedLanguage = newVal;
                        });
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
                    title: Text("الوضع المظلم"),
                    leading: Icon(
                      FontAwesomeIcons.brush,
                      color: Colors.black,
                    ),
                    trailing: Switch(
                      activeColor: Colors.teal,
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
    );
  }
}

