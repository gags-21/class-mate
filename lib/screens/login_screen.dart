import 'package:flutter/material.dart';
import 'package:image_upload/provider/validations_provider.dart';
import 'package:image_upload/screens/student_selection.dart';
import 'package:image_upload/util/api.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({super.key});

  TextEditingController emailController = TextEditingController();
  TextEditingController passController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final validationProvider = Provider.of<ValidationsProvider>(context);
    final size = MediaQuery.of(context).size;

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
          height: size.height * 0.95,
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

              // pass and forgot pass
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  SizedBox(
                    width: 300,
                    child: CredentialsField(
                      textController: passController,
                      isPassword: true,
                    ),
                  ),
                  // forgot pass
                  TextButton(
                    onPressed: () {
                      launchUrl(
                        Uri.parse(
                            "https://www.bcaeducation.com/lms/forgot-password"),
                      );
                    },
                    child: const Text(
                      "Forgot Password?",
                      textAlign: TextAlign.end,
                    ),
                  ),
                ],
              ),

              // login button
              const SizedBox(
                height: 30,
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
  CredentialsField({
    super.key,
    required this.textController,
    required this.isPassword,
  });

  final TextEditingController textController;
  final bool isPassword;

  bool passVisible = false;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: textController,
      keyboardType: isPassword
          ? TextInputType.visiblePassword
          : TextInputType.emailAddress,
      obscureText: isPassword
          ? passVisible
              ? false
              : true
          : false,
      decoration: InputDecoration(
        isDense: true,
        contentPadding: const EdgeInsets.all(15),
        label: isPassword ? const Text("Password") : const Text("Enter Email"),
        prefix: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Icon(
              isPassword ? Icons.lock_open_outlined : Icons.email_outlined),
        ),
        suffix: isPassword
            ? IconButton(
                onPressed: () {
                  passVisible = !passVisible;
                  (context as Element).markNeedsBuild();
                },
                icon: Icon(
                  passVisible
                      ? Icons.visibility_off_outlined
                      : Icons.visibility_outlined,
                ),
              )
            : null,
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(
            color: Colors.blue,
          ),
          borderRadius: BorderRadius.circular(14),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: textController.text == "" ? Colors.red : Colors.blue,
          ),
          borderRadius: BorderRadius.circular(14),
        ),
      ),
    );
  }
}
