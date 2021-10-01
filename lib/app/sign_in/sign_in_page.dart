import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:time_tracker_flutter_course/app/sign_in/email_sign_in_page.dart';
import 'package:time_tracker_flutter_course/app/sign_in/sign_in_bloc.dart';
import 'package:time_tracker_flutter_course/app/sign_in/sign_in_button.dart';
import 'package:time_tracker_flutter_course/app/sign_in/social_sign_in_button.dart';
import 'package:time_tracker_flutter_course/common_widgets/show_exception_dialog.dart';
import 'package:time_tracker_flutter_course/services/auth.dart';

class SignInPage extends StatelessWidget {
  const SignInPage({Key? key, required this.bloc}) : super(key: key);
  final SignInBloc bloc;
  static Widget create(BuildContext context) {  
    final auth=Provider.of<AuthBase>(context,listen: false);
    return Provider<SignInBloc>(
        create: (_) => SignInBloc(auth: auth),//not auth null
        dispose: (_,bloc)=>bloc.dispose(),
        child: Consumer<SignInBloc>(
            builder: (_, bloc, __) => SignInPage(bloc: bloc)));
  }

  void _showSignInError(BuildContext context, Exception exception) {
    if (exception is FirebaseAuthException &&
        exception.code == 'ERROR_ABORTED_BY_USER') return;
    showExceptionAlertDialog(context,
        title: 'Sign in failed', exception: exception);
  }

  Future<void> _signInAnonymously(BuildContext context) async {
    //final bloc=Provider.of<SignInBloc>(context,listen: false);
    try {
      //final auth = Provider.of<AuthBase>(context, listen: false);
      await bloc.signInAnonymously();
    } on Exception catch (e) {
      _showSignInError(context, e);
    }
  }

  Future<void> _signInWithGoogle(BuildContext context) async {
    try {
      await bloc.signInWithGoogle();
    } on Exception catch (e) {
      _showSignInError(context, e);
    }
  }

  Future<void> _signInWithFacebook(BuildContext context) async {
    try {
      await bloc.signInWithFacebook();
    } on Exception catch (e) {
      _showSignInError(context, e);
    }
  }

  void _signInWithEmail(BuildContext context) {
    Navigator.of(context).push(MaterialPageRoute<void>(
      fullscreenDialog: true,
      builder: (context) => EmailSignInPage(),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Time Tracker'),
        elevation: 2.0,
      ),
      body: StreamBuilder<bool>(
        stream: bloc.isLoadingStream,
        initialData: false,
        builder: (context, AsyncSnapshot) {
          //snapshot
          return buildContainer(context, AsyncSnapshot.data!);
        },
      ),
      backgroundColor: Colors.grey[200],
    );
  }

  Widget buildContainer(BuildContext context, bool isLoading) {
    return Padding(
      padding: EdgeInsets.all(16.0),
      //color: Colors.yellow,
      child: Column(
        //căng dọc
        mainAxisAlignment: MainAxisAlignment.center,
        //căng ngang
        crossAxisAlignment: CrossAxisAlignment.stretch, //chi phối phần width
        children: <Widget>[
          SizedBox(height: 50.0, child: _buildHeader(isLoading)),
          SizedBox(height: 30.0),
          SocialSignInButton(
              assetName: 'image/google.png',
              text: 'Sign in with Google',
              colorBackgroud: Colors.white,
              textColor: Colors.black87,
              onPressed: isLoading ? null : () => _signInWithGoogle(context)),
          SizedBox(height: 5.0),
          SocialSignInButton(
              assetName: 'image/facebook.png',
              text: 'Sign in with Facebook',
              colorBackgroud: Colors.blue.shade700,
              textColor: Colors.black87,
              onPressed: isLoading ? null : () => _signInWithFacebook(context)),
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
            onPressed: isLoading ? null : () => _signInWithEmail(context),
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
            onPressed: isLoading ? null : () => _signInAnonymously(context),
            colorBackgroud: Colors.lime,
            textColor: Colors.black,
          )
        ],
      ),
    );
  }

  Widget _buildHeader(bool isLoading) {
    if (isLoading) {
      return Center(
        child: CircularProgressIndicator(),
      );
    }
    return Text(
      'Sign in',
      textAlign: TextAlign.center,
      style: TextStyle(
        fontSize: 32.0,
        fontWeight: FontWeight.w600,
      ),
    );
  }
}
