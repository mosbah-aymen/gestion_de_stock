import 'package:gestion_de_stock/components/StatCard.dart';
import 'package:gestion_de_stock/imports.dart';

class WorkSpace extends StatelessWidget {
  final List<HeaderElement> headChildren;
  final Widget? child;
  final Widget? searchBar;
  final List<String>? statTitles,statValues;
  const WorkSpace(
      {Key? key, required this.headChildren, this.child, this.searchBar,this.statValues,this.statTitles})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(10),
      child: Column(
        children: [
          searchBar ?? const SizedBox(),
          statTitles!=null && statValues!=null? Row(
            children: List<Widget>.generate(statTitles!.length, (index) => Expanded(child: StatCard(value: statValues![index], title: statTitles![index], unit: ''),),
            ),
          ):const SizedBox(),
          headChildren.isNotEmpty
              ? Expanded(
                  child: Row(
                    children: List<Widget>.generate(
                        headChildren.length, (index) => headChildren[index]),
                  ),
                )
              : const SizedBox(),
          Expanded(
            flex: 10,
            child: SizedBox(
              child: child,
            ),
          )
        ],
      ),
    );
  }
}

class HeaderElement extends StatelessWidget {
  final Color? color,iconColor;
  final String title;
  final IconData? icon;
  final void Function()? onTap;
  const HeaderElement(
      {Key? key, this.color, required this.title, this.onTap, this.icon,this.iconColor})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        child: Card(
          elevation: 0,
          color: color??secondaryColor,
          margin: const EdgeInsets.all(8),
          child: Padding(
            padding: const EdgeInsets.all(5.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Icon(
                  icon ?? Icons.circle_outlined,
                  color: iconColor ?? Colors.white,
                ),
                const SizedBox(
                  width: 10,
                ),
                Text(
                  title,
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.white, fontSize: 18,overflow: TextOverflow.ellipsis),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
