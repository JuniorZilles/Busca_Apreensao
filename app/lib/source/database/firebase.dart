import 'dart:async';
import 'dart:convert';
import 'package:firebase_database/firebase_database.dart';
import '../models/insertModel.dart';
import '../models/sqlModel.dart';
import '../models/rootModel.dart';
import '../models/parameterModel.dart';
import '../models/statisticsModel.dart';
import '../database/sqllite.dart';

//request por API
class FirebaseDatabaseSnapshot {
  Future<RootModel> getData(String status, String compania) async {
    RootModel _model;
    await FirebaseDatabase.instance
        .reference()
        .child(compania)
        .child('placas')
        .child(status)
        .once()
        .then((DataSnapshot snapshot) async {
      if (snapshot != null) {
        String dados = jsonEncode(snapshot.value);
        Map<String, dynamic> mapeamento = json.decode(dados);
        _model = RootModel.fromSnapshot(mapeamento);
        ContentModel model1 = ContentModel(dados, status);
        await SqlLite().insertData(model1, status);
      }
    }).timeout(Duration(minutes: 1), onTimeout: () async {
      await SqlLite()
          .getSearchData(status)
          .then((List<Map<String, dynamic>> mapeamento) {
        if (mapeamento.length > 0) {
          Map<String, dynamic> maps = json.decode(mapeamento[0]['json']);
          if (maps != null) {
            _model = RootModel.fromSnapshot(maps);
            _model.nonetwork = false;
          }
        }
      });
    }).catchError((onError) {
      print('firebase.getData: ' + onError.toString());
      return null;
    });
    return _model;
  }

  Future<bool> setInsert(
      InsertModel model, String status, String compania) async {
    FirebaseDatabase database = new FirebaseDatabase();
    return await database
        .reference()
        .child(compania)
        .child('placas')
        .child(status)
        .push()
        .set(model.toJson())
        .then((onValue) {
      return true;
    }).timeout(Duration(minutes: 1), onTimeout: () {
      return false;
    }).catchError((onError) {
      print('firebase.setInsert: ' + onError.toString());
      return false;
    });
  }

  Future<bool> remove(String key, String status, String compania) async {
    FirebaseDatabase database = new FirebaseDatabase();
    return await database
        .reference()
        .child(compania)
        .child('placas')
        .child(status)
        .child(key)
        .remove()
        .then((snapshot) {
      return true;
    }).catchError((onError) {
      print('firebase.remove: ' + onError.toString());
      return null;
    });
  }

  Future<bool> update(
      InsertModel model, String status, String compania, String userId) async {
    remove(model.key, 'emandamento', compania).then((value) {
      if (value) {
        model.dataAlteracao = DateTime.now();
        model.userAlteracao = userId;
        setInsert(model, status, compania).then((val) {
          return val;
        });
      }
      return value;
    }).catchError((onError) {
      print('firebase.update: ' + onError.toString());
      return false;
    });
    return true;
  }

  Future<CarFounds> getEstatisticaData(String compania) async {
    CarFounds _model;
    await FirebaseDatabase.instance
        .reference()
        .child(compania)
        .child('estatisticas')
        .once()
        .then((DataSnapshot snapshot) async {
      if (snapshot != null) {
        String dados = jsonEncode(snapshot.value);
        Map<String, dynamic> mapeamento = json.decode(dados);
        _model = CarFounds.fromSnapshot(mapeamento);
        ContentModel model1 = ContentModel(dados, 'estatisticas');
        await SqlLite().insertData(model1, 'estatisticas');
      }
    }).timeout(Duration(minutes: 1), onTimeout: () async {
      await SqlLite()
          .getSearchData('estatisticas')
          .then((List<Map<String, dynamic>> mapeamento) {
        if (mapeamento.length > 0) {
          Map<String, dynamic> maps = json.decode(mapeamento[0]['json']);
          if (maps != null) {
            _model = CarFounds.fromSnapshot(maps);
          }
        }
      });
    }).catchError((onError) {
      print('firebase.getEstatisticaData: ' + onError.toString());
      return null;
    });
    return _model;
  }

  Future<ParameterModel> getUserCompanie(String idUser) async {
    ParameterModel _model = ParameterModel();
    await FirebaseDatabase.instance
        .reference()
        .child('usuarios')
        .child(idUser)
        .once()
        .then((DataSnapshot snapshot) async {
      if (snapshot != null) {
        List<String> companies = snapshot.value.toString().split(',');
        for (String compania in companies) {
          await getLogoCompanie(compania).then((onValue) {
            if (onValue != '') {
              String urlImagem = onValue;
              _model.model.add(ParameterItemModel(compania, urlImagem));
            }
          });
        }
      }
    }).catchError((onError) {
      print('firebase.getUserCompanie: ' + onError.toString());
      return null;
    });
    return _model;
  }

  Future<String> getLogoCompanie(String compania) async {
    String url = '';
    await FirebaseDatabase.instance
        .reference()
        .child(compania)
        .child('parameters')
        .child('logo')
        .once()
        .then((DataSnapshot snapshot) async {
      if (snapshot != null) {
        url = snapshot.value;
      }
    }).catchError((onError) {
      print('firebase.getLogoCompanie: ' + onError.toString());
      return url;
    });
    return url;
  }
}
