import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

Future<bool> signInWithGoogle() async {
  try {
    // هذا السطر هو السر: نقوم بعمل تسجيل خروج محلي قبل البدء
    // ليجبر جوجل على إظهار قائمة الحسابات في كل مرة تضغط فيها على الزر
    await _googleSignIn.signOut(); 
    
    final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
    if (googleUser == null) return false; 

    final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
    final AuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    await _auth.signInWithCredential(credential);
    return true;
  } catch (e) {
    print("خطأ في تسجيل الدخول: $e");
    return false;
  }
}

  Future<void> signOut() async {
    await _googleSignIn.signOut();
    await _auth.signOut();
  }
}