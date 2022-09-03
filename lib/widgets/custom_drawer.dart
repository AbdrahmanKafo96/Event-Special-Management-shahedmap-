import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:systemevents/models/category.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:systemevents/models/navigation_item.dart';
import 'package:systemevents/provider/auth_provider.dart';
import 'package:systemevents/provider/navigation_provider.dart';

class CustomDrwaer extends StatefulWidget {
  @override
  State<CustomDrwaer> createState() => _CustomDrwaerState();
}
class _CustomDrwaerState extends State<CustomDrwaer> {
  List<MyList> mylist = [];
  int selected;
  void addObj() {
    mylist.add(MyList(
        item: NavigationItem.home,
        title: 'الصفحة الرئيسية',
        color: Colors.grey,
        context: context,
        icon: FontAwesomeIcons.home,
        routPage: "Home"));

    mylist.add(MyList(
        item: NavigationItem.settings,
        title: 'الاعدادت',
        color: Colors.grey,
        context: context,
        icon: FontAwesomeIcons.cog,
        routPage: "settings"));

    mylist.add(MyList(
        item: NavigationItem.ProfilePage,
        title: 'الصفحة الشخصية',
        color: Colors.grey,
        context: context,
        icon: FontAwesomeIcons.solidUser,
        routPage: "ProfilePage"));

    mylist.add(MyList(
        item: NavigationItem.ResetPage,
        title: 'تعيين كلمة المرور',
        color: Colors.grey,
        context: context,
        icon: FontAwesomeIcons.key,
        routPage: "ResetPage"));

    mylist.add(MyList(
        item: NavigationItem.About,
        title: 'حول التطبيق',
        color: Colors.grey,
        context: context,
        icon: FontAwesomeIcons.addressCard,
        routPage: "About"));

    mylist.add(MyList(
       // item: NavigationItem.,
        title: 'تسجيل الخروج',
        color: Colors.grey,
        //  context: context,
        icon: FontAwesomeIcons.signOut,
        routPage: "logout"));
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    addObj();
  }
  @override
  Widget build(BuildContext context) {
    return Drawer(
        backgroundColor: Color.fromRGBO(255, 255, 255, 0.9),
        child: Stack(children: [
          Positioned(
            bottom: -120,
            right: 0,
            child: Container(
              child: Container(
                decoration: const BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        spreadRadius: 0,
                        blurRadius: 7,
                        offset: Offset(0, 1), // changes position of shadow
                      ),
                    ],
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      colors: [
                        Color(0xFF00695C),
                        Color(0xFF4DB6AC),
                      ],
                    )),
                width: 500,
                height: 200,
              ),
            ),
          ),
          Positioned(
            top: -120,
            left: 0,
            child: Container(
              decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    colors: [
                      Color(0xFF00695C),
                      Color(0xFF4DB6AC),
                    ],
                  ),
                  boxShadow: [
                    BoxShadow(
                      spreadRadius: 0,
                      blurRadius: 7,
                      offset: Offset(0, 1), // changes position of shadow
                    ),
                  ]),
              width: 500,
              height: 200,
            ),
          ),
          Container(
              child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                child: UserAccountsDrawerHeader(
                  margin: EdgeInsets.zero,
                  arrowColor: Colors.redAccent,
                  decoration: BoxDecoration(
                    color: Color.fromRGBO(255, 255, 255, 0.0),
                  ),
                  accountName: Text("Abdulrahman kafu"),
                  accountEmail: Text("bedootk90@gmail.com"),
                  currentAccountPicture: CircleAvatar(
//backgroundColor: Colors.orange,
                    child: Text(
                      "A",
                      style: TextStyle(fontSize: 40.0),
                    ),
                  ),
                ),
              ),
              ListView.builder(
// Important: Remove any padding from the ListView.
                shrinkWrap: true,
                itemCount: mylist.length,
                itemBuilder: (context, index) {
                  return Column(
                    children: [
                      ListTile(
                        shape: RoundedRectangleBorder(
//  side: BorderSide(color: Colors.white70, width: 1),
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                        ),
                        focusColor: Colors.redAccent,

                        title: Text('${mylist[index].title}'),
                        leading: Icon(mylist[index].icon),
// tileColor: selected == index ? Colors.blue : Colors.teal.withOpacity(0.4),
                        onTap: () {
                          setState(() {
                            selected = index;
                          });
                          if (mylist[index].routPage == "logout")
                            Provider.of<UserAuthProvider>(context,
                                    listen: false)
                                .logout(context);
                          else {
                            viewPage(
                                mylist[index].context, mylist[index].routPage);
                          }
                        },
                      ),
//    SizedBox(height: 8,),
                      if (index != mylist.length - 1) Divider()
                    ],
                  );
                },
              )
            ],
          ))
        ]));
  }
  viewPage(BuildContext ctx, String view) {
    return Navigator.of(ctx).pushNamed(
      view,
      arguments: (route) => false,
    );
  }
}
