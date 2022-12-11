import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:gestion_de_stock/imports.dart';
import 'package:gestion_de_stock/models/categorie.dart';

InputDecoration decoration(String? hint, {String? prefix,Color? prefixColor,Color? textColor}) => InputDecoration(
      hintText: hint,
      hintStyle: TextStyle(fontSize: 14),
      counterText: '',
      prefixText: prefix,
      prefixStyle:  TextStyle(
          color: prefixColor ??Colors.black, fontSize: 12, fontWeight: FontWeight.bold),
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
List<Categorie> categories=[];


class MyCustomScrollBehavior extends MaterialScrollBehavior {
  // Override behavior methods and getters like dragDevices
  @override
  Set<PointerDeviceKind> get dragDevices => {
    PointerDeviceKind.touch,
    PointerDeviceKind.mouse,
    // etc.
  };
}

Widget button(String title, IconData icon, Function onPressed,{Color? backgroundColor}) =>
    ElevatedButton.icon(
      style: TextButton.styleFrom(
        backgroundColor: backgroundColor??primaryColor,
        padding:const EdgeInsets.symmetric(
          horizontal: 15,
          vertical: 15,
        ),
      ),
      onPressed: () {
        onPressed();
      },
      icon: Icon(
        icon,
        size: 20,
        color: Colors.white,
      ),
      label: Text(
        title,
        style: TextStyle(color: Colors.white),
      ),
    );