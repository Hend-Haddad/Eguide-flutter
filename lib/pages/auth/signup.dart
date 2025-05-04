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
bool _hasStartedTypingConfirm = false;
bool _hasStartedTypingName = false;
bool _hasStartedTypingEmail = false;
bool _hasStartedTypingFrom = false;
bool _hasStartedTypingLivingIn = false;
bool _hasStartedTypingPassword = false;
AuthServices _authServices = AuthServices();

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final _formKey = GlobalKey<FormState>();
  final FocusNode _nameFocusNode = FocusNode();
  final FocusNode _emailFocusNode = FocusNode();
  final FocusNode _fromFocusNode = FocusNode();
  final FocusNode _livingInFocusNode = FocusNode();
  final FocusNode _passwordFocusNode = FocusNode();
  final FocusNode _confirmPasswordFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _nameFocusNode.addListener(() => setState(() {}));
    _emailFocusNode.addListener(() => setState(() {}));
    _fromFocusNode.addListener(() => setState(() {}));
    _livingInFocusNode.addListener(() => setState(() {}));
    _passwordFocusNode.addListener(() => setState(() {}));
    _confirmPasswordFocusNode.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _nameFocusNode.dispose();
    _emailFocusNode.dispose();
    _fromFocusNode.dispose();
    _livingInFocusNode.dispose();
    _passwordFocusNode.dispose();
    _confirmPasswordFocusNode.dispose();
    super.dispose();
  }

  bool validateEmail(String email) {
    bool emailValid = RegExp(
            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
        .hasMatch(email);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        _isEmailValid = emailValid;
      });
    });
    return emailValid;
  }

  bool validatePassword(String password) {
    bool passwordValid = password.length >= 6;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        _isPasswordValid = passwordValid;
      });
    });
    return passwordValid;
  }

  String? _nameValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your full name';
    }
    return null;
  }

  String? _emailValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your email';
    } else if (!validateEmail(value)) {
      return 'Please enter a valid email';
    }
    return null;
  }

  String? _fromValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter where you are from';
    }
    return null;
  }

  String? _livingInValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter where you live';
    }
    return null;
  }

  String? _passwordValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your password';
    } else if (!validatePassword(value)) {
      return 'Password must be at least 6 characters';
    }
    return null;
  }

  String? _confirmPasswordValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please confirm your password';
    } else if (value != _passController.text) {
      return 'Passwords do not match';
    }
    return null;
  }

  void _handleFieldChanged(String field, String value) {
    switch (field) {
      case 'name':
        _hasStartedTypingName = value.isNotEmpty;
        break;
      case 'email':
        _hasStartedTypingEmail = value.isNotEmpty;
        if (value.isNotEmpty) validateEmail(value);
        break;
      case 'from':
        _hasStartedTypingFrom = value.isNotEmpty;
        break;
      case 'livingIn':
        _hasStartedTypingLivingIn = value.isNotEmpty;
        break;
      case 'password':
        _hasStartedTypingPassword = value.isNotEmpty;
        if (value.isNotEmpty) validatePassword(value);
        break;
      case 'confirmPassword':
        _hasStartedTypingConfirm = value.isNotEmpty;
        _isPassMatch = value == _passController.text;
        break;
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_formKey.currentState != null) {
        _formKey.currentState!.validate();
      }
      setState(() {});
    });
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
              autovalidateMode: AutovalidateMode.onUserInteraction,
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
                  
                  // Full Name Field
                  Focus(
                    onFocusChange: (_) => setState(() {}),
                    child: TextFormField(
                      controller: _nameController,
                      focusNode: _nameFocusNode,
                      onChanged: (val) => _handleFieldChanged('name', val),
                      validator: _nameValidator,
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.symmetric(vertical: 18, horizontal: 16),
                        labelText: 'Full Name',
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                        labelStyle: TextStyle(
                          color: _nameFocusNode.hasFocus ? Colors.blue : Colors.black54,
                        ),
                        prefixIcon: Icon(
                          CupertinoIcons.person,
                          size: 18,
                          color: _nameFocusNode.hasFocus ? Colors.blue : Colors.black54,
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20.0),
                          borderSide: BorderSide(
                            color: _nameFocusNode.hasFocus ? Colors.blue : Colors.grey,
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
                        errorBorder: _hasStartedTypingName
                            ? OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20.0),
                                borderSide: BorderSide(color: Colors.grey))
                            : OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20.0),
                                borderSide: BorderSide(color: Colors.red)),
                        focusedErrorBorder: _hasStartedTypingName
                            ? OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20.0),
                                borderSide: BorderSide(color: Colors.grey))
                            : OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20.0),
                                borderSide: BorderSide(color: Colors.red)),
                        errorStyle: _hasStartedTypingName
                            ? const TextStyle(height: 0)
                            : null,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  
                  // Email Field
                  Focus(
                    onFocusChange: (_) => setState(() {}),
                    child: TextFormField(
                      controller: _emailController,
                      focusNode: _emailFocusNode,
                      onChanged: (val) => _handleFieldChanged('email', val),
                      validator: _emailValidator,
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.symmetric(vertical: 18, horizontal: 16),
                        labelText: 'Email',
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                        labelStyle: TextStyle(
                          color: _emailFocusNode.hasFocus ? Colors.blue : Colors.black54,
                        ),
                        prefixIcon: Icon(
                          CupertinoIcons.at,
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
                        errorBorder: _hasStartedTypingEmail && _isEmailValid
                            ? OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20.0),
                                borderSide: BorderSide(color: Colors.grey))
                            : OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20.0),
                                borderSide: BorderSide(color: Colors.red)),
                        focusedErrorBorder: _hasStartedTypingEmail && _isEmailValid
                            ? OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20.0),
                                borderSide: BorderSide(color: Colors.grey))
                            : OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20.0),
                                borderSide: BorderSide(color: Colors.red)),
                        errorStyle: (_hasStartedTypingEmail && _isEmailValid) || 
                                  (!_hasStartedTypingEmail && _emailController.text.isEmpty)
                            ? const TextStyle(height: 0)
                            : null,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  
                  // From Field
                  Focus(
                    onFocusChange: (_) => setState(() {}),
                    child: TextFormField(
                      controller: _fromController,
                      focusNode: _fromFocusNode,
                      onChanged: (val) => _handleFieldChanged('from', val),
                      validator: _fromValidator,
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.symmetric(vertical: 18, horizontal: 16),
                        labelText: 'Where are you from?',
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                        labelStyle: TextStyle(
                          color: _fromFocusNode.hasFocus ? Colors.blue : Colors.black54,
                        ),
                        prefixIcon: Icon(
                          CupertinoIcons.placemark,
                          size: 18,
                          color: _fromFocusNode.hasFocus ? Colors.blue : Colors.black54,
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20.0),
                          borderSide: BorderSide(
                            color: _fromFocusNode.hasFocus ? Colors.blue : Colors.grey,
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
                        errorBorder: _hasStartedTypingFrom
                            ? OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20.0),
                                borderSide: BorderSide(color: Colors.grey))
                            : OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20.0),
                                borderSide: BorderSide(color: Colors.red)),
                        focusedErrorBorder: _hasStartedTypingFrom
                            ? OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20.0),
                                borderSide: BorderSide(color: Colors.grey))
                            : OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20.0),
                                borderSide: BorderSide(color: Colors.red)),
                        errorStyle: _hasStartedTypingFrom
                            ? const TextStyle(height: 0)
                            : null,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  
                  // Living In Field
                  Focus(
                    onFocusChange: (_) => setState(() {}),
                    child: TextFormField(
                      controller: _livingInController,
                      focusNode: _livingInFocusNode,
                      onChanged: (val) => _handleFieldChanged('livingIn', val),
                      validator: _livingInValidator,
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.symmetric(vertical: 18, horizontal: 16),
                        labelText: 'Where do you live/will you live',
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                        labelStyle: TextStyle(
                          color: _livingInFocusNode.hasFocus ? Colors.blue : Colors.black54,
                        ),
                        prefixIcon: Icon(
                          CupertinoIcons.placemark,
                          size: 18,
                          color: _livingInFocusNode.hasFocus ? Colors.blue : Colors.black54,
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20.0),
                          borderSide: BorderSide(
                            color: _livingInFocusNode.hasFocus ? Colors.blue : Colors.grey,
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
                        errorBorder: _hasStartedTypingLivingIn
                            ? OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20.0),
                                borderSide: BorderSide(color: Colors.grey))
                            : OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20.0),
                                borderSide: BorderSide(color: Colors.red)),
                        focusedErrorBorder: _hasStartedTypingLivingIn
                            ? OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20.0),
                                borderSide: BorderSide(color: Colors.grey))
                            : OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20.0),
                                borderSide: BorderSide(color: Colors.red)),
                        errorStyle: _hasStartedTypingLivingIn
                            ? const TextStyle(height: 0)
                            : null,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  
                  // Password Field
                  Focus(
                    onFocusChange: (_) => setState(() {}),
                    child: TextFormField(
                      obscureText: !_isPassVisible,
                      controller: _passController,
                      focusNode: _passwordFocusNode,
                      onChanged: (val) => _handleFieldChanged('password', val),
                      validator: _passwordValidator,
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
                            _isPassVisible ? Icons.visibility : Icons.visibility_off,
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
                        errorBorder: _hasStartedTypingPassword && _isPasswordValid
                            ? OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20.0),
                                borderSide: BorderSide(color: Colors.grey))
                            : OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20.0),
                                borderSide: BorderSide(color: Colors.red)),
                        focusedErrorBorder: _hasStartedTypingPassword && _isPasswordValid
                            ? OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20.0),
                                borderSide: BorderSide(color: Colors.grey))
                            : OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20.0),
                                borderSide: BorderSide(color: Colors.red)),
                        errorStyle: (_hasStartedTypingPassword && _isPasswordValid) || 
                                  (!_hasStartedTypingPassword && _passController.text.isEmpty)
                            ? const TextStyle(height: 0)
                            : null,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  
                  // Confirm Password Field
                  Focus(
                    onFocusChange: (_) => setState(() {}),
                    child: TextFormField(
                      obscureText: !_isPassVisible,
                      controller: _passConfController,
                      focusNode: _confirmPasswordFocusNode,
                      validator: _confirmPasswordValidator,
                      onChanged: (val) => _handleFieldChanged('confirmPassword', val),
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.symmetric(vertical: 18, horizontal: 16),
                        labelText: 'Confirm Password',
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                        labelStyle: TextStyle(
                          color: _confirmPasswordFocusNode.hasFocus ? Colors.blue : Colors.black54,
                        ),
                        prefixIcon: Icon(
                          CupertinoIcons.lock,
                          size: 18,
                          color: _confirmPasswordFocusNode.hasFocus ? Colors.blue : Colors.black54,
                        ),
                        suffixIcon: IconButton(
                          onPressed: () {
                            setState(() {
                              _isPassVisible = !_isPassVisible;
                            });
                          },
                          icon: Icon(
                            _isPassVisible ? Icons.visibility : Icons.visibility_off,
                            color: _confirmPasswordFocusNode.hasFocus ? Colors.blue : Colors.black54,
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20.0),
                          borderSide: BorderSide(
                            color: _confirmPasswordFocusNode.hasFocus ? Colors.blue : Colors.grey,
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
                        errorBorder: _hasStartedTypingConfirm && _isPassMatch
                            ? OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20.0),
                                borderSide: BorderSide(color: Colors.grey))
                            : OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20.0),
                                borderSide: BorderSide(color: Colors.red)),
                        focusedErrorBorder: _hasStartedTypingConfirm && _isPassMatch
                            ? OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20.0),
                                borderSide: BorderSide(color: Colors.grey))
                            : OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20.0),
                                borderSide: BorderSide(color: Colors.red)),
                        errorStyle: (_hasStartedTypingConfirm && _isPassMatch) || 
                                  (!_hasStartedTypingConfirm && _passConfController.text.isEmpty)
                            ? const TextStyle(height: 0)
                            : null,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  
                  if (_hasStartedTypingConfirm)
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
                        child: const Text(
                          'Forgot Password?',
                          style: TextStyle(color: Colors.blue),
                        ),
                      ),
                    ],
                  ),
                  
                  Row(
                    children: [
                      Expanded(
                        child: CupertinoButton(
                          color: const Color.fromARGB(230, 94, 142, 206),
                          child: const Text(
                            'Sign up',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          onPressed: () async {
                            if (_formKey.currentState!.validate()) {
                              EndUser newUser = EndUser(
                                uid: 'uid',
                                username: _nameController.text.trim(),
                                email: _emailController.text.trim(),
                                from: _fromController.text.trim(),
                                livingIn: _livingInController.text.trim(),
                              );

                              dynamic creds = await _authServices.registerUser(
                                newUser,
                                _passController.text.trim(),
                              );
                              if (creds == null) {
                                const snackbar = SnackBar(
                                  content: Text("Email/Password invalid!"));
                                ScaffoldMessenger.of(context).showSnackBar(snackbar);
                              } else {
                                Navigator.pushReplacement(
                                  context,
                                  CupertinoPageRoute(
                                    builder: (context) => const NavPage()),
                                );
                              }
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 10),
                  
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Center(
                        child: Row(
                          children: [
                            const Text('Already a member?'),
                            TextButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  CupertinoPageRoute(
                                    builder: (context) => LoginPage()),
                                );
                              },
                              child: const Text(
                                'Sign in',
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
        ),
      ),
    );
  }
}