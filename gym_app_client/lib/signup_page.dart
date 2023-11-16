import 'package:flutter/material.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<SignUpPage> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _bDateController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmedPasswordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Padding(
                  padding: EdgeInsets.all(30.0),
                  child: Text(
                    "Sign Up",
                    style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.only(left: 30, right: 30, bottom: 15),
                  child: TextFormField(
                    controller: _usernameController,
                    decoration: const InputDecoration(
                      label: Text("Username"),
                      prefixIcon: Icon(Icons.person_outline),
                      hintText: "Enter your username",
                      filled: true,
                      enabledBorder:
                          OutlineInputBorder(borderSide: BorderSide.none),
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.blue)),
                    ),
                    validator: (String? value) {
                      if (value == null || value.isEmpty) {
                        return "Please enter your username";
                      }

                      setState(() => _usernameController.text = value);
                      return null;
                    },
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.only(left: 30, right: 30, bottom: 15),
                  child: TextFormField(
                    controller: _emailController,
                    decoration: const InputDecoration(
                      label: Text("Email"),
                      filled: true,
                      prefixIcon: Icon(Icons.mail_outline),
                      hintText: "Enter your email",
                      enabledBorder:
                          OutlineInputBorder(borderSide: BorderSide.none),
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.blue)),
                    ),
                    validator: (String? value) {
                      if (value == null || value.isEmpty) {
                        return "Please enter your email";
                      }

                      setState(() => _emailController.text = value);
                      return null;
                    },
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.only(left: 30, right: 30, bottom: 15),
                  child: TextFormField(
                    controller: _bDateController,
                    decoration: const InputDecoration(
                      label: Text("Birth Date"),
                      filled: true,
                      prefixIcon: Icon(Icons.calendar_month_outlined),
                      enabledBorder:
                          OutlineInputBorder(borderSide: BorderSide.none),
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.blue)),
                    ),
                    validator: (String? value) {
                      if (value == null || value.isEmpty) {
                        return "Please enter your birth date";
                      }

                      return null;
                    },
                    readOnly: true,
                    onTap: () => _selectDate(),
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.only(left: 30, right: 30, bottom: 15),
                  child: TextFormField(
                    controller: _passwordController,
                    decoration: const InputDecoration(
                      label: Text("Password"),
                      filled: true,
                      prefixIcon: Icon(Icons.lock_outline),
                      hintText: "Enter your password",
                      enabledBorder:
                          OutlineInputBorder(borderSide: BorderSide.none),
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.blue)),
                    ),
                    obscureText: true,
                    validator: (String? value) {
                      if (value == null || value.isEmpty) {
                        return "Please enter your password";
                      }

                      setState(() => _passwordController.text = value);
                      return null;
                    },
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.only(left: 30, right: 30, bottom: 30),
                  child: TextFormField(
                    controller: _confirmedPasswordController,
                    decoration: const InputDecoration(
                      label: Text("Confirm Password"),
                      filled: true,
                      prefixIcon: Icon(Icons.lock_outline),
                      hintText: "Please confirm your password",
                      enabledBorder:
                          OutlineInputBorder(borderSide: BorderSide.none),
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.blue)),
                    ),
                    obscureText: true,
                    validator: (String? value) {
                      if (value == null || value.isEmpty) {
                        return "Please enter your password";
                      }

                      setState(() => _confirmedPasswordController.text = value);
                      return null;
                    },
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      debugPrint("Successful submit!");

                      var registerData = {
                        "username": _usernameController.text,
                        "email": _emailController.text,
                        "bDate": _bDateController.text,
                        "password": _passwordController.text,
                        "cPassword": _confirmedPasswordController.text
                      };

                      debugPrint(registerData.toString());
                    } else {
                      debugPrint("Failed submittion!");
                    }
                  },
                  child: const Text('Sign Up'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _bDateController.dispose();
    _passwordController.dispose();
    _confirmedPasswordController.dispose();
    super.dispose();
  }

  Future<void> _selectDate() async {
    DateTime curDate = DateTime.now();

    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: curDate,
      firstDate: DateTime(curDate.year - 122),
      lastDate: curDate,
    );

    if (pickedDate != null) {
      setState(
          () => _bDateController.text = pickedDate.toString().split(" ")[0]);
    }
  }
}
