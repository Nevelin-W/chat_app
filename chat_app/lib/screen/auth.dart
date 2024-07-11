import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

final _fireBase = FirebaseAuth.instance;
final GlobalKey<ScaffoldMessengerState> _scaffoldMessengerKey =
    GlobalKey<ScaffoldMessengerState>();

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _formKey = GlobalKey<FormState>();
  var _isLogin = true;
  var _enterdEmail = '';
  var _enterdPassword = '';

  void _submit() async {
    final isValid = _formKey.currentState!.validate();
    if (!isValid) {
      return;
    }
    _formKey.currentState!.save();
    try {
      if (_isLogin) {
        final userCredentials = await _fireBase.signInWithEmailAndPassword(
          email: _enterdEmail,
          password: _enterdPassword,
        );
      } else {
        final userCredential = await _fireBase.createUserWithEmailAndPassword(
          email: _enterdEmail,
          password: _enterdPassword,
        );
      }
    } on FirebaseAuthException catch (e) {
      _scaffoldMessengerKey.currentState?.clearSnackBars();
      _scaffoldMessengerKey.currentState?.showSnackBar(
        SnackBar(
          content: Text(e.message ?? 'Authentication failed'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primaryContainer,
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                margin: const EdgeInsets.only(
                  top: 10,
                  bottom: 10,
                  right: 10,
                  left: 10,
                ),
                width: 200,
                child: Image.asset('assets/images/chat.png'),
              ),
              Card(
                margin: const EdgeInsets.all(10),
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          TextFormField(
                            decoration: const InputDecoration(
                              labelText: 'email',
                            ),
                            keyboardType: TextInputType.emailAddress,
                            autocorrect: false,
                            textCapitalization: TextCapitalization.none,
                            validator: (value) {
                              if (value == null ||
                                  value.trim().isEmpty ||
                                  !value.contains('@')) {
                                return 'Invalid email or password';
                              }
                              return null;
                            },
                            onSaved: (value) {
                              _enterdEmail = value!;
                            },
                          ),
                          TextFormField(
                            decoration: const InputDecoration(
                              labelText: 'password',
                            ),
                            obscureText: true,
                            autocorrect: false,
                            validator: (value) {
                              if (value == null || value.trim().length < 6) {
                                return 'Password must be at least 6 characters';
                              }
                              return null;
                            },
                            onSaved: (value) {
                              _enterdPassword = value!;
                            },
                          ),
                          const SizedBox(height: 20),
                          ElevatedButton(
                            onPressed: _submit,
                            style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  Theme.of(context).colorScheme.primary,
                              minimumSize: const Size.fromHeight(40),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),
                            child: Text(
                              _isLogin ? 'Login' : 'Sign Up',
                              style: TextStyle(
                                  color:
                                      Theme.of(context).colorScheme.onPrimary),
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              setState(() {
                                _isLogin = !_isLogin;
                              });
                            },
                            child:
                                Text(_isLogin ? 'Create an account' : 'Login'),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
