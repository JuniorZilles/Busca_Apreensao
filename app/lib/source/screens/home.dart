import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../security/authprovider.dart';
import '../security/authentication.dart';
import '../models/parameterModel.dart';
import '../screens/insert.dart';
import '../layout/card.dart';
import '../layout/dropDownItem.dart';
import '../config/colors.dart';
import '../config/text.dart';
import '../app.dart';

class Home extends StatefulWidget {
  final User user;
  final VoidCallback onSignedOut;
  final ParameterModel model;

  Home({this.onSignedOut, this.user, this.model});
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final _definition = ColorsDefinitions();
  String _companieNameSelected = '';
  String _companieURLSelected = '';

  @override
  initState() {
    _companieNameSelected = widget.model.model.first.compania;
    _companieURLSelected = widget.model.model.first.urlImagem;
    super.initState();
  }

  Future<void> _logout(BuildContext context) async {
    try {
      final AuthImplementation auth = AuthProvider.of(context).auth;
      await auth.signOut();
      widget.onSignedOut();
    } catch (e) {
      print(e);
    }
  }

  Future<bool> _back() {
    return showDialog(
          context: context,
          builder: (context) => new AlertDialog(
            title: new Text('Deseja sair?'),
            actions: <Widget>[
              ElevatedButton(
                child: Text(
                  'Não',
                  style: TextStyle(
                    color: ColorsDefinitions().obterThemeColor(),
                  ),
                ),
                onPressed: () => Navigator.of(context).pop(false),
              ),
              ElevatedButton(
                child: Text(
                  'Sim',
                  style: TextStyle(
                    color: ColorsDefinitions().obterThemeColor(),
                  ),
                ),
                onPressed: () => Navigator.of(context).pop(true),
              ),
            ],
          ),
        ) ??
        false;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _back,
      child: Scaffold(
        appBar: AppBar(
          title: Text(TextDefinition().obterAppHomeText()),
          backgroundColor: _definition.obterThemeColor(),
          actions: <Widget>[
            DropdownButton<int>(
                underline: Container(
                  color: _definition.obterThemeColor(),
                ),
                icon: CachedNetworkImage(
                  imageUrl: _companieURLSelected,
                  imageBuilder: (context, imageProvider) => Container(
                    width: 45.0,
                    height: 45.0,
                    decoration: new BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      image: new DecorationImage(
                        fit: BoxFit.fitWidth,
                        image: imageProvider,
                      ),
                    ),
                  ),
                  placeholder: (context, url) => new Container(
                    width: 45.0,
                    height: 45.0,
                    decoration: new BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      image: new DecorationImage(
                        fit: BoxFit.fitWidth,
                        image: new AssetImage('assets/jds.png'),
                      ),
                    ),
                  ),
                ),
                onChanged: (int newValue) {
                  setState(() {
                    _companieURLSelected =
                        widget.model.model[newValue].urlImagem;
                    _companieNameSelected =
                        widget.model.model[newValue].compania;
                  });
                },
                items: DropDownItens().getCompaniesToDropdownList(widget.model))
          ],
        ),
        body: Center(
          child: ListView(
            shrinkWrap: true,
            padding: EdgeInsets.all(10.0),
            children: <Widget>[
              CardEmAndamento(widget.user.uid, _companieNameSelected),
              CardConcluidos(widget.user.uid, _companieNameSelected),
              CardEstatisticas(_companieNameSelected),
            ],
          ),
        ),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: 0,
          elevation: 0.0,
          type: BottomNavigationBarType.fixed,
          items: [
            BottomNavigationBarItem(
              icon: Icon(
                Icons.home,
                color: _definition.obterThemeColor(),
              ),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.add,
                color: _definition.obterThemeColor(),
              ),
              label: 'Adicionar Placa',
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.exit_to_app,
                color: _definition.obterThemeColor(),
              ),
              label: 'Logout',
            ),
          ],
          onTap: (index) {
            if (index == 1) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (BuildContext context) =>
                      InsertPlates(widget.user.uid, _companieNameSelected),
                ),
              );
            } else if (index == 2) {
              _logout(context);
              Navigator.of(context).pop();
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (BuildContext context) => App(),
                ),
              );
            }
          },
        ),
      ),
    );
  }
}
