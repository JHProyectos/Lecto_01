class AuthenticationManager {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> signInWithGoogle(bool isUtnStudent) async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) throw Exception('Google sign-in canceled');

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      await _auth.signInWithCredential(credential);
      // Additional logic for UTN students
    } catch (e) {
      throw e;
    }
  }

  Future<void> signInWithEmailPassword(
      String email, String password, bool isUtnStudent) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      // Additional logic for UTN students
    } catch (e) {
      throw e;
    }
  }
}
