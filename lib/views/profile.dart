import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:waseem_api/providers/user_token_provider.dart';
import 'package:waseem_api/views/update_profile.dart';

class Profile extends StatelessWidget {
  const Profile({super.key});

  @override
  Widget build(BuildContext context) {
    var userProvider = Provider.of<UserProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("Profile"),
      ),
      body: Column(children: [
        Text("Name: ${userProvider.getUser()!.user!.name.toString()}",
            style: TextStyle(fontSize: 25,fontWeight: FontWeight.w800),),
        Text("Email: ${userProvider.getUser()!.user!.email.toString()}",
            style: TextStyle(fontSize: 25,fontWeight: FontWeight.w800),),
        ElevatedButton(onPressed: (){
          Navigator.push(context, MaterialPageRoute(builder: (context)=>UpdateProfile()));
        }, child: Text("Update Profile"))
      ],),
    );
  }
}
