import 'package:flutter/material.dart';

class PolicyScreen extends StatelessWidget {
  const PolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Application Information"),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              //  main logo
              Center(
                  child: Image.asset(
                "assets/title_logo.png",
                height: 80,
              )),

              // desc
              const SizedBox(height: 10),
              const Text(
                'ClassMate is your go-to attendance companion, streamlining the process with ease and simplicity. Our innovative solution ensures seamless tracking, making the learning experience smoother than ever. Embrace efficiency with ClassMate as we take attendance management to a whole new level, letting you focus on what truly matters—education',
                style: TextStyle(fontSize: 14),
                textAlign: TextAlign.left,
              ),

              const SizedBox(height: 20),
              // privacy policy starts
              RichText(
                text: const TextSpan(
                  children: [
                    TextSpan(
                      text: "Privacy",
                      style: TextStyle(color: Colors.blue),
                    ),
                    TextSpan(
                      text: " Policy",
                      style: TextStyle(color: Colors.red),
                    ),
                  ],
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue, // Headline color
                  ),
                ),
                textAlign: TextAlign.left,
              ),
              const SizedBox(height: 10),
              const Text(
                'Effective Date: 01-10-2024',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                textAlign: TextAlign.left,
              ),
              const SizedBox(height: 10),
              const Text(
                'Welcome to ClassMate, the mobile application for seamless attendance tracking. By using this application and selecting your name to mark attendance, you agree to the following privacy policy.',
                style: TextStyle(fontSize: 14),
                textAlign: TextAlign.left,
              ),
              const SizedBox(height: 20),
              const Text(
                'Information We Collect:',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                textAlign: TextAlign.left,
              ),
              const SizedBox(height: 10),
              const Text(
                'When marking attendance, ClassMate captures your name and may require a photo for verification purposes. This information is collected solely for educational purposes.',
                style: TextStyle(fontSize: 14),
                textAlign: TextAlign.left,
              ),
              const SizedBox(height: 20),
              const Text(
                'Data Storage:',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                textAlign: TextAlign.left,
              ),
              const SizedBox(height: 10),
              const Text(
                'Your attendance information, including photos, may be stored on third-party servers for efficient record-keeping. We take measures to ensure the security of your data, but we are not responsible for any data leaks or breaches.',
                style: TextStyle(fontSize: 14),
                textAlign: TextAlign.left,
              ),
              const SizedBox(height: 20),
              const Text(
                'Usage of Captured Data:',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                textAlign: TextAlign.left,
              ),
              const SizedBox(height: 10),
              const Text(
                'The captured data, including photos, will be used exclusively for attendance management within the educational context. We do not endorse or support the use of this data for any suspicious, criminal, or pornographic activities.',
                style: TextStyle(fontSize: 14),
                textAlign: TextAlign.left,
              ),
              const SizedBox(height: 20),
              const Text(
                'Data Security:',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                textAlign: TextAlign.left,
              ),
              const SizedBox(height: 10),
              const Text(
                'While we strive to maintain the security of your information, please be aware that no method of transmission over the Internet or electronic storage is 100% secure. We cannot guarantee the absolute security of your data.',
                style: TextStyle(fontSize: 14),
                textAlign: TextAlign.left,
              ),
              const SizedBox(height: 20),
              const Text(
                'Third-Party Links:',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                textAlign: TextAlign.left,
              ),
              const SizedBox(height: 10),
              const Text(
                'ClassMate may contain links to third-party websites or services. We are not responsible for the privacy practices or content of these third-party sites.',
                style: TextStyle(fontSize: 14),
                textAlign: TextAlign.left,
              ),
              const SizedBox(height: 20),
              const Text(
                'Changes to Privacy Policy:',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                textAlign: TextAlign.left,
              ),
              const SizedBox(height: 10),
              const Text(
                'We reserve the right to update our privacy policy at any time. Any changes will be effective upon posting the updated policy within the application.',
                style: TextStyle(fontSize: 14),
                textAlign: TextAlign.left,
              ),
              const SizedBox(height: 20),
              const Text(
                'Contact Us:',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                textAlign: TextAlign.left,
              ),
              const SizedBox(height: 10),
              const Text(
                'If you have any questions or concerns about our privacy policy, please contact HOD of Department.',
                style: TextStyle(fontSize: 14),
                textAlign: TextAlign.left,
              ),
              const SizedBox(height: 20),
              const Text(
                "By using ClassMate, you acknowledge that you have read and agree to this privacy policy.",
                style: TextStyle(fontSize: 14),
                textAlign: TextAlign.left,
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
