import 'package:flutter/material.dart';

import '../service/auth.dart';
import 'login.dart';
class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController pwdController = TextEditingController();
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Register"),
      ),
      body: Column(
        children: [
          TextField(
            controller: nameController,
          ),
          SizedBox(
            height: 20,
          ),
          TextField(
            controller: emailController,
          ),
          SizedBox(
            height: 20,
          ),
          TextField(
            controller: pwdController,
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
                if (emailController.text.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("Email cannot be empty.")));
                  return;
                }
                if (pwdController.text.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("Password cannot be empty.")));
                  return;
                }
                try {
                  isLoading = true;
                  setState(() {});
                  await AuthServices()
                      .registerUser(
                      name: nameController.text,
                      email: emailController.text,
                      password: pwdController.text)
                      .then((val) {
                    isLoading = false;
                    setState(() {});
                    showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: Text("Message"),
                            content: Text("Registered "),
                            actions: [
                              TextButton(
                                  onPressed: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                LoginView()));
                                  },
                                  child: Text("Okay"))
                            ],
                          );
                        });
                  });
                } catch (e) {
                  isLoading = false;
                  setState(() {});
                  ScaffoldMessenger.of(context)
                      .showSnackBar(SnackBar(content: Text(e.toString())));
                }
              },
              child: Text("Register"))
        ],
      ),
    );
  }
}