import 'package:chat/AppConfigProvider.dart';
import 'package:chat/auth/RegisterationScreen.dart';
import 'package:chat/database/DataBaseHelper.dart';
import 'package:chat/home/HomeScreen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class LoginScreen extends StatefulWidget {
  static const String ROUTE_NAME = 'login';

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _loginFormKey = GlobalKey<FormState>();

  String email = '';

  String password = '';
  bool isPasswordHidden = true;
  late AppConfigProvider provider;

  FocusNode passwordFocus =FocusNode();


  @override
  void dispose() {
    super.dispose();
    passwordFocus.dispose();
  }

  @override
  Widget build(BuildContext context) {
    provider = Provider.of<AppConfigProvider>(context);
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
            title: Center(child: Text(AppLocalizations.of(context)!.login)),
            backgroundColor: Colors.transparent,
            elevation: 0,
          ),
          body: Container(
            margin: EdgeInsets.only(top: 130),
            padding: EdgeInsets.all(12),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: EdgeInsets.fromLTRB(0, 0, 0, 5),
                    child: Text(
                      AppLocalizations.of(context)!.welcomeBack,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 24,
                      ),
                    ), //24 bold poppins
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Form(
                    key: _loginFormKey,
                    child: Column(
                      children: [
                        TextFormField(
                          autofocus: true,
                          onChanged: (textValue) {
                            email = textValue;
                          },
                          onFieldSubmitted: (_){
                            passwordFocus.requestFocus();
                          },
                          decoration: InputDecoration(
                              labelText: AppLocalizations.of(context)!.email,
                              floatingLabelBehavior:
                                  FloatingLabelBehavior.auto),
                          // The validator receives the text that the user has entered.
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return AppLocalizations.of(context)!.enterEmail;
                            }
                            return null;
                          },
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        TextFormField(
                          focusNode: passwordFocus,
                          obscureText: isPasswordHidden ? true : false,
                          onChanged: (textValue) {
                            password = textValue;
                          },
                          onFieldSubmitted: (_) => Login(),
                          decoration: InputDecoration(
                              suffixIcon: IconButton(
                                icon: Icon(isPasswordHidden
                                    ? Icons.visibility_off_outlined
                                    : Icons.visibility_outlined),
                                onPressed: () {
                                  isPasswordHidden = !isPasswordHidden;
                                  setState(() {});
                                },
                              ),
                              labelText: AppLocalizations.of(context)!.password,
                              floatingLabelBehavior:
                                  FloatingLabelBehavior.auto),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return AppLocalizations.of(context)!.enterPassword;
                            } else if (value.length < 6) {
                              return AppLocalizations.of(context)!.password6char;
                            }
                            return null;
                          },
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Container(
                          alignment: Alignment.centerLeft,
                          child: TextButton(
                            onPressed: () {},
                            child: Text(AppLocalizations.of(context)!.forgotPW),
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                      ],
                    ),
                  ),
                  isLoading
                      ? Center(child: CircularProgressIndicator())
                      : Container(
                          height: 50,
                          child: ElevatedButton(
                              onPressed: () {
                                Login();
                              },
                              child: Padding(
                                padding:
                                    const EdgeInsets.only(left: 20, right: 20),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      AppLocalizations.of(context)!.login,
                                      style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Icon(Icons.arrow_forward),
                                  ],
                                ),
                              )),
                        ),
                  TextButton(
                    child: Text(AppLocalizations.of(context)!.createNewAcc),
                    onPressed: () {
                      Navigator.pushNamed(
                          context, RegisterationScreen.ROUTE_NAME);
                    },
                  )
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  bool isLoading = false;
  void Login() {
    if (_loginFormKey.currentState?.validate() == true) {
      signIn();
    }
  }

  void signIn() async {
    setState(() {
      isLoading = true;
    });
    try {
      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      if (userCredential.user == null) {
        showMessageError(
            AppLocalizations.of(context)!.invalidCred);
      } else {
        getUsersCollectionWithConverter()
            .doc(userCredential.user!.uid)
            .get()
            .then((retrievedUser) {
          provider.updateUser(retrievedUser.data());
          Navigator.pushReplacementNamed(context, HomeScreen.ROUTE_NAME);
        });
      }
    } on FirebaseAuthException catch (e) {
      showMessageError(e.message ?? AppLocalizations.of(context)!.somethingWentWrong);
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
                child: Text(AppLocalizations.of(context)!.ok),
              )
            ],
          );
        });
  }
}
