import 'package:flutter/material.dart';
import 'package:inventory_app/helper/shared_pref.dart';
import 'package:inventory_app/ui/pages/home_page.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import '../../services/auth_services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../../style/text_input.dart';


class LoginPage extends StatefulWidget {
  static const String route = "/login";
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  late String email;
  late String password;
  bool isLoading = false;
  final AuthServices _auth = AuthServices();
  final SharedPref _sharedPref = SharedPref();

  
  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: isLoading,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Flexible(
                  child: SizedBox(
                    height: 200.0,
                    child: Image.network(
                      'https://github.com/tbadhit/MovieCatalogue-iOS/assets/75456232/01a33156-ef88-49be-9afb-d93e8a8e136b',
                      color: Colors.red,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 24,
                ),
                TextFormField(
                  keyboardType: TextInputType.emailAddress,
                  style: const TextStyle(color: Colors.black),
                  textAlign: TextAlign.center,
                  decoration: loginTextInputDecoration('Enter your email..'),
                  validator: validator,
                  onChanged: (newValue) {
                    email = newValue;
                  },
                ),
                const SizedBox(
                  height: 8.0,
                ),
                TextFormField(
                  obscureText: true,
                  style: const TextStyle(color: Colors.black),
                  textAlign: TextAlign.center,
                  decoration: loginTextInputDecoration('Enter your password..'),
                  validator: validator,
                  onChanged: (newValue) {
                    password = newValue;
                  },
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  child: Material(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(30),
                    elevation: 5.0,
                    child: MaterialButton(
                      onPressed: () async {
                        final isValid = _formKey.currentState!.validate();
                        if (isValid) {
                          setState(() {
                            isLoading = true;
                          });
                          final login = await _auth.login(email, password);
                          if (login?.sukses ?? false) {
                            // MENYIMPAN SESI KE STORAGE
                            await _sharedPref.save("login", true);
                            // BERPINDAH HALAMAN KE HOME
                            if (!mounted) return;
                            final route = MaterialPageRoute(
                              builder: (context) => const HomePage(),);
                            Navigator.pushReplacement(context, route);
                          } else {
                            Fluttertoast.showToast(msg: login?.pesan ?? "Gagal Login");
                          }
                          setState(() {
                            isLoading = false;
                          });
                        }
                      },
                      minWidth: 200.0,
                      height: 42,
                      child: const Text(
                        'Log In',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("Don't have an account?"),
                      const SizedBox(
                        width: 5,
                      ),
                      GestureDetector(
                          onTap: () {},
                          child: const Text(
                            "Register",
                            style: TextStyle(
                                color: Colors.red, fontWeight: FontWeight.bold),
                          ))
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String? validator(String? value) =>
      value!.isEmpty ? "Please enter field" : null;
}
