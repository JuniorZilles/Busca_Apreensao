import 'dart:async';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'authentication.dart';
import 'authprovider.dart';
import '../database/firebase.dart';
import '../models/parameterModel.dart';
import '../screens/login.dart';
import '../screens/home.dart';
import '../screens/splashPage.dart';
import '../screens/error.dart';

class MappingPage extends StatefulWidget {
  @override
  createState() => _MappingPageState();
}

enum AuthStatus {
  loading,
  notSignedIn,
  signIn,
  notAutorized,
}

class _MappingPageState extends State<MappingPage> {
  AuthStatus _authStatus = AuthStatus.loading;
  User _user;
  ParameterModel _model;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final AuthImplementation auth = AuthProvider.of(context).auth;
    ParameterModel temp;
    auth.getCurrentUser().then((User user) async {
      Timer(Duration(minutes: 5), () => {});
      if (user != null) {
        await FirebaseDatabaseSnapshot()
            .getUserCompanie(user.uid)
            .then((onValue) {
          temp = onValue;
          print(temp.model.length);
          setState(() {
            _user = user;
            _authStatus = user == null
                ? AuthStatus.notSignedIn
                : temp.model == null
                    ? AuthStatus.notAutorized
                    : AuthStatus.signIn;
            _model = temp;
          });
        });
      }
      setState(() {
        _authStatus = AuthStatus.notSignedIn;
      });
    });
  }

  void _signedIn() {
    final AuthImplementation auth = AuthProvider.of(context).auth;
    ParameterModel temp;
    auth.getCurrentUser().then((User user) async {
      print(user.uid);
      await FirebaseDatabaseSnapshot()
          .getUserCompanie(user.uid)
          .then((onValue) {
        temp = onValue;
        setState(() {
          _user = user;
          _authStatus =
              temp.model == null ? AuthStatus.notAutorized : AuthStatus.signIn;
          _model = temp;
        });
      });
    });
  }

  void _signedOut() {
    setState(() {
      _authStatus = AuthStatus.notSignedIn;
    });
  }

  @override
  Widget build(BuildContext context) {
    switch (_authStatus) {
      case AuthStatus.loading:
        return Splash().screen();
      case AuthStatus.notSignedIn:
        return Login(onSignedIn: _signedIn);
      case AuthStatus.notAutorized:
        return ErrorScreen()
            .screen('Acesso não autorizado, aguarde a liberação');
      case AuthStatus.signIn:
        return Home(onSignedOut: _signedOut, user: _user, model: _model);
    }
    return null;
  }
}
