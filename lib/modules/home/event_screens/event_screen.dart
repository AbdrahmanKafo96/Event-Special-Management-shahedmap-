import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:systemevents/modules/home/event_screens/video_picker.dart';

  import 'package:systemevents/provider/event_provider.dart';

class EventForm extends StatefulWidget {
  @override
  _EventFormState createState() => _EventFormState();
}

class _EventFormState extends State<EventForm> {
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return
      GestureDetector(
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        child: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(6.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [


              Text(
                "إضافة وصف الحدث",
                style: Theme.of(context).textTheme.headline6,
              ),
              Container(
                margin: EdgeInsets.all(5),
                padding: EdgeInsets.all(5),
                // decoration: BoxDecoration(
                //   color: Colors.white,
                //   border: Border.all(
                //       color: Colors.blueGrey,// set border color
                //       width: 2.0),   // set border width
                //   borderRadius: BorderRadius.all(
                //       Radius.circular(10.0)), // set rounded corner radius
                // ),
                child: TextFormField(
                  onChanged: (value) {
                    Provider.of<EventProvider>(context, listen: false)
                        .event
                        .setDescription = value;
                  },

                   keyboardType: TextInputType.multiline ,
                  maxLines: 4,
                  maxLength: 500,
                  decoration: InputDecoration(

                    hintText: 'ادخل وصف الحدث هنا.',
                    border: InputBorder.none,
                  ),
                ),
              ),
              VideoPicker(),

             // new style
            ],
          ),
        ),
    ),
      );
  }
}
