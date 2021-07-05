class ContentModel {
  int id;
  String json;
  String info;

  ContentModel(this.json, this.info);

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'json': json,
      'info': info
    };
  }
}

class PersonModel {
  int id;
  String iduser;
  String companie;

  PersonModel(this.iduser, this.companie);

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'iduser': iduser,
      'companie': companie
    };
  }
}