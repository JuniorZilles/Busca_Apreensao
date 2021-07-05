import 'package:flutter/material.dart';
import '../config/colors.dart';
import '../config/text.dart';

class ErrorScreen {
  final _definition = ColorsDefinitions();
  Widget screen(String message) {
    return Scaffold(
      appBar: AppBar(
          title: Text(TextDefinition().obterAppHomeText()),
          backgroundColor: _definition.obterThemeColor()),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(Icons.error, color: _definition.obterText(), size: 200.0),
            Container(
              padding: EdgeInsets.only(left: 30.0, right: 20.0, top: 20.0),
              child: Text(
                message,
                style: TextStyle(
                  color: _definition.obterText(),
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
