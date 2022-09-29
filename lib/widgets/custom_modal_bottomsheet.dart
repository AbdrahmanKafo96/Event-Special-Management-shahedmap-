import 'package:flutter/material.dart';

import '../shared_data/shareddata.dart';

void  showPicker(context , Function f , Function  f2 , { int index = -1}) {

  showModalBottomSheet(
      context: context,
      builder: (BuildContext bc) {
        return Container(
        //  color: Color(0xff424250),
          child:   Wrap(
            children: <Widget>[
                ListTile(
                  leading:   Icon(Icons.photo_library ,color: Colors.white ),
                  tileColor: Color(0xff424250),
                  focusColor: Color(0xff424250),
                  hoverColor: Color(0xff424250),
                  selectedColor: Color(0xff424250),
                  title:   Text(SharedData.getGlobalLang().picturesLibrary() ,style: Theme.of(context).textTheme.headline4,),
                  onTap: () {
                   if(index>-1)
                     {
                       f(index);
                     }
                     else{
                     f();
                   }

                    Navigator.of(context).pop();
                  }),
                ListTile(
                  tileColor: Color(0xff424250),
                  focusColor: Color(0xff424250),
                  hoverColor: Color(0xff424250),
                  selectedColor: Color(0xff424250),
                leading:   Icon(Icons.photo_camera ,color: Colors.white ),
                title:   Text(SharedData.getGlobalLang().cameraLibrary() , style: Theme.of(context).textTheme.headline4,),
                onTap: () {
                  if(index>0)
                  {
                    f2(index);
                  }
                  else{
                    f2();
                  }
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        );
      });
}