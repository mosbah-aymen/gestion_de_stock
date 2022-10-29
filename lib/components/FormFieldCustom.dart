import 'package:gestion_de_stock/imports.dart';
class FieldNewPackageForm extends StatelessWidget {
  final IconData? icon;
  final String title;
  final Widget? child;
  final double? height;
  final Function()? onPressed;
  const FieldNewPackageForm(
      {Key? key,
       this.icon,
      required this.title,
      this.child,
      this.height,
      this.onPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        GestureDetector(
          onTap: onPressed,
          child: Container(
            height: height ?? 60,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Colors.grey, width: 1),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: title == 'Description'
                  ? CrossAxisAlignment.start
                  : CrossAxisAlignment.center,
              children: [
                icon!=null?Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Icon(
                    icon,
                    color: primaryColor,
                  ),
                ):const SizedBox(),
                Expanded(child: child ?? const SizedBox()),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
