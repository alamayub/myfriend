import 'package:flutter/material.dart';
import 'package:myfriend/services/auth.dart';
import 'package:myfriend/utils/colors.dart';
import 'package:myfriend/utils/utils.dart';
import 'package:myfriend/widgets/form_input.dart';

class LoginScreen extends StatefulWidget {
  final Function toggleView;
  const LoginScreen({Key? key, required this.toggleView}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  bool? _isLoading;
  _login() async {
    if (_email.text.isNotEmpty && _password.text.isNotEmpty) {
      setState(() => _isLoading = true);
      bool res = await AuthService()
          .loginWithEmailAndPassword(_email.text.trim(), _password.text.trim());
      if (res == false) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: _isLoading == true
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  const Text('Welcome Back!',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  Container(
                    padding: const EdgeInsets.all(16),
                    child: Form(
                        child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        FormInput(
                            controller: _email,
                            textInputType: TextInputType.emailAddress,
                            hint: 'example@example.com',
                            prefixIcon: const Icon(Icons.email_outlined)),
                        const SizedBox(height: 12),
                        FormInput(
                            controller: _password,
                            textInputType: TextInputType.visiblePassword,
                            hint: '******',
                            obscure: true,
                            prefixIcon: const Icon(Icons.lock_outline)),
                        const SizedBox(height: 12),
                        roundedSubmitButton('Login', _login)
                      ],
                    )),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Text('Don\'t have an account? ',
                          style: TextStyle(color: secondaryColor)),
                      GestureDetector(
                          onTap: () => widget.toggleView(),
                          child: const Text('Sign Up',
                              style: TextStyle(
                                  color: primaryColor,
                                  fontWeight: FontWeight.w500)))
                    ],
                  ),
                  const SizedBox(height: 10)
                ],
              ));
  }
}
