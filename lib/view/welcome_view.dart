

import 'package:chat_app/utils/routes/routes_name.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class welcomeView extends StatelessWidget {
  const welcomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset('assets/images/logo.png',height: 100,),
            SizedBox(height: 20,),
            Text('Welcome!',style: GoogleFonts.azeretMono(color: Color(0xFFF377078),fontWeight: FontWeight.bold,fontSize: 26),),
            Padding(
              padding: const EdgeInsets.all(17.0),
              child: Text('Get a chance to chat with your loved ones....',style: GoogleFonts.azeretMono(color: Color(0xFFF377078),fontWeight: FontWeight.bold,fontSize: 15),),
            ),
            SizedBox(height: 10,),
            Container(
              height: 40,
              child: MaterialButton(
                  color: Color(0xFFF377078),
                  onPressed: ()async{
                    Navigator.pushNamed(context,routesName.home);
                  },
                  child: Text('Next',style: GoogleFonts.azeretMono(color: Colors.white),),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0),

                  )
              ),
            ),
          ],
        ),
      ),
    );
  }
}
