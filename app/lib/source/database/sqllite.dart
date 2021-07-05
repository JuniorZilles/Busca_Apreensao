import 'dart:async';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import '../models/sqlModel.dart';

class SqlLite {
  dadospesquisa() async {
    return openDatabase(
      join(await getDatabasesPath(), 'busca.db'),
      onCreate: (db, version) {
        return db.execute(
          "CREATE TABLE dados(id INTEGER PRIMARY KEY, json TEXT, info TEXT)",
        );
      },
      version: 1,
    );
  }

  dadospessoa() async {
    return openDatabase(
      join(await getDatabasesPath(), 'busca.db'),
      onCreate: (db, version) {
        return db.execute(
          "CREATE TABLE pesssoa(id INTEGER PRIMARY KEY, iduser TEXT, companie TEXT)",
        );
      },
      version: 1,
    );
  }

  Future<void> insertData(ContentModel json, String table) async {
    final Database db = await dadospesquisa();
    int id = 0;
    await getSearchData(table).then((List<Map<String, dynamic>> maps) async {
      if (maps.isEmpty) {
        await db.insert(
          'dados',
          json.toMap(),
          conflictAlgorithm: ConflictAlgorithm.replace,
        );
      } else {
        id = maps[0]['id'];
        json.id = id;
        await db
            .update('dados', json.toMap(), where: "id = ?", whereArgs: [id]);
      }
    });
  }

  Future<void> insertPersonInfoData(PersonModel json, String table) async {
    final Database db = await dadospesquisa();
    int id = 0;
    await getPersonData(table).then((List<Map<String, dynamic>> maps) async {
      if (maps.isEmpty) {
        await db.insert(
          'pesssoa',
          json.toMap(),
          conflictAlgorithm: ConflictAlgorithm.replace,
        );
      } else {
        id = maps[0]['id'];
        json.id = id;
        await db
            .update('pesssoa', json.toMap(), where: "id = ?", whereArgs: [id]);
      }
    });
  }

  Future<List<Map<String, dynamic>>> getSearchData(String info) async {
    final Database db = await dadospesquisa();
    final List<Map<String, dynamic>> maps =
        await db.query('dados', where: "info = ?", whereArgs: [info]);
    return maps;
  }

  Future<List<Map<String, dynamic>>> getPersonData(String iduser) async {
    final Database db = await dadospesquisa();
    final List<Map<String, dynamic>> maps =
        await db.query('pesssoa', where: "iduser = ?", whereArgs: [iduser]);
    return maps;
  }
}
