import '../models/parameterModel.dart';
import 'package:flutter/material.dart';

class DropDownItens {
  List<DropdownMenuItem<int>> getCompaniesToDropdownList(ParameterModel list) {
    List<DropdownMenuItem<int>> lista = [];
    for (int a = 0; a < list.model.length; a++) {
      lista.add(DropdownMenuItem<int>(
        value: a,
        child: Text(list.model[a].compania),
      ));
    }
    return lista;
  }
}
