import 'package:authentication_task/Screens/Register/register.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../components/buttons.dart';
import 'package:flutter/material.dart';
import '../../../../constants.dart';
import '../../HomePage.dart';

class LoginBody extends StatefulWidget {
  const LoginBody({Key? key}) : super(key: key);

  @override
  State<LoginBody> createState() => _LoginBodyState();
}

class _LoginBodyState extends State<LoginBody> {
  final _formKey = GlobalKey<FormState>();

  // TODO: Create Your Variables Here
  late String _tempEmail;
  late String _tempPassword;
  @override
  Widget build(BuildContext context) {
    bool emptyArea = false;

    return SafeArea(
        child: SingleChildScrollView(
      child: Column(
        children: [
///////////////////////////////////////////////////////////////////////////////////
          Padding(
            padding: const EdgeInsets.only(top: 120).r,
            child: SizedBox(
              width: 260.w,
              child: Column(
                children: [
                  Text(
                    "Login!",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: mainFontSize.sp,
                      fontWeight: mainFontWeight,
                    ),
                  ),
                  SizedBox(
                    height: 20.h,
                  ),
                  Text(
                    "Welcome back ! Login with your credentials",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: commonTextSize.sp,
                      color: lightGreyReceiptBG,
                    ),
                  ),
                ],
              ),
            ),
          ),
///////////////////////////////////////////////////////////////////////////////////

          SizedBox(width: double.infinity.w, height: 40.h),
          Form(
            key: _formKey,
            child: Column(
              children: [
///////////////////////////////////////////////////////////////////////////////////
                Padding(
                  padding: const EdgeInsets.only(right: 20.0).r,
                  child: SizedBox(
                    width: 220.w,
                    height: 90.h,
                    child: TextFormField(
                      validator: (value) {
                        if (value!.isEmpty) {
                          displaySnackBar("enter your email");
                          emptyArea = true;
                          return "empty";
                        }
                        return null;
                      },
                      cursorColor: textBlack,
                      style: TextStyle(fontSize: subFontSize.sp),
                      decoration: InputDecoration(
                        enabledBorder: const UnderlineInputBorder(
                          borderSide: BorderSide(color: textBlack),
                        ),
                        focusedBorder: const UnderlineInputBorder(
                          borderSide: BorderSide(color: textBlack),
                        ),
                        icon: const Icon(
                          Icons.email_outlined,
                          color: textBlack,
                        ),
                        labelText: "Email",
                        hintText: "abc@gmail.com",
                        labelStyle: TextStyle(
                            color: textBlack,
                            fontSize: mainFontSize.sp,
                            fontWeight: mainFontWeight),
                        hintStyle: TextStyle(
                            color: textBlack, fontSize: subFontSize.sp),
                      ),
                      onChanged: (text) {
                        // TODO: add your code to fetch the user email
                        _tempEmail = text;
                      },
                    ),
                  ),
                ),
///////////////////////////////////////////////////////////////////////////////////
                Padding(
                  padding: const EdgeInsets.only(right: 20.0).r,
                  child: SizedBox(
                    width: 220.w,
                    height: 90.h,
                    child: TextFormField(
                      validator: (value) {
                        if (value!.isEmpty) {
                          displaySnackBar("enter your email");
                          emptyArea = true;
                          return "empty";
                        }
                        return null;
                      },
                      cursorColor: textBlack,
                      style: TextStyle(fontSize: subFontSize.sp),
                      decoration: InputDecoration(
                        enabledBorder: const UnderlineInputBorder(
                          borderSide: BorderSide(color: textBlack),
                        ),
                        focusedBorder: const UnderlineInputBorder(
                          borderSide: BorderSide(color: textBlack),
                        ),
                        icon: const Icon(
                          Icons.password_outlined,
                          color: textBlack,
                        ),
                        labelText: "Password",
                        hintText: "******",
                        labelStyle: TextStyle(
                            color: textBlack,
                            fontSize: mainFontSize.sp,
                            fontWeight: mainFontWeight),
                        hintStyle: TextStyle(
                            color: textBlack, fontSize: subFontSize.sp),
                      ),
                      onChanged: (text) {
                        // TODO: add your code to fetch the user password
                        _tempPassword = text;
                      },
                    ),
                  ),
                ),
///////////////////////////////////////////////////////////////////////////////////
                SizedBox(height: 30.h, width: double.infinity.w),
                DefaultButton(
                    text: "Log in",
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        emptyArea = false;
                      }
                      if (emptyArea == false) {
                        await displaySnackBar("loading");

                        // TODO: add your code to log in by email & password

                        /*checking firestore for the user data while also having firebase authentication running
                         is redundant but is required by task as i understand*/

                        //check if user exists in firebase auth
                        if (await logInWithEmailAndPassword(
                            _tempEmail, _tempPassword)) {
                          //check if user exists in firestore if succesfully checked firebase auth
                          if (await verifyUserExistsInFireStore()) {
                            Navigator.pushNamed(context, HomePage.routeName);
                          }
                          //if user doesn't exist in firestore
                          else {
                            ScaffoldMessenger.maybeOf(context)
                                ?.clearSnackBars();
                            ScaffoldMessenger.maybeOf(context)?.showSnackBar(
                                const SnackBar(
                                    content:
                                        Text('No user found for that email.')));
                          }
                        }
                      }
                    }),
///////////////////////////////////////////////////////////////////////////////////
                SizedBox(height: 20.h, width: double.infinity.w),
                Text(
                  "Do not have an account ?",
                  style: (TextStyle(
                      color: textBlack, fontSize: commonTextSize.sp)),
                ),
///////////////////////////////////////////////////////////////////////////////////
                InkWell(
                  child: Text(
                    'Register',
                    style: TextStyle(
                        color: textBlack,
                        fontSize: commonTextSize.sp,
                        fontWeight: commonTextWeight),
                  ),
                  onTap: () {
                    Navigator.pushNamed(context, Register.routeName);
                  },
                )
              ],
            ),
          )
        ],
      ),
    ));
  }

  // TODO: Create Your Functions Here
  Future<bool> logInWithEmailAndPassword(String email, String password) async {
    try {
      //attempt to login user with name and password to firebase auth
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      //we will only check firestore if firebase authentication succesfully logged in the user so we must return a response
      return true;
    } on FirebaseAuthException catch (e) {
      //common exceptions
      if (e.code == 'user-not-found') {
        ScaffoldMessenger.maybeOf(context)?.clearSnackBars();
        ScaffoldMessenger.maybeOf(context)?.showSnackBar(
            const SnackBar(content: Text('No user found for that email.')));
      } else if (e.code == 'wrong-password') {
        ScaffoldMessenger.maybeOf(context)?.clearSnackBars();
        ScaffoldMessenger.maybeOf(context)?.showSnackBar(const SnackBar(
            content: Text('Wrong password provided for that user.')));
      } //for edge cases
      else {
        ScaffoldMessenger.maybeOf(context)?.clearSnackBars();
        ScaffoldMessenger.maybeOf(context)?.showSnackBar(
            SnackBar(content: Text('An error has occurd : ' + e.code)));
      }

      return false;
    }
  }

  Future<bool> verifyUserExistsInFireStore() async {
    final dB = FirebaseFirestore.instance;

    /* we will make use of the trick we did which is storing the required user in a document under the id generated
    by firebase authentication*/
    final userDoc = await dB
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser?.uid)
        .get(); //this is a doc snapshot
    return userDoc.exists;
  }
}
