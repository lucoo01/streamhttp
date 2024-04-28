import 'package:flutter/material.dart';

enum ColorTheme {
  light(
      background: Color(0xffffffff),
      propertyKey: Color(0xff101794),
      colon: Colors.black,
      string: Color(0xff067d17),
      number: Color(0xff1750eb),
      keyword: Color(0xff0033b3),
      fontColor: Color(0xff282828),
      cardItem: Color(0xfff1f1f1),
  ),
  dark(
      background: Color(0xff2b2b2b),
      propertyKey: Color(0xff767daa),
      colon: Color(0xff7ccc32),
      string: Color(0xff6a8759),
      number: Color(0xff6897bb),
      keyword: Color(0xffb0cc32),
      fontColor: Color(0xffeaeaea),
      cardItem: Color(0x909090bb),
  );

  final Color background;
  final Color propertyKey;
  final Color colon;
  final Color string;
  final Color number;
  final Color keyword;
  final Color? fontColor;
  final Color? cardItem;


  const ColorTheme(
      {
        required this.background,
        required this.propertyKey,
        required this.colon,
        required this.string,
        required this.number,
        required this.keyword,
        this.fontColor,
        this.cardItem
      });

  static ColorTheme of(Brightness brightness) {
    return brightness == Brightness.dark ? ColorTheme.dark : ColorTheme.light;
  }
}
