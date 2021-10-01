import 'dart:async';
import 'dart:math';

import 'package:time_tracker_flutter_course/app/sign_in/email_sign_in_model.dart';
import 'package:time_tracker_flutter_course/services/auth.dart';

class EmailSignInBloc{
  EmailSignInBloc({required this.auth});
  final AuthBase auth;
  final StreamController<EmailSignInModel> _modelController=StreamController<EmailSignInModel>();
  Stream<EmailSignInModel> get modelStream => _modelController.stream;

EmailSignInModel _model=EmailSignInModel();
  void dispose(){
    _modelController.close();
  }

  Future<void> submit() async {
    updateWith(submitted: true,isLoading: true);
    try {
      //await Future.delayed(Duration(seconds: 3));
      if (_model.formType == emailSignInFormType.signIn) {
        await auth.signInWithEmailAndPassword(_model.email, _model.password);
      } else {
        await auth.createUserWithEmailAndPassword(_model.email, _model.password);
      }
    } catch (e) {
      updateWith(isLoading: false);
      rethrow;
    }
  }

  void toggeFormType(){
    final formType=_model.formType==emailSignInFormType.signIn ? emailSignInFormType.register :emailSignInFormType.signIn;
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

  void updateWith({
    String? email,String? password,emailSignInFormType? formType, bool? isLoading,bool? submitted}){
        _model=_model.coppyWith(email: email,password: password,formType: formType,isLoading: isLoading,submitted: submitted);
        _modelController.add(_model);
    }
}