import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:provider/provider.dart';
import 'package:systemevents/models/category.dart';
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
  List<MyList> mylist = [];

  int selected;

Box box;

   @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Singleton.getBox().then((Box value) {
      setState(() {
        box=value;
      });
    });
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
                      accountName: Text(" kafu"),
                      accountEmail: Text("email"),
                      currentAccountPicture: CircleAvatar(
//backgroundColor: Colors.orange,
                        child: Text(
                          "A",
                          style: TextStyle(fontSize: 40.0),
                        ),
                      ),
                    ),
                  ),
                  ListView(
                    padding: EdgeInsets.only(right: 6,left: 6,top: 6,bottom: 6),
                    shrinkWrap: true,
                    children: <Widget>[
                      buildMenuItem(
                        context,
                        item: NavigationItem.home,
                        text: 'الصفحة الرئيسية',
                        icon: FontAwesomeIcons.home,
                      ),
                      const SizedBox(height: 8),
                      buildMenuItem(
                        context,
                        item: NavigationItem.settings,
                        text: 'الاعدادات',
                        icon: FontAwesomeIcons.cog,
                      ),
                      if(SharedData.getUserState() == false)
                        const SizedBox(height: 8),
                      if(SharedData.getUserState() == false)
                        buildMenuItem(
                          context,
                          item: NavigationItem.profilePage,
                          text: 'الصفحة الشخصية',
                          icon: FontAwesomeIcons.solidUser,
                        ),
                      if(SharedData.getUserState() == false)
                        const SizedBox(height: 8),
                      if(SharedData.getUserState() == false)
                        buildMenuItem(
                          context,
                          item: NavigationItem.resetPage,
                          text: 'تعيين كلمة المرور',
                          icon: FontAwesomeIcons.key,
                        ),
                      const SizedBox(height: 8),
                      buildMenuItem(
                        context,
                        item: NavigationItem.about,
                        text: 'حول التطبيق',
                        icon: FontAwesomeIcons.addressCard,
                      ),
                      const SizedBox(height: 8),
                      buildMenuItem(
                        context,
                        item: NavigationItem.logout,
                        text: 'تسجيل الخروج',
                        icon: FontAwesomeIcons.signOut,
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
      color: Colors.black.withOpacity(0.7),
      child: ListTile(
        shape: RoundedRectangleBorder(

            borderRadius: BorderRadius.all(Radius.circular(10))),
        selected: isSelected,

        selectedTileColor: Colors.blueGrey,
        leading: Icon(icon, color: color),
        title: Text(text, style: TextStyle(color: color, fontSize: 16)),
        onTap: () => selectItem(context, item),
      ),
    );
  }

  void selectItem(BuildContext context, NavigationItem item) {
    if(item == NavigationItem.logout){
      Provider.of<UserAuthProvider>(context,
          listen: false)
          .logout(context);
    }else{
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
