// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:systemevents/provider/EventProvider.dart';
// import 'CheckEmailView.dart';
//
// class ResetPage extends StatefulWidget {
//   @override
//   _ResetPageState createState() => _ResetPageState();
// }
//
// class _ResetPageState extends State<ResetPage> {
//   final emailController = TextEditingController();
//   @override
//   Widget build(BuildContext context) {
//     return Directionality(
//       textDirection: TextDirection.rtl,
//       child: Scaffold(
//         appBar: AppBar(
//           title: Text(
//             'رجوع',
//             style: TextStyle(color: Colors.white),
//           ),
//          // leadingWidth: 25,
//           leading: IconButton(
//             icon: Icon(Icons.arrow_back ,color: Colors.white,),
//             onPressed: () {},
//           ),
//           actions: [
//             Padding(
//               padding: const EdgeInsets.all(8.0),
//               child: Icon(Icons.help_outline ,color: Colors.white,),
//             )
//           ],
//         ),
//         body: Padding(
//           padding: const EdgeInsets.all(16.0),
//           child: ListView(
//             children: [
//               Text(
//                 'إعادة ضبط كلمة المرور',
//                 style: Theme.of(context).textTheme.headline4,
//
//               ),
//               SizedBox(
//                 height: 16,
//               ),
//               Text(
//                 'أدخل البريد الإلكتروني المرتبط بحسابك وسنرسل بريدًا إلكترونيًا يحتوي على إرشادات لإعادة تعيين كلمة المرور الخاصة بك',
//                 style: Theme.of(context).textTheme.subtitle1,
//               ),
//               SizedBox(
//                 height: 16,
//               ),
//               Text(
//                 'البريد الالكتروني',
//                 style: Theme.of(context).textTheme.subtitle1,
//               ),
//               SizedBox(
//                 height: 8,
//               ),
//               Container(
//                 height: 50,
//                 child: TextFormField(
//                   controller: emailController,
//                   style:
//                   TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
//                 ),
//               ),
//               SizedBox(
//                 height: 16,
//               ),
//               Row(
//                 children: [
//                   Expanded(
//                       child: ElevatedButton(
//                         onPressed: () {
//                           //navigate to check email view
//                           Provider.of<EventProvider>(context,listen: false).forgotpassword(emailController.text.toString());
//                            Navigator.push(context, MaterialPageRoute(builder: (context) => CheckEmailView()));
//                         },
//                         child: Text(
//                           'إرسال',
//                           style: TextStyle(fontSize: 20),
//                         ),
//                       )),
//                 ],
//               )
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
