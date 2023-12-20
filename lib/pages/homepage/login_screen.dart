import 'package:flutter/material.dart';
import 'package:flutter_application_1/components/custom_circular_progress_indicator.dart';
import 'package:flutter_application_1/components/custom_dialog.dart';
import 'package:flutter_application_1/core/helpers/persistence_storage.dart';
import 'package:flutter_application_1/core/http_services/api_calls.dart';
import 'package:flutter_application_1/dto/auth_dto.dart';
import 'package:flutter_application_1/pages/homepage/banner.dart';
import 'package:flutter_application_1/store/auth_store.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

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
                
                // debugPrint("{'error': '${resp.error}', 'message': '${resp.message}', 'accessToken': '${resp.accessToken}'}");
                if(resp.error) {
                    setState(() => message = resp.message);
                    if(context.mounted) {
                        showCustomDialog(context, message);
                    }
                } else {
                    await setJwtToken(resp.accessToken);
                    await setUsername(usernameController.text);
                    UserDataResp dataResp = await getUserData(await getJwtToken(), await getUsername());
                    ref.read(userDataStateProvider.notifier).setData(UserData.fromJson(dataResp.data));
                }
            } catch (e) {
                debugPrint("error $e");
                setState(() => message = "Terjadi kesalahan, silahkan coba beberapa saat lagi");
                if(context.mounted) {
                    showCustomDialog(context, message);
                }
            } finally {
                setState(() => isLoading.value = false);
            }
        } 
        
        return Form(
            key: _formKey,
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                    const CarouselCustom(),
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
                                        setState(() => isShowPassword.value = !isShowPassword.value);
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
                        padding: const EdgeInsets.only(left: xPadding, right: xPadding),
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                                GestureDetector(
                                    onTap: () {
                                        context.push("/forget-password");
                                    },
                                    child: Text(
                                        "Lupa Password ?", 
                                        style: TextStyle(color: Colors.red[600], )
                                    ),
                                ),
                            ],
                        )
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
                                    if (isLoading.value)...[const SizedBox(width: 12) ,const CustomCircularProgressIndicator()]
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