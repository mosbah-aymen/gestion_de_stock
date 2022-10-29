import 'package:gestion_de_stock/imports.dart';

class Window extends StatefulWidget {
  final Widget body,header;
  const Window({Key? key,required this.header,required this.body}) : super(key: key);

  @override
  State<Window> createState() => _WindowState();
}

class _WindowState extends State<Window> {
  @override
  Widget build(BuildContext context) {
    final Size _size = MediaQuery.of(context).size;
    return Container(
      margin: EdgeInsets.symmetric(
          vertical: _size.width * .05, horizontal: _size.width * .1),
      child: Card(
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.all(8),
              width: double.infinity,
              color: secondaryColor,
              child:widget.header,
            ),
            Expanded(
              child: widget.body,
            ),
          ],
        ),
      ),
    );
  }
}
