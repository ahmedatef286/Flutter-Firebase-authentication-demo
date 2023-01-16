import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../components/buttons.dart';
import 'package:flutter/material.dart';
import '../../../../constants.dart';
import '../../HomePage.dart';
import '../../Login/login.dart';

class RegisterBody extends StatefulWidget {
  const RegisterBody({Key? key}) : super(key: key);

  @override
  State<RegisterBody> createState() => _RegisterBodyState();
}

class _RegisterBodyState extends State<RegisterBody> {
  final _formKey = GlobalKey<FormState>();

  // TODO: Create Your Variables Here (added)
  //store the registered data in temporary variables that will be used to create and store the account once at the end
  //it is better to store all the information at once istead of constatnly saving to firestore with every change
  //we are safe assuming these variables won't be accessed unless they have all been filled since we will access them only if validation is succesfull
  late String _tempName;
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
            padding: const EdgeInsets.only(top: 50).r,
            child: SizedBox(
              width: 260.w,
              child: Column(
                children: [
                  Text(
                    "Register Now!",
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
                    "Create an Account,Its free",
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
                          Icons.person,
                          color: textBlack,
                        ),
                        labelText: "User Name",
                        hintText: "Ahmed Mohamed",
                        labelStyle: TextStyle(
                            color: textBlack,
                            fontSize: mainFontSize.sp,
                            fontWeight: mainFontWeight),
                        hintStyle: TextStyle(
                            color: textBlack, fontSize: subFontSize.sp),
                      ),
                      onChanged: (text) {
                        // TODO: add your code to add User Name in firestore
                        _tempName = text;
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
                        // TODO: add your code to add the user email in firestore
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
                        // TODO: add your code to add the user password in firestore
                        _tempPassword = text;
                      },
                    ),
                  ),
                ),
///////////////////////////////////////////////////////////////////////////////////
                SizedBox(height: 30.h, width: double.infinity.w),
                DefaultButton(
                    text: "Register",
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        emptyArea = false;
                      }
                      if (emptyArea == false) {
                        await displaySnackBar("loading");
                        // TODO: add your code to register by email & password and store the user data in firestore

                        //attempt to register user in firebase auth
                        if (await registerWithEmailAndPassword(
                            _tempEmail, _tempPassword)) {
                          //save data to firestore if succesful
                          await saveUserToFireStore(
                              _tempName, _tempEmail, _tempPassword);
                          Navigator.pushNamed(context, HomePage.routeName);
                        }
                      }
                    }),
///////////////////////////////////////////////////////////////////////////////////
                SizedBox(height: 20.h, width: double.infinity.w),
                Text(
                  "Already have an account ?",
                  style: (TextStyle(
                      color: textBlack, fontSize: commonTextSize.sp)),
                ),
///////////////////////////////////////////////////////////////////////////////////
                InkWell(
                  child: Text(
                    'Log in',
                    style: TextStyle(
                        color: textBlack,
                        fontSize: commonTextSize.sp,
                        fontWeight: commonTextWeight),
                  ),
                  onTap: () {
                    Navigator.pushNamed(context, Login.routeName);
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
  Future<bool> registerWithEmailAndPassword(
      String email, String password) async {
    try {
      //attempt to create user with name and password in firebase auth
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      //we will only save to firestore if firebase authentication succesfully created the user so we must return a response
      return true;
    } on FirebaseAuthException catch (e) {
      //common exceptions
      if (e.code == 'weak-password') {
        ScaffoldMessenger.maybeOf(context)?.clearSnackBars();
        ScaffoldMessenger.maybeOf(context)?.showSnackBar(const SnackBar(
            content: Text('The password provided is too weak.')));
      } else if (e.code == 'email-already-in-use') {
        ScaffoldMessenger.maybeOf(context)?.clearSnackBars();
        ScaffoldMessenger.maybeOf(context)?.showSnackBar(const SnackBar(
            content: Text('The account already exists for that email.')));
      } //for edge cases
      else {
        ScaffoldMessenger.maybeOf(context)?.clearSnackBars();
        ScaffoldMessenger.maybeOf(context)?.showSnackBar(
            SnackBar(content: Text('An error has occurd : ' + e.code)));
      }

      return false;
    }
  }

  Future<void> saveUserToFireStore(
      String name, String email, String password) async {
    final dB = FirebaseFirestore.instance;
    final user = <String, dynamic>{
      "userName": name,
      "userEmail": email,
      "userPassword": password
    };
    /* Since we are using firebase auth, we can make use of the unique identifier generated by it and make
    it the id of the created user document as well to make fetching users easier later across the entire application 
    through the firebase auth instance*/
    final newUserDoc =
        dB.collection('users').doc(FirebaseAuth.instance.currentUser?.uid);
    await newUserDoc.set(user);
  }
}
