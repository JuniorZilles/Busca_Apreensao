import 'package:flutter/material.dart';
import '../config/colors.dart';
import '../screens/statistics.dart';
import '../layout/dialog.dart';
import '../database/firebase.dart';
import '../screens/pesquisa.dart';
import '../models/statisticsModel.dart';

class CardEmAndamento extends StatefulWidget {
  final String userId;
  final String compania;
  CardEmAndamento(this.userId, this.compania);
  @override
  _CardEmAndamentoState createState() {
    return new _CardEmAndamentoState();
  }
}

class _CardEmAndamentoState extends State<CardEmAndamento> {
  final _definitions = ColorsDefinitions();
  final GlobalKey<State> _keyLoader = new GlobalKey<State>();
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(10.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          GestureDetector(
            onTap: () {
              Dialogs.showLoadingDialog(context, _keyLoader);
              FirebaseDatabaseSnapshot()
                  .getData('emandamento', widget.compania)
                  .then((snapshot) {
                Navigator.of(_keyLoader.currentContext, rootNavigator: true)
                    .pop(); //close the dialoge
                if (snapshot != null) {
                  showSearch(
                      context: context,
                      delegate: DataSearch('emandamento', snapshot.dados,
                          snapshot.nonetwork, widget.userId, widget.compania));
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content:
                          Text("Não foi posssível realizar a solicitação!")));
                }
              });
            },
            child: Container(
              height: 150,
              width: MediaQuery.of(context).size.width / 1.1,
              color: _definitions.obterThemeColor(),
              child: Container(
                alignment: Alignment.bottomLeft,
                margin: EdgeInsets.only(left: 15, bottom: 10),
                child: Text(
                  'Em Andamento',
                  style: TextStyle(
                    color: _definitions.obterThemeTextColor(),
                    fontSize: 25.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class CardConcluidos extends StatefulWidget {
  final String userId;
  final String compania;
  CardConcluidos(this.userId, this.compania);
  @override
  _CardConcluidosState createState() {
    return new _CardConcluidosState();
  }
}

class _CardConcluidosState extends State<CardConcluidos> {
  final _definitions = ColorsDefinitions();
  final GlobalKey<State> _keyLoader = new GlobalKey<State>();
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(10.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          GestureDetector(
            onTap: () {
              Dialogs.showLoadingDialog(context, _keyLoader);
              FirebaseDatabaseSnapshot()
                  .getData('concluidos', widget.compania)
                  .then((snapshot) {
                Navigator.of(_keyLoader.currentContext, rootNavigator: true)
                    .pop(); //close the dialoge
                if (snapshot != null) {
                  showSearch(
                      context: context,
                      delegate: DataSearch('concluidos', snapshot.dados,
                          snapshot.nonetwork, widget.userId, widget.compania));
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content:
                          Text("Não foi posssível realizar a solicitação!")));
                }
              });
            },
            child: Container(
              height: 150,
              width: MediaQuery.of(context).size.width / 1.1,
              color: _definitions.obterThemeColor(),
              child: Container(
                alignment: Alignment.bottomLeft,
                margin: EdgeInsets.only(left: 15, bottom: 10),
                child: Text(
                  'Concluidos',
                  style: TextStyle(
                    color: _definitions.obterThemeTextColor(),
                    fontSize: 25.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class CardEstatisticas extends StatefulWidget {
  final String compania;
  CardEstatisticas(this.compania);
  @override
  createState() => _CardEstatisticasState();
}

class _CardEstatisticasState extends State<CardEstatisticas> {
  final _definitions = ColorsDefinitions();
  final GlobalKey<State> _keyLoader = new GlobalKey<State>();

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(10.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          GestureDetector(
            onTap: () {
              Dialogs.showLoadingDialog(context, _keyLoader);
              FirebaseDatabaseSnapshot()
                  .getEstatisticaData(widget.compania)
                  .then((onValue) {
                Navigator.of(_keyLoader.currentContext, rootNavigator: true)
                    .pop(); //close the dialoge
                if (onValue != null) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (BuildContext context) => EstatisticsChart(
                          seriesList: Statistics().createSampleData(
                              onValue.carrosemandamento,
                              onValue.carrosconcluidos)),
                    ),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content:
                          Text("Não foi posssível realizar a solicitação!")));
                }
              });
            },
            child: Container(
              height: 150,
              width: MediaQuery.of(context).size.width / 1.1,
              color: _definitions.obterThemeColor(),
              child: Container(
                alignment: Alignment.bottomLeft,
                margin: EdgeInsets.only(left: 15, bottom: 10),
                child: Text(
                  'Estatísticas',
                  style: TextStyle(
                    color: _definitions.obterThemeTextColor(),
                    fontSize: 25.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
