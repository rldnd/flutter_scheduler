import 'package:drift/drift.dart' show Value;
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:scheduler/components/custom_text_field.dart';
import 'package:scheduler/constants/colors.dart';
import 'package:scheduler/database/drift_database.dart';

class ScheduleBottomSheet extends StatefulWidget {
  final DateTime selectedDate;
  final int? scheduleId;

  const ScheduleBottomSheet(
      {super.key, required this.selectedDate, this.scheduleId});

  @override
  State<ScheduleBottomSheet> createState() => _ScheduleBottomSheetState();
}

class _ScheduleBottomSheetState extends State<ScheduleBottomSheet> {
  final GlobalKey<FormState> formKey = GlobalKey();
  int? startTime;
  int? endTime;
  String? content;
  int? selectedColorId;

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: FutureBuilder<Schedule>(
          future: null,
          builder: (context, snapshot) {
            return FutureBuilder<Schedule>(
                future: widget.scheduleId == null
                    ? null
                    : GetIt.I<LocalDatabase>().getSchedule(widget.scheduleId!),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return const Center(child: Text('스케쥴을 불러올 수 없습니다.'));
                  }

                  if (snapshot.connectionState != ConnectionState.none &&
                      !snapshot.hasData) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (snapshot.hasData && startTime == null) {
                    startTime = snapshot.data!.startTime;
                    endTime = snapshot.data!.endTime;
                    content = snapshot.data!.content;
                    selectedColorId = snapshot.data!.colorId;
                  }

                  return SafeArea(
                    child: Container(
                        height: MediaQuery.of(context).size.height / 2 +
                            bottomInset,
                        color: Colors.white,
                        child: Padding(
                          padding: EdgeInsets.only(bottom: bottomInset),
                          child: Padding(
                            padding: const EdgeInsets.only(
                                left: 8.0, right: 8.0, top: 16.0),
                            child: Form(
                              key: formKey,
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
                                    startInitialValue:
                                        startTime?.toString() ?? '',
                                    endInitialValue: endTime?.toString() ?? '',
                                  ),
                                  SizedBox(height: 16.0),
                                  _Content(
                                    onSaved: (String? value) {
                                      content = value;
                                    },
                                    initialValue: content ?? '',
                                  ),
                                  SizedBox(height: 16.0),
                                  FutureBuilder<List<CategoryColor>>(
                                      future: GetIt.I<LocalDatabase>()
                                          .getCategoryColors(),
                                      builder: (context, snapshot) {
                                        if (snapshot.hasData &&
                                            selectedColorId == null &&
                                            snapshot.data!.isNotEmpty) {
                                          selectedColorId =
                                              snapshot.data![0].id;
                                        }
                                        return _ColorPicker(
                                          colors: snapshot.hasData
                                              ? snapshot.data!
                                              : [],
                                          selectedColorId: selectedColorId,
                                          colorIdSetter: (int id) {
                                            setState(
                                                () => selectedColorId = id);
                                          },
                                        );
                                      }),
                                  SizedBox(height: 8.0),
                                  _SaveButton(
                                    onPressed: onSavePressed,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        )),
                  );
                });
          }),
    );
  }

  void onSavePressed() async {
    if (formKey.currentState == null) return;

    if (formKey.currentState!.validate()) {
      formKey.currentState!.save();

      if (widget.scheduleId == null) {
        await GetIt.I<LocalDatabase>().createSchedule(SchedulesCompanion(
          date: Value(widget.selectedDate),
          startTime: Value(startTime!),
          endTime: Value(endTime!),
          content: Value(content!),
          colorId: Value(selectedColorId!),
        ));
      } else {
        await GetIt.I<LocalDatabase>().updateScheduleById(
            widget.scheduleId!,
            SchedulesCompanion(
              date: Value(widget.selectedDate),
              startTime: Value(startTime!),
              endTime: Value(endTime!),
              content: Value(content!),
              colorId: Value(selectedColorId!),
            ));
      }

      Navigator.of(context).pop();
    } else {
      print('에러가 있습니다');
    }
  }
}

class _Time extends StatelessWidget {
  final FormFieldSetter<String> onStartSaved;
  final FormFieldSetter<String> onEndSaved;
  final String startInitialValue;
  final String endInitialValue;

  const _Time(
      {Key? key,
      required this.onStartSaved,
      required this.onEndSaved,
      required this.startInitialValue,
      required this.endInitialValue})
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
          initialValue: startInitialValue,
        )),
        const SizedBox(width: 16.0),
        Expanded(
            child: CustomTextField(
          label: '마감 시간',
          isTime: true,
          onSaved: onEndSaved,
          initialValue: endInitialValue,
        ))
      ],
    );
  }
}

class _Content extends StatelessWidget {
  final FormFieldSetter<String> onSaved;
  final String initialValue;

  const _Content({Key? key, required this.onSaved, required this.initialValue})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: CustomTextField(
        label: '내용',
        isTime: false,
        onSaved: onSaved,
        initialValue: initialValue,
      ),
    );
  }
}

typedef ColorIdSetter = void Function(int id);

class _ColorPicker extends StatelessWidget {
  final List<CategoryColor> colors;
  final int? selectedColorId;
  final ColorIdSetter colorIdSetter;

  const _ColorPicker(
      {Key? key,
      required this.colors,
      required this.selectedColorId,
      required this.colorIdSetter})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8.0,
      runSpacing: 10.0,
      children: colors
          .map(
            (color) => GestureDetector(
                onTap: () {
                  colorIdSetter(color.id);
                },
                child: renderColor(color, selectedColorId == color.id)),
          )
          .toList(),
    );
  }

  Widget renderColor(CategoryColor categoryColor, bool isSelected) {
    return Container(
      width: 32.0,
      height: 32.0,
      decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Color(int.parse('FF${categoryColor.hexCode}', radix: 16)),
          border: isSelected
              ? Border.all(
                  color: Colors.black,
                  width: 4.0,
                )
              : null),
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
