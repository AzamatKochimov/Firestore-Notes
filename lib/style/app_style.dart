import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppStyle {
  static Color mainColor = const Color(0xFF000633);
  static Color accentColor = const Color.fromARGB(255, 143, 167, 203);

  // Set Different color for Cards

  static List<Color> cardsColor = [
    Colors.white70,
    Colors.red.shade200,
    Colors.amber.shade200,
    Colors.green.shade200,
    Colors.purple.shade200,
    Colors.orange.shade200,
    Colors.yellow.shade200,
    Colors.blue.shade200,
    Colors.pink.shade200,
    Colors.blueGrey.shade200,
  ];

  // Styling the Font of the notes

  static TextStyle mainTitle = 
    GoogleFonts.roboto(fontSize: 18.0, fontWeight: FontWeight.bold);

  static TextStyle mainContent = 
    GoogleFonts.nunito(fontSize: 16.0, fontWeight: FontWeight.normal);

  static TextStyle mainDateTitle = 
    GoogleFonts.roboto(fontSize: 13.0, fontWeight: FontWeight.w500);

}