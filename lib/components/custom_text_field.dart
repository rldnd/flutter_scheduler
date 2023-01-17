import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:scheduler/constants/colors.dart';

class CustomTextField extends StatelessWidget {
  final String label;
  final bool isTime;
  final FormFieldSetter<String> onSaved;

  const CustomTextField(
      {super.key,
      required this.label,
      required this.isTime,
      required this.onSaved});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: PRIMARY_COLOR,
            fontWeight: FontWeight.w600,
          ),
        ),
        if (isTime) renderTextField(),
        if (!isTime) Expanded(child: renderTextField())
      ],
    );
  }

  Widget renderTextField() {
    return TextFormField(
      onSaved: onSaved,
      validator: (String? value) {
        if (value == null || value.isEmpty) return '값을 입력해주세요';
        if (isTime) {
          int time = int.parse(value);
          if (time < 0) return '0 이상의 숫자를 입력해주세요';
          if (time > 24) return '24 이하의 숫자를 입력해주세요';
        }

        return null;
      },
      maxLines: isTime ? 1 : null,
      maxLength: 500,
      expands: !isTime,
      keyboardType: isTime ? TextInputType.number : TextInputType.multiline,
      inputFormatters: isTime
          ? [
              FilteringTextInputFormatter.digitsOnly,
            ]
          : [],
      cursorColor: Colors.grey,
      decoration: InputDecoration(
        border: InputBorder.none,
        filled: true,
        fillColor: Colors.grey[200],
      ),
    );
  }
}
