import 'package:flutter/material.dart';
import 'package:the_hub_flutter/services/auth_services.dart';
import 'package:the_hub_flutter/widgets/auth_widgets/auth_submit_button.dart';
import 'package:the_hub_flutter/widgets/auth_widgets/auth_text_field.dart';
import 'package:the_hub_flutter/widgets/auth_widgets/auth_with_widget.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({
    super.key,
    required this.onTap,
  });

  final void Function()? onTap;

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  void displayMessage(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(message),
      ),
    );
  }

  void signUp() async {
    showDialog(
      context: context,
      builder: (context) => const Center(
        child: CircularProgressIndicator(),
      ),
    );

    try {
      await AuthService().noServices.registerUser(
            emailController.text,
            passwordController.text,
            confirmPasswordController.text,
            usernameController.text,
          );

      if (context.mounted) Navigator.pop(context);
    } on AuthException catch (e) {
      Navigator.pop(context);
      displayMessage(e.toString());
    } catch (e) {
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
                  size: 60,
                ),
                const SizedBox(height: 50),

                // welcome back
                Text(
                  "Let's create an account",
                  style: TextStyle(
                    color: Colors.grey[700],
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 25),

                // mail
                AuthTextField(
                  controller: emailController,
                  hintText: "Email",
                  keyboardType: TextInputType.emailAddress,
                ),
                const SizedBox(height: 10),
                // username
                AuthTextField(
                  controller: usernameController,
                  hintText: "Username",
                ),
                // password
                const SizedBox(height: 10),
                AuthTextField(
                  controller: passwordController,
                  hintText: "Password",
                  password: true,
                ),
                const SizedBox(height: 10),
                AuthTextField(
                  controller: confirmPasswordController,
                  hintText: "Comfirm Password",
                  password: true,
                ),
                const SizedBox(height: 50),

                //sign in Button
                AuthSubmitButton(
                  text: "Register",
                  onTap: signUp,
                ),
                const SizedBox(height: 50),

                // continue with
                Row(
                  children: [
                    Expanded(
                      child: Divider(
                        thickness: 0.5,
                        color: Colors.grey[400],
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
                        color: Colors.grey[400],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 50),

                // google and apple
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    AuthWithWidget(
                      onTap: () {},
                      imagePath: "assets/apple.png",
                    ),
                    // SizedBox(width: 100),
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
                      "Already have an account?",
                      style: TextStyle(
                        color: Colors.grey[700],
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(width: 4),
                    GestureDetector(
                      onTap: widget.onTap,
                      child: const Text(
                        "Login Now",
                        style: TextStyle(
                          color: Colors.blue,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
