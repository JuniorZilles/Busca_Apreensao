import 'package:flutter/material.dart';
import '../config/colors.dart';
import '../models/insertModel.dart';
import '../database/firebase.dart';

class DataSearch extends SearchDelegate<String> {
  final String status;
  final String userId;
  final String compania;
  List<InsertModel> model;
  bool network;

  DataSearch(this.status, this.model, this.network, this.userId, this.compania);

  List<InsertModel> recentes = [];

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      )
    ];
  }

  @override
  ThemeData appBarTheme(BuildContext context) {
    assert(context != null);
    final ThemeData theme = ThemeData.dark();
    assert(theme != null);
    return theme.copyWith(
      primaryColor: ColorsDefinitions().obterThemeColor(),
      inputDecorationTheme: InputDecorationTheme(
        focusColor: ColorsDefinitions().obterThemeTextColor(),
        hintStyle: TextStyle(
            color:
                ColorsDefinitions().obterThemeTextColor()), //, fontSize: 20.0
      ),
    );
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: AnimatedIcon(
        icon: AnimatedIcons.menu_arrow,
        progress: transitionAnimation,
      ),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    final suggestionsList = query.isEmpty
        ? recentes
        : model
            .where((p) =>
                p.modelo.toLowerCase().contains(query.toLowerCase()) ||
                p.placa.toLowerCase().contains(query.toLowerCase()) ||
                p.cor.toLowerCase().contains(query.toLowerCase()) ||
                p.marca.toLowerCase().contains(query.toLowerCase()) ||
                p.ano.toLowerCase().contains(query.toLowerCase()) ||
                p.observacao.toLowerCase().contains(query.toLowerCase()))
            .toList();
    return obterListView(suggestionsList, suggestionsList.length);
  }

  Widget obterBackgroundConcluir() {
    return Container(
      child: Icon(Icons.check_circle, color: Colors.white),
      color: Colors.green,
      alignment: Alignment.centerLeft,
      padding: EdgeInsets.only(left: 7),
    );
  }

  Widget obterBackgroundConcluir2() {
    return Container(
      child: Icon(Icons.check_circle, color: Colors.white),
      color: Colors.green,
      alignment: Alignment.centerRight,
      padding: EdgeInsets.only(right: 7),
    );
  }

  Widget obterBackgroundEmAndamento() {
    return Container(
      child: Icon(Icons.delete, color: Colors.white),
      color: Colors.red,
      alignment: Alignment.centerRight,
      padding: EdgeInsets.only(right: 7),
    );
  }

  Widget obterBackgroundEmAndamento2() {
    return Container(
      child: Icon(Icons.delete, color: Colors.white),
      color: Colors.red,
      alignment: Alignment.centerLeft,
      padding: EdgeInsets.only(left: 7),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    recentes = model;
    final suggestionsList = query.isEmpty
        ? recentes
        : model
            .where((p) =>
                p.modelo.toLowerCase().contains(query.toLowerCase()) ||
                p.placa.toLowerCase().contains(query.toLowerCase()) ||
                p.cor.toLowerCase().contains(query.toLowerCase()) ||
                p.marca.toLowerCase().contains(query.toLowerCase()) ||
                p.ano.toLowerCase().contains(query.toLowerCase()) ||
                p.observacao.toLowerCase().contains(query.toLowerCase()))
            .toList();

    return obterListView(suggestionsList, suggestionsList.length);
  }

  Widget obterListView(List<InsertModel> suggestionsList, int qtd) {
    return ListView.builder(
      itemCount: qtd,
      itemBuilder: (context, index) {
        return Dismissible(
          key: Key(suggestionsList[index].key),
          onDismissed: (direction) {
            if (network) {
              if (status == 'concluidos') {
                final placa = suggestionsList[index].placa;
                FirebaseDatabaseSnapshot()
                    .remove(suggestionsList[index].key, status, compania)
                    .then((onValue) {
                  if (onValue) {
                    model.remove(
                        (InsertModel a) => a.key == suggestionsList[index].key);
                    recentes = model;
                    suggestionsList.removeAt(index);
                    qtd--;
                    ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("Placa $placa removida")));
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content:
                            Text("Não foi posssível realizar a solicitação!")));
                  }
                });
              } else {
                FirebaseDatabaseSnapshot()
                    .update(
                        suggestionsList[index], 'concluidos', compania, userId)
                    .then((onValue) {
                  if (onValue) {
                    model.remove(
                        (InsertModel a) => a.key == suggestionsList[index].key);
                    recentes = model;
                    suggestionsList.removeAt(index);
                    qtd--;
                    ScaffoldMessenger.of(context)
                        .showSnackBar(SnackBar(content: Text("Placa movida")));
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content:
                            Text("Não foi posssível realizar a solicitação!")));
                  }
                });
              }
            } else {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text(
                      "Verifique a conexão com a internet e retorne para a página inicial!")));
            }
          },
          background: status != 'concluidos'
              ? obterBackgroundConcluir()
              : obterBackgroundEmAndamento2(),
          secondaryBackground: status != 'concluidos'
              ? obterBackgroundConcluir2()
              : obterBackgroundEmAndamento(),
          child: ListTile(
            leading: Icon(Icons.directions_car),
            title: Text(suggestionsList[index].placa),
            subtitle: Text(suggestionsList[index].modelo),
            //trailing: Icon(Icons.arrow_downward),
            onTap: () {
              obterCorpoDialogo(context, suggestionsList[index]);
            },
          ),
        );
      },
    );
  }

  void obterCorpoDialogo(BuildContext context, InsertModel model) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(model.placa),
        content: Container(
          height: MediaQuery.of(context).size.height / 5,
          child: SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: MediaQuery.of(context).size.height / 5,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    child: Text('Modelo: ' + model.modelo),
                  ),
                  Container(
                    child: Text('Marca: ' + model.marca),
                  ),
                  Container(
                    child: Text('Ano: ' + model.ano),
                  ),
                  Container(
                    child: Text('Cor: ' + model.cor),
                  ),
                  Container(
                    child: Text('Observação: ' + model.observacao),
                  ),
                ],
              ),
            ),
          ),
        ),
        actions: <Widget>[
          ElevatedButton(
            child: Text(
              'Ok',
              style: TextStyle(
                color: ColorsDefinitions().obterThemeColor(),
              ),
            ),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      ),
    );
  }
}
