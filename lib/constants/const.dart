import 'package:firebase_auth/firebase_auth.dart';
import 'package:gestion_de_stock/imports.dart';

InputDecoration decoration(String? hint, {String? prefix}) => InputDecoration(
      hintText: hint,
      counterText: '',

      prefixText: prefix,
      prefixStyle: const TextStyle(
          color: Colors.black, fontSize: 16, fontWeight: FontWeight.bold),
      border: const OutlineInputBorder(
          borderSide: BorderSide(
        color: Colors.transparent,
      )),
      enabledBorder: const OutlineInputBorder(
          borderSide: BorderSide(
        color: Colors.transparent,
      )),
      disabledBorder:  const OutlineInputBorder(
                borderSide: BorderSide(
              color: Colors.transparent,
            )),
      focusedBorder: const OutlineInputBorder(
          borderSide: BorderSide(
        color: Colors.transparent,
      )),
    );
User? user;
List<String> categories=['EAU','roulements'];