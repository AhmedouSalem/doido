import 'package:flutter/material.dart';

class CustomTopForm extends StatelessWidget {
  const CustomTopForm({
    super.key,
    required this.textLabel,
    this.iconPrefix,
    required this.fieldController,
    this.validatorInput,
    this.onTapField,
    required this.testReadOnly,
    this.styleLabel,
    this.colorPrefixIcon,
    required this.colorUnderline,
  });
  final String? textLabel;
  final Widget? iconPrefix;
  final TextEditingController fieldController;
  final String? Function(String?)? validatorInput;
  final void Function()? onTapField;
  final bool testReadOnly;
  final TextStyle? styleLabel;
  final Color? colorPrefixIcon;
  final Color colorUnderline;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(20.0),
      child: Column(
        children: [
          TextFormField(
            style: styleLabel,
            onTap: onTapField,
            validator: validatorInput,
            controller: fieldController,
            readOnly: testReadOnly,
            decoration: InputDecoration(
              labelStyle: styleLabel,
              prefixIcon: iconPrefix,
              prefixIconColor: colorPrefixIcon,
              labelText: textLabel,
              enabled: true,
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: colorUnderline),
              ),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: colorUnderline),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
