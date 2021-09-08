import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:crypto/crypto.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
// import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

enum ApplicationLoginState { loggedOut, loggedIn, loadding }

class AuthProvider extends ChangeNotifier {
  /// init Firebase
  AuthProvider() {
    init();
  }

  ApplicationLoginState _loginState = ApplicationLoginState.loadding;

  ApplicationLoginState get loginState => _loginState;
  String _token = "";
  String get token => _token;

  User? _user;
  User? get user => _user;
  /// 拿到 TOKEN
  Future<void> init() async {
    await Firebase.initializeApp();

    try {
      FirebaseAuth.instance.authStateChanges().listen((user) async {
        if (user == null) {
          print("NULL USER");
          _loginState = ApplicationLoginState.loggedOut;
          notifyListeners();
        } else {
          _user = user;
           _token = await user.getIdToken(true);
          _loginState = ApplicationLoginState.loggedIn;
          debugPrint("Firebase Token：" + _token.toString(), wrapWidth: 4096);
          notifyListeners();
        }
      });
    } catch (e) {
      print("error from Auth_Provider get User id :$e");
    }
  }

  /// 登出
  void signOut() {
    FirebaseAuth.instance.signOut();
  }

  /// Google
  Future<void> signInWithGoogle() async {
    try {
      print("signInWithGoogle is onPressed");
      // // Trigger the authentication flow
      final googleInUser = await GoogleSignIn(
        scopes: [
          'email',
          'https://www.googleapis.com/auth/contacts.readonly',
        ],
      ).signIn();
      // Obtain the auth details from the request
      final googleAuth = await googleInUser?.authentication;
      // / Create a new credential
      final OAuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleAuth?.accessToken, idToken: googleAuth?.idToken);
      //use google login with firebase
      await FirebaseAuth.instance.signInWithCredential(credential);
    } on FirebaseAuthException catch (e) {
      // errorCallback(e);
    }
  }

  /// Apple
  Future<void> signInWithApple() async {
    // To prevent replay attacks with the credential returned from Apple, we
    // include a nonce in the credential request. When signing in with
    // Firebase, the nonce in the id token returned by Apple, is expected to
    // match the sha256 hash of `rawNonce`.
    final rawNonce = generateNonce();
    final nonce = sha256ofString(rawNonce);

    // Request credential for the currently signed in Apple account.
    final appleCredential = await SignInWithApple.getAppleIDCredential(
      scopes: [
        AppleIDAuthorizationScopes.email,
        AppleIDAuthorizationScopes.fullName,
      ],
      nonce: nonce,
    );

    // Create an `OAuthCredential` from the credential returned by Apple.
    final oauthCredential = OAuthProvider("apple.com").credential(
      idToken: appleCredential.identityToken,
      rawNonce: rawNonce,
    );
    print(appleCredential);
    print("SIGN IN WITH APPLE");
    // Sign in the user with Firebase. If the nonce we generated earlier does
    // not match the nonce in `appleCredential.identityToken`, sign in will fail.
    await FirebaseAuth.instance.signInWithCredential(oauthCredential);
  }

  /// Generates a cryptographically secure random nonce, to be included in a
  /// credential request.
  String generateNonce([int length = 32]) {
    final charset =
        '0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._';
    final random = Random.secure();
    return List.generate(length, (_) => charset[random.nextInt(charset.length)])
        .join();
  }

  /// Returns the sha256 hash of [input] in hex notation.
  String sha256ofString(String input) {
    final bytes = utf8.encode(input);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }

  // /// FB
  // Future<void> signInWithFacebook() async {
  //   // Trigger the sign-in flow
  //   final LoginResult loginResult = await FacebookAuth.instance.login();
  //
  //   // Create a credential from the access token
  //   final OAuthCredential facebookAuthCredential =
  //       FacebookAuthProvider.credential(loginResult.accessToken!.token);
  //
  //   // Once signed in, return the UserCredential
  //   await FirebaseAuth.instance.signInWithCredential(facebookAuthCredential);
  // }
}
