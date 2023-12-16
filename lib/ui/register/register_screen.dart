import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:to_do/ui/components/custom_form_field.dart';
import 'package:to_do/ui/database/model/user.dart' as MyUser;
import 'package:to_do/ui/database/my_database.dart';
import 'package:to_do/ui/dialouge_utlis.dart';
import 'package:to_do/ui/home/home_screen.dart';
import 'package:to_do/ui/login/login_screen.dart';
import 'package:to_do/vaild_utils.dart';

import '../../providers/auth_provider.dart';

class RegisterScreen extends StatefulWidget {
  static const String routeName = "register_screen";

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  var formKey = GlobalKey<FormState>();

  var nameController = TextEditingController(text: "Muhamed");

  var emailController = TextEditingController(text: "muhamed@gmail.com");

  var passwordController = TextEditingController(text: "123456");

  var confirmPasswordController = TextEditingController(text: "123456");

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
          color: Color(0XFFDFECDB),
          image: DecorationImage(
              image: AssetImage("assets/images/auth_bg.jpg"), fit: BoxFit.fill)),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: Text("Register"),
        ),
        body: Container(
          padding: EdgeInsets.all(12),
          child: SingleChildScrollView(
            child: Form(
              key: formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SizedBox(
                    height: MediaQuery.of(context).size.height * .3,
                  ),
                  CustomFormField(
                      controller: nameController,
                      label: "Full Name",
                      validator: (text) {
                        if (text == null || text.trim().isEmpty) {
                          return "Please enter full name";
                        }
                        return null;
                      }),
                  CustomFormField(
                    controller: emailController,
                    label: "Email Address",
                    validator: (text) {
                      if (text == null || text.trim().isEmpty) {
                        return "Please enter email Address";
                      }
                      if (!ValidUtils.isValidEmail(text)) {
                        return "Please enter valid email Address";
                      }
                      return null;
                    },
                    keyboardType: TextInputType.emailAddress,
                  ),
                  CustomFormField(
                    controller: passwordController,
                    label: "Password",
                    validator: (text) {
                      if (text == null || text.trim().isEmpty) {
                        return "Please enter your password";
                      }
                      if (text.length < 6) {
                        return "Password must be at least 6 characters";
                      }
                      return null;
                    },
                    keyboardType: TextInputType.text,
                    isPassword: true,
                  ),
                  CustomFormField(
                    controller: confirmPasswordController,
                    label: "Password Confirmation",
                    validator: (text) {
                      if (text == null || text.trim().isEmpty) {
                        return "Please confirm your password";
                      }
                      if (passwordController.text != text) {
                        return "Passwords don't match";
                      }
                      return null;
                    },
                    keyboardType: TextInputType.text,
                    isPassword: true,
                  ),
                  ElevatedButton(
                      onPressed: () {
                        register();
                      },
                      style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.symmetric(vertical: 12)),
                      child: Text(
                        "Register",
                        style: TextStyle(fontSize: 24),
                      )),
                  TextButton(
                      onPressed: () {
                        Navigator.pushReplacementNamed(
                            context, LoginScreen.routeName);
                      },
                      child: const Text("Already Have Account?"))
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  FirebaseAuth authService = FirebaseAuth.instance;

  void register() async {
    if (formKey.currentState?.validate() == false) {
      return;
    }
    DialogUtils.showLoadingDialog(context, "Loading...");
    try {
      var result = await authService.createUserWithEmailAndPassword(
          email: emailController.text, password: passwordController.text);
      // DialogUtils.hideDialog(context);
      var user = MyUser.User(
          id: result.user?.uid,
          name: nameController.text,
          email: emailController.text);
      await MyDatabase.addUser(user);
      var authProvider = Provider.of<MyAuthProvider>(context, listen: false);
      authProvider.updateUser(user);
      DialogUtils.showMessage(context, 'User registered successfully',
          posActionName: 'OK', posAction: () {
        Navigator.pushReplacementNamed(context, HomeScreen.routeName);
      }, dismissable: false);
    } on FirebaseException catch (e) {
      DialogUtils.hideDialog(context);
      String errorMessage = "something went wrong";
      if (e.code == 'weak-password') {
        errorMessage = 'The password provided is too weak';
      } else if (e.code == 'email-already-in-use') {
        errorMessage = 'The account already exists for that email.';
      }
      DialogUtils.showMessage(context, errorMessage, posActionName: "OK");
    } catch (e) {
      String errorMessage = "Something went wrong";
      DialogUtils.hideDialog(context);
      DialogUtils.showMessage(context, errorMessage,
          posActionName: "Cancle", negActionName: "Try Again", negAction: () {
        register();
      });
    }
  }
}
