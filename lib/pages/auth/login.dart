// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, use_build_context_synchronously


import 'package:eguideapp/pages/auth/pass_resset/email_verif.dart';
import 'package:eguideapp/pages/auth/signup.dart';
import 'package:eguideapp/pages/core/navpage.dart';
import 'package:eguideapp/utils/dims.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../servises/auth_services.dart';
import '../../utils/app_strings.dart';
import '../../utils/app_styles.dart';

TextEditingController _emailController= TextEditingController();
TextEditingController _passController= TextEditingController();
bool _isPassVisible= false;

AuthServices _authServices = AuthServices();

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
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
          Text(AppStrings.LoginPageSignin,
              style: AppStyles.authTitleStyle,)

                    ],
            ),
            const SizedBox(height: 20,),
            TextField(
            controller: _emailController ,
           decoration: InputDecoration(
            prefixIcon: Icon(Icons.alternate_email,size: 18,color: Colors.black54),
            label: Text('Email',style: TextStyle(color: Colors.black54),),
            enabledBorder: OutlineInputBorder(
                       borderRadius: BorderRadius.circular(20.0),
                        borderSide: BorderSide(color: Colors.grey)
                     ),
            focusedBorder: OutlineInputBorder(
                       borderRadius: BorderRadius.circular(20.0),
                       borderSide: BorderSide(color: Colors.grey)
                     ),
                     ),
           ),
             const SizedBox(height: 10,),
             TextField(
                 obscureText: _isPassVisible,
                 controller: _passController ,
                
                decoration: InputDecoration(
                  prefixIcon: Icon(CupertinoIcons.lock,size: 18,color: Colors.black54),
                  label:Text('Password',style: TextStyle(color: Colors.black54),) ,
                  suffixIcon:IconButton(
                    // ignore: avoid_print
                    onPressed: () { setState(() { _isPassVisible = !_isPassVisible;}); print(_isPassVisible); },  
                    icon: Icon(_isPassVisible ? Icons.visibility_off :Icons.visibility)),
                     enabledBorder: OutlineInputBorder(
                       borderRadius: BorderRadius.circular(20.0),
                        borderSide: BorderSide(color: Colors.grey)
                     ),
                     focusedBorder: OutlineInputBorder(
                       borderRadius: BorderRadius.circular(20.0),
                       borderSide: BorderSide(color: Colors.grey)
                     ),
                ),
           ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(onPressed: (){Navigator.push(context, CupertinoPageRoute(builder: (context) => EmailPage(),));}, child: Text('Forgot Password?',style: TextStyle(color: Colors.blue,),))
                ],
              ),
              const SizedBox(height: 10,),
              Row(
                children: [
                  Expanded(child: CupertinoButton(
                    color: Color.fromARGB(230, 94, 142, 206) ,
                    child: Text('Sign in' ,style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),),
                     onPressed: () async {
                          if (_emailController.text.trim().isEmpty ||
                              _passController.text.isEmpty) {
                            const snackbar = SnackBar(
                                content:
                                    Text("Email/Password cannot be empty!"));
                            ScaffoldMessenger.of(context)
                                .showSnackBar(snackbar);
                          } else {
                            dynamic creds = await _authServices.loginUser(
                                _emailController.text, _passController.text);
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
                        })),
                ],
              ),
              const SizedBox(height: 30,),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                Center(
                  
                  child: Row(
                    children: [
                      Text('Not a member?'),
                      TextButton(onPressed:(){Navigator.push(context, CupertinoPageRoute(builder: (context) => SignupPage(),));} , 
                      child: Text('Sign up',style: TextStyle(color: Colors.blue),))
                    ],
                  ),
                )
              ],)
        ],
      ),
     )), 
    );
  }
}

