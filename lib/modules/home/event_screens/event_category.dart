import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shahed/models/category.dart';
import 'package:shahed/provider/event_provider.dart';
import 'package:shahed/shared_data/shareddata.dart';
import 'package:shahed/singleton/singleton.dart';
import 'package:shahed/widgets/checkInternet.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;

import '../../../theme/colors_app.dart';

class EventCategory extends StatefulWidget {
  @override
  _EventCategoryState createState() => _EventCategoryState();
}

class _EventCategoryState extends State<EventCategory> {
  List<CategoryClass> gategoryList = <CategoryClass>[];
  String dropdownValue1 = '0';
  String ?dropdownName1;
  Database? database;

  List<EventType> typesList = <EventType>[];
  List<EventType> subTypesList = <EventType>[];
  String? dropdownValue2, dropdownName2;

  @override
  void initState() {
    super.initState();
    openDB().then((db) {
      SharedClass.getBox().then((box) async {
        // SharedPreferences prefs= await Singleton.getPrefInstance();
        // final key = 'token';
        // final value = prefs.get(key ) ?? 0;

        checkInternetConnectivity(context).then((ste) async {
          if (ste == true) {
            getCategoryList(0);
            getTypeList(0);
            Map data = {
              'version_number': box.get('version_number').toString(),
            };

            final response = await http.post(
                Uri.parse("${SharedClass.apiPath}/isVersionUpdated"),
                body: data);
            if (response.statusCode == 200) {
              var res = jsonDecode(response.body);

              if (res['message'] == true) {
                int? type_count = Sqflite.firstIntValue(
                    await database!.rawQuery('SELECT COUNT(*) FROM event_type'));

                int? category_count = Sqflite.firstIntValue(await database
                    !.rawQuery('SELECT COUNT(*) FROM event_category'));

                if (type_count! > 0 && category_count! > 0) {
                  await database
                      !.rawDelete('DELETE FROM event_type')
                      .then((value) {});
                  await database
                      !.rawDelete('DELETE FROM event_category')
                      .then((value) {});
                }
                getCategoryList(1);
                getTypeList(1);
                box.put('version_number', int.parse(res['data']));
              }
            } else {
              // if api not connected ...
              fetchData();
            }
          } else {
            // get data from local storage ...

            fetchData();
          }
        }); // check internet
      }); // end shared pref
    }); // end openDB
  } // end ini

  @override
  void dispose() {
    super.dispose();

    database!.close().then((value) {});
  }

  void fetchData() async {
    database!.rawQuery('SELECT * FROM event_category').then((list) {
      setState(() {
        list.forEach((element) {
          gategoryList.add(CategoryClass(
              category_id: element['category_id'] as int ,
              category_name: element['category_name'] as String,
              emergency_phone: int.parse(element['emergency_phone']as String)));
        });
        gategoryList.insert(
            0,
            CategoryClass(
                category_id: 0,
                category_name: SharedData.getGlobalLang().chooseCategory(),
                emergency_phone: 0));
        dropdownValue1 = gategoryList.first.category_id.toString();
        dropdownName1 = gategoryList.first.category_name.toString();
      });
    });

    database!.rawQuery('SELECT * FROM event_type').then((type_list) {
      setState(() {
        type_list.forEach((element) {
          typesList.add(EventType(
              type_id: element['type_id'] as int,
              type_name: element['type_name'] as String,
              category_id: element['category_id'] as int));
        });
        subTypesList.insert(
            0,
            EventType(
                type_id: 0,
                type_name: SharedData.getGlobalLang().chooseType(),
                category_id: 0));
        dropdownValue2 = subTypesList.first.type_id.toString();
        dropdownName2 = subTypesList.first.type_name;
      });
    });
  }

  Future openDB() async {
    // open the database
    database = await openDatabase("event_system", version: 1,
        onCreate: (Database db, int version) {
      db.execute(
          'CREATE TABLE event_category (category_id INTEGER PRIMARY KEY, category_name TEXT,'
          'emergency_phone TEXT )');
      db.execute(
          'CREATE TABLE event_type (type_id INTEGER PRIMARY KEY, type_name TEXT,'
          'category_id INTEGER ,'
          'FOREIGN KEY(category_id) REFERENCES event_category(category_id))');
      print('onCreated');
    }, onOpen: (db) async {
      database = db;
      print('onOpen');
    });
  }

  void insertCategory(
      {int? category_id, String? category_name, int? emergency_phone}) {
    database!.transaction((txn) async{
      txn.rawInsert(
          'INSERT INTO event_category(category_id ,category_name, emergency_phone) VALUES(?,?,?)',
          [category_id, category_name, emergency_phone]).then((id2) {});
    });
  }

  void insertType({int? type_id, String? type_name, int? category_id}) {
    database!.transaction((txn) async{
      txn.rawInsert(
          'INSERT INTO event_type(type_id, type_name, category_id ) VALUES(?, ?, ?)',
          [type_id, type_name, category_id]).then((id2) {});
    });
  }

  void getTypeList(int state) {
    Provider.of<EventProvider>(context, listen: false)
        .fetchEventTypes()
        .then((value) {
      setState(() {
        value!.forEach((EventType? element) {
          if (state == 1) {
            insertType(
                type_name: element!.type_name,
                category_id: element!.category_id,
                type_id: element!.type_id);
          } else {
            typesList.add(EventType(
                type_id: element!.type_id,
                type_name: element!.type_name,
                category_id: element!.category_id));
          }
        });
        if (state == 0) {
          subTypesList.insert(
              0,
              EventType(
                  type_id: 0,
                  type_name: SharedData.getGlobalLang().chooseType(),
                  category_id: 0));
          dropdownValue2 = subTypesList.first.type_id.toString();
          dropdownName2 = subTypesList.first.type_name;
        }
      });
    });
  }

  void getCategoryList(int state) {
    Provider.of<EventProvider>(context, listen: false)
        .fetchEventCategories()
        .then((value) {
      setState(() {
        value!.forEach((CategoryClass? element) {
          if (state == 1) {
            insertCategory(
                category_name: element!.category_name,
                emergency_phone: element!.emergency_phone,
                category_id: element!.category_id);
          } else {
            gategoryList.add(CategoryClass(
                category_id: element!.category_id,
                category_name: element!.category_name,
                emergency_phone: element!.emergency_phone));
          }
        });

        if (state == 0) {
          gategoryList.insert(
              0,
              CategoryClass(
                  category_id: 0,
                  category_name: SharedData.getGlobalLang().chooseCategory()));
          dropdownValue1 = gategoryList.first.category_id.toString();
          dropdownName1 = gategoryList.first.category_name.toString();
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Color(SharedColor.greyIntColor),
        borderRadius: BorderRadius.circular(24),
      ),
      padding: EdgeInsets.only(top: 10, bottom: 10, left: 2, right: 2),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
                padding: EdgeInsets.only(left: 10, right: 10),
                decoration: BoxDecoration(
                  color: Color(SharedColor.greyIntColor),
                  border: Border.all(color: SharedColor.orange, width: 1),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    hint: Text(SharedData.getGlobalLang().chooseCategory(),
                        style: Theme.of(context).textTheme.bodyText1),
                    iconEnabledColor: SharedColor.white,
                    borderRadius: BorderRadius.circular(15),
                    dropdownColor: SharedColor.black.withOpacity(0.9),
                    icon: Icon(Icons.arrow_drop_down),
                    iconSize: 24,
                    isExpanded: true,
                    // style: TextStyle(
                    //     color: SharedColor.black,
                    //     fontSize: 16
                    // ),
                    value: dropdownValue1,

                    onChanged: (String? value) {
                      setState(() {
                        Provider.of<EventProvider>(context, listen: false).event.categoryClass.category_name =
                            gategoryList
                                .where((el) {
                                  return el.category_id.toString() == value;
                                })
                                .toList()[0]
                                .category_name;

                        Provider.of<EventProvider>(context, listen: false).event.categoryClass.emergency_phone =
                            gategoryList
                                .where((el) {
                                  return el.category_id.toString() == value;
                                })
                                .toList()[0]
                                .emergency_phone;

                        dropdownValue1 = value!;

                        Provider.of<EventProvider>(context, listen: false)
                            .event
                            .categoryClass
                            .category_id = int.parse(dropdownValue1.toString());

                        subTypesList.clear();
                        subTypesList.insert(
                            0,
                            EventType(
                                type_id: 0,
                                type_name:
                                    SharedData.getGlobalLang().chooseType(),
                                category_id: 0));
                        dropdownValue2 = subTypesList.first.type_id.toString();
                        dropdownName2 = subTypesList.first.type_name;

                        subTypesList.addAll(typesList
                            .where((element) =>
                                element.category_id ==
                                int.parse(dropdownValue1.toString()))
                            .toList());
                      });
                    },
                    items: gategoryList.map((CategoryClass data) {
                      return DropdownMenuItem<String>(
                        value: data.category_id.toString(),
                        child: Container(
                          alignment:
                              SharedData.getGlobalLang().getLanguage == "AR"
                                  ? Alignment.centerRight
                                  : Alignment.centerLeft,
                          child: Text(data.category_name!,
                              style: Theme.of(context).textTheme.bodyText1),
                        ),
                      );
                    }).toList(),

                    menuMaxHeight: MediaQuery.of(context).size.height / 2,
                  ),
                )),
          ),
          SizedBox(
            height: 12,
          ),
          int.parse(dropdownValue1) > 0
              ? Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                      padding: EdgeInsets.only(left: 10, right: 10),
                      decoration: BoxDecoration(
                        color: Color(SharedColor.greyIntColor),
                        border: Border.all(color: SharedColor.orange, width: 1),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          hint: Text(SharedData.getGlobalLang().chooseType(),
                              style: Theme.of(context).textTheme.bodyText1),
                          dropdownColor: SharedColor.black.withOpacity(0.9),
                          iconEnabledColor: SharedColor.white,
                          borderRadius: BorderRadius.circular(15),
                          icon: Icon(Icons.arrow_drop_down),
                          iconSize: 24,
                          isExpanded: true,
                          style: TextStyle(color: SharedColor.green, fontSize: 19),
                          value: dropdownValue2,
                          onChanged: (String? value) {
                            setState(() {
                              dropdownValue2 = value;

                              Provider.of<EventProvider>(context, listen: false).event.eventType.type_name =
                                  subTypesList
                                      .where((el) {
                                        return el.type_id.toString() == value;
                                      })
                                      .toList()[0]
                                      .type_name;

                              Provider.of<EventProvider>(context, listen: false)
                                      .event
                                      .eventType
                                      .type_id =
                                  int.parse(dropdownValue2.toString());
                            });
                          },
                          items: subTypesList.map((EventType data) {
                            return DropdownMenuItem<String>(
                              value: data.type_id.toString(),
                              child: Container(
                                alignment:
                                    SharedData.getGlobalLang().getLanguage ==
                                            "AR"
                                        ? Alignment.centerRight
                                        : Alignment.centerLeft,
                                child: Text(data.type_name!,
                                    style:
                                        Theme.of(context).textTheme.bodyText1),
                              ),
                            );
                          }).toList(),
                          menuMaxHeight: MediaQuery.of(context).size.height / 2,
                        ),
                      )),
                )
              : SizedBox.shrink()
        ],
      ),
    );
  }
}
