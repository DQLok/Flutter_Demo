import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:time_tracker_flutter_course/app/homepage.dart';
import 'package:time_tracker_flutter_course/app/sign_in/sign_in_page.dart';
import 'package:time_tracker_flutter_course/services/auth.dart';

class LadingPage extends StatelessWidget {
  const LadingPage({Key? key, required this.auth}) : super(key: key);
  final AuthBase auth;
//   @override  //StatefullWidget
//   _LadingPageState createState() => _LadingPageState();
// }

// class _LadingPageState extends State<LadingPage> {
//   User? _user;

//   @override
//   void initState() {
//     super.initState();
//     // widget.auth.authStateChanges().listen((event) {
//     //   print('user id ${event?.uid}');
//     // });
//     _updateUser(widget.auth.currentUser);
//   }

//   void _updateUser(User? user) {
//     print('update user');
//     setState(() {
//       _user = user;
//     });
//   }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
        stream: auth.authStateChanges(),
        builder: (context, snapshot) { 
          if (snapshot.connectionState == ConnectionState.active) {
            final User? user = snapshot.data;
            if (user == null) {
              return SignInPage(
                auth: auth,
              );
            }
            return HomePage(
              auth: auth,
            );
          }
          return Scaffold(
            body: Center(child: CircularProgressIndicator(),),
          );
        });
  }
}
