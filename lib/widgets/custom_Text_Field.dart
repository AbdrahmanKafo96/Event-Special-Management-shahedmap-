import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

Widget customTextFormField(BuildContext buildContext,
    {TextEditingController editingController,
    TextAlign textAlign=TextAlign.right,
    TextInputType textInputType,
    FormFieldValidator<String> validator,
    bool obsecure = false,
    bool readOnly,
    VoidCallback onTap,
    VoidCallback onEditingCompleted,
    TextInputType keyboardType,
    ValueChanged<String> onChanged,
    bool isMulti,
    bool autofocus,
    bool enabled,
    String errorText,
    String labelText,
    String hintText,
    Widget suffixIcon,
    Widget prefixIcon,
    TextStyle helperStyle}) {
  return TextFormField(

    autofocus: autofocus,
    onTap: onTap,
    onEditingComplete: onEditingCompleted,
    style: Theme.of(buildContext).textTheme.bodyText1,
    controller: editingController,
    textAlign: textAlign,
    keyboardType: textInputType,
    inputFormatters: <TextInputFormatter>[
      FilteringTextInputFormatter.singleLineFormatter
    ],
    validator: validator,
    obscureText: obsecure,
    onChanged: onChanged,
    decoration: InputDecoration(
      errorText: errorText,
      prefixIcon: prefixIcon,
      suffixIcon: suffixIcon,
      labelText: labelText,
      hintText: hintText,
      helperStyle: helperStyle,
      border: OutlineInputBorder(),
      // hintStyle: TextStyle(color: Colors.blueGrey, fontSize: 15),
      //  contentPadding: EdgeInsets.symmetric(vertical: 8, horizontal: 20),
      // enabledBorder: textFieldfocused(),
      // focusedBorder: textFieldfocused(),
      // errorBorder: errorrTextFieldBorder(),
      // focusedErrorBorder: errorrTextFieldBorder(),
    ),
  );
}
