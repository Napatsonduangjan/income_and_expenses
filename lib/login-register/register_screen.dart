import 'package:flutter/material.dart';
import 'package:income_and_expenses/main.dart';
import 'login_screen.dart';
import 'package:income_and_expenses/service/auth_service.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Income Expenses App"),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Center(
        child: Container(
          height: 400,
          width: 300,
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(20))),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "Register",
                style: TextStyle(fontSize: 40),
              ),
              TextField(
                controller: emailController,
                decoration: const InputDecoration(
                    labelText: "Email", border: OutlineInputBorder()),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: passwordController,
                decoration: const InputDecoration(
                  labelText: "Password",
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.visiblePassword,
                maxLength: 8,
                obscureText: true,
              ),
              const SizedBox(height: 10),
              TextField(
                controller: confirmPasswordController,
                decoration: const InputDecoration(
                  labelText: "Confirm Password",
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.visiblePassword,
                maxLength: 8,
                obscureText: true,
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                      onPressed: () async {
                        var res = await AuthService().reqistration(
                            email: emailController.text,
                            password: passwordController.text,
                            confirm: confirmPasswordController.text);
                        if (res == 'success') {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => LoginScreen()));
                        }
                        print(res);
                      },
                      child: const Text("Register")),
                  TextButton(
                      onPressed: () async {
                        var res = await AuthService().signin(
                            email: emailController.text,
                            password: passwordController.text);

                        if (res == "success") {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(builder: (context) => HomeScreen()),
                          );
                        } else {
                          print("Login failed with message: $res");
                          ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text(res!)));
                        }
                      },
                      child: const Text("Login"))
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
