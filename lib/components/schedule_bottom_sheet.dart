import 'package:flutter/material.dart';
import 'package:scheduler/components/custom_text_field.dart';
import 'package:scheduler/constants/colors.dart';

class ScheduleBottomSheet extends StatefulWidget {
  const ScheduleBottomSheet({super.key});

  @override
  State<ScheduleBottomSheet> createState() => _ScheduleBottomSheetState();
}

class _ScheduleBottomSheetState extends State<ScheduleBottomSheet> {
  final GlobalKey<FormState> formKey = GlobalKey();
  int? startTime;
  int? endTime;
  String? content;

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: SafeArea(
        child: Container(
            height: MediaQuery.of(context).size.height / 2 + bottomInset,
            color: Colors.white,
            child: Padding(
              padding: EdgeInsets.only(bottom: bottomInset),
              child: Padding(
                padding:
                    const EdgeInsets.only(left: 8.0, right: 8.0, top: 16.0),
                child: Form(
                  key: formKey,
                  autovalidateMode: AutovalidateMode.always,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _Time(
                        onStartSaved: (String? value) {
                          startTime = int.parse(value!);
                        },
                        onEndSaved: (String? value) {
                          endTime = int.parse(value!);
                        },
                      ),
                      SizedBox(height: 16.0),
                      _Content(
                        onSaved: (String? value) {
                          content = value;
                        },
                      ),
                      SizedBox(height: 16.0),
                      _ColorPicker(),
                      SizedBox(height: 8.0),
                      _SaveButton(
                        onPressed: onSavePressed,
                      ),
                    ],
                  ),
                ),
              ),
            )),
      ),
    );
  }

  void onSavePressed() {
    if (formKey.currentState == null) return;

    if (formKey.currentState!.validate()) {
      formKey.currentState!.save();

      print('-------');
      print('startTime: $startTime');
      print('endTime: $endTime');
      print('content: $content');
    } else {
      print('에러가 있습니다');
    }
  }
}

class _Time extends StatelessWidget {
  final FormFieldSetter<String> onStartSaved;
  final FormFieldSetter<String> onEndSaved;
  const _Time({Key? key, required this.onStartSaved, required this.onEndSaved})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
            child: CustomTextField(
          label: '시작 시간',
          isTime: true,
          onSaved: onStartSaved,
        )),
        const SizedBox(width: 16.0),
        Expanded(
            child: CustomTextField(
          label: '마감 시간',
          isTime: true,
          onSaved: onEndSaved,
        ))
      ],
    );
  }
}

class _Content extends StatelessWidget {
  final FormFieldSetter<String> onSaved;

  const _Content({Key? key, required this.onSaved}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: CustomTextField(
        label: '내용',
        isTime: false,
        onSaved: onSaved,
      ),
    );
  }
}

class _ColorPicker extends StatelessWidget {
  const _ColorPicker({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8.0,
      runSpacing: 10.0,
      children: [
        renderColor(Colors.red),
        renderColor(Colors.orange),
        renderColor(Colors.yellow),
        renderColor(Colors.green),
        renderColor(Colors.blue),
        renderColor(Colors.indigo),
        renderColor(Colors.purple),
      ],
    );
  }

  Widget renderColor(Color color) {
    return Container(
      width: 32.0,
      height: 32.0,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color,
      ),
    );
  }
}

class _SaveButton extends StatelessWidget {
  final VoidCallback onPressed;

  const _SaveButton({Key? key, required this.onPressed}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton(
            onPressed: onPressed,
            style: ElevatedButton.styleFrom(
              backgroundColor: PRIMARY_COLOR,
            ),
            child: const Text('저장'),
          ),
        ),
      ],
    );
  }
}
