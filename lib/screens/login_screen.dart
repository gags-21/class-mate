import 'package:flutter/material.dart';
import 'package:image_upload/provider/validations_provider.dart';
import 'package:image_upload/screens/student_selection.dart';
import 'package:image_upload/util/api.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final validationProvider = Provider.of<ValidationsProvider>(context);
    final size = MediaQuery.of(context).size;

    TextEditingController emailController = TextEditingController();
    TextEditingController passController = TextEditingController();

    // checking valid email id
    bool checkEmailValid() {
      bool isValid = RegExp(
              r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
          .hasMatch(emailController.text);
      return isValid;
    }

    return Scaffold(
      body: SingleChildScrollView(
        child: SizedBox(
          height: size.height * 0.9,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(
                height: 150,
              ),
              Center(
                child: Image.asset(
                  "assets/attendence_image.png",
                  height: 150,
                ),
              ),
              const SizedBox(
                height: 50,
              ),

              // email
              SizedBox(
                width: 300,
                child: CredentialsField(
                  textController: emailController,
                  isPassword: false,
                ),
              ),

              const SizedBox(
                height: 20,
              ),

              // pass
              SizedBox(
                width: 300,
                child: CredentialsField(
                  textController: passController,
                  isPassword: true,
                ),
              ),

              // login button
              const SizedBox(
                height: 60,
              ),

              FilledButton.tonal(
                onPressed: () async {
                  if (emailController.text != "" && passController.text != "") {
                    if (checkEmailValid()) {
                      validationProvider.loaderSwitcher(true);
                      await UserApi()
                          .loginWithEmail(
                              emailController.text, passController.text)
                          .then((value) {
                        if (value) {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const StudentSelectPage(),
                            ),
                          );
                        }
                      }).catchError((e) {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) => LoginAlertDialog(
                            title: "Login Faild",
                            desc: e,
                          ),
                        );
                      });
                      validationProvider.loaderSwitcher(false);
                    } else {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) =>
                            const LoginAlertDialog(
                          title: "Invalid email",
                          desc: "Please enter valid email",
                        ),
                      );
                      validationProvider.loaderSwitcher(false);
                    }
                  }
                },
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.blueAccent),
                  shape: MaterialStateProperty.all(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                  minimumSize: MaterialStateProperty.all(
                    const Size(300, 50),
                  ),
                ),
                child: validationProvider.dataLoading
                    ? const CircularProgressIndicator(
                        color: Colors.white,
                      )
                    : const Text(
                        'Login',
                        style: TextStyle(color: Colors.white),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class LoginAlertDialog extends StatelessWidget {
  const LoginAlertDialog({
    super.key,
    required this.title,
    required this.desc,
  });

  final String title;
  final String desc;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(title),
      content: Text(desc),
      actions: <Widget>[
        TextButton(
          onPressed: () => Navigator.pop(context, 'OK'),
          child: const Text('Retry'),
        ),
      ],
    );
  }
}

class CredentialsField extends StatelessWidget {
  const CredentialsField({
    super.key,
    required this.textController,
    required this.isPassword,
  });

  final TextEditingController textController;
  final bool isPassword;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: textController,
      keyboardType: isPassword
          ? TextInputType.visiblePassword
          : TextInputType.emailAddress,
      obscureText: isPassword ? true : false,
      decoration: InputDecoration(
        isDense: true,
        contentPadding: const EdgeInsets.all(15),
        label: isPassword ? const Text("Password") : const Text("Enter Email"),
        prefix: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Icon(
              isPassword ? Icons.lock_open_outlined : Icons.email_outlined),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(
            color: Colors.blue,
          ),
          borderRadius: BorderRadius.circular(14),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(
            color: Colors.red,
          ),
          borderRadius: BorderRadius.circular(14),
        ),
      ),
    );
  }
}
