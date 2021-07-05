import 'insertModel.dart';

class RootModel {
  List<InsertModel> dados = [];
  bool nonetwork = true;

  RootModel(this.dados);

  RootModel.fromSnapshot(Map<String, dynamic> mapeamento) {
    List<String> keys;
    if (mapeamento != null) {
      keys = mapeamento.keys.toList();
      for (int a = 0; a < keys.length; a++) {
        Map<String, dynamic> parsed = mapeamento[keys[a]];
        dados.add(InsertModel.fromJson(parsed, keys[a]));
      }
    }
  }
}
