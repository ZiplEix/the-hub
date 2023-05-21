import 'package:flutter/material.dart';
import 'package:the_hub_flutter/services/auth_services.dart';
import 'package:the_hub_flutter/widgets/auth_widgets/auth_submit_button.dart';
import 'package:the_hub_flutter/widgets/auth_widgets/auth_text_field.dart';
import 'package:the_hub_flutter/widgets/auth_widgets/auth_with_widget.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({
    super.key,
    required this.onTap,
  });

  final void Function()? onTap;

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  void displayMessage(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(message),
      ),
    );
  }

  void signIn() async {
    showDialog(
      context: context,
      builder: (context) => const Center(
        child: CircularProgressIndicator(),
      ),
    );

    if (_emailController.text.isEmpty || _passwordController.text.isEmpty) {
      Navigator.pop(context);
      displayMessage("Please fill all the fields");
      return;
    }

    try {
      await AuthService().noServices.logInUser(
            _emailController.text,
            _passwordController.text,
          );
      if (context.mounted) Navigator.pop(context);
    } on AuthException catch (e) {
      Navigator.pop(context);
      displayMessage(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Logo
                const Icon(
                  Icons.lock,
                  size: 100,
                ),
                const SizedBox(height: 50),

                // welcome back
                Text(
                  "Welcome back",
                  style: TextStyle(
                    color: Colors.grey[700],
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 25),

                // username password
                AuthTextField(
                  controller: _emailController,
                  hintText: "Email",
                  keyboardType: TextInputType.emailAddress,
                ),
                const SizedBox(height: 10),
                AuthTextField(
                  controller: _passwordController,
                  hintText: "Password",
                  password: true,
                ),
                const SizedBox(height: 10),

                // forget password
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25),
                  child: Row(
                    children: [
                      Text(
                        "Forget password ?",
                        style: TextStyle(color: Colors.grey[600]),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 25),

                // sign in Button
                AuthSubmitButton(
                  text: "Sign In",
                  onTap: signIn,
                ),
                const SizedBox(height: 50),

                // continue with
                Row(
                  children: [
                    Expanded(
                      child: Divider(
                        thickness: 0.5,
                        color: Colors.grey[500],
                        indent: 25,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Text(
                        "Or continue with",
                        style: TextStyle(
                          color: Colors.grey[700],
                        ),
                      ),
                    ),
                    Expanded(
                      child: Divider(
                        thickness: 0.5,
                        color: Colors.grey[500],
                        endIndent: 25,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 50),

                // tier services auth
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    AuthWithWidget(
                      onTap: () {},
                      imagePath: "assets/apple.png",
                    ),
                    AuthWithWidget(
                      onTap: () => AuthService().google.signInWithGoogle(),
                      imagePath: "assets/google.png",
                    ),
                  ],
                ),
                const SizedBox(height: 50),

                // not members
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Not a member yet?",
                      style: TextStyle(
                        color: Colors.grey[700],
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(width: 4),
                    GestureDetector(
                      onTap: widget.onTap,
                      child: const Text(
                        "Register Now",
                        style: TextStyle(
                          color: Colors.blue,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
