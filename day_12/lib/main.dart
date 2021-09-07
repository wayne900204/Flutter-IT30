import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'bloc/network_bloc.dart';
import 'bloc/newtwork_event.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Colors.cyan[300],
        body: BlocProvider(
          create: (context) =>NetworkBloc()..add(ListenConnection()),
          child: HomeScreen(),
        ),
      ),
    );
  }
}

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: BlocBuilder<NetworkBloc, NetworkState>(
        builder: (context, state) {
          if (state is ConnectionFailure) return Text("Failed to connect to Internet",);
          if (state is ConnectionSuccess)
            return Text(" Connected to Internet Successfully");
          else
            return SizedBox();
        },
      ),
    );
  }
}
