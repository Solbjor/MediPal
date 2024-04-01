import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:medipal/constant/images.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:medipal/main.dart';
import 'package:medipal/pages/signup.dart';
import 'package:medipal/pages/forgotpasswd.dart';

class PatientPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    colors: [
                      Color(0xFF6D98EB), // Light blue at the bottom
                      Color(0xFFBAD2FF),
                    ],
                  ),
                ),
                child: Padding(
                  padding: EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          IconButton(
                            icon: Icon(Icons.arrow_back, color: Colors.white, size: 40),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),
                          Container(
                            height: 100,
                            width: 100,
                            child: Image.asset(
                              myImage,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 34),
                      Row(
                        children: [ 
                          Image.asset(
                            myCal,
                          ),
                          Padding(
                            padding: EdgeInsets.all(10.25),
                            child: Text(
                              'Patient Record',
                              style: TextStyle(
                                fontSize: 26,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                shadows: [
                                  Shadow(
                                    color: Colors.black.withOpacity(0.5),
                                    offset: Offset(0, 3),
                                    blurRadius: 5,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    profilePic,
                  ),
                ],
              ),
              SizedBox(height: 8.47,),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Name of Patient',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 21.64,),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Gender',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.normal,
                      color: Color(0xFF7B7B7B),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 23.24,),
              
                Container(
                  decoration: BoxDecoration(
                    color: Color(0xFFDADFEC),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20.0),
                      topRight: Radius.circular(20.0),
                    ),
                  ),
                  child: Column(
                    children: [
                      Row(
                          children: [
                            Padding(
                              padding: EdgeInsets.only(top: 21.82, left: 27),
                              child: Text(
                                'General info',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                          ),
                        ],
                      ),
                      for (int i = 0; i < 4; i++)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(top: 18.92, left: 30),
                            child: Text(
                              'Title $i:',
                              style: TextStyle(
                                color: Color(0xFF7B7B7B),
                                fontWeight: FontWeight.normal,
                                fontSize: 16,
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: 18.92, right: 179),
                            child: Text(
                              'Item $i',
                              style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.normal,
                                fontSize: 16,
                              ),
                            ),
                            ),
                          ],
                        ),
                        SizedBox(height: 23.01),
                        Row(
                          children: [
                            Padding(
                              padding: EdgeInsets.only(top: 21.82, left: 27),
                              child: Text(
                                'Recent Diagnosis',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                        for (int i = 0; i < 2; i++)
                        Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(top: 18.92, left: 30),
                            child: Text(
                              'Title $i:',
                              style: TextStyle(
                                color: Color(0xFF7B7B7B),
                                fontWeight: FontWeight.normal,
                                fontSize: 16,
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: 18.92, right: 179),
                            child: Text(
                              'Item $i',
                              style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.normal,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 25.91),
                      Row(
                        children: [
                          Padding(
                            padding: EdgeInsets.only(top: 25.91, left: 27),
                            child: Text(
                              'Disorders',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                      for (int i = 0; i < 2; i++)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(top: 18.92, left: 30),
                            child: Text(
                              'Title $i:',
                              style: TextStyle(
                                color: Color(0xFF7B7B7B),
                                fontWeight: FontWeight.normal,
                                fontSize: 16,
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: 18.92, right: 179),
                            child: Text(
                              'Item $i',
                              style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.normal,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 25.91),   
                      Row(
                        children: [
                          Padding(
                            padding: EdgeInsets.only(top: 21.82, left: 27),
                            child: Text(
                              'Immunizations',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                      for (int i = 0; i < 2; i++)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(top: 18.92, left: 30),
                            child: Text(
                              'Title $i:',
                              style: TextStyle(
                                color: Color(0xFF7B7B7B),
                                fontWeight: FontWeight.normal,
                                fontSize: 16,
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: 18.92, right: 179),
                            child: Text(
                              'Item $i',
                              style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.normal,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 25.91), 
                      Row(
                        children: [
                          Padding(
                            padding: EdgeInsets.only(top: 21.82, left: 27),
                            child: Text(
                              'Lab Work',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                      for (int i = 0; i < 2; i++)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(top: 18.92, left: 30),
                            child: Text(
                              'Title $i:',
                              style: TextStyle(
                                color: Color(0xFF7B7B7B),
                                fontWeight: FontWeight.normal,
                                fontSize: 16,
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: 18.92, right: 179),
                            child: Text(
                              'Item $i',
                              style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.normal,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 25.91), 
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      );
  }
}
