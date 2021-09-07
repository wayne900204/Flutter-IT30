import 'package:day_13/models/userModel.dart';
import 'package:day_13/provider/add_users_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'home_list.dart';

class ShowStream extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<UserModel>>(
      stream: context.watch<AddUsersProvider>().getUserStream,
      builder: (BuildContext context, AsyncSnapshot<List<UserModel>> snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data!.length == 0) {
            return Text('No Data');
          }
          return HomeList(data: snapshot.data!);
        }
        return Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }
}
