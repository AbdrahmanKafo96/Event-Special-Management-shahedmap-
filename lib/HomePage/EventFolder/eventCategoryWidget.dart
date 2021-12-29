import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:systemevents/model/Category.dart';
import 'package:systemevents/provider/EventProvider.dart';

class CustomCategoryEvent extends StatefulWidget {
  @override
  _CustomCategoryEventState createState() => _CustomCategoryEventState();
}

class _CustomCategoryEventState extends State<CustomCategoryEvent> {
   List<CategoryClass>  gategoryList = List<CategoryClass>(); String dropdownValue1 ,dropdownName1;

   List<EventType>  typesList = List<EventType>(); 
 List<EventType>  subTypesList = List<EventType>();
   
   String dropdownValue2 ,dropdownName2;
  @override
  void initState() {
    super.initState();
    convert1();
    convert2();
  }
   convert2(){
     Provider.of<EventProvider>
       (context, listen: false).fetchEventTypes().
     then((value){
       setState(() {
         value.forEach((EventType element) {
           typesList.add(
               EventType(type_id: element.type_id,type_name: element.type_name,category_id: element.category_id));
         });
          subTypesList.insert(0, EventType(type_id: 0 ,type_name:'اختار النوع' ,category_id: 0 )) ;
         dropdownValue2=subTypesList.first.type_id.toString();
         dropdownName2=subTypesList.first.type_name ;
       });
     }) ;
   }
  convert1(){
    Provider.of<EventProvider>
      (context, listen: false).fetchEventCategories().
    then((value){
      setState(() {
        value.forEach((CategoryClass element) {
          gategoryList.add(new CategoryClass(category_id: element.category_id,category_name: element.category_name));

        });

        gategoryList.insert(0, CategoryClass(category_id: 0 ,category_name:'اختار الصنف')) ;
         dropdownValue1=gategoryList.first.category_id.toString();
        dropdownName1=gategoryList.first.category_name.toString();

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
