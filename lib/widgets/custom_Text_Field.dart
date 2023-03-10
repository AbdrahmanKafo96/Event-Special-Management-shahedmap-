import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shahed/widgets/customDirectionality.dart'; 
import '../shared_data/shareddata.dart';


Widget customTextFormField(BuildContext buildContext,
    {TextEditingController? editingController,

    TextInputType? textInputType,
    FormFieldValidator<String>? validator,
    bool obsecure = false,
    bool? readOnly,
    VoidCallback? onTap,
    VoidCallback? onEditingCompleted,
    TextInputType? keyboardType,
    ValueChanged<String>? onChanged,
    bool isMulti = false,
    bool? autofocus,
    bool? enabled,
    String? errorText,
    String? labelText,
    String? hintText,
    Widget? suffixIcon,
    Widget? prefixIcon,
    TextStyle? hintStyle,
    int maxLines = 1,
    InputBorder border = const OutlineInputBorder(),
    int? maxLength ,
    TextStyle? helperStyle}) {
  return customDirectionality(
    child: TextFormField(
      // autofocus: autofocus,
      onTap: onTap,
      textDirection:SharedData.getGlobalLang().getLanguage=="AR"? TextDirection.rtl :TextDirection.ltr,
      maxLength: maxLength,
      maxLines: maxLines,
      onEditingComplete: onEditingCompleted,
      style: Theme.of(buildContext).textTheme.bodyText1,
      controller: editingController,
      textAlign: SharedData.getGlobalLang().getLanguage =="AR" ? TextAlign.right:TextAlign.left,
      keyboardType: textInputType,
      inputFormatters: <TextInputFormatter>[
        FilteringTextInputFormatter.singleLineFormatter
      ],
      validator: validator,
      obscureText: obsecure,
      onChanged: onChanged,
      decoration: InputDecoration(
        hintStyle: hintStyle,
        errorText: errorText,
        prefixIcon: prefixIcon,
        suffixIcon: suffixIcon,
        labelText: labelText,
        hintText: hintText,
        helperStyle: helperStyle,
        border: border,
        isCollapsed: true,
        // hintStyle: TextStyle(color: Colors.blueGrey, fontSize: 15),
        //  contentPadding: EdgeInsets.symmetric(vertical: 8, horizontal: 20),
        // enabledBorder: textFieldfocused(),
        // focusedBorder: textFieldfocused(),
        // errorBorder: errorrTextFieldBorder(),
        // focusedErrorBorder: errorrTextFieldBorder(),
      ),
    ),
  );
}
