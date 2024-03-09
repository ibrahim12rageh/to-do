import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:to_do/auth/custom_text_form.dart';
import 'package:to_do/auth/register/register_screen.dart';
import 'package:to_do/dialog_utils.dart';
import 'package:to_do/home/home_screen.dart';
import 'package:to_do/my_theme.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class LoginScreen extends StatefulWidget {
  static const String routeName ='login screen' ;

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController emailController = TextEditingController(text: "ibrahim@gmail.com");

  TextEditingController passwordController = TextEditingController(text: '123456');

  var formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          color: MyTheme.backgroundLightColor,
          child: Image.asset('assets/images/main_background.png',
          height: double.infinity,
            width: double.infinity,
            fit: BoxFit.fill,
          ),
        ),
        Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            title: const Text('login'),
            centerTitle: true,
          ),
          body: SingleChildScrollView(
            child: Column(
              children: [
                Form(
                    key: formKey,
                    child: Column(
                  children: [
                    SizedBox(
                      height: MediaQuery.of(context).size.height*0.23,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Text('Welcome Back!',
                      style: Theme.of(context).textTheme.titleMedium,
                      ),
                    ),
                    CustomTextForm(
                      label: AppLocalizations.of(context)!.email,
                      keyboardType: TextInputType.emailAddress,
                      controller: emailController,
                      validator: (text){
                        if(text == null || text.trim().isEmpty){
                          return 'please enter your email';
                        }
                        bool emailValid =
                        RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                            .hasMatch(text); // compare the user will enter with regexp
                        if(!emailValid){
                          return 'please enter valid email';
                        }
                        return null;
                      },
                    ),
                    CustomTextForm(
                      label: AppLocalizations.of(context)!.password,
                      keyboardType: TextInputType.number,
                      obSecureText: true,
                      controller: passwordController,
                      validator: (text){
                        if(text == null || text.trim().isEmpty){
                          return 'please enter your password';
                        }
                        if(text.length < 6){
                          return 'password should be at lease 8 number';
                        }
                        return null;
                      },
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10),
                      child: ElevatedButton(onPressed: (){
                        login();
                      }, child: Text('login',style: Theme.of(context).textTheme.titleLarge,),
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10),
                      child: TextButton(onPressed: (){
                        Navigator.of(context).pushNamed(RegisterScreen.routeName);
                      }, child: Text('Or Create Account',style: Theme.of(context).textTheme.titleSmall?.copyWith(color: MyTheme.primaryColor),)),
                    ),
                  ],
                )
                )
              ],
            ),
          ),
        )
      ],
    );
  }

  void login() async{
    if(formKey.currentState?.validate()== true){
      //login
      // todo: show loading
      DialogUtils.showLoading(
          context:context,
          message: 'loading...',
          isDismissible: false
      );
      try {
        final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
            email: emailController.text,
            password: passwordController.text
        );
        // todo: hide loading
        DialogUtils.hideLoading(context);
        // todo: show message
        DialogUtils.showMessage(context: context, message: 'Login successfully',
            title: 'success',posActionName: 'Ok',posAction: (){
              Navigator.of(context).pushNamed(HomeScreen.routeName);
            }
        );
        print('login successfully');
        print(credential.user?.uid ?? '');
      }
      on FirebaseAuthException catch (e) {
        if (e.code == 'invalid-credential') {
          // todo: hide loading
          DialogUtils.hideLoading(context);
          // todo: show message
          DialogUtils.showMessage(context: context, message: 'The supplied auth credential is incorrect, malformed or has expired.',
            title: 'Error',posActionName: 'Ok',
          );
          print('The supplied auth credential is incorrect, malformed or has expired.');
        }
        // else if (e.code == 'wrong-password') {
        //   print('Wrong password provided for that user.');
        // }
      }
      catch(e){
        // todo: hide loading
        DialogUtils.hideLoading(context);
        // todo: show message
        DialogUtils.showMessage(context: context, message: '${e.toString()}',
          title: 'Error',posActionName: 'Ok',
        );
        print(e.toString());
      }
    }
  }
}
