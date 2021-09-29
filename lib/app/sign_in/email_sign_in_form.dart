import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:time_tracker_flutter_course/app/sign_in/validators.dart';
import 'package:time_tracker_flutter_course/common_widgets/form_submit_button.dart';
import 'package:time_tracker_flutter_course/common_widgets/show_exception_dialog.dart';
import 'package:time_tracker_flutter_course/services/auth.dart';

enum emailSignInFormType { signIn, register }

class emailSignInForm extends StatefulWidget with EmailAndPAsswordValidators {

  @override
  _emailSignInForm createState() => _emailSignInForm();
}

class _emailSignInForm extends State<emailSignInForm> {
//   @override
//   Widget build(BuildContext context) {
//     return Container(

//     );
//   }
// }
// class emailSignInForm extends StatelessWidget {
  // const emailSignInForm({ Key? key }) : super(key: key);
  emailSignInFormType _formType = emailSignInFormType.signIn;

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final FocusNode _emailFocusNode = FocusNode();
  final FocusNode _passwordFocusNode = FocusNode();

  String get _email => _emailController.text;
  String get _password => _passwordController.text;

  bool _submitted = false;
  bool _isLoading = false;
  
  @override
  void dispose(){
    _emailController.dispose();
    _passwordController.dispose();
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();
    super.dispose();
  }
  void _submit() async {
    setState(() {
      _submitted = true;
      _isLoading = true;
    });
    try {
      final auth=Provider.of<AuthBase>(context,listen: false);
      //await Future.delayed(Duration(seconds: 3));
      if (_formType == emailSignInFormType.signIn) {
        await auth.signInWithEmailAndPassword(_email, _password);
      } else {
        await auth.createUserWithEmailAndPassword(_email, _password);
      }
      Navigator.of(context).pop();
    } on FirebaseAuthException catch (e) {
      // if (Platform.isIOS) {
      // } else {
      //   showDialog(
      //       context: context,
      //       builder: (context) {
      //         return AlertDialog(
      //           title: Text('Sign in failed'),
      //           content: Text(e.toString()),
      //           actions: [
      //             TextButton(
      //                 onPressed: () => Navigator.of(context).pop(),
      //                 child: Text('ok'))
      //           ],
      //         );
      //       });
      //   print(e.toString());
      // }
      showExceptionAlertDialog(context, title: 'Sign in failed', exception: e);
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _emailEditingComplete() {
    final newFocus = widget.emailValidator.isValid(_email)
        ? _passwordFocusNode
        : _emailFocusNode;
    FocusScope.of(context).requestFocus(newFocus);
  }

  void _toggleFormType() {
    setState(() {
      _submitted = false;
      _formType = _formType == emailSignInFormType.signIn
          ? emailSignInFormType.register
          : emailSignInFormType.signIn;
    });
    _emailController.clear();
    _passwordController.clear();
  }

  List<Widget> _buildChildren() {
    final primaryText = _formType == emailSignInFormType.signIn
        ? 'sign in'
        : 'Create an account';
    final secondaryText = _formType == emailSignInFormType.signIn
        ? 'Need an account? Register'
        : 'Have an account? Sign in';

    bool submitEnable = widget.emailValidator.isValid(_email) &&
        widget.passwordValidator.isValid(_password) &&
        !_isLoading;

    return [
      _buildEmailTextField(),
      SizedBox(
        height: 5.0,
      ),
      _buildPasswordTextField(),
      SizedBox(
        height: 5.0,
      ),
      FormSubmitButton(
          text: primaryText, onPressed: submitEnable ? _submit : null),
      SizedBox(
        height: 5.0,
      ),
      TextButton(
          child: Text(secondaryText),
          onPressed: !_isLoading ? _toggleFormType : null)
    ];
  }

  TextField _buildEmailTextField() {
    bool showErrorText = _submitted && widget.emailValidator.isValid(_email);
    return TextField(
      controller: _emailController,
      focusNode: _emailFocusNode,
      decoration: InputDecoration(
          labelText: 'Email',
          hintText: 'test@test.com',
          errorText: showErrorText ? widget.invalidEmailErrorText : null,
          enabled: _isLoading == false),
      autocorrect: false,
      keyboardType: TextInputType.emailAddress,
      textInputAction: TextInputAction.next,
      onEditingComplete: _emailEditingComplete,
      onChanged: (password) => _updateState(),
    );
  }

  TextField _buildPasswordTextField() {
    bool showErrorText =
        _submitted && widget.passwordValidator.isValid(_password);
    return TextField(
      controller: _passwordController,
      focusNode: _passwordFocusNode,
      decoration: InputDecoration(
          labelText: 'Password',
          errorText: showErrorText ? widget.invalidPassErrorText : null,
          enabled: _isLoading == false),
      obscureText: true,
      textInputAction: TextInputAction.done,
      onEditingComplete: _submit,
      onChanged: (email) => _updateState(),
    );
  }

  void _updateState() {
    print('email: ${_email}, password: ${_password}');
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: _buildChildren(),
      ),
    );
  }
}
