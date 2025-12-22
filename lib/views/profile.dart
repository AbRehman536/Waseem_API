import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:waseem_api/views/update_profile.dart';

import '../providers/user_token_provider.dart';

class ProfileView extends StatelessWidget {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    var userProvider = Provider.of<UserProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("Profile"),
      ),
      body: Column(
        children: [
          Text(
            "Name: ${userProvider.getUser()!.user!.name.toString()}",
            style: TextStyle(fontSize: 30),
          ),
          SizedBox(
            height: 20,
          ),
          Text(
            "Email: ${userProvider.getUser()!.user!.email.toString()}",
            style: TextStyle(fontSize: 30),
          ),
          SizedBox(
            height: 20,
          ),
          ElevatedButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => UpdateProfileView()));
              },
              child: Text("Update Profile"))
        ],
      ),
    );
  }
}