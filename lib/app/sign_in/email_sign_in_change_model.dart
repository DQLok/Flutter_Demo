import 'package:flutter/material.dart';
import 'package:time_tracker_flutter_course/app/sign_in/email_sign_in_model.dart';
import 'package:time_tracker_flutter_course/app/sign_in/validators.dart';
import 'package:time_tracker_flutter_course/services/auth.dart';

class EmailSignInChangeModel with EmailAndPAsswordValidators, ChangeNotifier {
  EmailSignInChangeModel(
      {required this.auth,
      this.email = '',
      this.password = '',
      this.formType = emailSignInFormType.signIn,
      this.isLoading = false,
      this.submitted = false});
  final AuthBase auth;
  String email;
  String password;
  emailSignInFormType formType;
  bool isLoading;
  bool submitted;

   Future<void> submit() async {
    updateWith(submitted: true,isLoading: true);
    try {
      //await Future.delayed(Duration(seconds: 3));
      if (formType == emailSignInFormType.signIn) {
        await auth.signInWithEmailAndPassword(email,password);
      } else {
        await auth.createUserWithEmailAndPassword(email,password);
      }
    } catch (e) {
      updateWith(isLoading: false);
      rethrow;
    }
  }

  String get primaryButtonText {
    return formType == emailSignInFormType.signIn
        ? 'sign in'
        : 'Create an account';
  }

  String get secondaryButtonText {
    return formType == emailSignInFormType.signIn
        ? 'Need an account? Register'
        : 'Have an account? Sign in';
  }

  bool get canSubmit {
    return emailValidator.isValid(email) &&
        passwordValidator.isValid(password) &&
        !isLoading;
  }

  String? get passwordErrorText {
    bool showErrorText = submitted && passwordValidator.isValid(password);
    return showErrorText ? invalidEmailErrorText : null;
  }

  String? get emailErrorText {
    bool showErrorText = submitted && emailValidator.isValid(email);
    return showErrorText ? invalidEmailErrorText : null;
  }

  void toggeFormType(){
    final formType=this.formType==emailSignInFormType.signIn ? emailSignInFormType.register :emailSignInFormType.signIn;
     updateWith(
      email: '',
      password:'',      
      formType: formType,
      isLoading: false,
      submitted: false,
    );
  }

  void updateEmail(String email) =>updateWith(email: email);

  void updatePassword(String password)=>updateWith(password: password);

  void updateWith(
      {String? email,
      String? password,
      emailSignInFormType? formType,
      bool? isLoading,
      bool? submitted}) {
    this.email = email ?? this.email;
    this.password = password ?? this.password;
    this.formType = formType ?? this.formType;
    this.isLoading = isLoading ?? this.isLoading;
    this.submitted = submitted ?? this.submitted;
    notifyListeners();
  }
}
