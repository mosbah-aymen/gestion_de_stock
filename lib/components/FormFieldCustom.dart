import 'package:gestion_de_stock/imports.dart';
class FieldNewPackageForm extends StatelessWidget {
  final IconData? icon;
  final String title;
  final Widget? child;
  final double? height;
  final Color? textColor,borderColor;
  final Function()? onPressed;
  const FieldNewPackageForm(
      {Key? key,
       this.icon,
      required this.title,
      this.child,
      this.height,
        this.textColor,
        this.borderColor,
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
            style:  TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: textColor,
            ),
          ),
        ),
        GestureDetector(
          onTap: onPressed,
          child: Container(
            height: height ?? 40,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: borderColor??Colors.grey, width: 1),
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
                    color:borderColor??primaryColor,
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
