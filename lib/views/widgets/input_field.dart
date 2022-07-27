import 'package:flutter/material.dart';

// ignore: must_be_immutable
class InputField extends StatelessWidget {
  final String title;

  Widget? widget;
  final String? hint;
  TextEditingController? controller;
  InputField(
      {Key? key,
      this.widget,
      required this.title,
      required this.hint,
      this.controller})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style:const TextStyle(fontSize: 20, color: Colors.black),
        ),
        const SizedBox(
          height: 5,
        ),
        TextFormField(
          maxLines: 3,
          minLines: 1,
          style: Theme.of(context)
              .textTheme
              .bodyText1!
              .copyWith(fontFamily: "def"),
          controller: controller,
          readOnly: widget == null ? false : true,
          decoration: InputDecoration(
            suffixIconColor: Colors.indigo,
            filled: true,
            fillColor: Colors.grey.shade200,
            hintText: hint,
            labelStyle:const TextStyle(fontFamily: "imp", fontSize: 40),
            suffixIcon: widget,
            enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(5),
                borderSide: BorderSide(color: Colors.grey.shade200)),
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(5),
                borderSide: BorderSide(color: Colors.grey.shade200)),
            focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),
                borderSide: BorderSide(color: Colors.green.shade200)),
          ),
        )
      ],
    );
  }
}
