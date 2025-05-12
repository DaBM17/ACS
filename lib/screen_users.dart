import 'dart:io';

import 'package:flutter/material.dart';
import 'screen_user_info.dart';
import 'data.dart';

class UsersPage extends StatefulWidget {
  List<User> users;
  UserGroup userGroup;

  UsersPage({super.key, required this.users, required this.userGroup});

  @override
  State<UsersPage> createState() => _UsersPageState();
}

class _UsersPageState extends State<UsersPage> {
  late List<User> users;
  late UserGroup userGroup;
  //late FileImage avatarImage;
  int newGroupCounter = 0;

  @override
  void initState() {
    super.initState();
    userGroup = widget.userGroup;
    users = widget.users;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Users ${widget.userGroup.name}'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          //String newGroupName = "New User $newGroupCounter";
          newGroupCounter++;
          User newUser = User(
              "New User $newGroupCounter",
              "00000");
          users.add(newUser);
          setState(() {});
        },
      ),
      body: ListView.separated(
        // it's like ListView.builder() but better
        // because it includes a separator between items
        padding: const EdgeInsets.all(16.0),
        itemCount: users.length,
        itemBuilder: (BuildContext context, int index) =>
            _buildRow(users[index], index),
        separatorBuilder: (BuildContext context, int index) => const Divider(),
      ),
    );
  }

  Widget _buildRow(User user, int index) {
    //String rightName = correctName(user);
    String rightName = user.name;
    if (rightName.contains("New User", 0)) {
      rightName = "new user";
    }
    return ListTile(
      leading: CircleAvatar(foregroundImage: FileImage(File(Data.images[rightName.toLowerCase()]!)) as ImageProvider,),
      title: Text(user.name),
      trailing: Text(user.credential),
      onTap: () => Navigator.of(context)
          .push(MaterialPageRoute<void>(
          builder: (context) => UserInfo(user: user)),
      )
          .then((var v) => setState(() {})),
    );
  }
}