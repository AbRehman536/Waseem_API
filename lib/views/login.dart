import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:waseem_api/providers/user_token_provider.dart';
import 'package:waseem_api/service/auth.dart';
import 'package:waseem_api/views/profile.dart';
import 'package:waseem_api/views/register.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    var userProvider = Provider.of<UserProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("Login"),
      ),
      body: Column(children: [
        TextField(controller: emailController,),
        TextField(controller: passwordController,),
        isLoading ? Center(child: CircularProgressIndicator(),):
        ElevatedButton(onPressed: ()async{
          try{
            isLoading = true;
            setState(() {});
            await AuthServices().loginUser(
                email: emailController.text,
                password: passwordController.text)
                .then((value)async{
                  userProvider.setToken(value.token.toString());
                  AuthServices().getProfile(value.token.toString())
                  .then((userData){
                    isLoading = false;
                    setState(() {});
                    showDialog(context: context, builder: (BuildContext context) {
                      return AlertDialog(
                        content: Text(userData.user!.name.toString()),
                        actions: [
                          TextButton(onPressed: (){
                            Navigator.push(context, MaterialPageRoute(builder: (context)=>Profile()));
                          }, child: Text("Okay"))
                        ],
                      );
                    }, );
                  });
            });
          }catch(e){
            isLoading = false;
            setState(() {});
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));

          }
        }, child: Text("Login")),
        TextButton(onPressed: (){
          Navigator.push(context, MaterialPageRoute(builder: (context)=>Register()));
        }, child: Text("Register"))
      ],),
    );
  }
}
