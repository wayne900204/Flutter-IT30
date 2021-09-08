import 'package:day_16/widget/social_icon.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import 'auth_provider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  // await Firebase.initializeApp();
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]).then((_) {
    runApp(MultiProvider(providers: [
      ChangeNotifierProvider<AuthProvider>(
        create: (context) => AuthProvider(),
      ),
    ], child: new MyApp()));
  });
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Google、Apple、FB SignInDemo')),
      body: SafeArea(
        child: Consumer<AuthProvider>(builder: (context, state, child) {
          if(state.loginState==ApplicationLoginState.loggedIn){
            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    IconButton(onPressed: ()=> context.read<AuthProvider>().signOut(), icon: Icon(Icons.logout)),
                    Text("Token：",style: TextStyle(fontSize: 24,color: Colors.red),),
                    Text( state.token,style: TextStyle(fontSize: 18,color: Colors.black),),
                    Text("User：",style: TextStyle(fontSize: 24,color: Colors.red),),
                    Text(state.user.toString(),style: TextStyle(fontSize: 18,color: Colors.black),),
                  ],
                ),
              ),
            );
          }
          return SingleChildScrollView(
            child: Column(
              children: [
                SocialIcon(
                    iconSrc: "assets/icons/google.svg",
                    text: "Google",
                    onPress: () =>
                        context.read<AuthProvider>().signInWithGoogle()),
                // SocialIcon(
                //     iconSrc: "assets/icons/facebook.svg",
                //     text: "Facebook",
                //     onPress: () async =>
                //         context.read<AuthProvider>().signInWithFacebook()),
                SocialIcon(
                  iconSrc: "assets/icons/apple.svg",
                  text: "Apple",
                  onPress: () =>
                      context.read<AuthProvider>().signInWithApple(),
                ),
              ],
            ),
          );
        }),
      ),
    );
  }
}
