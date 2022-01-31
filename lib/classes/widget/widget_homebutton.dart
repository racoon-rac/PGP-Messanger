import 'package:flutter/material.dart';

class HomeButton extends StatelessWidget {
  final String text;
  final Icon? rightSideIcon;
  final void Function()? onPressed;
  const HomeButton(
      {Key? key,
      required this.text,
      required this.onPressed,
      this.rightSideIcon})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ElevatedButton(
        child: Container(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(text,
                      style:
                          const TextStyle(fontSize: 16, fontFamily: 'Roboto')),
                  if (rightSideIcon is Icon) rightSideIcon!,
                ]),
          ),
          alignment: Alignment.centerLeft,
        ),
        onPressed: onPressed,
      ),
    );
  }
}
