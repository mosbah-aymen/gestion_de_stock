
import 'package:gestion_de_stock/imports.dart';
import 'package:gestion_de_stock/screens/gestion%20des%20entree/archive_achat.dart';
import 'package:gestion_de_stock/screens/gestion%20des%20entree/list_entree.dart';
import 'package:gestion_de_stock/screens/gestion%20des%20sorties/archive_ventes.dart';
import 'package:gestion_de_stock/screens/gestion%20des%20sorties/list_sortie.dart';

class Configuration extends StatefulWidget {
  static const String id = 'Configuration';
  const Configuration({Key? key}) : super(key: key);

  @override
  State<Configuration> createState() => _ConfigurationState();
}

class _ConfigurationState extends State<Configuration> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Expanded(
        child: GridView(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisExtent: 200,
              childAspectRatio: 1,
              mainAxisSpacing: 30,
              crossAxisSpacing: 10),
          children: [
            const CardConfig(assetImagePath: 'assets/images/zip-icon.png',title: 'Archive Des Ventes', window: ArchiveVentes()),
            const CardConfig(assetImagePath:'assets/images/document-archive-icon.png',title: 'Archive Des Achats', window: ArchiveAchat()),
            CardConfig(
                title: "Log out",
                assetImagePath: 'assets/images/logout.png',
                window: AlertDialog(
                  title: const Text('Are you sure to Log out?'),
                  actions: [
                    TextButton(
                        onPressed: () async {
                          // await FirebaseAuth.instance.signOut().then((value) {
                          //   Navigator.pushReplacement(
                          //       context,
                          //       MaterialPageRoute(
                          //           builder: (context) =>
                          //               const SplashScreen()));
                          // });
                          Navigator.pop(context);
                        },
                        child: const Text('LogOut')),
                    TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text("Cancel")),
                  ],
                ))
          ],
        ),
      ),
    );
  }
}

class CardConfig extends StatefulWidget {
  final String title;
  final String? assetImagePath, networkImagePath, description;
  final Widget window;
  const CardConfig(
      {Key? key,
      this.assetImagePath,
      required this.title,
      required this.window,
      this.networkImagePath,
      this.description})
      : super(key: key);

  @override
  State<CardConfig> createState() => _CardConfigState();
}

class _CardConfigState extends State<CardConfig> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(10),
      hoverColor: primaryColor,
      onTap: () {
        showDialog(context: context, builder: (context) => widget.window)
            .then((value) {
          setState(() {});
        });
      },
      child: Card(
        elevation: 4,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              widget.networkImagePath != null
                  ? Image.network(widget.networkImagePath!,
                      loadingBuilder: (context, child, event) {
                      return SizedBox(
                        height: 100,
                        child: event == null
                            ? child
                            : const Center(child: CircularProgressIndicator()),
                      );
                    })
                  : widget.assetImagePath != null
                      ? Image.asset(
                          widget.assetImagePath!,
                          height: 100,
                        )
                      : const SizedBox(),
              Text(
                widget.title,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: secondaryColor,
                ),
              ),
              if (widget.description != null)
                Expanded(
                  child: Text(
                    widget.description.toString(),
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                  ),
                )
            ],
          ),
        ),
      ),
    );
  }
}
