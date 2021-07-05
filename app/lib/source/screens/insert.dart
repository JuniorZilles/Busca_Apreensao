import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../config/colors.dart';
import '../models/insertModel.dart';
import '../layout/dialog.dart';
import '../database/firebase.dart';

class InsertPlates extends StatefulWidget {
  final String userId;
  final String compania;
  InsertPlates(this.userId, this.compania);
  @override
  createState() => _InsertPlatesState();
}

class PlateFieldValidator {
  static String validate(String value) {
    return value.isEmpty ? 'Placa não pode ser vazia' : null;
  }
}

class _InsertPlatesState extends State<InsertPlates> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  InsertModel _model = InsertModel('', '', '', '', '', '', '', '', '');
  final GlobalKey<State> _keyLoader = new GlobalKey<State>();
  final GlobalKey<State> _keyContainer = new GlobalKey<State>();
  final FocusNode _placaNode = FocusNode();
  final FocusNode _modeloNode = FocusNode();
  final FocusNode _marcaNode = FocusNode();
  final FocusNode _anoNode = FocusNode();
  final FocusNode _corNode = FocusNode();
  final FocusNode _observacaoNode = FocusNode();

  @override
  void dispose() {
    _placaNode.dispose();
    _modeloNode.dispose();
    _marcaNode.dispose();
    _anoNode.dispose();
    _corNode.dispose();
    _observacaoNode.dispose();
    super.dispose();
  }

  bool validateAndSave() {
    final FormState form = _formKey.currentState;
    if (form.validate()) {
      form.save();
      return true;
    }
    return false;
  }

  Future<void> validateAndSubmit() async {
    _model.userInclusao = widget.userId;
    _model.userAlteracao = widget.userId;
    if (validateAndSave()) {
      Dialogs.showLoadingDialog(_keyContainer.currentContext, _keyLoader);
      FirebaseDatabaseSnapshot()
          .setInsert(_model, 'emandamento', widget.compania)
          .then((result) {
        Navigator.of(_keyLoader.currentContext, rootNavigator: true).pop();
        if (result == false) {
          ScaffoldMessenger.of(_keyContainer.currentContext).showSnackBar(
            SnackBar(
              content: Text('Não foi possível realizar a solicitação!'),
            ),
          );
        } else {
          _formKey.currentState.reset();
          ScaffoldMessenger.of(_keyContainer.currentContext).showSnackBar(
            SnackBar(
              content: Text('Dado incluido com sucesso!'),
            ),
          );
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final definitions = ColorsDefinitions();
    return Scaffold(
      appBar: new AppBar(
        title: new Text('Incluir placa'),
        backgroundColor: definitions.obterThemeColor(),
      ),
      body: SingleChildScrollView(
        key: _keyContainer,
        padding: EdgeInsets.only(
          top: 16,
          left: 16,
          right: 16,
          bottom: 16,
        ),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                width: MediaQuery.of(context).size.width / 1.1,
                height: 70,
                padding: EdgeInsets.only(
                  top: 16,
                  left: 16,
                  right: 16,
                  bottom: 16,
                ),
                child: TextFormField(
                    textCapitalization: TextCapitalization.characters,
                    autofocus: true,
                    decoration: InputDecoration(
                      fillColor: definitions.obterText(),
                      hintText: 'Placa',
                    ),
                    validator: PlateFieldValidator.validate,
                    onSaved: (String value) {
                      return _model.placa = value.trim();
                    },
                    focusNode: _placaNode,
                    onFieldSubmitted: (term) {
                      _placaNode.unfocus();
                      FocusScope.of(context).requestFocus(_modeloNode);
                    }),
              ),
              Container(
                width: MediaQuery.of(context).size.width / 1.1,
                height: 70,
                padding: EdgeInsets.only(
                  top: 16,
                  left: 16,
                  right: 16,
                  bottom: 16,
                ),
                child: TextFormField(
                  textCapitalization: TextCapitalization.sentences,
                  decoration: InputDecoration(
                    fillColor: definitions.obterText(),
                    hintText: 'Modelo',
                  ),
                  focusNode: _modeloNode,
                  onFieldSubmitted: (term) {
                    _modeloNode.unfocus();
                    FocusScope.of(context).requestFocus(_marcaNode);
                  },
                  onSaved: (String value) {
                    return _model.modelo = value.trim();
                  },
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width / 1.1,
                height: 70,
                padding: EdgeInsets.only(
                  top: 16,
                  left: 16,
                  right: 16,
                  bottom: 16,
                ),
                child: TextFormField(
                  textCapitalization: TextCapitalization.sentences,
                  decoration: InputDecoration(
                    fillColor: definitions.obterText(),
                    hintText: 'Marca',
                  ),
                  focusNode: _marcaNode,
                  onFieldSubmitted: (term) {
                    _marcaNode.unfocus();
                    FocusScope.of(context).requestFocus(_anoNode);
                  },
                  onSaved: (String value) {
                    return _model.marca = value.trim();
                  },
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width / 1.1,
                height: 70,
                padding: EdgeInsets.only(
                  top: 40,
                  left: 16,
                  right: 16,
                  bottom: 0,
                ),
                child: TextFormField(
                  maxLength: 4,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    fillColor: definitions.obterText(),
                    hintText: 'Ano',
                  ),
                  focusNode: _anoNode,
                  onFieldSubmitted: (term) {
                    _anoNode.unfocus();
                    FocusScope.of(context).requestFocus(_corNode);
                  },
                  onSaved: (String value) {
                    return _model.ano = value.trim();
                  },
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width / 1.1,
                height: 70,
                padding: EdgeInsets.only(
                  top: 16,
                  left: 16,
                  right: 16,
                  bottom: 16,
                ),
                child: TextFormField(
                  textCapitalization: TextCapitalization.sentences,
                  decoration: InputDecoration(
                    fillColor: definitions.obterText(),
                    hintText: 'Cor',
                  ),
                  focusNode: _corNode,
                  onFieldSubmitted: (term) {
                    _corNode.unfocus();
                    FocusScope.of(context).requestFocus(_observacaoNode);
                  },
                  onSaved: (String value) {
                    return _model.cor = value.trim();
                  },
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width / 1.1,
                height: 70,
                padding: EdgeInsets.only(
                  top: 16,
                  left: 16,
                  right: 16,
                  bottom: 16,
                ),
                child: TextFormField(
                  textCapitalization: TextCapitalization.sentences,
                  keyboardType: TextInputType.multiline,
                  decoration: InputDecoration(
                    fillColor: definitions.obterText(),
                    hintText: 'Observação',
                  ),
                  focusNode: _observacaoNode,
                  onSaved: (String value) {
                    return _model.observacao = value.trim();
                  },
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(
                      top: 16,
                      left: 16,
                      right: 16,
                    ),
                    child: ElevatedButton(
                      child: Text(
                        'Limpar',
                        style: TextStyle(
                            fontSize: 20.0,
                            color: ColorsDefinitions().obterThemeColor()),
                      ),
                      onPressed: (() {
                        _formKey.currentState.reset();
                      }),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                      top: 16,
                      left: 16,
                      right: 16,
                    ),
                    child: ElevatedButton(
                      child: Text(
                        'Salvar',
                        style: TextStyle(
                            fontSize: 20.0,
                            color: ColorsDefinitions().obterThemeColor()),
                      ),
                      onPressed: (() {
                        FocusScope.of(context).requestFocus(new FocusNode());
                        validateAndSubmit();
                      }),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
