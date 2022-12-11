import 'package:gestion_de_stock/components/workspace.dart';
import 'package:gestion_de_stock/imports.dart';

class ScanDirect extends StatefulWidget {
  static const String id='Scan Direct';
  const ScanDirect({Key? key}) : super(key: key);

  @override
  State<ScanDirect> createState() => _ScanDirectState();
}

class _ScanDirectState extends State<ScanDirect> {
  @override
  Widget build(BuildContext context) {
    return const WorkSpace(headChildren: [],
    child: SingleChildScrollView(
      child: Text('Scan Direct'),
    ),);
  }
}
