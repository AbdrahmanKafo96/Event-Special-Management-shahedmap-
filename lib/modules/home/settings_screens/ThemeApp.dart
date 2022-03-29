import 'package:flutter/material.dart';
import 'package:systemevents/widgets/change_theme_button_widget.dart';

class ThemeApp  extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body:   Container(
        child:  ChangeThemeButtonWidget(),

      ),
    );
  }
}
