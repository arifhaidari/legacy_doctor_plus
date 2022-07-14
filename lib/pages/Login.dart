import 'package:doctor_app/transulation/translations_delegate_base.dart';
import 'package:flutter/material.dart';
class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(TranslationBase.of(context).subTitle,),),
    );
  }
}
