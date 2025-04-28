// ignore_for_file: prefer_const_constructors, avoid_print


import 'package:eguideapp/pages/core/add_post.dart';
import 'package:eguideapp/pages/core/homepage.dart';
import 'package:eguideapp/pages/core/profile.dart';
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

class NavPage extends StatefulWidget {
  const NavPage({super.key});

  @override
  State<NavPage> createState() => _NavPageState();
}

class _NavPageState extends State<NavPage> {
   int _selectedIndex =0;

   final List<Widget>_pages=[
     Homepage(),
     addPostPage(),
     ProfileScreen(),
      
   ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar:Container(
        color: Colors.white12,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: GNav(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            backgroundColor: Colors.white12,
            color: Color.fromARGB(230, 94, 142, 206) ,
            activeColor: Color.fromARGB(230, 94, 142, 206) ,
            tabBackgroundColor: Colors.grey.shade200,
            gap: 8,
            padding: EdgeInsets.all(16),
            onTabChange:(int index){
             setState(() {
                _selectedIndex = index ; 
             });
                },
            // ignore: prefer_const_literals_to_create_immutables
            tabs:[
              
              GButton(
                icon: Icons.home,
                text: 'Home',
              ),
               GButton(
                icon: Icons.add,
                gap: 8,
                text: 'Add post',
                ),
              GButton(
                icon: Icons.person,
                gap: 8,
                text: 'Profile',
                ),
                
            ] ),
        ),
      ),

    );
  }
}