import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/material.dart';
import '../config/colors.dart';

class EstatisticsChart extends StatefulWidget {
  final List<charts.Series> seriesList;

  EstatisticsChart({this.seriesList});
  @override
  State<StatefulWidget> createState() {
    return new ProgressChartEstatisticsChartState();
  }
}

class ProgressChartEstatisticsChartState extends State<EstatisticsChart> {

  @override
  Widget build(BuildContext context) {
    final definitions = ColorsDefinitions();
    return Scaffold(
      appBar: new AppBar(
        title: new Text('Estatísticas'),
        backgroundColor: definitions.obterThemeColor(),
      ),
      body: Container(
        margin: EdgeInsets.all(15),
        child: charts.BarChart(
          widget.seriesList,
          animate: false,
          defaultRenderer: new charts.BarRendererConfig(
          groupingType: charts.BarGroupingType.grouped, strokeWidthPx: 2.0),
          behaviors: [
            new charts.SeriesLegend(),
            new charts.PanAndZoomBehavior()
          ],
        ),
      ),
    );
  }

  
}
