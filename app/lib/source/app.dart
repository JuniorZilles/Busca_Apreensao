import 'package:flutter/material.dart';
import 'security/mapping.dart';
import 'security/authentication.dart';
import 'security/authprovider.dart';
import 'config/colors.dart';
import 'config/text.dart';

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AuthProvider(
      auth: Auth(),
      child: MaterialApp(
        title: TextDefinition().obterAppHomeText(),
        theme: ThemeData(
          primarySwatch: ColorsDefinitions().obterAppTheme(),
        ),
        home: MappingPage(),
      ),
    );
  }
}
