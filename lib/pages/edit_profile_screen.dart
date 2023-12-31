import 'package:flutter/material.dart';
import 'package:flutter_application_1/components/custom_circular_progress_indicator.dart';
import 'package:flutter_application_1/core/helpers/month_mapper.dart';
import 'package:flutter_application_1/core/helpers/persistence_storage.dart';
import 'package:flutter_application_1/core/http_services/api_calls.dart';
import 'package:flutter_application_1/dto/auth_dto.dart';
import 'package:flutter_application_1/store/auth_store.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class EditProfileScreen extends StatelessWidget {
    const EditProfileScreen({Key? key}) : super(key: key);

    @override
    Widget build(BuildContext context) {
        
        return Scaffold(
            appBar: AppBar(
                title: const Text("Edit Profile"),
                leading: GestureDetector(
                    child: const Icon(Icons.close_rounded, color: Colors.white),
                    onTap: () {
                        Router.neglect(context, () => context.go("/"));
                    }
                )
            ),
            body: LayoutBuilder(
                builder: (BuildContext context, BoxConstraints viewportConstraints) {
                    return SingleChildScrollView(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                        child: ConstrainedBox(
                            constraints: BoxConstraints(
                                minHeight: viewportConstraints.maxHeight,
                            ),
                            child: const _EditProfileForm(),
                        ),
                    );
                },
            ),
        );
    }
}

class _EditProfileForm extends StatefulHookConsumerWidget {
  const _EditProfileForm({ Key? key }) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _EditProfileFormState();
}

class _EditProfileFormState extends ConsumerState<_EditProfileForm> {
    final _formKey = GlobalKey<FormState>();
    TextEditingController inputUsernameController = TextEditingController();
    TextEditingController inputNamaController = TextEditingController();
    TextEditingController inputEmailController = TextEditingController();
    TextEditingController inpuIntroController = TextEditingController();
    TextEditingController inpuMobileController = TextEditingController();
    TextEditingController inpuDateController = TextEditingController();
    // bool isLoading = false;

    @override
    void initState() {
        super.initState();
        
    }
    
    @override
    Widget build(BuildContext context) {
        // Map<String, dynamic> _userData = GoRouterState.of(context).extra! as Map<String, dynamic>;
        var userDataState = ref.watch(userDataStateProvider)!;
        ValueNotifier<bool> isLoading = useState(false);
        // debugPrint("halo: ${userDataState.toString()}");
        inputUsernameController.text = userDataState.username;//_userData['username']! as String;
        inputNamaController.text = userDataState.firstName;//_userData['nama']! as String;
        inputEmailController.text = userDataState.email;//_userData['email']! as String;
        inpuIntroController.text = userDataState.intro!;//_userData['intro']! as String;
        inpuMobileController.text = userDataState.mobile;//_userData['phone']! as String;
        inpuDateController.text = userDataState.birthdate!;//_userData['birthdate']! as String;

        return Form(
            key: _formKey,
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                    Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: TextFormField(
                            controller: inputUsernameController,
                            decoration: const InputDecoration(
                                floatingLabelBehavior: FloatingLabelBehavior.auto,
                                labelText: 'Username',
                                border: OutlineInputBorder()
                            ),
                            validator: (value) {
                                if (value == null || value.isEmpty) {
                                    return 'Username tidak boleh kosong';
                                }
                                    return null;
                            },
                        ),
                    ),
                    Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: TextFormField(
                            controller: inputNamaController,
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
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: TextFormField(
                            controller: inputEmailController,
                            decoration: const InputDecoration(
                                floatingLabelBehavior: FloatingLabelBehavior.auto,
                                labelText: 'Email',
                                border: OutlineInputBorder()
                            ),
                            validator: (value) {
                                if (value == null || value.isEmpty) {
                                    return 'Email tidak boleh kosong';
                                }

                                // using regular expression
                                if (!RegExp(r'\S+@\S+\.\S+').hasMatch(value)) {
                                    return "Alamat email tidak valid";
                                }

                                return null;
                            },
                        ),
                    ),
                    Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: TextFormField(
                            controller: inpuIntroController,
                            decoration: const InputDecoration(
                                floatingLabelBehavior: FloatingLabelBehavior.auto,
                                labelText: 'Intro',
                                border: OutlineInputBorder()
                            ),
                            validator: (value) {
                                if (value == null || value.isEmpty) {
                                    return 'Username tidak boleh kosong';
                                }
                                    return null;
                            },
                        ),
                    ),
                    Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: TextFormField(
                            controller: inpuMobileController,
                            decoration: const InputDecoration(
                                prefixText: "(+62) ",
                                floatingLabelBehavior: FloatingLabelBehavior.auto,
                                labelText: 'No. HP',
                                border: OutlineInputBorder()
                            ),
                        ),
                    ),
                    Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: TextFormField(
                            readOnly: true,
                            controller: inpuDateController,
                            onTap: () async{
                                DateTime? pickedDate = await showDatePicker(
                                    context: context,
                                    initialDate: datePickerParser(inpuDateController.text) == "" ? DateTime.now() : DateTime.parse(inpuDateController.text.split("-").reversed.join("")), //get today's date
                                    firstDate: DateTime(1900), //DateTime.now() - not to allow to choose before today.
                                    lastDate: DateTime.now()
                                );

                                if(pickedDate != null ){
                                    debugPrint("selected date : ${pickedDate.toString()}");  //get the picked date in the format => 2022-07-04 00:00:00.000
                                    inpuDateController.text = datePickerParser(pickedDate.toString());
                                } else {
                                    debugPrint("Date is not selected");
                                }
                            },
                            decoration: const InputDecoration(
                                floatingLabelBehavior: FloatingLabelBehavior.always,
                                labelText: 'Tgl. lahir',
                                border: OutlineInputBorder()
                            ),
                        ),
                    ),
                    Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: ElevatedButton(
                            onPressed: isLoading.value ? null : () async{
                                if(_formKey.currentState!.validate()) {
                                    UserData userData;
                                    UserData formData = UserData(username: inputUsernameController.text, email: inputEmailController.text, mobile: inpuMobileController.text, firstName: inputNamaController.text, intro: inpuIntroController.text, profile: "", birthdate: inpuDateController.text);
                                    ref.read(userDataStateProvider.notifier).setData(formData);
                                    isLoading.value = true;
                                    // await Future.delayed(const Duration(seconds: 2)); // TODO : remove this on build prod
                                    try {
                                        formData = UserData(username: inputUsernameController.text, email: inputEmailController.text, mobile: inpuMobileController.text, firstName: inputNamaController.text, intro: inpuIntroController.text, profile: "", birthdate: inpuDateController.text);
                                        userData = await updateUserData(userDataState.username, await getJwtToken(), formData);
                                        ref.read(userDataStateProvider.notifier).setData(userData);
                                    } catch (e) {
                                        debugPrint("Error update data");
                                        debugPrintStack();
                                    } finally {
                                        setState(() {
                                            isLoading.value = false;
                                        });
                                    }
                                    debugPrint("Simpan data");
                                }
                            }, 
                            child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                    const Text("Update Data"),
                                    if (isLoading.value)...[const SizedBox(width: 12) ,const CustomCircularProgressIndicator(color: Colors.blueAccent,)]
                                ],
                            )
                        )
                    ),
                ],
            
            )
        );
    }
}