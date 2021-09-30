import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

abstract class AuthBase {
  User? get currentUser;
  Stream<User?> authStateChanges();
  Future<User?> signInAnonymously();
  Future<User?> signInWithGoogle();
  Future<User?> signInWithFacebook();
  Future<User?> signInWithEmailAndPassword(String email,String password);
  Future<User?> createUserWithEmailAndPassword(String email,String password);
  Future<void> signOut();
}

class Auth implements AuthBase {
  final _firebaseAuth = FirebaseAuth.instance;

  Stream<User?> authStateChanges() => _firebaseAuth.authStateChanges();

  User? get currentUser => _firebaseAuth.currentUser;

  Future<User?> signInAnonymously() async {
    final userCredential = await _firebaseAuth.signInAnonymously();
    return userCredential.user;
  }

  Future<User?> signInWithGoogle() async {
    final googleSignIn = GoogleSignIn();
    final googleUser = await googleSignIn.signIn();
    if (googleUser != null) {
      final googleAuth = await googleUser.authentication;
      if (googleAuth.idToken != null) {
        final userCredential = await _firebaseAuth.signInWithCredential(
            GoogleAuthProvider.credential(
                idToken: googleAuth.idToken,
                accessToken: googleAuth.accessToken));                
        return userCredential.user;
      } else {
        throw FirebaseAuthException(
            code: 'ERROR_MISSING_GOOGLE_ID_TOKEN',
            message: 'MISSING GOOGLE ID TOKEN');
      }
    } else {
      throw FirebaseAuthException(
          code: 'ERROR_ABORTED_BY_USER', message: 'SIGN IN ABORTED BY USER');
    }
  }

  // Future<User?> signInWithFacebook() async{    
  //   final LoginResult fb= await FacebookAuth.instance.login(
  //     permissions: [
  //       'public_profile',
  //       'email',
  //       'pasges_show_list',
  //       'pages_messaging',
  //       'pages_manage_metadata'
  //     ],
  //   );
  //   final userData=await FacebookAuth.instance.getUserData();
  //   print('.........${fb}');
  //   switch(fb.status){
  //     case LoginStatus.success:
  //         final AccessToken accessToken=fb.accessToken!;
  //         final facebookAuthCredential=FacebookAuthProvider.credential(accessToken.token);
  //         final userCredential=await FirebaseAuth.instance.signInWithCredential(facebookAuthCredential);
  //         return userCredential.user;          
  //     case LoginStatus.cancelled:
  //         throw FirebaseAuthException(code: 'ERROR_ABORTED_BY_USER',message: 'SIGN IN ABORTED BY USER');
          
  //     case LoginStatus.failed:
  //         throw FirebaseAuthException(code: 'ERROR_ABORTED_BY_USER',message: fb.message);
  //     case LoginStatus.operationInProgress:
  //         throw UnimplementedError();
  //   }
  // }
  

  final _facebookAuth = FacebookAuth.instance;
  Future<User?> signInWithFacebook() async {
    final LoginResult result = await _facebookAuth.login(
        permissions: [
          'public_profile',
          'email',
          'pages_show_list',
          'pages_messaging',
          'pages_manage_metadata'
        ],
      );
      final userData = await _facebookAuth.getUserData();

      if (result.status == LoginStatus.success) {
        final AccessToken accessToken = result.accessToken!;
        final facebookAuthCredential =
            FacebookAuthProvider.credential(accessToken.token);
        final userCreadential =
            await _firebaseAuth.signInWithCredential(facebookAuthCredential);
        return userCreadential.user;
      } else if (result.status == LoginStatus.cancelled) {
        throw FirebaseAuthException(
            code: "ERROR_ABORTED_BY_USER", message: "SIGN IN ABORTED BY USER");
      } else if (result.status == LoginStatus.failed) {
        throw FirebaseAuthException(
            code: "ERROR_ABORTED_BY_USER", message: result.message);
      } else {
        throw UnimplementedError();
      }
  }

  Future<User?> signInWithEmailAndPassword(String email,String password) async{
    final userCredential=await _firebaseAuth.signInWithCredential(EmailAuthProvider.credential(email: email, password: password));
    return userCredential.user;
  }

  Future<User?> createUserWithEmailAndPassword(String email,String password) async{
    final userCredential=await _firebaseAuth.createUserWithEmailAndPassword(email: email, password: password);
    return userCredential.user;
  }

  Future<void> signOut() async {
    final googleSignIn=GoogleSignIn();
    await googleSignIn.signOut();
    await FacebookAuth.instance.logOut();
    await _firebaseAuth.signOut();
  } 
}
