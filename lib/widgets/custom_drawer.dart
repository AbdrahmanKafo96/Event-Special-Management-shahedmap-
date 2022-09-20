import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:systemevents/models/navigation_item.dart';
import 'package:systemevents/provider/auth_provider.dart';
import 'package:systemevents/provider/navigation_provider.dart';
import 'package:systemevents/shared_data/shareddata.dart';
import 'package:systemevents/singleton/singleton.dart';

class CustomDrawer extends StatefulWidget {
  @override
  State<CustomDrawer> createState() => _CustomDrawerState();
}

class _CustomDrawerState extends State<CustomDrawer> {
  String email = "";
  String username = " ";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    openBox();
  }

  void openBox() {
    Singleton.getBox().then((value) {
      setState(() {
        email = value.get('email');
        username =  value.get('unitname').toString();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
        backgroundColor:Colors.transparent.withOpacity(0.5) ,
        child: Stack(children: [
          // Positioned(
          //   bottom: -120,
          //   right: 0,
          //   child: Container(
          //     child: Container(
          //       decoration: const BoxDecoration(
          //           boxShadow: [
          //             BoxShadow(
          //               spreadRadius: 0,
          //               blurRadius: 7,
          //               offset: Offset(0, 1), // changes position of shadow
          //             ),
          //           ],
          //           shape: BoxShape.circle,
          //           gradient: LinearGradient(
          //             colors: [
          //               Color(0xFF424250),
          //               Color(0xff33333d),
          //             ],
          //           )),
          //       width: 500,
          //       height: 170,
          //     ),
          //   ),
          // ),
          Positioned(
            top: -120,
            left: 0,
            child: Container(
              decoration: const BoxDecoration(
                  shape: BoxShape.circle,

                  gradient: LinearGradient(
                    colors: [
                      Color(0xFF424250),
                      Color(0xff33333d),
                    ],
                  ),
                  boxShadow: [
                    BoxShadow(
                      spreadRadius: 0,
                      blurRadius: 7,
                      offset: Offset(0, 1), // changes position of shadow
                    ),
                  ]),
              width: 650,
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
                  accountName: Text("$username" ,style: Theme.of(context).textTheme.bodyText1,),
                  accountEmail: Text("$email" ,style: Theme.of(context).textTheme.bodyText1,),
                  currentAccountPicture: CircleAvatar(
                    backgroundColor: Colors.orange,
                    child: Text(
                      "${username[0].toUpperCase()}",
                      style: TextStyle(fontSize: 40.0),
                    ),
                  ),
                ),
              ),
              ListView(
                padding: EdgeInsets.only(right: 6, left: 6, top: 6, bottom: 6),
                shrinkWrap: true,
                children: <Widget>[
                  buildMenuItem(
                    context,
                    item: NavigationItem.home,
                    text: 'الصفحة الرئيسية',
                    icon: FontAwesomeIcons.house,
                  ),
                  const SizedBox(height: 8),
                  buildMenuItem(
                    context,
                    item: NavigationItem.settings,
                    text: 'الإعدادات',
                    icon: FontAwesomeIcons.gear,
                  ),
                  if (SharedData.getUserState() == false)
                    const SizedBox(height: 8),
                  if (SharedData.getUserState() == false)
                    buildMenuItem(
                      context,
                      item: NavigationItem.profilePage,
                      text: 'الصفحة الشخصية',
                      icon: FontAwesomeIcons.solidUser,
                    ),
                  if (SharedData.getUserState() == false)
                    const SizedBox(height: 8),
                  if (SharedData.getUserState() == false)
                    buildMenuItem(
                      context,
                      item: NavigationItem.resetPage,
                      text: 'تعيين كلمة المرور',
                      icon: Icons.lock_reset,
                    ),
                  const SizedBox(height: 8),
                  buildMenuItem(
                    context,
                    item: NavigationItem.about,
                    text: 'حول التطبيق',
                    icon: Icons.people_alt,
                  ),
                  const SizedBox(height: 8),
                  buildMenuItem(
                    context,
                    item: NavigationItem.logout,
                    text: 'تسجيل الخروج',
                    icon: FontAwesomeIcons.arrowRightFromBracket,
                  ),
                ],
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

  Widget buildMenuItem(
    BuildContext context, {
    NavigationItem item,
    String text,
    IconData icon,
  }) {
    final provider = Provider.of<NavigationProvider>(context);
    final currentItem = provider.getNavigationItem;
    final isSelected = item == currentItem;

    final color = isSelected ? Colors.white : Colors.grey;

    return Material(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10))),
      color: Color(0xFF424250),
      child: ListTile(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(10))),
        selected: isSelected,

        selectedTileColor: Color(0xFFfe6e00),
        hoverColor: Color(0xFFFF8F00),
        // tileColor: Color(0xFFFF8F00),
        leading: Icon(icon, color: color),
        title: Text(text, style: TextStyle(color: color, fontSize: 16)),
        onTap: () => selectItem(context, item),
      ),
    );
  }

  void selectItem(BuildContext context, NavigationItem item) {
    if (item == NavigationItem.logout) {
      Provider.of<UserAuthProvider>(context, listen: false).logout(context);
    } else {
      final provider = Provider.of<NavigationProvider>(context, listen: false);
      provider.setNavigationItem(item);
    }
  }
}

// ListView.builder(
// // Important: Remove any padding from the ListView.
// shrinkWrap: true,
// itemCount: mylist.length,
// itemBuilder: (context, index) {
// return Column(
// children: [
// ListTile(
// shape: RoundedRectangleBorder(
// //  side: BorderSide(color: Colors.white70, width: 1),
// borderRadius: BorderRadius.all(Radius.circular(10)),
// ),
// focusColor: Colors.redAccent,
//
// title: Text('${mylist[index].title}'),
// leading: Icon(mylist[index].icon),
// // tileColor: selected == index ? Colors.blue : Colors.teal.withOpacity(0.4),
// onTap: () {
// setState(() {
// selected = index;
// });
// if (mylist[index].routPage == "logout")
// Provider.of<UserAuthProvider>(context,
// listen: false)
//     .logout(context);
// else {
// viewPage(
// mylist[index].context, mylist[index].routPage);
// }
// },
// ),
// //    SizedBox(height: 8,),
// if (index != mylist.length - 1) Divider()
// ],
// );
// },
// )
