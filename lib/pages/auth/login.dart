import 'package:eguideapp/pages/auth/pass_resset/email_verif.dart';
import 'package:eguideapp/pages/auth/signup.dart';
import 'package:eguideapp/pages/core/navpage.dart';
import 'package:eguideapp/utils/dims.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../servises/auth_services.dart';
import '../../utils/app_strings.dart';
import '../../utils/app_styles.dart';

TextEditingController _emailController = TextEditingController();
TextEditingController _passController = TextEditingController();
bool _isPassVisible = false;

AuthServices _authServices = AuthServices();

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final FocusNode _emailFocusNode = FocusNode();
  final FocusNode _passwordFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _emailFocusNode.addListener(() => setState(() {}));
    _passwordFocusNode.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Container(
          margin: AppDims.globalMargin,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Image.asset('assets/images/login.png'),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    AppStrings.LoginPageSignin,
                    style: AppStyles.authTitleStyle,
                  )
                ],
              ),
              const SizedBox(height: 20),

              // Email Field
              Focus(
                onFocusChange: (_) => setState(() {}),
                child: TextField(
                  controller: _emailController,
                  focusNode: _emailFocusNode,
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.symmetric(vertical: 18, horizontal: 16),
                    labelText: 'Email',
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                    labelStyle: TextStyle(
                      color: _emailFocusNode.hasFocus ? Colors.blue : Colors.black54,
                    ),
                    prefixIcon: Icon(
                      Icons.alternate_email,
                      size: 18,
                      color: _emailFocusNode.hasFocus ? Colors.blue : Colors.black54,
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20.0),
                      borderSide: BorderSide(
                        color: _emailFocusNode.hasFocus ? Colors.blue : Colors.grey,
                        width: 1.5,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20.0),
                      borderSide: const BorderSide(
                        color: Colors.blue,
                        width: 2.0,
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // Password Field
              Focus(
                onFocusChange: (_) => setState(() {}),
                child: TextField(
                  obscureText: _isPassVisible,
                  controller: _passController,
                  focusNode: _passwordFocusNode,
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.symmetric(vertical: 18, horizontal: 16),
                    labelText: 'Password',
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                    labelStyle: TextStyle(
                      color: _passwordFocusNode.hasFocus ? Colors.blue : Colors.black54,
                    ),
                    prefixIcon: Icon(
                      CupertinoIcons.lock,
                      size: 18,
                      color: _passwordFocusNode.hasFocus ? Colors.blue : Colors.black54,
                    ),
                    suffixIcon: IconButton(
                      onPressed: () {
                        setState(() {
                          _isPassVisible = !_isPassVisible;
                        });
                      },
                      icon: Icon(
                        _isPassVisible ? Icons.visibility_off : Icons.visibility,
                        color: _passwordFocusNode.hasFocus ? Colors.blue : Colors.black54,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20.0),
                      borderSide: BorderSide(
                        color: _passwordFocusNode.hasFocus ? Colors.blue : Colors.grey,
                        width: 1.5,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20.0),
                      borderSide: const BorderSide(
                        color: Colors.blue,
                        width: 2.0,
                      ),
                    ),
                  ),
                ),
              ),

              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        CupertinoPageRoute(builder: (context) => EmailPage()),
                      );
                    },
                    child: Text(
                      'Forgot Password?',
                      style: TextStyle(color: Colors.blue),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: CupertinoButton(
                      color: const Color.fromARGB(230, 94, 142, 206),
                      child: const Text(
                        'Sign in',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      onPressed: () async {
                        if (_emailController.text.trim().isEmpty ||
                            _passController.text.isEmpty) {
                          const snackbar = SnackBar(
                            content: Text("Email/Password cannot be empty!"));
                          ScaffoldMessenger.of(context).showSnackBar(snackbar);
                        } else {
                          dynamic creds = await _authServices.loginUser(
                            _emailController.text, _passController.text);
                          if (creds == null) {
                            const snackbar = SnackBar(
                              content: Text("Email/Password invalid!"));
                            ScaffoldMessenger.of(context).showSnackBar(snackbar);
                          } else {
                            Navigator.pushReplacement(
                              context,
                              CupertinoPageRoute(
                                builder: (context) => const NavPage()));
                          }
                        }
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Center(
                    child: Row(
                      children: [
                        const Text('Not a member?'),
                        TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              CupertinoPageRoute(
                                builder: (context) => SignupPage()));
                          },
                          child: const Text(
                            'Sign up',
                            style: TextStyle(color: Colors.blue),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}