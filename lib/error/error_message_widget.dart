import 'package:flutter/material.dart';
import 'package:doctor_app/res/size.dart';

class ErrorMessage extends StatelessWidget {
  final String message;
  final bool bottomPadding;

  const ErrorMessage({Key key, this.message, this.bottomPadding=true}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return this.message == null || this.message == ""
        ? Container()
        : Padding(
            padding: const EdgeInsets.only(bottom: 15),
            child: Text(
              this.message ?? "",
              style: TextStyle(
                  fontSize: size.convert(context, 12), color: Colors.red[800]),
            ),
          );
  }
}
