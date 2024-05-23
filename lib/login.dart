import 'package:admin/home.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class adimalog extends StatefulWidget {
  const adimalog({super.key});

  @override
  State<adimalog> createState() => _adimalogState();
}

class _adimalogState extends State<adimalog> {
    var email = TextEditingController();
  var password = TextEditingController();
  void login(){
      const String adminEmail = 'admin@gmail.com';
    const String adminPassword = 'admin@123';
print('object');
    if (email.text == adminEmail && password.text == adminPassword) {
      print('object');
      Fluttertoast.showToast(msg: 'Login Successful as Admin');
      // Redirect to the admin home page
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
        return AdminHomePage();
      }));
      return;
    }

  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 130, 0, 122),
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 1, 1, 82),
        leading: const Icon(
          Icons.admin_panel_settings,
          size: 33,
          color: Colors.white,
        ),
        title: const Text(
          'Admin',
          style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
              color: Color.fromARGB(255, 255, 255, 255)),
        ),
        elevation: 44,
      ),
      body: Card(
        shadowColor: Colors.black54,
        color: Color.fromARGB(255, 244, 238, 214),
        margin: EdgeInsets.symmetric(horizontal: 270.0, vertical: 94.0),
        child: Container(
          decoration: BoxDecoration(
            color: Color.fromARGB(255, 255, 248, 219),
            borderRadius: BorderRadius.circular(20),
            boxShadow: const [
              BoxShadow(
                color: Color.fromARGB(197, 91, 0, 151),
                blurRadius: 14,
                offset: Offset(4, 8), // Shadow position
              ),
            ],
          ),
          child: Padding(
            padding: EdgeInsets.all(10.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Text(
                  'Admin Login',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20.0,
                    color: Color.fromARGB(255, 0, 0, 0),
                  ),
                ),
                 TextFormField(
                  controller: email,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    labelText: 'Mail',
                  ),
                ),
                 TextFormField(
                  controller:password,
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    
                  ),
                ),
                SizedBox(height: 20.0),
                GestureDetector(
                  onTap: (){
                    login();
                  },
                  child: Container(
                    height: 39,
                    width: 88,
                    decoration: BoxDecoration(
                        boxShadow: const [
                          BoxShadow(
                            color: Color.fromARGB(197, 32, 10, 46),
                            blurRadius: 14,
                            offset: Offset(4, 8), // Shadow position
                          ),
                        ],
                        color: Color.fromARGB(255, 255, 255, 255),
                        borderRadius: BorderRadiusDirectional.circular(7),
                        gradient: const LinearGradient(
                          colors: [
                            Color.fromARGB(255, 51, 6, 76),
                            Color.fromARGB(255, 19, 2, 65)
                          ],
                          begin: Alignment.bottomLeft,
                          end: Alignment.topRight,
                          stops: [0.4, 0.7],
                          tileMode: TileMode.repeated,
                        )),
                    child: const Center(
                        child: Text(
                      "Log In",
                      style: TextStyle(
                          color: Color.fromARGB(255, 255, 255, 255),
                          fontSize: 14,
                          fontWeight: FontWeight.w100),
                    )),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
