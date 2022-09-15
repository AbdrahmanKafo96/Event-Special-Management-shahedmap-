import 'package:flutter/material.dart';

class Logo extends StatefulWidget {
  String _url;
  Logo(this._url);
  @override
  _LogoState createState() => _LogoState();
}

class _LogoState extends State<Logo> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Container(
       // padding: EdgeInsets.all(10),

         child: Center(child: Image(
           image: AssetImage('assets/images/${widget._url}'),
           width: MediaQuery.of(context).size.width,
           height: MediaQuery.of(context).size.height*0.4,))
      ),
    );
  }
}
