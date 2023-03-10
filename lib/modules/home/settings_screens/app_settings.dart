import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:location/location.dart';
import 'package:provider/provider.dart';
import 'package:shahed/provider/language.dart';
import 'package:shahed/provider/style_data.dart';
import 'package:shahed/shared_data/shareddata.dart';
import 'package:shahed/singleton/singleton.dart';
import 'package:shahed/widgets/custom_app_bar.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shahed/widgets/custom_drawer.dart';
import 'package:workmanager/workmanager.dart';
import '../../../main.dart';
import '../../../theme/colors_app.dart';
//import 'package:geolocator/geolocator.dart';

class AppSettings extends StatefulWidget {
  @override
  State<AppSettings> createState() => _AppSettingsState();
}

class _AppSettingsState extends State<AppSettings> {
  List<String> _languages = ['AR', "EN"];
  String _selectedLanguage='AR';
  Location location = new Location();
  bool _darkMode = false ,_locationState=false;
  Box? _box;
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
        _locationState=value.get('fetch')??false;
        _language.getLanguage;
        _darkMode=value.get(darkThemePreference.THEME_STATUS);
        _selectedLanguage=_box!.get('language');
       // _darkMode=darkMode;
      });
    });
  }

  @override
  Widget build(BuildContext context) {

    themeChange= Provider.of<DarkThemeProvider>(context);

    return   Scaffold(
        drawer: CustomDrawer(),
        //backgroundColor: _darkMode?SharedColor.black:SharedColor.white,
        appBar:customAppBar(context,title:_language.settingsHeading()  ,icon: FontAwesomeIcons.gear),
        body: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.all(5),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[

                Card(
                  color: Color(SharedColor.greyIntColor),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    children: [
                      ListTile(
                        title: Text(_language.changeLanguage() , style: Theme.of(context).textTheme.headline4,),
                        leading: Icon(
                          FontAwesomeIcons.language,
                          color: SharedColor.green,
                        ),
                        trailing: DropdownButton(
                          dropdownColor: SharedColor.black.withOpacity(0.9),
                          hint: Text(_language.languages() , style: Theme.of(context).textTheme.bodyText1,),
                          value: _selectedLanguage,
                          onChanged: (newVal)  {
                            _box!.put("language", newVal);

                          //  _language.setLanguage=newVal;
                            setState(() {
                              language=newVal!;
                              SharedData.getGlobalLang().setLanguage=newVal  ;
                              _selectedLanguage = newVal;
                            });
                            ShahedApp.restartApp(context);
                          },
                          items: _languages.map((lang) {
                            return DropdownMenuItem(
                              child: Text(lang, style:Theme.of(context).textTheme.bodyText1,),
                              value: lang,
                            );
                          }).toList(),
                        ),
                      ),
                      ListTile(
                        title: Text(_language.darkMode() , style: Theme.of(context).textTheme.headline4,),
                        leading: Icon(
                          FontAwesomeIcons.brush,
                          color: SharedColor.white,
                        ),
                        trailing: Switch(
                          activeColor: SharedColor.blue,
                          value: _darkMode,
                          onChanged: (val){
                          //_pref.setBool('darkMode', val);

                            setState(() {
                              themeChange.darkTheme = val;
                              _darkMode=val;
                            });
                          },
                        ),
                      ),SharedData.getUserState() == true
                          ?ListTile(
                        title: Text(_language.fetchCurrentLocation() , style: Theme.of(context).textTheme.headline4,),
                        leading: Icon(
                          FontAwesomeIcons.locationDot,
                          color: SharedColor.redAccent,
                        ),
                        subtitle: Text(_language.fetchLocationEveryQuarter() ,style: Theme.of(context).textTheme.subtitle1,),
                        trailing: Switch(
                          activeColor: SharedColor.deepOrange,
                          value: _locationState,
                          onChanged: (val)  async {

                            bool _serviceEnabled;
                          PermissionStatus _permissionGranted;
                          LocationData _locationData;
                            _serviceEnabled = await location.serviceEnabled();
                            if (!_serviceEnabled) {
                              _serviceEnabled = await location.requestService();
                              if (!_serviceEnabled) {
                                return;
                              }
                            }

                            _permissionGranted = await location.hasPermission();
                            if (_permissionGranted == PermissionStatus.denied) {
                              _permissionGranted = await location.requestPermission();
                              if (_permissionGranted != PermissionStatus.granted) {
                                return;
                              }
                            }
                            setState(() {
                              _locationState=val;
                             if(_locationState==true){
                               if (SharedData.getUserState() ) {


                                       Workmanager().initialize(
                                         callbackDispatcher,
                                         isInDebugMode: false,
                                       );
                                       Workmanager().registerPeriodicTask("fetchBackground", "fetchBackground",
                                           frequency: Duration(minutes: 15),
                                          tag: 'fetchLocation',
                                           constraints: Constraints(
                                             networkType: NetworkType.connected,
                                             requiresBatteryNotLow: false,
                                           ));

                               }
                             }else{
                               Workmanager().cancelByTag('fetchLocation');
                              }
                             _box!.put('fetch', _locationState);
                            });
                          },
                        ),
                      ) : SizedBox.shrink(),
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

