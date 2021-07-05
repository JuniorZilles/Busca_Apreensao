import 'package:charts_flutter/flutter.dart' as charts;

class CarFoundsModel {
  final DateTime time;
  final int encontrados;

  CarFoundsModel(this.time, this.encontrados);
}

class CarFounds {
  List<CarFoundsModel> carrosconcluidos = [];
  List<CarFoundsModel> carrosemandamento = [];

  CarFounds.fromSnapshot(Map<String, dynamic> mapeamento) {
    Map<String, dynamic> parsedJson =
        mapeamento['concluidos'] != null ? mapeamento['concluidos'] : null;

    List<String> keys = parsedJson.keys.toList();
    for (int a = 0; a < keys.length; a++) {
      int valor = parsedJson[int.parse(keys[a])];
      if (valor != null) {
        CarFoundsModel cars = CarFoundsModel(
            DateTime(
                int.parse(keys[a].length < 6
                    ? keys[a].substring(1, 5)
                    : keys[a].substring(2, 6)),
                int.parse(keys[a].length < 6
                    ? keys[a].substring(0, 1)
                    : keys[a].substring(0, 2))),
            valor);
        carrosconcluidos.add(cars);
      }
    }

    parsedJson =
        mapeamento['emandamento'] != null ? mapeamento['emandamento'] : null;

    keys = parsedJson.keys.toList();
    for (int a = 0; a < keys.length; a++) {
      int valor = parsedJson[int.parse(keys[a])];
      if (valor != null) {
        CarFoundsModel cars = CarFoundsModel(
            DateTime(
                int.parse(keys[a].length < 6
                    ? keys[a].substring(1, 5)
                    : keys[a].substring(2, 6)),
                int.parse(keys[a].length < 6
                    ? keys[a].substring(0, 1)
                    : keys[a].substring(0, 2))),
            valor);
        carrosemandamento.add(cars);
      }
    }
    carrosconcluidos.sort((a, b) => a.time.compareTo(b.time));
    carrosemandamento.sort((a, b) => a.time.compareTo(b.time));
    //CarFounds.toEqualSize();
    //carrosconcluidos.sort((a, b)=> a.time.compareTo(b.time));
    //carrosemandamento.sort((a, b)=> a.time.compareTo(b.time));
  }

  CarFounds.toEqualSize() {
    bool ok = false;
    int a, b = 0;
    while (ok) {
      if (a >= carrosconcluidos.length || b >= carrosemandamento.length) {
        ok = true;
      } else {
        int comparacao =
            carrosconcluidos[a].time.compareTo(carrosemandamento[b].time);
        if (comparacao == 0) {
          a++;
          b++;
        } else if (comparacao > 0) {
          carrosemandamento.insert(
              a, CarFoundsModel(carrosconcluidos[a].time, 0));
          a++;
          b++;
        } else if (comparacao > 0) {
          carrosconcluidos.insert(
              a, CarFoundsModel(carrosemandamento[a].time, 0));
          a++;
          b++;
        }
      }
    }
  }
}

class Statistics {
  List<charts.Series<CarFoundsModel, String>> createSampleData(
      List<CarFoundsModel> emandamento, List<CarFoundsModel> concluidos) {
    return [
      // Blue bars with a lighter center color.
      new charts.Series<CarFoundsModel, String>(
        id: 'Concluidos',
        domainFn: (CarFoundsModel buscas, _) =>
            buscas.time.month.toString() + '/' + buscas.time.year.toString(),
        measureFn: (CarFoundsModel buscas, _) => buscas.encontrados,
        colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
        fillColorFn: (_, __) =>
            charts.MaterialPalette.blue.shadeDefault.lighter,
        data: concluidos,
      ),
      new charts.Series<CarFoundsModel, String>(
        id: 'Em Andamento',
        domainFn: (CarFoundsModel buscas, _) =>
            buscas.time.month.toString() + '/' + buscas.time.year.toString(),
        measureFn: (CarFoundsModel buscas, _) => buscas.encontrados,
        colorFn: (_, __) => charts.MaterialPalette.red.shadeDefault,
        fillColorFn: (_, __) => charts.MaterialPalette.red.shadeDefault.lighter,
        data: emandamento,
      ),
    ];
  }
}
