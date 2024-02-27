import 'package:flutter/material.dart';
import 'package:duration_picker/duration_picker.dart';
import 'package:gym_app_client/utils/components/fields/form/padded_text_form_field.dart';
import 'package:gym_app_client/utils/common/helper_functions.dart';

class TrainingDurationFormField extends StatefulWidget {
  final Duration initDuration;
  final void Function(Duration) onDurationChanged;
  final Duration minDuration;
  final EdgeInsets padding;

  const TrainingDurationFormField({
    super.key,
    required this.initDuration,
    required this.minDuration,
    required this.onDurationChanged,
    required this.padding,
  });

  @override
  State<TrainingDurationFormField> createState() =>
      _TrainingDurationFormFieldState();
}

class _TrainingDurationFormFieldState extends State<TrainingDurationFormField> {
  late final TextEditingController _durationTextController;

  @override
  void initState() {
    _durationTextController =
        TextEditingController(text: durationToString(widget.initDuration));

    super.initState();
  }

  Future<Duration?> _selectDuration(BuildContext context) async {
    var pickedDuration = await showDurationPicker(
      context: context,
      initialTime: widget.initDuration,
    );

    return pickedDuration;
  }

  @override
  void dispose() {
    _durationTextController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PaddedTextFormField(
      padding: widget.padding,
      controller: _durationTextController,
      decoration: const InputDecoration(
        label: Text("Training Duration"),
        filled: true,
        prefixIcon: Icon(Icons.timer_outlined),
        enabledBorder: OutlineInputBorder(borderSide: BorderSide.none),
        focusedBorder:
            OutlineInputBorder(borderSide: BorderSide(color: Colors.blue)),
      ),
      validator: (_) {
        if (_durationTextController.text.isEmpty ||
            _durationTextController.text == "0:00:00") {
          return "Please select training duration";
        }

        return null;
      },
      readOnly: true,
      onTap: () async {
        Duration? pickedDuration = await _selectDuration(context);

        if (pickedDuration != null &&
            pickedDuration.compareTo(widget.minDuration) > 0) {
          _durationTextController.text = durationToString(pickedDuration);
          widget.onDurationChanged(pickedDuration);
        }
      },
    );
  }
}
