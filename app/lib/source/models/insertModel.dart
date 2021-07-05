class InsertModel {
  String key;
  String placa;
  String modelo;
  String marca;
  String cor;
  String ano;
  String observacao;
  String userInclusao;
  DateTime dataInclusao = DateTime.now();
  String userAlteracao;
  DateTime dataAlteracao = DateTime.now();

  InsertModel(this.key, this.placa, this.modelo, this.marca, this.cor, this.ano,
      this.observacao, this.userInclusao, this.userAlteracao);

  InsertModel.fromJson(Map<String, dynamic> parsedJson, String id) {
    key = id;
    placa = parsedJson['placa'] != null ? parsedJson['placa'] : '';
    modelo = parsedJson['modelo'] != null ? parsedJson['modelo'] : '';
    marca = parsedJson['marca'] != null ? parsedJson['marca'] : '';
    cor = parsedJson['cor'] != null ? parsedJson['cor'] : '';
    ano = parsedJson['ano'] != null ? parsedJson['ano'] : '';
    observacao = parsedJson['observacao'] != null ? parsedJson['observacao'] : '';
    userAlteracao = parsedJson['userAlteracao'] != null ? parsedJson['userAlteracao'] : '';
    userInclusao = parsedJson['userInclusao'] != null ? parsedJson['userInclusao'] : '';
    dataInclusao = parsedJson['dataInclusao'] != null ? DateTime.parse(parsedJson['dataInclusao']) : null;
    dataAlteracao = parsedJson['dataAlteracao'] != null ? DateTime.parse(parsedJson['dataAlteracao']) : null;
  }

  Map<String, dynamic> toJson() =>
    {
      'placa': placa,
      'modelo': modelo,
      'marca': marca,
      'cor': cor,
      'ano': ano,
      'observacao': observacao,
      'userInclusao': userInclusao,
      'dataInclusao': dataInclusao.toString(),
      'userAlteracao': userAlteracao,
      'dataAlteracao': dataAlteracao.toString(),
    };
}
