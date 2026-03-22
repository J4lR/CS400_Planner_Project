import 'package:flutter/material.dart';
import 'package:test/components/rounded_button.dart';
import 'package:test/components/rounded_text_form_field.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: SafeArea(
        child: Scaffold(
          resizeToAvoidBottomInset: true,
          backgroundColor: Colors.white,
          body: _buildUI(context),
        ),
      ),
    );
  }
}

Widget _buildUI(BuildContext context) {
  return Column(children: [_header(context), _loginForm(context)]);
}

Widget _header(BuildContext context) {
  return Container(
    width: MediaQuery.of(context).size.width,
    height: MediaQuery.of(context).size.height * 0.25,
    color: const Color.fromARGB(255, 203, 81, 56),
    padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.10),
    child: Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const Padding(
          padding: EdgeInsets.fromLTRB(20, 0, 0, 0),
          child: Text(
            "Sign In",
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.w600,
              fontSize: 30,
            ),
          ),
        ),
        Image.asset(
          "assets/images/Calendar.png",
          width: MediaQuery.of(context).size.width * 0.45,
          fit: BoxFit.fitHeight,
        ),
      ],
    ),
  );
}

Widget _loginForm(BuildContext context) {
  return SizedBox(
    width: MediaQuery.of(context).size.width,
    height: MediaQuery.of(context).size.height * 0.75,
    child: Form(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 25),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [_formField(context), _buttomButton(context)],
        ),
      ),
    ),
  );
}

Widget _formField(BuildContext context) {
  return SizedBox(
    height: MediaQuery.of(context).size.height * 0.25,
    child: Column(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        RoundedTextFormField(
          prefixIcon: Icons.email_outlined,
          hintText: 'Email Address',
        ),
        RoundedTextFormField(
          prefixIcon: Icons.lock_outline,
          hintText: 'Password',
          obscureText: true,
        ),
        Text(
          "Forgot Password?",
          style: TextStyle(color: Colors.blue, fontSize: 15),
        ),
      ],
    ),
  );
}

Widget _buttomButton(BuildContext context) {
  return Column(
    mainAxisSize: MainAxisSize.max,
    mainAxisAlignment: MainAxisAlignment.center,
    crossAxisAlignment: CrossAxisAlignment.center,
    children: [
      SizedBox(
        width: MediaQuery.of(context).size.width * 0.80,
        height: MediaQuery.of(context).size.height * 0.06,
        child: RoundedButton(text: "Sign In"),
      ),
      Padding(
        padding: const EdgeInsets.only(top: 20, bottom: 30),
        child: Text(
          ("I Don't Have an Account"),
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w600,
            color: Colors.blue,
          ),
        ),
      ),
    ],
  );
}
