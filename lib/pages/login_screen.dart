import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/core/helpers/persistence_storage.dart';
import 'package:flutter_application_1/core/http_services/api_calls.dart';
import 'package:flutter_application_1/dto/auth_dto.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// Create a Form widget.
class _MyCustomForm extends StatefulWidget {
    const _MyCustomForm({super.key});

    @override
    _MyCustomFormState createState() {
        return _MyCustomFormState();
    }
}

class _MyCustomFormState extends State<_MyCustomForm> {
    // Create a global key that uniquely identifies the Form widget
    // and allows validation of the form.
    //
    // Note: This is a GlobalKey<FormState>,
    // not a GlobalKey<MyCustomFormState>.
    final _formKey = GlobalKey<FormState>();
    TextEditingController usernameController = TextEditingController();
    TextEditingController passwordController = TextEditingController();
    bool obscured = true;
    String username = "";
    String password = "";
    String message = "";
    String accessToken = "";
    bool isLoading = false;
    

    @override
    void dispose() {
        // TODO: implement dispose
        usernameController.dispose();
        passwordController.dispose();
        super.dispose();
    }

    @override
    Widget build(BuildContext context) {
        const double xPadding = 12.0;
        IconData iconData = obscured ? Icons.visibility_off : Icons.visibility;

        void loginTest() async {
            try {
                SigninResp resp = await login(
                    SigninReq(
                        username: usernameController.text,
                        password: passwordController.text
                    )
                );
                // SharedPreferences prefs = await SharedPreferences.getInstance();
                await setJwtToken(resp.accessToken);
                await setUsername(usernameController.text);
                
                debugPrint("{'error': '${resp.error}', 'message': '${resp.message}', 'accessToken': '${resp.accessToken}'}");
                if(resp.error) {
                    if(context.mounted) {
                        showDialog(
                            context: context, 
                            builder: (BuildContext context) {
                                BuildContext dialogContext = context;
                                return AlertDialog(
                                    title: const Text('Oops!'),
                                    content: Text(resp.message),
                                    actions: <Widget>[
                                        TextButton(
                                            onPressed: () {
                                                return Navigator.pop(dialogContext);
                                            },
                                            child: const Text('OK'),
                                        ),
                                    ],
                                );
                            }
                        );
                    }
                    
                } else {
                    if(context.mounted){
                        context.go("/profile", extra:{"username":  usernameController.text, "jwt": resp.accessToken});
                    }
                }
            } catch (e) {
                debugPrint("error $e");
                setState(() {
                    message = "Terjadi kesalahan, silahkan coba beberapa saat lagi";
                    //   accessToken = "";
                });
            } finally {
                setState(() {
                    isLoading = false;
                });
            }
        }

        void toggleObscured() {
        // debugPrint("usernameFieldFocusNode.hasPrimaryFocus => ${usernameFieldFocusNode.hasPrimaryFocus}");
            setState(() {
                obscured = !obscured;
            });
        }

        void onChangeUsername(String value) {
            debugPrint("username : $value");
        }

        void onChangePassword(String value) {
            debugPrint("password : $value");
        }

        // Build a Form widget using the _formKey created above.
        return Form(
            key: _formKey,
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                    Padding(
                        padding: const EdgeInsets.symmetric(horizontal: xPadding, vertical: 16),
                        child: TextFormField(
                            onChanged: (value) => {onChangeUsername(value)},
                            controller: usernameController,
                            // focusNode: usernameFieldFocusNode,
                            decoration: const InputDecoration(
                                floatingLabelBehavior: FloatingLabelBehavior.auto,
                                labelText: 'username',
                                border: OutlineInputBorder()
                            ),
                            // The validator receives the text that the user has entered.
                            validator: (value) {
                                if (value == null || value.isEmpty) {
                                    return 'Username tidak boleh kosong';
                                }
                                    return null;
                            },
                        ),
                    ),
                    Padding(
                        padding: const EdgeInsets.symmetric(horizontal: xPadding, vertical: 16),
                        child: TextFormField(
                            onChanged: (value) => {onChangePassword(value)},
                            controller: passwordController,
                            // focusNode: passwordFieldFocusNode,
                            obscureText: obscured,
                            decoration: InputDecoration(
                                floatingLabelBehavior: FloatingLabelBehavior.auto,
                                labelText: 'password',
                                border: const OutlineInputBorder(),
                                suffixIcon: IconButton(
                                    onPressed: toggleObscured, 
                                    icon: Icon(iconData)
                                )
                            ),
                            // The validator receives the text that the user has entered.
                            validator: (value) {
                                if (value == null || value.isEmpty) {
                                    return 'Password tidak boleh kosong';
                                }
                                    return null;
                            },
                        ),
                    ),
                    Padding(
                        padding: const EdgeInsets.symmetric(horizontal: xPadding, vertical: 16),
                        child: ElevatedButton(
                            onPressed: isLoading ? null : () {
                                debugPrint("pressed username : ${usernameController.text} password : ${passwordController.text}");
                            
                                
                                if (_formKey.currentState!.validate()) {
                                    setState(() {
                                        message = "";
                                        isLoading = true;
                                    });
                                    // ScaffoldMessenger.of(context).showSnackBar(
                                    //   const SnackBar(content: Text('Processing Data')),
                                    // );
                                    loginTest();
                                }
                            },
                            child: isLoading ? const CupertinoActivityIndicator(color: Colors.blue,) : const Text('Login'),
                        ),
                    ),
                    Padding(
                        padding: const EdgeInsets.symmetric(horizontal: xPadding, vertical: 0),
                        child: Center(
                            child: Row(
                                // crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                    const Text("Belum punya akun ?"),
                                    const SizedBox(width: 4),
                                    GestureDetector(
                                        onTap: () {
                                            context.push("/signup");
                                        },
                                        child: const Text(
                                            "Daftar", 
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

class LoginScreen extends StatelessWidget {
    const LoginScreen({super.key});

    @override
    Widget build(BuildContext context) {
        const appTitle = 'Login';

        return Scaffold(
            appBar: AppBar(
                title: const Text(appTitle),
            ),
            // body: const _MyCustomForm(),
            body: const LoginForm(),
        );
    }
}

class LoginForm extends StatefulHookConsumerWidget {
    const LoginForm({super.key});

    @override
    ConsumerState<ConsumerStatefulWidget> createState() => _LoginFormState();
}
class _LoginFormState extends ConsumerState<LoginForm> {
    final _formKey = GlobalKey<FormState>();
    // TextEditingController usernameController = TextEditingController();
    // TextEditingController passwordController = TextEditingController();
    // TextEditingController usernameController = TextEditingController();
    // TextEditingController passwordController = TextEditingController();
    bool obscured = true;
    String username = "";
    String password = "";
    String message = "";
    String accessToken = "";
    // bool isLoading = false;

    @override
    Widget build(BuildContext context) {
        const double xPadding = 12.0;
        final usernameController = useTextEditingController(text: "");
        final passwordController = useTextEditingController(text: "");
        var isShowPassword = useState(false);
        ValueNotifier<bool> isLoading = useState(false);
        IconData iconData = isShowPassword.value ? Icons.visibility_off : Icons.visibility;

        void submitLogin() async {
            try {
                SigninResp resp = await login(
                    SigninReq(
                        username: usernameController.text,
                        password: passwordController.text
                    )
                );
                // SharedPreferences prefs = await SharedPreferences.getInstance();
                
                debugPrint("{'error': '${resp.error}', 'message': '${resp.message}', 'accessToken': '${resp.accessToken}'}");
                if(resp.error) {
                    if(context.mounted) {
                        showDialog(
                            context: context, 
                            builder: (BuildContext context) {
                                BuildContext dialogContext = context;
                                return AlertDialog(
                                    title: const Text('Oops!'),
                                    content: Text(resp.message),
                                    actions: <Widget>[
                                        TextButton(
                                            onPressed: () {
                                                return Navigator.pop(dialogContext);
                                            },
                                            child: const Text('OK'),
                                        ),
                                    ],
                                );
                            }
                        );
                    }
                    
                } else {
                    await setJwtToken(resp.accessToken);
                    await setUsername(usernameController.text);
                    if(context.mounted){
                        context.go("/profile", extra:{"username":  usernameController.text, "jwt": resp.accessToken});
                    }
                }
            } catch (e) {
                debugPrint("error $e");
                setState(() {
                    message = "Terjadi kesalahan, silahkan coba beberapa saat lagi";
                    //   accessToken = "";
                });
            } finally {
                setState(() {
                    isLoading.value = false;
                });
            }
        } 
        return Form(
            key: _formKey,
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                    Padding(
                        padding: const EdgeInsets.symmetric(horizontal: xPadding, vertical: 16),
                        child: TextFormField(
                            // onChanged: (value) => {onChangeUsername(value)},
                            controller: usernameController,
                            // focusNode: usernameFieldFocusNode,
                            decoration: const InputDecoration(
                                floatingLabelBehavior: FloatingLabelBehavior.auto,
                                labelText: 'username',
                                border: OutlineInputBorder()
                            ),
                            // The validator receives the text that the user has entered.
                            validator: (value) {
                                if (value == null || value.isEmpty) {
                                    return 'Username tidak boleh kosong';
                                }
                                    return null;
                            },
                        ),
                    ),
                    Padding(
                        padding: const EdgeInsets.symmetric(horizontal: xPadding, vertical: 16),
                        child: TextFormField(
                            // onChanged: (value) => {onChangePassword(value)},
                            controller: passwordController,
                            // focusNode: passwordFieldFocusNode,
                            obscureText: isShowPassword.value,
                            decoration: InputDecoration(
                                floatingLabelBehavior: FloatingLabelBehavior.auto,
                                labelText: 'password',
                                border: const OutlineInputBorder(),
                                suffixIcon: IconButton(
                                    onPressed: () {
                                        setState(() {
                                            isShowPassword.value = !isShowPassword.value;
                                        });
                                    }, 
                                    icon: Icon(iconData)
                                )
                            ),
                            // The validator receives the text that the user has entered.
                            validator: (value) {
                                if (value == null || value.isEmpty) {
                                    return 'Password tidak boleh kosong';
                                }
                                    return null;
                            },
                        ),
                    ),
                    Padding(
                        padding: const EdgeInsets.symmetric(horizontal: xPadding, vertical: 16),
                        child: ElevatedButton(
                            onPressed: isLoading.value ? null : () async {
                                debugPrint("pressed username : ${usernameController.text} password : ${passwordController.text}");
                            
                                
                                if (_formKey.currentState!.validate()) {
                                    setState(() {
                                        message = "";
                                        isLoading.value = true;
                                    });
                                    // ScaffoldMessenger.of(context).showSnackBar(
                                    //   const SnackBar(content: Text('Processing Data')),
                                    // );
                                    // await Future.delayed(const Duration(seconds: 2));
                                    // setState(() {
                                    //     message = "";
                                    //     isLoading.value = false;
                                    // });
                                    submitLogin();
                                }
                            },
                            child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                    const Text("Login"),
                                    if (isLoading.value)...[const SizedBox(width: 12) ,const CupertinoActivityIndicator(color: Colors.blue,)]
                                ],
                            )
                        ),
                    ),
                    Padding(
                        padding: const EdgeInsets.symmetric(horizontal: xPadding, vertical: 0),
                        child: Center(
                            child: Row(
                                // crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                    const Text("Belum punya akun ?"),
                                    const SizedBox(width: 4),
                                    GestureDetector(
                                        onTap: () {
                                            context.push("/signup");
                                        },
                                        child: const Text(
                                            "Daftar", 
                                            style: TextStyle(color: Colors.blue)
                                        ),
                                    ),
                                ]
                            )
                        ),
                    ),
                ],
            )
        );
    }
}