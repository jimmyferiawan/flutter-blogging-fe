import 'package:flutter/material.dart';
import 'package:flutter_application_1/core/helpers/month_mapper.dart';
import 'package:flutter_application_1/core/helpers/persistence_storage.dart';
import 'package:flutter_application_1/store/auth_store.dart';
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
                        // Map<String, dynamic> _userData = GoRouterState.of(context).extra! as Map<String, dynamic>;
                        // String username = _userData['username']! as String;

                        // getJwtToken().then((value) {
                            Router.neglect(context, () => context.go("/profile"));
                        // });
                    }
                )
            ),
            // body: const Column(
            //     crossAxisAlignment: CrossAxisAlignment.stretch,
            //     children: <Widget>[
            //         Padding(
            //             padding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            //             child: _EditProfileForm(),
            //         ),
            //     ],
            // ),
            body: LayoutBuilder(
                builder: (BuildContext context, BoxConstraints viewportConstraints) {
                return SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                    child: ConstrainedBox(
                        constraints: BoxConstraints(
                            minHeight: viewportConstraints.maxHeight,
                        ),
                        child: const IntrinsicHeight(
                            child: _EditProfileForm(),
                        ),
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

    @override
    void initState() {
        // TODO: implement initState
        super.initState();
        
    }
    
    @override
    Widget build(BuildContext context) {
        // Map<String, dynamic> _userData = GoRouterState.of(context).extra! as Map<String, dynamic>;
        var userDataState = ref.watch(userDataStateProvider);
        debugPrint("halo: ${userDataState.toString()}");
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
                            // initialValue: _userData['username']! as String ,
                            // onChanged: (value) => {onChangeUsername(value)},
                            controller: inputUsernameController,
                            // focusNode: usernameFieldFocusNode,
                            decoration: const InputDecoration(
                                floatingLabelBehavior: FloatingLabelBehavior.auto,
                                labelText: 'Username',
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
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: TextFormField(
                            // initialValue: _userData['nama']! as String,
                            // onChanged: (value) => {onChangeUsername(value)},
                            controller: inputNamaController,
                            // focusNode: usernameFieldFocusNode,
                            decoration: const InputDecoration(
                                floatingLabelBehavior: FloatingLabelBehavior.auto,
                                labelText: 'Nama',
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
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: TextFormField(
                            // initialValue: _userData['email']! as String,
                            // onChanged: (value) => {onChangeUsername(value)},
                            controller: inputEmailController,
                            // focusNode: usernameFieldFocusNode,
                            decoration: const InputDecoration(
                                floatingLabelBehavior: FloatingLabelBehavior.auto,
                                labelText: 'Email',
                                border: OutlineInputBorder()
                            ),
                            // The validator receives the text that the user has entered.
                            validator: (value) {
                                if (value == null || value.isEmpty) {
                                    return 'This field is required';
                                }

                                // using regular expression
                                if (!RegExp(r'\S+@\S+\.\S+').hasMatch(value)) {
                                    return "Please enter a valid email address";
                                }

                                return null;
                            },
                        ),
                    ),
                    Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: TextFormField(
                            // initialValue: _userData['intro']! as String,
                            // onChanged: (value) => {onChangeUsername(value)},
                            controller: inpuIntroController,
                            // focusNode: usernameFieldFocusNode,
                            decoration: const InputDecoration(
                                floatingLabelBehavior: FloatingLabelBehavior.auto,
                                labelText: 'Intro',
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
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: TextFormField(
                            // initialValue: _userData['phone']! as String,
                            // onChanged: (value) => {onChangeUsername(value)},
                            controller: inpuMobileController,
                            // focusNode: usernameFieldFocusNode,
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
                            // initialValue: _userData['birthdate']! as String,
                            readOnly: true,
                            controller: inpuDateController,
                            onTap: () async{
                                DateTime? pickedDate = await showDatePicker(
                                    context: context,
                                    initialDate: DateTime.now(), //get today's date
                                    firstDate: DateTime(1900), //DateTime.now() - not to allow to choose before today.
                                    lastDate: DateTime.now()
                                );

                                if(pickedDate != null ){
                                    debugPrint("selected date : ${pickedDate.toString()}");  //get the picked date in the format => 2022-07-04 00:00:00.000
                                    inpuDateController.text = datePickerParser(pickedDate.toString());
                                    // String formattedDate = DateFormat('yyyy-MM-dd').format(pickedDate); // format date in required form here we use yyyy-MM-dd that means time is removed
                                    // print(formattedDate); //formatted date output using intl package =>  2022-07-04
                                        //You can format date as per your need

                                    // setState(() {
                                    //     dateController.text = formattedDate; //set foratted date to TextField value. 
                                    // });
                                } else {
                                    debugPrint("Date is not selected");
                                }
                            },
                            // onChanged: (value) => {onChangeUsername(value)},
                            // controller: usernameController,
                            // focusNode: usernameFieldFocusNode,
                            decoration: const InputDecoration(
                                floatingLabelBehavior: FloatingLabelBehavior.always,
                                labelText: 'Tgl. lahir',
                                border: OutlineInputBorder()
                            ),
                            // The validator receives the text that the user has entered.
                        ),
                    ),
                    Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: ElevatedButton(
                            onPressed: () {
                                debugPrint(_formKey.currentState.toString());
                                if(_formKey.currentState!.validate()) {
                                    debugPrint("Simpan data");
                                }
                            }, 
                            child: const Text("Simpan")
                        )
                    ),
                ],
            
            )
        );
        
    }
}