import 'package:flutter/material.dart';
import 'package:systemevents/widgets/change_theme_button_widget.dart';

class ThemeApp  extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("خلفية التطبيق"),),
      body:   Container(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text("تعيين خلفية التطبيق" ,style:  Theme.of(context).textTheme.headline6,),
                 Row(
                   children: [
                     Text("وضع الخلفية" ,style:  Theme.of(context).textTheme.labelLarge),
                     ChangeThemeButtonWidget(),
                   ],
                 ),
                Divider(color: Colors.grey[700], )
              ],
        ),
      ),
    );
  }
}
