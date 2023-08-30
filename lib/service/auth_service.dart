import 'package:firebase_auth/firebase_auth.dart';
import 'package:swift_chat/helper/helper_function.dart';
import 'package:swift_chat/service/database_services.dart';

class AuthService {
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  //login
   Future loginWithUserNameandPassword(
       String email, String password) async {
    try {
      User user = (await firebaseAuth.signInWithEmailAndPassword(
              email: email, password: password))
          .user!;

      if (user!= null) {
        return true;
      }
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }



  // register
  Future registerUserWithEmailandPassword(
      String fullName, String email, String password) async {
    try {
      User user = (await firebaseAuth.createUserWithEmailAndPassword(
              email: email, password: password))
          .user!;

      if (user!= null) {
        // call our database service to update the user data.
        await DatabaseServices(uid: user.uid).savingUserData(fullName, email);
        return true;
      }
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }

  //singout
  Future singOut() async{
    try{
      await HelperFuntion.saveUserLoggedInStatus(false);
      await HelperFuntion.saveUserEmailSF("");
      await HelperFuntion.saveUserNameSF("");
      await firebaseAuth.signOut();
    } catch(e){
      return null;
    }
  }
}
