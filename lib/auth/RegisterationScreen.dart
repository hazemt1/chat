import 'package:chat/Appprovider.dart';
import 'package:chat/auth/LoginScreen.dart';
import 'package:chat/database/DataBaseHelper.dart';
import 'package:chat/home/HomeScreen.dart';
import 'package:chat/model/User.dart' as MyUser;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';

class RegisterationScreen extends StatefulWidget {
  static const String ROUTE_NAME = 'register';

  @override
  _RegisterationScreenState createState() => _RegisterationScreenState();
}

class _RegisterationScreenState extends State<RegisterationScreen> {
  final _registerFormKey = GlobalKey<FormState>();

  String userName = '';

  String email = '';

  String password = '';
  bool isPasswordHidden = false;
  late AppProvider provider;

  @override
  Widget build(BuildContext context) {
    provider = Provider.of<AppProvider>(context);
    return Stack(
      children: [
        Container(
          decoration: BoxDecoration(color: Colors.white),
          child: Image.asset(
            'assets/images/bg.png',
            fit: BoxFit.fill,
            width: double.infinity,
            height: double.infinity,
          ),
        ),
        Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            leading: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: (){
                Navigator.pop(context);
              },
            ),
            title: Center(child: Text('Create Account',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 23),)),
            backgroundColor: Colors.transparent,
            elevation: 0,
            centerTitle: true,
          ),
          body: Container(
            margin: EdgeInsets.only(top: 120),
            height: double.infinity,
            padding: EdgeInsets.all(12),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Form(
                    key: _registerFormKey,
                    child: Column(
                      children: [
                        TextFormField(
                          onChanged: (textValue) {
                            userName = textValue;
                          },
                          decoration: InputDecoration(
                              labelText: 'User Name',
                              floatingLabelBehavior: FloatingLabelBehavior.auto),
                          // The validator receives the text that the user has entered.
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter user name';
                            }
                            return null;
                          },
                        ),
                        TextFormField(
                          onChanged: (textValue) {
                            email = textValue;
                          },
                          decoration: InputDecoration(
                              labelText: 'Email',
                              floatingLabelBehavior: FloatingLabelBehavior.auto),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter email';
                            }
                            return null;
                          },
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        TextFormField(
                          obscureText: isPasswordHidden ? true : false,
                          onChanged: (textValue) {
                            password = textValue;
                          },
                          decoration: InputDecoration(
                              suffixIcon:IconButton(
                                icon: Icon(isPasswordHidden? Icons.visibility_off_outlined : Icons.visibility_outlined),
                                onPressed: (){
                                  isPasswordHidden = !isPasswordHidden;
                                  setState(() {});
                                },
                              ),
                              labelText: 'Password',
                              floatingLabelBehavior: FloatingLabelBehavior.auto),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter password';
                            } else if (value.length < 6) {
                              return 'password should be at least 6 characters';
                            }
                            return null;
                          },
                        ),
                        SizedBox(
                          height: 30,
                        ),
                      ],
                    ),
                  ),
                 Container(
                   margin: EdgeInsets.only(top:100),
                   alignment: Alignment.bottomCenter,
                   child: Column(
                     children: [
                       isLoading
                           ?Center(child: CircularProgressIndicator())
                           : Container(
                             child: ElevatedButton(
                             style: ButtonStyle( backgroundColor: MaterialStateProperty.all(Colors.white),),
                               onPressed: (){
                                 createAccount();
                               },
                               child: Padding(padding:  const EdgeInsets.only(left: 20,right: 20),
                               child: Row(
                                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                 children: [
                                   Text('Create Account',style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold,color: Colors.grey),),
                                   Icon(Icons.arrow_forward,color: Colors.grey,)
                                 ],
                               ),
                               ),
                            ),
                           ),
                     ],
                   ),
                 ),

                 /* TextButton(child: Text('Already have Account!'),
                    onPressed: (){
                      Navigator.pushReplacementNamed(context, LoginScreen.ROUTE_NAME);
                    },
                  )
                  */
                ],
              ),
            ),
          ),
        )
      ],
    );
  }

  final db = FirebaseFirestore.instance;
  bool isLoading = false;
  void createAccount() {
    if (_registerFormKey.currentState?.validate() == true) {
      registerUser();
    }
  }

  void registerUser() async {
    setState(() {
      isLoading = true;
    });
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
      showMessageError('User registered Successful');

      final userCollectionRef = getUsersCollectionWithConverter();
      final user = MyUser.User(
          email: email, id: userCredential.user!.uid, userName: userName);
      userCollectionRef.doc(user.id).set(user).then((value) {
        provider.updateUser(user);
        Navigator.of(context).pushReplacementNamed(HomeScreen.ROUTE_NAME);
      });
    } on FirebaseAuthException catch (e) {
      showMessageError(e.message ?? "something went wrong please try again");
    } catch (e) {
      print(e);
    }
    setState(() {
      isLoading = false;
    });
  }

  void showMessageError(String message) {
    showDialog(
        context: context,
        builder: (buildContext) {
          return AlertDialog(
            content: Text(message),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text('ok'),
              )
            ],
          );
        });
  }
}