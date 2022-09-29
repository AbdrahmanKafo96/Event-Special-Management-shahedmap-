import 'package:contactus/contactus.dart';
import 'package:flutter/material.dart';
import 'package:shahed/widgets/custom_app_bar.dart';
import 'package:shahed/widgets/custom_drawer.dart';
import '../../../shared_data/shareddata.dart';
import '../../../widgets/customDirectionality.dart';

class About extends StatefulWidget {
  @override
  _AboutState createState() => _AboutState();
}
class _AboutState extends State<About>  {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return customDirectionality(
        child: Scaffold(
          drawer: CustomDrawer(),
          appBar: customAppBar(
            context,
            title: SharedData.getGlobalLang().aboutApp(),
            icon: Icons.people_alt
             ),
          body: Container(
            child:  Padding(
              padding: const EdgeInsets.all(10.0),
              child:   ContactUs(
                logo: const AssetImage('assets/images/programmerlogo.png'),
                email:   'abdrahmankafo@gmail.com',
                companyName: '',
                githubUserName: 'AbdrahmanKafo96',
                linkedinURL: 'https://www.linkedin.com/in/abdrahman-kafo-945b331b5/',
                tagLine: SharedData.getGlobalLang().infoDevelopmentTeam(),
                twitterHandle: ' ',
                textColor: Colors.black,
                cardColor: Colors.white,
                companyColor: Colors.black,
                taglineColor: Colors.black,
              ),
            ),
        ),
      ),
    );
  }
}
