import 'package:chat_app/utils/routes/routes.dart';
import 'package:chat_app/utils/routes/routes_name.dart';
import 'package:chat_app/view/auth/profile_creation.dart';
import 'package:chat_app/view/auth/signup_view.dart';
import 'package:chat_app/view/home_screen.dart';
import 'package:chat_app/view_model/chats_view_model.dart';
import 'package:chat_app/view_model/profileCreation_view_model.dart';
import 'package:chat_app/view_model/services/auth_services.dart';
import 'package:cloudinary_flutter/cloudinary_context.dart';
import 'package:cloudinary_url_gen/cloudinary.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  CloudinaryContext.cloudinary =
      Cloudinary.fromCloudName(cloudName: 'diartjx7f');
  runApp( MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
     return MultiProvider(
        providers: [
    ChangeNotifierProvider(create: (_) => ProfileViewModel()),
          ChangeNotifierProvider(create: (_) => ChatsViewModel()),

    ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: false,
        ),
        initialRoute: routesName.splash,
        onGenerateRoute: routes.generateRoute,
      ),
    );
  }
}


