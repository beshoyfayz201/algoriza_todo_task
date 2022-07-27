import 'package:flutter/material.dart';

// ignore: must_be_immutable
class TxtField extends StatefulWidget {
  final TextEditingController textEditingController;
  String label;
  final IconData? icon;
  final bool readOnly;
  String? hint;
  String? Function(String?) valid;
  TxtField({
    Key? key,
    this.hint,
    required this.valid,
    required this.textEditingController,
    required this.label,
    this.icon,
    this.readOnly = false,
  }) : super(key: key);

  @override
  State<TxtField> createState() => _TxtFieldState();
}

class _TxtFieldState extends State<TxtField> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding:const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      child: TextFormField(
          controller: widget.textEditingController,
          onTap: widget.hint == "pick a time"
              ? () async {
                  TimeOfDay? t = await showTimePicker(
                      context: context, initialTime: TimeOfDay.now());
                  if (t != null) {
                    setState(() {
                      widget.label = t.format(context);
                      widget.textEditingController.text = t.format(context);
                    });
                  }
                }
              : () {},
          textAlign: TextAlign.start,
          decoration: InputDecoration(
              label: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Text(widget.label),
              ),
              prefixIcon: widget.label == "Time" ? Icon(widget.icon) : null,
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(5)),
              hintText: widget.hint,
              filled: true,
              fillColor: Colors.grey.shade100),
          readOnly: widget.readOnly,
          validator: widget.valid),
    );
  }
}
