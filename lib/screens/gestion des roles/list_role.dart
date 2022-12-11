
import 'package:gestion_de_stock/components/workspace.dart';
import 'package:gestion_de_stock/imports.dart';

class ListRole extends StatefulWidget {
  static const String id='Gestion Des Role';
  const ListRole({Key? key}) : super(key: key);

  @override
  State<ListRole> createState() => _ListRoleState();
}

class _ListRoleState extends State<ListRole> {
  @override
  Widget build(BuildContext context) {
    return WorkSpace(
      headChildren: [],
      child: SingleChildScrollView(
        child: Column(
          children: [Text('Gestion des role'),],
        ),
      ),
    );
  }
}
