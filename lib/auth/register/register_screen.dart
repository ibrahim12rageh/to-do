import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:to_do/auth/custom_text_form.dart';
import 'package:to_do/dialog_utils.dart';
import 'package:to_do/firebase_utils.dart';
import 'package:to_do/home/home_screen.dart';
import 'package:to_do/model/my_user.dart';
import 'package:to_do/my_theme.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class RegisterScreen extends StatefulWidget {
  static const String routeName ='register screen' ;

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  TextEditingController nameController = TextEditingController(text: "ibrahim");

  TextEditingController emailController = TextEditingController(text: "ibrahim@gmail.com");

  TextEditingController passwordController = TextEditingController(text: '123456');

  TextEditingController confirmPasswordController = TextEditingController(text: '123456');

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
            title: Text('create account'),
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
                    CustomTextForm(
                      label: AppLocalizations.of(context)!.user_name,
                      controller: nameController,
                      validator: (text){
                        if(text == null || text.trim().isEmpty){
                          return 'please enter user name';
                        }
                        return null;
                      },
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
                    CustomTextForm(
                      label: AppLocalizations.of(context)!.confirm_password,
                      keyboardType: TextInputType.number,
                      obSecureText: true,
                      controller: confirmPasswordController,
                      validator: (text){
                        if(text == null || text.trim().isEmpty){
                          return 'please confirm password';
                        }
                        if(text != passwordController.text){
                          return "confirm password doesn't match password.";
                        }
                        return null;
                      },
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10),
                      child: ElevatedButton(onPressed: (){
                        register();
                      }, child: Text('create Account',style: Theme.of(context).textTheme.titleLarge,),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue
                        ),
                      ),
                    )
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

  void register() async{
    if(formKey.currentState?.validate()== true){
      //register
      // todo: show loading
      DialogUtils.showLoading(
          context:context,
          message: 'loading...',
        isDismissible: false
      );
      try {
        final credential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: emailController.text,
          password: passwordController.text,
        );
        MyUser myUser = MyUser(
            id: credential.user?.uid ?? '',
            name: nameController.text,
            email: emailController.text
        );
        await FirebaseUtils.addUserToFireStore(myUser);
        // todo: hide loading
        DialogUtils.hideLoading(context);
        // todo: show message
        DialogUtils.showMessage(context: context, message: 'register successfully',
          title: 'success',posActionName: 'Ok',posAction: (){
          Navigator.of(context).pushNamed(HomeScreen.routeName);
            }
        );
        print('register successfully');
        print(credential.user?.uid ?? '');
      } on FirebaseAuthException catch (e) {
        if (e.code == 'weak-password') {
          // todo: hide loading
          DialogUtils.hideLoading(context);
          // todo: show message
          DialogUtils.showMessage(context: context, message: 'The password provided is too weak.',
            title: 'Error',posActionName: 'Ok',
          );
          print('The password provided is too weak.');
        } else if (e.code == 'email-already-in-use') {
          // todo: hide loading
          DialogUtils.hideLoading(context);
          // todo: show message
          DialogUtils.showMessage(context: context,
              message: 'The account already exists for that email.',
            title: 'Error',posActionName: 'Ok',
          );
          print('The account already exists for that email.');
        }
      } catch (e) {
        // todo: hide loading
        DialogUtils.hideLoading(context);
        // todo: show message
        DialogUtils.showMessage(context: context, message: '${e.toString()}',
          title: 'Error',posActionName: 'Ok',
        );
        print(e);
      }
    }
  }
}
