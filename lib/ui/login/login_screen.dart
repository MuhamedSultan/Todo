import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:to_do/providers/auth_provider.dart';
import 'package:to_do/ui/database/my_database.dart';
import 'package:to_do/ui/home/home_screen.dart';
import 'package:to_do/ui/register/register_screen.dart';
import '../../vaild_utils.dart';
import '../components/custom_form_field.dart';
import '../dialouge_utlis.dart';

class LoginScreen extends StatefulWidget {
  static const String routeName = "login_screen";

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  var formKey = GlobalKey<FormState>();

  var emailController = TextEditingController(text: "muhamed@gmail.com");

  var passwordController = TextEditingController(text: "123456");

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
          title: Text("Login"),
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
                  ElevatedButton(
                      onPressed: () {
                        login();
                      },
                      style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.symmetric(vertical: 12)),
                      child: Text(
                        "Login",
                        style: TextStyle(fontSize: 24),
                      )),
                  TextButton(
                      onPressed: () {
                        Navigator.pushReplacementNamed(
                            context, RegisterScreen.routeName);
                      },
                      child: const Text("Don't Have Account?"))
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  FirebaseAuth authService = FirebaseAuth.instance;

  void login() async {
    if (formKey.currentState?.validate() == false) {
      return;
    }
    DialogUtils.showLoadingDialog(context, "Loading...");
    try {
      var result = await authService.signInWithEmailAndPassword(
          email: emailController.text, password: passwordController.text);
      // DialogUtils.hideDialog(context);
      // DialogUtils.showMessage(context, "Successful Login"
      //     "${result.user?.uid}");
      var user = await MyDatabase.readUser(result.user?.uid ?? "");
      DialogUtils.hideDialog(context);
      if (user == null) {
        DialogUtils.showMessage(context, "error. can't find user",
            posActionName: "OK");
        return;
      }
      var authProvider = Provider.of<MyAuthProvider>(context, listen: false);
      authProvider.updateUser(user);

      DialogUtils.showMessage(context, 'User logged in successfully',
          posActionName: 'OK', posAction: () {
        Navigator.pushReplacementNamed(context, HomeScreen.routeName);
      }, dismissable: false);
    } on FirebaseException catch (e) {
      DialogUtils.hideDialog(context);
      String errorMessage = "wrong email or password";
      DialogUtils.showMessage(context, errorMessage, posActionName: "OK");
    } catch (e) {
      String errorMessage = "Something went wrong";
      DialogUtils.hideDialog(context);
      DialogUtils.showMessage(context, errorMessage,
          posActionName: "Cancle", negActionName: "Try Again", negAction: () {
        login();
      });
    }
  }
}
