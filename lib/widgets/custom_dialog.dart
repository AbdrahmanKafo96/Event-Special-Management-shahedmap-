import 'package:flutter/material.dart';
import 'package:shahed/theme/colors_app.dart';
import 'package:shahed/widgets/customDirectionality.dart';

Future<dynamic> customReusableShowDialog(
    BuildContext context, String header,
    {TextEditingController? textController,
    ValueChanged<String>? onChanged,
    TextInputType? keyboardType,
    FormFieldValidator<String>? validator,
    VoidCallback? onTap,
    String? labelText,
    String? hintText,
    TextStyle? helperStyle,
    Key? formKey,
    List<Widget>? actions,
    Widget? widget}) async {
  return showDialog(
    context: context,
    builder: (context) {
      return customDirectionality(
        child: AlertDialog(
          backgroundColor: Color(SharedColor.darkIntColor),
          title: Text(
            header,
            style: Theme.of(context).textTheme.bodyText1,
          ),
          content: widget,
          actions: actions,
        ),
      );
    },
  );
}
