import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'infrastructure/navigation/navigation.dart';
import 'infrastructure/theme/app.color.dart';

class Main extends StatelessWidget {
  final String initialRoute;
  const Main(this.initialRoute, {super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      getPages: Nav.routes,
      initialRoute: initialRoute,
      theme: ThemeData(
        brightness: Brightness.light,
        canvasColor: Colors.transparent,
        colorScheme: ColorScheme.light(
          primary: AppColor.primaryColor,
          secondary: AppColor.secondaryColor,
        ),
        progressIndicatorTheme: ProgressIndicatorThemeData(
          color: AppColor.primaryColor,
        ),
        buttonTheme: ButtonThemeData(
          buttonColor: AppColor.primaryColor,
          textTheme: ButtonTextTheme.primary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(32),
          ),
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ButtonStyle(
            backgroundColor: WidgetStateProperty.all(
              AppColor.primaryColor,
            ),
            shape: WidgetStateProperty.all(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(32),
              ),
            ),
            splashFactory: NoSplash.splashFactory,
            elevation: WidgetStateProperty.all(0),
            enableFeedback: true,
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          errorStyle: TextStyle(
            color: AppColor.errorColor,
            fontSize: 11,
            fontWeight: FontWeight.w500,
          ),
          hintStyle: const TextStyle(
            color: AppColor.secondaryGreyColor,
            fontSize: 11,
            fontStyle: FontStyle.italic,
            fontWeight: FontWeight.w400,
            height: 2.4,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: const BorderSide(
              color: AppColor.borderColor,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: const BorderSide(
              color: AppColor.borderColor,
              width: 0.83,
            ),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: BorderSide(
              color: AppColor.errorColor,
              width: 1.83,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: BorderSide(
              color: AppColor.primaryColor,
              width: 1.83,
            ),
          ),
          contentPadding: const EdgeInsets.only(
            left: 14,
            right: 14,
          ),
        ),
        snackBarTheme: SnackBarThemeData(
          backgroundColor: AppColor.errorColor,
          contentTextStyle: const TextStyle(
            color: Colors.white,
          ),
        ),
        textTheme: GoogleFonts.mulishTextTheme(),
        primaryTextTheme: GoogleFonts.mulishTextTheme(),
      ),
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      locale: const Locale('id', 'ID'),
      supportedLocales: const [
        Locale('en', 'US'),
        Locale('id', 'ID'),
      ],
    );
  }
}
