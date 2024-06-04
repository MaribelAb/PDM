import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

double defaultMargin = 30.0;

// COLORS
Color kBlackColor = Color(0xff292A2D);
Color kWhiteColor = Color(0xffFFFFFF);
Color kGreyColor = Color(0xff98999F);
Color kBlueColor = Color(0xff5284E3);
Color kBackgroundButtonColor = Color(0xffFCFCFD);
Color kStrokeButtonColor = Color(0xffE5E5E5);
Color bgColor = Colors.white;

// TEXT STYLES
TextStyle blackTextStyle = GoogleFonts.juliusSansOne(
  color: kBlackColor,
);
TextStyle whiteTextStyle = GoogleFonts.juliusSansOne(
  color: kWhiteColor,
);
TextStyle blueTextStyle = GoogleFonts.juliusSansOne(
  color: kBlueColor,
);

TextStyle greyTextStyle = GoogleFonts.juliusSansOne(
  color: kGreyColor,
);

TextStyle titulo = GoogleFonts.juliusSansOne(
  color: kGreyColor,
);

// FONT WEIGHTS
FontWeight thin = FontWeight.w100;
FontWeight extraLight = FontWeight.w200;
FontWeight light = FontWeight.w300;
FontWeight regular = FontWeight.w400;
FontWeight medium = FontWeight.w500;
FontWeight semiBold = FontWeight.w600;
FontWeight bold = FontWeight.w700;
FontWeight extraBold = FontWeight.w800;
FontWeight black = FontWeight.w900;


final ThemeData myTheme = ThemeData(
  primaryColor: Colors.amber,
  fontFamily: 'Roboto', // Example font family
  
);

final TextStyle tituloStyle = GoogleFonts.juliusSansOne(
  fontSize: 32.0,
  color: Colors.black,
  fontWeight: bold,
);

final TextStyle defaultStyle = GoogleFonts.roboto(
  fontSize: 16.0,
  color: Colors.black,
);

final TextStyle greetingStyle = GoogleFonts.juliusSansOne(
  fontSize: 18.0,
  color: Colors.black,
);

final TextStyle subtituloStyle = GoogleFonts.archivoNarrow(
  fontSize: 24.0,
  color: Colors.black,
);

final TextStyle normalStyle = GoogleFonts.sourceSans3(
  fontSize: 18.0,
  color: Colors.black,
);