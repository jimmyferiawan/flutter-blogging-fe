import 'package:flutter/material.dart';
import 'package:flutter_application_1/components/custom_circular_progress_indicator.dart';
import 'package:flutter_application_1/components/custom_dialog.dart';
import 'package:flutter_application_1/core/http_services/api_calls.dart';
import 'package:flutter_application_1/dto/forget_password_dto.dart';
import 'package:flutter_application_1/dto/send_otp_forget_password_dto.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class ForgotPasswordScreen extends StatefulHookConsumerWidget {
    const ForgotPasswordScreen({super.key});

    @override
    ConsumerState<ConsumerStatefulWidget> createState() => _ForgotPasswordScreenState();
}
class _ForgotPasswordScreenState extends ConsumerState<ForgotPasswordScreen> {
    final _formKey = GlobalKey<FormState>();
    SnackBar snackBar(String? message) => SnackBar(content: Text(message!),);
    SizedBox verticalSpacer({double verticalHeight=12}) => SizedBox(height: verticalHeight,);

    Future<String> sendOtp(String? username) async{
        SendOtpDTOResponse response = await sendOtpMail(username);
        debugPrint("Sending OTP to email");

        return response.message!;
    }

    @override
    Widget build(BuildContext forgotPasswordScreenContext) {
        TextEditingController usernameController = useTextEditingController.fromValue(TextEditingValue.empty);
        TextEditingController otpController = useTextEditingController.fromValue(TextEditingValue.empty);
        TextEditingController newPasswordController = useTextEditingController.fromValue(TextEditingValue.empty);
        TextEditingController newPasswordConfirmController = useTextEditingController.fromValue(TextEditingValue.empty);
        ValueNotifier<bool> isLoadingSendOtp = useState(false);
        ValueNotifier<bool> isLoadingSubmitResetPassword = useState(false);
        ValueNotifier<bool> isResetPasswordSuccess = useState(false);
        ValueNotifier<bool> newPasswordVisible = useState(true);
        ValueNotifier<bool> newPasswordConfirmVisible = useState(true);
        ValueNotifier<String?> isErrorcheckUsername = useState(null);

        return Scaffold(
            appBar: AppBar(
                title: const Text("Lupa password"),
            ),
            body: Padding(
                padding: const EdgeInsets.only(left: 12, right: 12),
                child: Form(
                    key: _formKey,
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: <Widget>[
                            TextFormField(
                                onFieldSubmitted: (value) {
                                    debugPrint(value);
                                },
                                controller: usernameController,
                                decoration: InputDecoration(
                                    floatingLabelBehavior: FloatingLabelBehavior.auto,
                                    labelText: 'Username, email or phone',
                                    border: const OutlineInputBorder(),
                                    // suffixIcon: !isLoading.value ? null : const CustomCircularProgressIndicator(),
                                    errorText: isErrorcheckUsername.value ?? isErrorcheckUsername.value
                                ),
                                validator: (value) {
                                    if (value == null || value.isEmpty) {
                                        return 'Tidak boleh kosong';
                                    }
                                        return null;
                                },
                            ),
                            verticalSpacer(),
                            TextFormField(
                                controller: otpController,
                                onFieldSubmitted: (value) {
                                    debugPrint(value);
                                },
                                // controller: usernameController,
                                decoration: InputDecoration(
                                    floatingLabelBehavior: FloatingLabelBehavior.auto,
                                    labelText: 'OTP Token',
                                    border: const OutlineInputBorder(),
                                    suffixIcon: isLoadingSendOtp.value ? 
                                        const CustomCircularProgressIndicator() 
                                        : 
                                        SendOtpButton(
                                            onButtonPressed: () async{
                                                if(usernameController.text.isEmpty) {
                                                    isErrorcheckUsername.value = "Tidak boleh kosong";
                                                } else {
                                                    // SendOtpDTORequest form = SendOtpDTORequest(email: usernameController.text, token: otpController.text, newPassword: newPasswordController.text);
                                                    String? snackBarMessage;
                                                    isErrorcheckUsername.value = null;

                                                    try {
                                                        isLoadingSendOtp.value = true;
                                                        String? message = await sendOtp(usernameController.text);
                                                        snackBarMessage = message;
                                                    } catch (e) {
                                                        snackBarMessage = e.toString();
                                                        isErrorcheckUsername.value = e.toString();
                                                    } finally {
                                                        isLoadingSendOtp.value = false;
                                                        Future(() => ScaffoldMessenger.of(context).showSnackBar(snackBar(snackBarMessage)));
                                                    }
                                                }
                                            }, 
                                            buttonIcon: const Icon(Icons.send_rounded)
                                        ),
                                ),
                                validator: (value) {
                                    if (value == null || value.isEmpty) {
                                        return 'Tidak boleh kosong';
                                    }
                                        return null;
                                },
                            ),
                            verticalSpacer(),
                            TextFormField(
                                controller: newPasswordController,
                                obscureText: newPasswordVisible.value,
                                onFieldSubmitted: (value) {
                                    debugPrint(value);
                                },
                                decoration: InputDecoration(
                                    floatingLabelBehavior: FloatingLabelBehavior.auto,
                                    labelText: 'Password baru',
                                    border: const OutlineInputBorder(),
                                    suffixIcon: IconButton(
                                        onPressed: () => newPasswordVisible.value = !newPasswordVisible.value, 
                                        icon: Icon(newPasswordVisible.value ? Icons.visibility_off_outlined : Icons.visibility_outlined)
                                    )
                                ),
                                validator: (value) {
                                    if (value == null || value.isEmpty) {
                                        return 'Tidak boleh kosong';
                                    }
                                        return null;
                                },
                            ),
                            verticalSpacer(),
                            TextFormField(
                                controller: newPasswordConfirmController,
                                obscureText: newPasswordConfirmVisible.value,
                                onFieldSubmitted: (value) {
                                    debugPrint(value);
                                },
                                // controller: usernameController,
                                decoration: InputDecoration(
                                    floatingLabelBehavior: FloatingLabelBehavior.auto,
                                    labelText: 'Konfirmasi password baru',
                                    border: const OutlineInputBorder(),
                                    suffixIcon: IconButton(
                                        onPressed: () => newPasswordConfirmVisible.value = !newPasswordConfirmVisible.value, 
                                        icon: Icon(newPasswordConfirmVisible.value ? Icons.visibility_off_outlined : Icons.visibility_outlined)
                                    )
                                ),
                                validator: (value) {
                                    if (value == null || value.isEmpty) {
                                        return 'Tidak boleh kosong';
                                    }
                                        return null;
                                },
                            ),
                            verticalSpacer(verticalHeight: 16),
                            ElevatedButton(
                                onPressed: isLoadingSubmitResetPassword.value ? null : () async{
                                    debugPrint("change password");
                                    if(_formKey.currentState!.validate()) {
                                        SubmitForgetPasswordDTORequest requestBody = SubmitForgetPasswordDTORequest(email: usernameController.text, token: otpController.text, newPassword: newPasswordController.text);
                                        // SubmitForgetPasswordDTOResponse? response;
                                        String? snackBarMessage;

                                        try {
                                            isLoadingSubmitResetPassword.value = true;
                                            await sendResetPassword(requestBody);
                                            isResetPasswordSuccess.value = true;
                                            snackBarMessage = "Reset password berhasil";
                                        } catch (e) {
                                            debugPrint("Error reset password = .${e.toString()}");
                                            snackBarMessage = e.toString();
                                            isResetPasswordSuccess.value = false;
                                        } finally {
                                            isLoadingSubmitResetPassword.value = false;
                                            Future(() {
                                                isResetPasswordSuccess.value ? 
                                                    showDialogCustomAction(context: forgotPasswordScreenContext, dialogAction: (forgotPasswordScreenContext){ context.go("/");}, dialogTitle: "Success", dialogActionText: "Login", dialogMessage: "Berhasil melakukan reset password")
                                                    :
                                                    ScaffoldMessenger.of(context).showSnackBar(snackBar(snackBarMessage));
                                            });
                                        }
                                    }
                                },
                                child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center, 
                                    children: <Widget>[
                                        const Text("Reset Password"),
                                        if(isLoadingSubmitResetPassword.value)...[const CustomCircularProgressIndicator()]
                                    ],
                                ),
                            ),
                        ]
                    ),
                )
            )
        );
    }
}

class SendOtpButton extends StatelessWidget {
    final VoidCallback? onButtonPressed;
    final Icon? buttonIcon;
    
    const SendOtpButton({super.key, this.onButtonPressed, this.buttonIcon});

    @override
    Widget build(BuildContext context){
        return IconButton(onPressed: onButtonPressed, icon: buttonIcon == null ? const Icon(Icons.send_rounded) : buttonIcon!);
    }
}