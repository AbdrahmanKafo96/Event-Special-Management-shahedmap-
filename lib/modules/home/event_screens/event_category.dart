import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:systemevents/models/Category.dart';
import 'package:systemevents/provider/event_provider.dart';
import 'package:systemevents/singleton/singleton.dart';
import 'package:systemevents/widgets/checkInternet.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:convert'  as convert;
import 'package:http/http.dart' as http;

class EventCategory extends StatefulWidget {
  @override
  _EventCategoryState createState() => _EventCategoryState();
}

class _EventCategoryState extends State<EventCategory> {
   List<CategoryClass>  gategoryList = List<CategoryClass>();
   String dropdownValue1 ,dropdownName1;
   Database database ;
   List<EventType>  typesList = List<EventType>(); 
  List<EventType>  subTypesList = List<EventType>();
   String dropdownValue2 ,dropdownName2;
  @override
  void initState() {
    super.initState();
    openDB().then((db) {
      Singleton.getPrefInstance().then((pref) async{


        checkInternetConnectivity(context).then((ste) async{
          if(ste==true){
            getCategoryList(0);
            getTypeList(0);
            Map data={
              'version_number':  pref.getInt('version_number').toString(),
            };
            final response =  await http.post(
                Uri.parse("${Singleton.apiPath}/isVersionUpdated") ,body: data );
            if(response.statusCode==200){
              var res=jsonDecode(response.body);
              print(res['message']);
              if(res['message']==true){

                  int  type_count = Sqflite
                      .firstIntValue(await database.rawQuery('SELECT COUNT(*) FROM event_type'));
                  print('deleted');
                  int  category_count = Sqflite
                      .firstIntValue(await database.rawQuery('SELECT COUNT(*) FROM event_category'));

                  if(type_count >0 && category_count>0)
                  {
                    await database.rawDelete('DELETE FROM event_type' ).then((value) {

                    });
                    await database.rawDelete('DELETE FROM event_category' ).then((value) {
                    });
                  }
                  getCategoryList(1);
                  getTypeList(1);
                  pref.setInt('version_number', int.parse(res['data']));

              }
            }
            else{
              // if api not connected ...
              fetchData();
            }

          }else {
            // get data from local storage ...

            fetchData();
          }
        });// check internet
      });// end shared pref
    }); // end openDB
  }// end ini
@override
  void dispose() {
     super.dispose();

       database.close().then((value) {

       });
  }
 void  fetchData()async{
    database.rawQuery('SELECT * FROM event_category').then((list) {
      setState(() {
        list.forEach((element) {

          gategoryList.add(new CategoryClass(category_id:element['category_id'],
              category_name: element['category_name'],emergency_phone: int.parse(element['emergency_phone'])));
        });
        gategoryList.insert(0, CategoryClass(category_id: 0 ,category_name:'اختار الصنف',emergency_phone:0)) ;
        dropdownValue1=gategoryList.first.category_id.toString();
        dropdownName1=gategoryList.first.category_name.toString();
      });

    });


    database.rawQuery('SELECT * FROM event_type').then((type_list) {
      setState(() {
        type_list.forEach((element) {
          typesList.add(
              EventType(
                  type_id: element['type_id'],
                  type_name: element['type_name'],
                  category_id: element['category_id'] ));
        });
        subTypesList.insert(0, EventType(type_id: 0 ,type_name:'اختار النوع' ,category_id: 0 )) ;
        dropdownValue2=subTypesList.first.type_id.toString();
        dropdownName2=subTypesList.first.type_name ;
      });
    });
  }
  Future openDB()  async{
    // open the database
     database= await openDatabase("event_system", version: 1,
        onCreate: (Database db, int version)   {
            db.execute(
              'CREATE TABLE event_category (category_id INTEGER PRIMARY KEY, category_name TEXT,'
                  'emergency_number TEXT )');
            db.execute(
              'CREATE TABLE event_type (type_id INTEGER PRIMARY KEY, type_name TEXT,'
                  'category_id INTEGER ,'
                  'FOREIGN KEY(category_id) REFERENCES event_category(category_id))');
          print('onCreated');
        },onOpen: (db) async{
            database=db;
           print('onOpen');

         }
        );
  }
  void insertCategory({int category_id,String category_name, int emergency_number  })  {
      database.transaction((txn) {
         txn.rawInsert(
          'INSERT INTO event_category(category_id ,category_name, emergency_number) VALUES(?,?,?)',
          [category_id ,category_name,emergency_number ]).then((id2) {
        print('inserted2: $id2');
      });
        return null;
    });
  } void insertType({  int type_id ,String type_name ,int category_id})  {
       database.transaction((txn) {
        txn.rawInsert(
           'INSERT INTO event_type(type_id, type_name, category_id ) VALUES(?, ?, ?)',
           [type_id ,type_name, category_id ]).then((id2) {
          print('inserted2: $id2');
        });

       return null;
     });
   }
  void  getTypeList(int state ){

     Provider.of<EventProvider>
       (context, listen: false).fetchEventTypes().
     then((value){
       setState(() {
         value.forEach((EventType element) {
             if(state==1){
               insertType(type_name:  element.type_name,
                   category_id:  element.category_id,type_id:element.type_id );
             }else{

               typesList.add(
                   EventType(
                       type_id: element.type_id,
                       type_name: element.type_name,
                       category_id: element.category_id
                   ));
             }

         });
         if(state==0){
            subTypesList.insert(0, EventType(type_id: 0 ,type_name:'اختار النوع' ,category_id: 0 )) ;
            dropdownValue2=subTypesList.first.type_id.toString();
            dropdownName2=subTypesList.first.type_name ;
          }
       });
     }) ;
   }
  void  getCategoryList(int state){

    Provider.of<EventProvider>
      (context, listen: false).fetchEventCategories().
    then((value){
      setState(() {
        value.forEach((CategoryClass element) {

          if(state==1) {
            insertCategory(category_name: element.category_name,
                emergency_number: element.emergency_phone ,
                category_id: element.category_id);
          }else{
            gategoryList.add(new CategoryClass(category_id: element.category_id,
                category_name: element.category_name ,emergency_phone: element.emergency_phone));
          }
        });

        if(state==0) {
          gategoryList.insert(0, CategoryClass(category_id: 0 ,category_name:'اختار الصنف')) ;
          dropdownValue1=gategoryList.first.category_id.toString();
          dropdownName1=gategoryList.first.category_name.toString();
        }

      });
    }) ;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 8.0 , right: 8),
      child: Row(

        children: [
          Expanded(
            flex: 1,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                padding: EdgeInsets.only(left: 8,right: 8),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey,width: 1),
                  borderRadius: BorderRadius.circular(15),
                ),
                child:DropdownButton<String>(
                  //  hint: Text(dropdownName),

                  dropdownColor: Colors.white,
                  icon: Icon(Icons.arrow_drop_down),
                  iconSize: 36,
                  isExpanded: true,
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 22
                  ),
                  value: dropdownValue1,

                  onChanged: (String value){
                    setState(() {
                      Provider.of<EventProvider>(context, listen: false)
                          .event.categoryClass.category_name =
                          gategoryList.where((el) {
                            return el.category_id.toString()==value;
                          }).toList()[0].category_name ;

                      Provider.of<EventProvider>(context, listen: false)
                          .event.categoryClass.emergency_phone =
                          gategoryList.where((el) {
                            return el.category_id.toString()==value;
                          }).toList()[0].emergency_phone ;

                      dropdownValue1=value ;

                       Provider.of<EventProvider>
                        (context, listen: false).event.categoryClass.category_id=
                         int.parse(dropdownValue1.toString());

                        subTypesList.clear();
                        subTypesList.insert(0, EventType(type_id: 0 ,type_name:'اختار النوع' ,category_id: 0 )) ;
                        dropdownValue2=subTypesList.first.type_id.toString();
                        dropdownName2=subTypesList.first.type_name ;

                        subTypesList.addAll(typesList.where((element) =>
                       element.category_id==int.parse(dropdownValue1.toString())).toList());
                    });
                  },
                  items: gategoryList.map((CategoryClass data){
                    return DropdownMenuItem<String>(
                      value: data.category_id.toString(),
                      child: Text(data.category_name ,style:  TextStyle(fontSize: 14), ),
                    );
                  }).toList(),
                ) ,
              ),
            ),
          ),
          dropdownValue1=="0"?
          SizedBox.shrink(): Expanded(
            flex: 1,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                padding: EdgeInsets.only(left: 8,right: 8),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey,width: 1),
                  borderRadius: BorderRadius.circular(15),
                ),
                child:DropdownButton<String>(
                  //  hint: Text(dropdownName),
                  dropdownColor: Colors.white,
                  icon: Icon(Icons.arrow_drop_down),
                  iconSize: 36,
                  isExpanded: true,
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 22
                  ),
                  value: dropdownValue2,

                  onChanged: (String value){
                    setState(() {
                        dropdownValue2=value;
                       //  print(Provider.of<EventProvider>(context, listen: false).event.categoryClass.category_id );

                        Provider.of<EventProvider>(context, listen: false).event.eventType.type_name =
                            subTypesList.where((el) {
                         return el.type_id.toString()==value;
                        }).toList()[0].type_name ;

                        Provider.of<EventProvider>
                         (context, listen: false).event.eventType.type_id=int.parse(dropdownValue2.toString() );
                    });
                  },
                  items:
                  subTypesList.map((EventType data){
                    return DropdownMenuItem<String>(
                      value: data.type_id.toString(),
                      child: Text(data.type_name ,style: TextStyle(fontSize: 14),),
                    );
                  }).toList(),
                ) ,
              ),
            ),
          )
        ],
      ),
    );
  }
}
