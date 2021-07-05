import 'package:busca_apreensao/source/config/images.dart';
import 'package:flutter/material.dart';
import '../security/authentication.dart';
import '../security/authprovider.dart';
import '../layout/dialog.dart';
import '../config/colors.dart';
import '../config/errors.dart';

class Login extends StatefulWidget {
  final VoidCallback onSignedIn;

  Login({this.onSignedIn});

  @override
  createState() => _LoginState();
}

class EmailFieldValidator {
  static String validate(String value) {
    return value.isEmpty ? 'Email não pode ser vazio' : null;
  }
}

class PasswordFieldValidator {
  static String validate(String value) {
    return value.isEmpty ? 'Senha não pode ser vazia' : null;
  }
}

enum FormType { login, register }

class _LoginState extends State<Login> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  FormType _formType = FormType.login;
  String _email = "";
  String _password = "";
  String _label = 'Login';
  String _label1 = 'Criar Conta';
  final GlobalKey<State> _keyLoader = new GlobalKey<State>();
  final GlobalKey<State> _keyContainer = new GlobalKey<State>();

  bool validateAndSave() {
    final FormState form = _formKey.currentState;
    if (form.validate()) {
      form.save();
      return true;
    }
    return false;
  }

  Future<void> validateAndSubmit() async {
    if (validateAndSave()) {
      Dialogs.showLoadingDialog(context, _keyLoader); //invoking login
      try {
        final AuthImplementation auth = AuthProvider.of(context).auth;
        if (_formType == FormType.login) {
          await auth.signIn(_email, _password);
        } else {
          await auth.createUser(_email, _password);
        }
        Navigator.of(_keyLoader.currentContext, rootNavigator: true)
            .pop(); //close the dialoge
        widget.onSignedIn();
      } catch (e) {
        Navigator.of(_keyLoader.currentContext, rootNavigator: true)
            .pop(); //close the dialoge
        getErrors(e.toString());
      }
    }
  }

  Future<void> validateAndResetPassword() async {
    if (validateAndSave()) {
      try {
        final AuthImplementation auth = AuthProvider.of(context).auth;
        await auth.requestNewPassword(_email);
        ScaffoldMessenger.of(_keyContainer.currentContext).showSnackBar(
          SnackBar(
            content: Text(
                'O link de recuperação foi enviado para sua conta de email com sucesso!'),
          ),
        );
      } catch (e) {
        getErrors(e.toString());
      }
    }
  }

  void getErrors(String erro) {
    String _mensagem = ErrorDefinition().obterLoginErrors(erro);
    ScaffoldMessenger.of(_keyContainer.currentContext)
        .showSnackBar(SnackBar(content: Text(_mensagem)));
  }

  void moveToRegister() {
    _formKey.currentState.reset();
    setState(() {
      _formType = FormType.register;
      _label = 'Registrar';
      _label1 = 'Fazer Login';
    });
  }

  void moveToLogin() {
    _formKey.currentState.reset();
    setState(() {
      _formType = FormType.login;
      _label = 'Login';
      _label1 = 'Criar Conta';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: <Widget>[
          SliverList(
            delegate: SliverChildListDelegate(
              [
                Container(
                  key: _keyContainer,
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: <Widget>[
                        Container(
                          width: MediaQuery.of(context).size.width,
                          height: MediaQuery.of(context).size.height / 2.3,
                          decoration: BoxDecoration(
                            color: ColorsDefinitions().obterThemeSecundary(),
                            borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(70),
                            ),
                          ),
                          child: Container(
                            width: MediaQuery.of(context).size.width,
                            height: MediaQuery.of(context).size.height / 2.3,
                            child: Stack(
                              alignment: Alignment.center,
                              children: <Widget>[
                                CircleAvatar(
                                  radius: 90,
                                  backgroundImage: ImageDefinition()
                                      .obterIconAsImageProvider(),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.only(top: 42),
                          child: Column(
                            children: <Widget>[
                              Container(
                                width: MediaQuery.of(context).size.width / 1.2,
                                height: 50,
                                padding: EdgeInsets.only(
                                  top: 4,
                                  left: 16,
                                  right: 16,
                                  bottom: 4,
                                ),
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(40)),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black26,
                                        blurRadius: 5,
                                      ),
                                    ]),
                                child: TextFormField(
                                  decoration: InputDecoration(
                                      fillColor: Colors.black,
                                      hintText: 'Email',
                                      icon: Icon(Icons.email)),
                                  validator: EmailFieldValidator.validate,
                                  onSaved: (String value) {
                                    return _email = value.trim();
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.only(top: 32),
                          child: Column(
                            children: <Widget>[
                              Container(
                                width: MediaQuery.of(context).size.width / 1.2,
                                height: 50,
                                padding: EdgeInsets.only(
                                  top: 4,
                                  left: 16,
                                  right: 16,
                                  bottom: 4,
                                ),
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(40)),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black26,
                                        blurRadius: 5,
                                      ),
                                    ]),
                                child: TextFormField(
                                  obscureText: true,
                                  decoration: InputDecoration(
                                      fillColor: Colors.black,
                                      hintText: 'Senha',
                                      icon: Icon(Icons.vpn_key)),
                                  validator: PasswordFieldValidator.validate,
                                  onSaved: (String value) {
                                    return _password = value.trim();
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                        Align(
                          alignment: Alignment.centerRight,
                          child: Padding(
                            padding: EdgeInsets.only(right: 8.0),
                            child: ElevatedButton(
                              child: Text(
                                'Esqueci a senha',
                                style: TextStyle(
                                    fontSize: 12.5, color: Colors.black),
                              ),
                              onPressed: (() {
                                FocusScope.of(context)
                                    .requestFocus(new FocusNode());
                                validateAndResetPassword();
                              }),
                            ),
                          ),
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width / 1.2,
                          height: 50,
                          decoration: BoxDecoration(
                            color: ColorsDefinitions().obterThemeSecundary(),
                            borderRadius: BorderRadius.all(Radius.circular(40)),
                          ),
                          child: ElevatedButton(
                            child: Text(
                              _label,
                              style: TextStyle(
                                  fontSize: 20.0, color: Colors.white),
                            ),
                            onPressed: (() {
                              FocusScope.of(context)
                                  .requestFocus(new FocusNode());
                              validateAndSubmit();
                            }),
                          ),
                        ),
                        ElevatedButton(
                          child: Text(
                            _label1,
                            style:
                                TextStyle(fontSize: 15.0, color: Colors.black),
                          ),
                          onPressed: _formType == FormType.login
                              ? moveToRegister
                              : moveToLogin,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
