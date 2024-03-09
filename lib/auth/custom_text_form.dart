import 'package:flutter/material.dart';
import 'package:to_do/my_theme.dart';
typedef MyValidator = String? Function(String?)?;
class CustomTextForm extends StatelessWidget {
  String label ;
  TextInputType keyboardType ;
  TextEditingController controller ;
  MyValidator validator;
  bool obSecureText ;
  CustomTextForm({
    required this.label,
    required this.validator,
    required this.controller,
    this.keyboardType = TextInputType.text,
    this.obSecureText = false ,
  });
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: TextFormField(
        decoration: InputDecoration(
            labelText: label,
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide(
              color: MyTheme.primaryColor,
              width: 2
            )
          ),
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: BorderSide(
                  color: MyTheme.primaryColor,
                  width: 2
              )
          ),
          errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: BorderSide(
                  color: MyTheme.redColor,
                  width: 2
              )
          ),
          focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: BorderSide(
                  color: MyTheme.primaryColor,
                  width: 2
              )
          ),
        ),
        keyboardType: keyboardType,
        controller: controller,
        validator: validator,
        obscureText: obSecureText,
      ),
    );
  }
}
