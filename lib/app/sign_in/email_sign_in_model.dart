import 'package:time_tracker_flutter_course/app/sign_in/validators.dart';

enum emailSignInFormType { signIn, register }

class EmailSignInModel with EmailAndPAsswordValidators {
  EmailSignInModel(
      {this.email = '',
      this.password = '',
      this.formType = emailSignInFormType.signIn,
      this.isLoading = false,
      this.submitted = false});

  final String email;
  final String password;
  final emailSignInFormType formType;
  final bool isLoading;
  final bool submitted;

  String get primaryButtonText{
     return formType == emailSignInFormType.signIn
        ? 'sign in'
        : 'Create an account';
  }

  String get secondaryButtonText{
    return formType == emailSignInFormType.signIn
        ? 'Need an account? Register'
        : 'Have an account? Sign in';
  }

  bool get canSubmit{
    return  emailValidator.isValid(email) &&
        passwordValidator.isValid(password) &&
        !isLoading;

  }

  String? get passwordErrorText{
    bool showErrorText =
        submitted && passwordValidator.isValid(password);
        return showErrorText ? invalidEmailErrorText : null;
  }

  String? get emailErrorText{
        bool showErrorText = submitted && emailValidator.isValid(email);
    return showErrorText ?invalidEmailErrorText :null;
  }

  EmailSignInModel coppyWith({
    String? email,String? password,emailSignInFormType? formType,bool? isLoading,bool? submitted}){
      return EmailSignInModel(email: email ?? this.email,password: password??this.password,formType: formType??this.formType,isLoading: isLoading??this.isLoading,submitted: submitted??this.submitted);
    }
}
