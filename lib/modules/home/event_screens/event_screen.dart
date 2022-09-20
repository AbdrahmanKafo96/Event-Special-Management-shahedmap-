import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:systemevents/provider/event_provider.dart';
import 'package:systemevents/widgets/custom_Text_Field.dart';

class EventForm extends StatefulWidget {
  @override
  _EventFormState createState() => _EventFormState();
}

class _EventFormState extends State<EventForm> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(6.0),
          child:

              Container(
                margin: EdgeInsets.all(5),
                padding: EdgeInsets.all(5),
                child: customTextFormField(
                  context,
                  onChanged: (value) {
                    Provider.of<EventProvider>(context, listen: false)
                        .event
                        .setDescription = value;
                  },
                  keyboardType: TextInputType.multiline,
                   maxLines: 4,
                  maxLength: 500,
                    hintStyle: Theme.of(context).textTheme.bodyText1,
                    hintText: 'ادخل وصف الحدث هنا.',
                    border: InputBorder.none,

                ),
              ),

              // new style

        ),
      ),
    );
  }
}
