import 'package:flutter/material.dart';
import 'package:myfriend/widgets/form_input.dart';

import '../../services/auth.dart';
import '../../utils/colors.dart';
import '../../utils/utils.dart';

class RegisterScreen extends StatefulWidget {
  final Function toggleView;
  const RegisterScreen({Key? key, required this.toggleView}) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController _name = TextEditingController();
  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();

  @override
  void dispose() {
    _name.dispose();
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  bool? _isLoading;

  _register() async {
    if (_name.text.isNotEmpty &&
        _email.text.isNotEmpty &&
        _password.text.isNotEmpty) {
      setState(() => _isLoading = true);
      bool res = await AuthService().register(
          _name.text.trim(), _email.text.trim(), _password.text.trim());
      if (res == false) {
        setState(() => _isLoading = false);
      }
    } else {
      showMessage('Please fill the fields!');
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
                  const Text('CREATE ACCOUNT',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  Container(
                    padding: const EdgeInsets.all(16),
                    child: Form(
                        child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        FormInput(
                            controller: _name,
                            textInputType: TextInputType.text,
                            textCapitalization: TextCapitalization.words,
                            hint: 'John Doe',
                            prefixIcon: const Icon(Icons.person_outlined)),
                        const SizedBox(height: 12),
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
                        roundedSubmitButton('Register', _register)
                      ],
                    )),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Text('Already have an account? ',
                          style: TextStyle(color: secondaryColor)),
                      GestureDetector(
                        onTap: () => widget.toggleView(),
                        child: const Text('Login',
                            style: TextStyle(
                                color: primaryColor,
                                fontWeight: FontWeight.w500)),
                      )
                    ],
                  ),
                  const SizedBox(height: 10)
                ],
              ));
  }
}


/*
File? _photo;
  final ImagePicker _picker = ImagePicker();

  _imgFromGallery() async {
    final pickedFile = await _picker.pickImage(
        source: ImageSource.gallery, maxHeight: 500, maxWidth: 500);
    if (pickedFile != null) {
      setState(() => _photo = File(pickedFile.path));
    }
  }

GestureDetector(
                          onTap: _imgFromGallery,
                          child: Container(
                            width: 100,
                            height: 100,
                            clipBehavior: Clip.antiAlias,
                            decoration: BoxDecoration(
                                color: lightColor,
                                borderRadius: BorderRadius.circular(50)),
                            child: _photo != null
                                ? Image.file(_photo!, fit: BoxFit.cover)
                                : const Center(
                                    child: Icon(Icons.image_rounded,
                                        color: Colors.black)),
                          ),
                        ),
                        const SizedBox(height: 16),*/