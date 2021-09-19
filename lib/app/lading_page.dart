import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:time_tracker_flutter_course/app/homepage.dart';
import 'package:time_tracker_flutter_course/app/sign_in/sign_in_page.dart';
import 'package:time_tracker_flutter_course/services/auth.dart';

class LadingPage extends StatefulWidget {
  const LadingPage({ Key? key, required this.auth }) : super(key: key);
  final AuthBase auth;
  @override
  _LadingPageState createState() => _LadingPageState();
}

class _LadingPageState extends State<LadingPage> {
     User? _user;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _updateUser(widget.auth.currentUser);
  }

   void _updateUser(User? user){
     print('aaa');
      setState(() {
          _user=user;
      });
   }

  @override
  Widget build(BuildContext context) {
    if(_user==null){
    return SignInPage(onSignIn: _updateUser,auth: widget.auth,);
    }
    return HomePage(onSignOut: ()=>_updateUser(null),auth: widget.auth,);
  }
}