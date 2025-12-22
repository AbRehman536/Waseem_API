import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/user_token_provider.dart';
import '../service/auth.dart';

class UpdateProfileView extends StatefulWidget {
  const UpdateProfileView({super.key});

  @override
  State<UpdateProfileView> createState() => _UpdateProfileViewState();
}

class _UpdateProfileViewState extends State<UpdateProfileView> {
  TextEditingController nameController = TextEditingController();
  bool isLoading = false;

  @override
  void initState() {
    var userProvider = Provider.of<UserProvider>(context, listen: false);
    nameController = TextEditingController(
        text: userProvider.getUser()!.user!.name.toString());
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var userProvider = Provider.of<UserProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("Update Profile"),
      ),
      body: Column(
        children: [
          TextField(
            controller: nameController,
          ),
          SizedBox(
            height: 20,
          ),
          isLoading
              ? Center(
            child: CircularProgressIndicator(),
          )
              : ElevatedButton(
              onPressed: () async {
                if (nameController.text.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("Name cannot be empty.")));
                  return;
                }

                try {
                  isLoading = true;
                  setState(() {});
                  await AuthServices()
                      .updateProfile(
                      token: userProvider.getToken().toString(),
                      name: nameController.text)
                      .then((val)async {
                    await AuthServices()
                        .getProfile(userProvider.getToken().toString()).then((userData){
                      userProvider.setUser(userData);
                      isLoading = false;
                      setState(() {});
                      showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: Text("Message"),
                              content: Text(
                                  "Profile has been updated successfully"),
                              actions: [
                                TextButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                      Navigator.pop(context);
                                    },
                                    child: Text("Okay"))
                              ],
                            );
                          });
                    });

                  });
                } catch (e) {
                  isLoading = false;
                  setState(() {});
                  ScaffoldMessenger.of(context)
                      .showSnackBar(SnackBar(content: Text(e.toString())));
                }
              },
              child: Text("Update Profile"))
        ],
      ),
    );
  }
}