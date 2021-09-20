import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:time_tracker_flutter_course/app/lading_page.dart';
import 'package:time_tracker_flutter_course/services/auth.dart';

Future<void> main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  
  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Time Tracker ',
      theme: ThemeData(
        primarySwatch: Colors.indigo,
      ),
       home: LadingPage(auth: Auth()),
      // Container(
      //   color: Colors.white,
      // ),
    );
  }
}