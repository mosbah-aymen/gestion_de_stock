
import 'package:gestion_de_stock/components/workspace.dart';
import 'package:gestion_de_stock/imports.dart';

class Statistics extends StatefulWidget {
  static const String id='Statistiques';
  const Statistics({Key? key}) : super(key: key);

  @override
  State<Statistics> createState() => _StatisticsState();
}

class _StatisticsState extends State<Statistics> {
  @override
  Widget build(BuildContext context) {
    return WorkSpace(headChildren: [],
    child: Column(
      children: [
        Text('Statistics'),
      ],
    ),);
  }
}
