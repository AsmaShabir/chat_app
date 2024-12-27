

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../view_model/services/splash_services.dart';

class SplashView extends StatefulWidget {
  const SplashView({super.key});

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> {
  splashServices SplashServices= splashServices();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    SplashServices.checkAuthentication(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset('assets/images/logo.png',height: 100,),
             // Text('FitTrack',style: GoogleFonts.azeretMono(color: Color(0xFFF1f305c),fontWeight: FontWeight.bold,fontSize: 26),),

            ],
          ),
        ),
      ),
    );
  }
}
