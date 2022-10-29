
import 'package:gestion_de_stock/imports.dart';

String idPage = ListProducts.id;
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        backgroundColor: const Color(0xFFE8E8E8),
      ),
      home: const MyHomePage(),
    );
  }
}

