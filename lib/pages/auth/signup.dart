// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, use_build_context_synchronously
import 'package:eguideapp/models/end_user.dart';
import 'package:eguideapp/pages/auth/login.dart';
import 'package:eguideapp/pages/auth/pass_resset/email_verif.dart';
import 'package:eguideapp/pages/core/navpage.dart';
import 'package:eguideapp/servises/auth_services.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../utils/app_strings.dart';
import '../../utils/app_styles.dart';
import '../../utils/dims.dart';

TextEditingController _emailController = TextEditingController();
TextEditingController _passController = TextEditingController();
TextEditingController _nameController = TextEditingController();
TextEditingController _passConfController = TextEditingController();
TextEditingController _fromController = TextEditingController();
TextEditingController _livingInController = TextEditingController();
bool _isPassVisible = false;
bool _isPassMatch = false;
bool _isEmailValid = true;
bool _isPasswordValid = true;
AuthServices _authServices = AuthServices();

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final _formKey = GlobalKey<FormState>();

  bool validateEmail(String email) {
    bool emailValid = RegExp(
            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
        .hasMatch(email);
    setState(() {
      _isEmailValid = emailValid;
    });
    return emailValid;
  }

  bool validatePassword(String password) {
    bool passwordValid = password.length >= 6;
    setState(() {
      _isPasswordValid = passwordValid;
    });
    return passwordValid;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            margin: AppDims.globalMargin,
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  const SizedBox(height: 30),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(AppStrings.SignupPageSignup,
                          style: AppStyles.authTitleStyle),
                    ],
                  ),
                  const SizedBox(height: 38),
                  TextFormField(
                    controller: _nameController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your full name';
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      prefixIcon: Icon(CupertinoIcons.person,
                          size: 18, color: Colors.black54),
                      label: Text('Full Name',
                          style: TextStyle(color: Colors.black54)),
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20.0),
                          borderSide: BorderSide(color: Colors.grey)),
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20.0),
                          borderSide: BorderSide(color: Colors.grey)),
                      errorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20.0),
                          borderSide: BorderSide(color: Colors.red)),
                      focusedErrorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20.0),
                          borderSide: BorderSide(color: Colors.red)),
                    ),
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: _emailController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your email';
                      } else if (!validateEmail(value)) {
                        return 'Please enter a valid email';
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      prefixIcon: Icon(CupertinoIcons.at,
                          size: 18, color: Colors.black54),
                      label: Text('Email',
                          style: TextStyle(color: Colors.black54)),
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20.0),
                          borderSide: BorderSide(color: Colors.grey)),
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20.0),
                          borderSide: BorderSide(color: Colors.grey)),
                      errorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20.0),
                          borderSide: BorderSide(color: Colors.red)),
                      focusedErrorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20.0),
                          borderSide: BorderSide(color: Colors.red)),
                    ),
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: _fromController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter where you are from';
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      prefixIcon: Icon(CupertinoIcons.placemark,
                          size: 18, color: Colors.black54),
                      label: Text('Where are you from?',
                          style: TextStyle(color: Colors.black54)),
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20.0),
                          borderSide: BorderSide(color: Colors.grey)),
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20.0),
                          borderSide: BorderSide(color: Colors.grey)),
                      errorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20.0),
                          borderSide: BorderSide(color: Colors.red)),
                      focusedErrorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20.0),
                          borderSide: BorderSide(color: Colors.red)),
                    ),
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: _livingInController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter where you live';
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      prefixIcon: Icon(CupertinoIcons.placemark,
                          size: 18, color: Colors.black54),
                      label: Text('Where do you live/will you live',
                          style: TextStyle(color: Colors.black54)),
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20.0),
                          borderSide: BorderSide(color: Colors.grey)),
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20.0),
                          borderSide: BorderSide(color: Colors.grey)),
                      errorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20.0),
                          borderSide: BorderSide(color: Colors.red)),
                      focusedErrorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20.0),
                          borderSide: BorderSide(color: Colors.red)),
                    ),
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    obscureText: !_isPassVisible,
                    controller: _passController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your password';
                      } else if (!validatePassword(value)) {
                        return 'Password must be at least 6 characters';
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      prefixIcon: Icon(CupertinoIcons.lock,
                          size: 18, color: Colors.black54),
                      label: Text('Password',
                          style: TextStyle(color: Colors.black54)),
                      suffixIcon: IconButton(
                          onPressed: () {
                            setState(() {
                              _isPassVisible = !_isPassVisible;
                            });
                          },
                          icon: Icon(_isPassVisible
                              ? Icons.visibility
                              : Icons.visibility_off)),
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20.0),
                          borderSide: BorderSide(color: Colors.grey)),
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20.0),
                          borderSide: BorderSide(color: Colors.grey)),
                      errorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20.0),
                          borderSide: BorderSide(color: Colors.red)),
                      focusedErrorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20.0),
                          borderSide: BorderSide(color: Colors.red)),
                    ),
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    obscureText: !_isPassVisible,
                    controller: _passConfController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please confirm your password';
                      } else if (value != _passController.text) {
                        return 'Passwords do not match';
                      }
                      return null;
                    },
                    onChanged: (val) {
                      setState(() {
                        _passController.text == val
                            ? _isPassMatch = true
                            : _isPassMatch = false;
                      });
                    },
                    decoration: InputDecoration(
                      prefixIcon: Icon(CupertinoIcons.lock,
                          size: 18, color: Colors.black54),
                      label: Text('Confirm Password',
                          style: TextStyle(color: Colors.black54)),
                      suffixIcon: IconButton(
                          onPressed: () {
                            setState(() {
                              _isPassVisible = !_isPassVisible;
                            });
                          },
                          icon: Icon(_isPassVisible
                              ? Icons.visibility
                              : Icons.visibility_off)),
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20.0),
                          borderSide: BorderSide(color: Colors.grey)),
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20.0),
                          borderSide: BorderSide(color: Colors.grey)),
                      errorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20.0),
                          borderSide: BorderSide(color: Colors.red)),
                      focusedErrorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20.0),
                          borderSide: BorderSide(color: Colors.red)),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Visibility(
                      visible: _isPassMatch,
                      replacement: Row(
                        children: const [
                          Icon(
                            CupertinoIcons.xmark_circle_fill,
                            color: Colors.redAccent,
                            size: 18,
                          ),
                          SizedBox(width: 6),
                          Text(
                            'Passwords do not match',
                            style: TextStyle(color: Colors.redAccent),
                          ),
                        ],
                      ),
                      child: Row(
                        children: const [
                          Icon(
                            CupertinoIcons.checkmark_circle_fill,
                            color: Colors.teal,
                            size: 18,
                          ),
                          SizedBox(width: 6),
                          Text(
                            'Passwords match',
                            style: TextStyle(color: Colors.teal),
                          ),
                        ],
                      )),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                CupertinoPageRoute(
                                    builder: (context) => EmailPage()));
                          },
                          child: Text(
                            'Forgot Password?',
                            style: TextStyle(color: Colors.blue),
                          ))
                    ],
                  ),
                  Row(
                    children: [
                      Expanded(
                          child: CupertinoButton(
                        color: Color.fromARGB(230, 94, 142, 206),
                        child: Text(
                          'Sign up',
                          style: TextStyle(
                              color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            EndUser newUser = EndUser(
                                uid: 'uid',
                                username: _nameController.text.trim(),
                                email: _emailController.text.trim(),
                                from: _fromController.text.trim(),
                                livingIn: _livingInController.text.trim());

                            dynamic creds = await _authServices.registerUser(
                                newUser, _passController.text.trim());
                            if (creds == null) {
                              const snackbar = SnackBar(
                                  content: Text("Email/Password invalid!"));
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(snackbar);
                            } else {
                              Navigator.pushReplacement(
                                  context,
                                  CupertinoPageRoute(
                                      builder: (context) => const NavPage()));
                            }
                          }
                        },
                      ))
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Center(
                        child: Row(
                          children: [
                            Text('Already a member?'),
                            TextButton(
                                onPressed: () {
                                  Navigator.push(
                                      context,
                                      CupertinoPageRoute(
                                          builder: (context) => LoginPage()));
                                },
                                child: Text(
                                  'Sign in',
                                  style: TextStyle(color: Colors.blue),
                                ))
                          ],
                        ),
                      )
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}