import 'package:flutter/material.dart';
import 'package:shahed/theme/colors_app.dart';
import 'package:shahed/widgets/customDirectionality.dart';
import '../shared_data/shareddata.dart';

void showPicker(context , Function f , Function  f2 , { int index = -1}) {

  showModalBottomSheet(
      context: context,
      builder: (BuildContext bc) {
        return customDirectionality(
          child: Container(
          //  color: Color(0xff424250),
            child:   Wrap(
              children: <Widget>[
                  ListTile(
                    leading:   Icon(Icons.photo_library ,color: SharedColor.white ),
                    tileColor: Color(SharedColor.greyIntColor),
                    focusColor: Color(SharedColor.greyIntColor),
                    hoverColor: Color(SharedColor.greyIntColor),
                    selectedColor: Color(SharedColor.greyIntColor),
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
                    tileColor: Color(SharedColor.greyIntColor),
                    focusColor: Color(SharedColor.greyIntColor),
                    hoverColor: Color(SharedColor.greyIntColor),
                    selectedColor: Color(SharedColor.greyIntColor),
                  leading:   Icon(Icons.photo_camera ,color: Colors.white ),
                  title:   Text(SharedData.getGlobalLang().cameraLibrary() , style: Theme.of(context).textTheme.headline4,),
                  onTap: () {
                    if(index>=0)
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
          ),
        );
      });
}