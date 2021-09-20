import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:time_tracker_flutter_course/app/sign_in/sign_in_button.dart';
import 'package:time_tracker_flutter_course/app/sign_in/social_sign_in_button.dart';
import 'package:time_tracker_flutter_course/services/auth.dart';

class SignInPage extends StatelessWidget {
  const SignInPage({Key? key,required this.auth}) : super(key: key);
  final AuthBase auth;

  Future<void>  _signInAnonymously() async{
    try{
     await auth.signInAnonymously();
    }catch(e){
      print(e.toString());
    }
  }
  Future<void>  _signInWithGoogle() async{
    try{
     await auth.signInWithGoogle();
    }catch(e){
      print(e.toString());
    }
  }

  Future<void>  _signInWithFacebook() async{
    try{
     await auth.signInWithFacebook();
    }catch(e){
      print(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Time Tracker'),
        elevation: 2.0,
      ),
      body: buildContainer(),
      backgroundColor: Colors.grey[200],
    );
  }

  Widget buildContainer() {
    return Padding(
      padding: EdgeInsets.all(16.0),
      //color: Colors.yellow,
      child: Column(
        //căng dọc
        mainAxisAlignment: MainAxisAlignment.center,
        //căng ngang
        crossAxisAlignment: CrossAxisAlignment.stretch, //chi phối phần width
        children: <Widget>[
          Text(
            'Sign in',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 32.0,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 30.0),
          SocialSignInButton(
              assetName: 'image/google.png',
              text: 'Sign in with Google',
              colorBackgroud: Colors.white,
              textColor: Colors.black87,
              onPressed: _signInWithGoogle),
          SizedBox(height: 5.0),
          SocialSignInButton(
              assetName: 'image/facebook.png',
              text: 'Sign in with Facebook',
              colorBackgroud: Colors.blue.shade700,
              textColor: Colors.black87,
              onPressed: _signInWithFacebook),
          SizedBox(height: 5.0),
          SocialSignInButton(
              assetName: 'image/instagram.png',
              text: 'Sign in with Instagram',
              colorBackgroud: Colors.pink.shade400,
              textColor: Colors.black87,
              onPressed: () {}),
          SizedBox(height: 5.0),
          SignInButton(
            text: 'Sign in with Email',
            onPressed: () {},
            colorBackgroud: Color(0xFF00796B),
            textColor: Colors.black87,
          ),
          SizedBox(height: 5.0),
          Text(
            'or',
            style: TextStyle(fontSize: 14.0, color: Colors.black87),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 5.0),
          SignInButton(
            text: 'Go anonymous',
            onPressed: _signInAnonymously,
            colorBackgroud: Colors.lime,
            textColor: Colors.black,
          )
        ],
      ),
    );
  }
}
