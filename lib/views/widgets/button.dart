import 'package:flutter/material.dart';

class WideButton extends StatelessWidget {
  final Function onpressed;
  final String text;
  const WideButton({Key? key, required this.onpressed, required this.text})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: TextButton(
        style: TextButton.styleFrom(
            backgroundColor: Colors.green,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10))),
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.all(5.0),
              child: Text(
                text,
                style:const TextStyle(color: Colors.white, fontSize: 15),
              ),
            )
          ],
          mainAxisAlignment: MainAxisAlignment.center,
        ),
        onPressed: () {
          onpressed();
        },
      ),
    );
  }
}
