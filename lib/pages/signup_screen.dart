import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/core/http_services/api_calls.dart';
import 'package:flutter_application_1/dto/auth_dto.dart';
import 'package:go_router/go_router.dart';

class _SingupForm extends StatefulWidget {
    const _SingupForm({Key? key}) : super(key: key);

    @override
    _SignupFormState createState() => _SignupFormState();
}

class _SignupFormState extends State<_SingupForm> {
    final _signupFormKey = GlobalKey<FormState>();
    TextEditingController firstNameController = TextEditingController();
    TextEditingController noHandphoneController = TextEditingController();
    TextEditingController usernameController = TextEditingController();
    TextEditingController emailController = TextEditingController();
    TextEditingController passwordController = TextEditingController();
    TextEditingController paswordConfirmController = TextEditingController();

    bool _passwordObsecured = true;
    bool _passwordConfirmObsecured = true;

    final Icon validIcon = const Icon(Icons.check_circle_outline, size: 16, color: Colors.green);
    final Icon invalidIcon = const Icon(Icons.cancel_outlined, size: 16, color: Colors.red);
    bool isValidEightCharacter = false;
    bool isAdaHuruf = false;
    bool isAdaAngka = false;
    bool isKonfirmasiPasswordSama = false;
    bool isHurufBesar = false;
    bool isHurufKecil = false;
    bool _isLoading = false;

    bool isPasswordSesuaiKetentuan() {
        if(isValidEightCharacter && isAdaHuruf && isAdaAngka && isKonfirmasiPasswordSama && isHurufBesar && isHurufKecil ) {
            return true;
        } else {
            return false;
        }
    }

    @override
    void dispose() {
        // TODO: implement dispose
        firstNameController.dispose();
        noHandphoneController.dispose();
        usernameController.dispose();
        emailController.dispose();
        passwordController.dispose();
        paswordConfirmController.dispose();
        super.dispose();
    }

    @override
    Widget build(BuildContext context) {
        const double xPadding = 12.0;
        Icon eightCharacter = isValidEightCharacter ? validIcon : invalidIcon;
        Icon hurufKecil = isHurufKecil ? validIcon : invalidIcon;
        Icon hurufBesar = isHurufBesar ? validIcon : invalidIcon;
        Icon adaAngka = isAdaAngka ? validIcon : invalidIcon;
        Icon adaHuruf = isAdaHuruf ? validIcon : invalidIcon;
        Icon konfirmasiPasswordSama = isKonfirmasiPasswordSama ? validIcon : invalidIcon;

        return Form(
            key: _signupFormKey,
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                    Padding(
                        padding: const EdgeInsets.symmetric(horizontal: xPadding, vertical: 16),
                        child: TextFormField(
                        controller: firstNameController,
                        decoration: const InputDecoration(
                            floatingLabelBehavior: FloatingLabelBehavior.auto,
                            labelText: 'Nama',
                            border: OutlineInputBorder()
                        ),
                        validator: (value) {
                            if (value == null || value.isEmpty) {
                                return 'Nama tidak boleh kosong';
                            }
                                return null;
                        },
                        ),
                    ),
                    Padding(
                        padding: const EdgeInsets.only(left: xPadding, right: xPadding, top: 16, bottom: 8),
                        child: TextFormField(
                            controller: emailController,
                            decoration:  InputDecoration(
                                floatingLabelBehavior: FloatingLabelBehavior.auto,
                                labelText: 'E-mail',
                                border: const OutlineInputBorder(),
                                helperText: "Ex. : mail@your.domain",
                                helperStyle: TextStyle(
                                    color: Colors.blue.shade800
                                )
                            ),
                            validator: (value) {
                                if (value == null || value.isEmpty) {
                                    return 'Email tidak boleh kosong';
                                }

                                // using regular expression
                                if (!RegExp(r'\S+@\S+\.\S+').hasMatch(value)) {
                                    return "Please enter a valid email address";
                                }

                                return null;
                            },
                        ),
                    ),
                    // Padding(
                    //     padding: const EdgeInsets.symmetric(horizontal: xPadding, vertical: 16),
                    //     child: TextFormField(
                    //         controller: usernameController,
                    //         decoration: const InputDecoration(
                    //             floatingLabelBehavior: FloatingLabelBehavior.auto,
                    //             labelText: 'Username',
                    //             border: OutlineInputBorder()
                    //         ),
                    //     ),
                    // ),
                    // Padding(
                    //     padding: const EdgeInsets.symmetric(horizontal: xPadding, vertical: 16),
                    //     child: TextFormField(
                    //         controller: noHandphoneController,
                    //         decoration: const InputDecoration(
                    //             floatingLabelBehavior: FloatingLabelBehavior.auto,
                    //             labelText: 'No. Handphone',
                    //             border: OutlineInputBorder(),
                    //             prefix: Text("(+62) ")
                    //         ),
                    //     ),
                    // ),
                    Padding(
                        padding: const EdgeInsets.symmetric(horizontal: xPadding, vertical: 16),
                        child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                                Expanded(
                                    child: TextFormField(
                                        controller: usernameController,
                                        decoration: const InputDecoration(
                                            floatingLabelBehavior: FloatingLabelBehavior.auto,
                                            labelText: 'Username',
                                            border: OutlineInputBorder()
                                        ),
                                        validator: (value) {
                                            if(value == "") {
                                                return "username tidak boleh kosong";
                                            }

                                            return null;
                                        },
                                    ),
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                    child: TextFormField(
                                        // onChanged: (value) {
                                        //     if (RegExp(r'^0').hasMatch(value)) {
                                        //         noHandphoneController.text = "";
                                        //     }
                                        // },
                                        keyboardType: const TextInputType.numberWithOptions(decimal: false, signed: true),
                                        controller: noHandphoneController,
                                        decoration: const InputDecoration(
                                            floatingLabelBehavior: FloatingLabelBehavior.auto,
                                            labelText: 'No. Handphone',
                                            border: OutlineInputBorder(),
                                            prefix: Text("(+62) ")
                                        ),
                                        validator: (value) {
                                            if(value == "") {
                                                return "No. Handphone tidak boleh kosong";
                                            }
                                            return null;
                                        },
                                    ),
                                ),
                            ],
                        )
                    ),
                    // Padding(
                    //     padding: const EdgeInsets.symmetric(horizontal: xPadding, vertical: 16),
                    //     child: TextFormField(
                    //         obscureText: _passwordObsecured,
                    //         controller: passwordController,
                    //         decoration: InputDecoration(
                    //             floatingLabelBehavior: FloatingLabelBehavior.auto,
                    //             labelText: 'Password',
                    //             border: const OutlineInputBorder(),
                    //             suffixIcon: IconButton(
                    //                 onPressed: () {
                    //                     setState(() {
                    //                         _passwordObsecured = !_passwordObsecured;
                    //                     });
                    //                 }, 
                    //                 icon: Icon(_passwordObsecured ? Icons.visibility_off : Icons.visibility)
                    //             )
                    //         ),
                    //     ),
                    // ),
                    // Padding(
                    //     padding: const EdgeInsets.symmetric(horizontal: xPadding, vertical: 16),
                    //     child: TextFormField(
                    //         obscureText: _passwordConfirmObsecured,
                    //         controller: paswordConfirmController,
                    //         decoration: InputDecoration(
                    //             floatingLabelBehavior: FloatingLabelBehavior.auto,
                    //             labelText: 'Konfirmasi Password',
                    //             border: const OutlineInputBorder(),
                    //             suffixIcon: IconButton(
                    //                 onPressed: () {
                    //                     setState(() {
                    //                         _passwordConfirmObsecured = !_passwordConfirmObsecured;
                    //                     });
                    //                 }, 
                    //                 icon: Icon(_passwordConfirmObsecured ? Icons.visibility_off : Icons.visibility)
                    //             )
                    //         ),
                    //     ),
                    // ),
                    Padding(
                        padding: const EdgeInsets.symmetric(horizontal: xPadding, vertical: 16),
                        child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center ,
                            children: <Widget>[
                                Expanded(
                                    child: TextFormField(
                                        obscureText: _passwordObsecured,
                                        onChanged: (value) {
                                            setState(() {
                                                if(value.length < 8) {
                                                    isValidEightCharacter = false;
                                                } else {
                                                    isValidEightCharacter = true;
                                                }
                                                if(RegExp(r'[a-z]').hasMatch(value)) {
                                                    isHurufKecil = true;
                                                } else {
                                                    isHurufKecil = false;
                                                }
                                                if (RegExp(r'[A-Z]').hasMatch(value)) {
                                                    isHurufBesar = true;
                                                } else {
                                                    isHurufBesar = false;
                                                }
                                                if (RegExp(r'[0-9]').hasMatch(value)) {
                                                    isAdaAngka = true;
                                                } else {
                                                    isAdaAngka = false;
                                                }
                                                if (RegExp(r'[a-zA-Z]').hasMatch(value)) {
                                                    isAdaHuruf = true;
                                                } else {
                                                    isAdaHuruf = false;
                                                }
                                                if (value == paswordConfirmController.text) {
                                                    isKonfirmasiPasswordSama = true;
                                                } else {
                                                    isKonfirmasiPasswordSama = false;
                                                }
                                            });
                                        },
                                        controller: passwordController,
                                        decoration: InputDecoration(
                                            floatingLabelBehavior: FloatingLabelBehavior.auto,
                                            labelText: 'Password',
                                            border: const OutlineInputBorder(),
                                            suffixIcon: IconButton(
                                                onPressed: () {
                                                    setState(() {
                                                        _passwordObsecured = !_passwordObsecured;
                                                    });
                                                }, 
                                                icon: Icon(_passwordObsecured ? Icons.visibility_off : Icons.visibility)
                                            )
                                        ),
                                        validator: (value) {
                                            if(value == "") {
                                                return "Password tidak boleh kosong";
                                            }
                                            if(value != paswordConfirmController.text) {
                                                return "Password tidak sama";
                                            }
                                            if(!isPasswordSesuaiKetentuan()) {
                                                return "Password tidak memenuhi kriteria";
                                            }
                                            return null;
                                        },
                                    )
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                    child: TextFormField(
                                        onChanged: (value) {
                                            setState(() {
                                                if(value == passwordController.text) {
                                                    isKonfirmasiPasswordSama = true;
                                                } else {
                                                    isKonfirmasiPasswordSama = false;
                                                }
                                            });
                                        },
                                        obscureText: _passwordConfirmObsecured,
                                        controller: paswordConfirmController,
                                        decoration: InputDecoration(
                                            floatingLabelBehavior: FloatingLabelBehavior.auto,
                                            labelText: 'Konfirmasi Password',
                                            border: const OutlineInputBorder(),
                                            suffixIcon: IconButton(
                                                onPressed: () {
                                                    setState(() {
                                                        _passwordConfirmObsecured = !_passwordConfirmObsecured;
                                                    });
                                                }, 
                                                icon: Icon(_passwordConfirmObsecured ? Icons.visibility_off : Icons.visibility)
                                            )
                                        ),
                                        validator: (value) {
                                            if(value != passwordController.text) {
                                                return "Password tidak sama";
                                            }
                                            return null;
                                        },
                                    )
                                ),
                            ],
                        )
                    ),
                    Padding(
                        padding: const EdgeInsets.symmetric(horizontal: xPadding),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: <Widget>[
                                Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: <Widget>[
                                        Expanded(
                                            child: Wrap(
                                                crossAxisAlignment: WrapCrossAlignment.center,
                                                children: [
                                                    const Text("Minimal 8 karakter"),
                                                    const SizedBox(width: 8),
                                                    eightCharacter,
                                                ],
                                            )
                                        ),
                                        Expanded(
                                            child: Wrap(
                                                crossAxisAlignment: WrapCrossAlignment.center,
                                                children: [
                                                    const Text("Konfirmasi password"),
                                                    const SizedBox(width: 8),
                                                    konfirmasiPasswordSama,
                                                ],
                                            )
                                        ),
                                    ],
                                ),
                                Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: <Widget>[
                                        Expanded(
                                            child: Wrap(
                                                crossAxisAlignment: WrapCrossAlignment.center,
                                                children: [
                                                    const Text("Terdapat huruf"),
                                                    const SizedBox(width: 8),
                                                    adaHuruf,
                                                ],
                                            )
                                        ),
                                        Expanded(
                                            child: Wrap(
                                                crossAxisAlignment: WrapCrossAlignment.center,
                                                children: [
                                                    const Text("Huruf Besar"),
                                                    const SizedBox(width: 8),
                                                    hurufBesar,
                                                ],
                                            )
                                        ),
                                    ],
                                ),
                                Row(
                                    children: <Widget>[
                                        Expanded(
                                            child: Wrap(
                                                crossAxisAlignment: WrapCrossAlignment.center,
                                                children: [
                                                    const Text('Terdapat angka'),
                                                    const SizedBox(width: 8),
                                                    adaAngka,
                                                ],
                                            )
                                        ),
                                        Expanded(
                                            child: Wrap(
                                                crossAxisAlignment: WrapCrossAlignment.center,
                                                children: [
                                                    const Text('Huruf Kecil'),
                                                    const SizedBox(width: 8),
                                                    // Icon(Icons.check_circle_outline, size: 16, color: Colors.green),
                                                    hurufKecil,
                                                ],
                                            )
                                        ),
                                    ],
                                ),
                            ]
                        ),
                    ),
                    Padding(
                        padding: const EdgeInsets.symmetric(horizontal: xPadding, vertical: 16),
                        child: ElevatedButton(
                            onPressed: _isLoading ? null : () async{
                                debugPrint("Daftar clicked!");
                                if (_signupFormKey.currentState!.validate()) {
                                    setState(() {
                                        _isLoading = true;
                                    });
                                    
                                    try {
                                        Map<String, dynamic> daftar = await signUp(SignupReq(username: usernameController.text, firstName: firstNameController.text, mobile: noHandphoneController.text, email: emailController.text, password: passwordController.text));
                                        // Map<String, dynamic> daftar = await Future.delayed(const Duration(seconds: 3), () {
                                        //     return {"status": 201, "body": '{ "error": false, "message": "Registrasi Berhasil", "data": { "username": "astuti", "firstName": "Astuti", "middleName": "Astuti", "lastName": "Putri", "email": "kacangserabii@mail.com", "mobile": "087784517741" } }' };
                                        // }); // testing only
                                        int statusCode = daftar['status'];
                                        debugPrint(daftar.toString());

                                        Map<String, dynamic> respBody = jsonDecode(daftar['body']);

                                        if(context.mounted) {
                                            showDialog(
                                                context: context, 
                                                builder: (BuildContext context) {
                                                    BuildContext dialogContext = context;
                                                    return AlertDialog(
                                                        title: Text(statusCode == 201 ? "berhasil" : "Gagal"),
                                                        content: Text(statusCode == 201 ? "Pendaftaran berhasil, silahkan konfirmasi melalui link yang terkirim ke email anda" : respBody["message"]),
                                                        actions: <Widget>[
                                                            TextButton(
                                                                onPressed: () {
                                                                    if(statusCode == 201) {
                                                                        return context.go("/");
                                                                    } else {
                                                                        return Navigator.pop(dialogContext);
                                                                    }
                                                                },
                                                                child: const Text('OK'),
                                                            ),
                                                        ],
                                                    );
                                                }
                                            );
                                        }
                                    } catch (e) {
                                        debugPrint("Error : ${e.toString()}");
                                    } finally {
                                        setState(() {
                                            _isLoading = false;
                                        });
                                    }
                                } else {

                                }
                                // Map<String, dynamic> daftar = await signUp(SignupReq(username: usernameController.text, firstName: firstNameController.text, mobile: noHandphoneController.text, email: emailController.text, password: passwordController.text));
                            },
                            child: _isLoading ?  const CupertinoActivityIndicator(color: Colors.blue,) : const Text('Daftar'),
                        ),
                    ),
                    Padding(
                        padding: const EdgeInsets.symmetric(horizontal: xPadding, vertical: 0),
                        child: Center(
                            child: Row(
                                // crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                    const Text("Sudah punya akun ?"),
                                    const SizedBox(width: 4),
                                    GestureDetector(
                                        onTap: () {
                                            context.pop("/");
                                        },
                                        child: const Text("Login",
                                            style: TextStyle(color: Colors.blue)
                                        ),
                                    ),
                                ]
                            )
                        ),
                    ),
                ],
            ),
        );
    }
}

class SignupScreen extends StatelessWidget {
    const SignupScreen({Key? key}) : super(key: key);

    @override
    Widget build(BuildContext context) {
        return Scaffold(
            appBar: AppBar(
                title: const Text("Signup"),
            ),
            // body: const _SingupForm(),
            body:LayoutBuilder(
                builder: (BuildContext context, BoxConstraints viewportConstraints) {
                    return SingleChildScrollView(
                            padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 10),
                            child: ConstrainedBox(
                                constraints: BoxConstraints(
                                    minHeight: viewportConstraints.maxHeight,
                                ),
                                child: const IntrinsicHeight(
                                    child: _SingupForm(),
                                ),
                            ),
                        );
                    },
            )
        );
    }
}
