import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/components/scrollable_screen.dart';
import 'package:flutter_application_1/core/helpers/month_mapper.dart';
import 'package:flutter_application_1/core/helpers/persistence_storage.dart';
import 'package:flutter_application_1/core/http_services/api_calls.dart';
import 'package:flutter_application_1/dto/auth_dto.dart';
import 'package:flutter_application_1/store/auth_store.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class LoginScreen extends ConsumerWidget {
    const LoginScreen({super.key});

    @override
    Widget build(BuildContext context, ref) {
        final isLogin = ref.watch(userDataStateProvider);

        return Scaffold(
            appBar: AppBar(
                title: Text(isLogin == null ? "Login" : "Account"),
            ),
            // body: const _MyCustomForm(),
            body: isLogin == null ? const LoginForm() : const AccountScreen(),
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
    bool obscured = true;
    String username = "";
    String password = "";
    String message = "";
    String accessToken = "";

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
                    UserDataResp dataResp = await getUserData(await getJwtToken(), await getUsername());
                    ref.read(userDataStateProvider.notifier).setData(UserData.fromJson(dataResp.data));
                }
            } catch (e) {
                debugPrint("error $e");
                setState(() {
                    message = "Terjadi kesalahan, silahkan coba beberapa saat lagi";
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

class AccountScreen extends ConsumerWidget {
    const AccountScreen({super.key});

    @override
    Widget build(BuildContext context, WidgetRef ref) {
        final accountData = ref.watch(userDataStateProvider)!;
        
        return ScrollableScreen(
            children: Column(
                children: <Widget>[
                    ProfileComponent(accountData: accountData, logoutFunction: () async{
                        debugPrint("logout");
                        await clearSession();
                        ref.read(userDataStateProvider.notifier).setData(null);
                    },)
                ],
            )
        );
    }
}

class ProfileComponent extends StatelessWidget {
    const ProfileComponent({
        super.key,
        required this.accountData,
        required this.logoutFunction,
    });

    final UserData accountData;
    final VoidCallback? logoutFunction;

    @override
    Widget build(BuildContext context){
        return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
                const SizedBox(height: 12,),
                Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4.0),
                    child: Text("Username: ${accountData.username}"),
                ),
                Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4.0),
                    child: Text("Nama: ${accountData.firstName}"),
                ),
                Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4.0),
                    child: Text("Email: ${accountData.email}"),
                ),
                Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4.0),
                    child: Text("No. Hp: (+62) ${accountData.mobile}"),
                ),
                Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4.0),
                    child: Text("Intro: ${accountData.intro}"),
                ),
                Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4.0),
                    child: Text("Tgl. Lahir: ${datePrettier(accountData.birthdate!)}"),
                ),
                Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4.0),
                    child: Text("Profile: ${accountData.profile}"),
                ),
                Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: <Widget>[
                            Expanded(
                                child: OutlinedButton(
                                    style: OutlinedButton.styleFrom(
                                        side: const BorderSide(
                                            color: Colors.blue
                                        )
                                    ),
                                    onPressed: () { 
                                        context.push("/profile/edit");
                                    }, 
                                    child: Text(
                                        "Edit Profile", 
                                        style: TextStyle(color: Colors.blue[800]),
                                    )
                                ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                                child: OutlinedButton(
                                    style: OutlinedButton.styleFrom(
                                        side: const BorderSide(
                                            color: Colors.red
                                        )
                                    ),
                                    onPressed: logoutFunction, 
                                    child: Text(
                                        "Logout", 
                                        style: TextStyle(color: Colors.red[600]),
                                    )
                                )
                            )
                        ],
                    )
                ),
                const SizedBox(height: 12,),
            ],
        );
    }
}