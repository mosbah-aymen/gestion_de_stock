import 'package:gestion_de_stock/imports.dart';

class SearchField extends StatelessWidget {
  final Function(String)? onSubmitted;
  final String? hint;
   SearchField({
    Key? key,
    this.onSubmitted,
    this.hint,
  }) : super(key: key);

  @override

  Widget build(BuildContext context) {
    return Container(
      child: TextField(
        onChanged: onSubmitted,
        autofocus: true,
        decoration: InputDecoration(
          hintText: hint??"Search",
          filled: true,
          border: const OutlineInputBorder(

            borderSide: BorderSide(color: bgColor),
            borderRadius: BorderRadius.all(Radius.circular(10)),
          ),
          suffixIcon: InkWell(
            child: Container(
              padding: const EdgeInsets.all(8),
              margin: const EdgeInsets.symmetric(horizontal: 8),
              decoration: BoxDecoration(
                color: secondaryColor,
                borderRadius: const BorderRadius.all(Radius.circular(10)),
              ),
              child: const Icon(Icons.search,color: Colors.white,),
            ),
          ),
        ),
      ),
    );
  }
}
