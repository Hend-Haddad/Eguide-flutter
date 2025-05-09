import 'package:eguideapp/pages/auth/pass_resset/email_verif.dart';
import 'package:eguideapp/pages/auth/signup.dart';
import 'package:eguideapp/pages/core/navpage.dart';
import 'package:eguideapp/utils/dims.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../servises/auth_services.dart';
import '../../utils/app_strings.dart';
import '../../utils/app_styles.dart';
import 'package:provider/provider.dart';
import 'package:eguideapp/main.dart';

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
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;
    final buttonColor = const Color.fromARGB(230, 94, 142, 206); // Couleur originale du bouton
    final linkColor = Colors.blue; // Couleur originale des liens

    return Scaffold(
      backgroundColor: isDarkMode ? Colors.grey[900] : Colors.white,
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
                    style: AppStyles.authTitleStyle.copyWith(
                      color: isDarkMode ? Colors.white : Colors.black,
                    ),
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
                  style: TextStyle(color: Colors.black), // Texte toujours noir
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: isDarkMode ? Colors.white : Colors.white, // Fond blanc dans les deux modes
                    contentPadding: const EdgeInsets.symmetric(vertical: 18, horizontal: 16),
                    labelText: 'Email',
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                    labelStyle: TextStyle(
                      color: _emailFocusNode.hasFocus ? buttonColor : Colors.black54,
                    ),
                    prefixIcon: Icon(
                      Icons.alternate_email,
                      size: 18,
                      color: _emailFocusNode.hasFocus ? buttonColor : Colors.black54,
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20.0),
                      borderSide: BorderSide(
                        color: _emailFocusNode.hasFocus ? buttonColor : Colors.grey,
                        width: 1.5,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20.0),
                      borderSide: BorderSide(
                        color: buttonColor,
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
                  obscureText: !_isPassVisible,
                  controller: _passController,
                  focusNode: _passwordFocusNode,
                  style: TextStyle(color: Colors.black), // Texte toujours noir
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: isDarkMode ? Colors.white : Colors.white, // Fond blanc dans les deux modes
                    contentPadding: const EdgeInsets.symmetric(vertical: 18, horizontal: 16),
                    labelText: 'Password',
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                    labelStyle: TextStyle(
                      color: _passwordFocusNode.hasFocus ? buttonColor : Colors.black54,
                    ),
                    prefixIcon: Icon(
                      CupertinoIcons.lock,
                      size: 18,
                      color: _passwordFocusNode.hasFocus ? buttonColor : Colors.black54,
                    ),
                    suffixIcon: IconButton(
                      onPressed: () {
                        setState(() {
                          _isPassVisible = !_isPassVisible;
                        });
                      },
                      icon: Icon(
                        _isPassVisible ? Icons.visibility_off : Icons.visibility,
                        color: _passwordFocusNode.hasFocus ? buttonColor : Colors.black54,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20.0),
                      borderSide: BorderSide(
                        color: _passwordFocusNode.hasFocus ? buttonColor : Colors.grey,
                        width: 1.5,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20.0),
                      borderSide: BorderSide(
                        color: buttonColor,
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
                      style: TextStyle(color: linkColor), // Couleur originale
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: CupertinoButton(
                      color: buttonColor, // Couleur originale
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
                          final snackbar = SnackBar(
                            content: Text("Email/Password cannot be empty!"),
                          );
                          ScaffoldMessenger.of(context).showSnackBar(snackbar);
                        } else {
                          dynamic creds = await _authServices.loginUser(
                            _emailController.text, _passController.text);
                          if (creds == null) {
                            final snackbar = SnackBar(
                              content: Text("Email/Password invalid!"),
                            );
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
                        Text(
                          'Not a member?',
                          style: TextStyle(
                            color: isDarkMode ? Colors.white : Colors.black,
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              CupertinoPageRoute(
                                builder: (context) => SignupPage()));
                          },
                          child: Text(
                            'Sign up',
                            style: TextStyle(color: linkColor), // Couleur originale
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