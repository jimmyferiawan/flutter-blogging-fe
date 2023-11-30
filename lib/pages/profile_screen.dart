import 'package:flutter/material.dart';
import 'package:flutter_application_1/core/helpers/error_mapper.dart';
import 'package:flutter_application_1/core/helpers/month_mapper.dart';
import 'package:flutter_application_1/core/helpers/persistence_storage.dart';
import 'package:flutter_application_1/core/http_services/api_calls.dart';
import 'package:flutter_application_1/dto/auth_dto.dart';
import 'package:go_router/go_router.dart';

class ProfileScreen extends StatelessWidget {
    const ProfileScreen({Key? key}) : super(key: key);
  
    @override
    Widget build(BuildContext context) {
        // Map<String, String> objSample = GoRouterState.of(context).extra! as Map<String, String>;
        // return Scaffold(
        //     appBar: AppBar(
        //         title: const Text("Profile"),
        //     ),
        //     body: Column(
        //         crossAxisAlignment: CrossAxisAlignment.stretch,
        //         children: <Widget>[
        //             Padding(
        //                 padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
        //                 child: _UserProfile(params: objSample),
        //             ),
        //         ],
        //     ),
        // );
        // return _UserProfile(params: objSample);
        return const _UserProfile();
    }
}

class _UserProfile extends StatefulWidget {
    // final Map<String, dynamic> params;
    // const _UserProfile({Key? key, required this.params}) : super(key: key);
    const _UserProfile({Key? key}) : super(key: key);

    @override
    _UserProfileState createState() => _UserProfileState();
}

class _UserProfileState extends State<_UserProfile> {
    late Future<Map<String, dynamic>> _userData;
    String jsonProfile = "";
    late CrossAxisAlignment _alignment;

    Future<Map<String, dynamic>> _getProfileData() async {
        String userName = await getUsername();
        String token = await getJwtToken();
        UserDataResp resp = await getUserData(token, userName);
        Map<String, dynamic> respJson = resp.toJson();

        if(respJson['error']! as bool) {
            throw UnathorizedError(message: respJson["message"] as String);
        } else {
            return respJson;
        }
    }

    @override
    void deactivate() {
        // TODO: implement deactivate
        super.deactivate();
        debugPrint("Profile Screen deactivated");
    }

    @override
    void dispose() {
        // TODO: implement dispose
        super.dispose();
        debugPrint("Profile Screen disposed");
    }

    @override
    void initState() {
        super.initState();
        _alignment = CrossAxisAlignment.center;
        _userData = _getProfileData();
    }

    
    @override
    Widget build(BuildContext context) {
        // setState(() {
        //     _userData = getJwtToken().then((value) {
        //         // jsonProfile = ;
        //         return _getProfileData(value, widget.params['username'] ?? "");
        //     });
        // });
        debugPrint("Profile Screen builded");
        
        return Scaffold(
            appBar: AppBar(
                title: const Text("Profile"),
            ),
            body: RefreshIndicator(
                onRefresh: () async {
                    // return Future<void>.delayed(const Duration(seconds: 3), () {
                        setState(() {
                            _userData = _getProfileData();
                        });
                    // });
                },
                child: LayoutBuilder(
                    builder: (context, constraint) {
                        return SingleChildScrollView(
                            physics: const AlwaysScrollableScrollPhysics(),
                            child: SizedBox(
                                height: constraint.maxHeight,
                                child: Column(
                                    crossAxisAlignment: _alignment,
                                    children: <Widget>[
                                        Padding(
                                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
                                            child: FutureBuilder(
                                                future: _userData, 
                                                builder: (context, snapshot) {
                                                    switch (snapshot.connectionState) {
                                                        case ConnectionState.none:
                                                        case ConnectionState.waiting:
                                                            _alignment = CrossAxisAlignment.center;
                                                            
                                                            return const Center(child: CircularProgressIndicator());
                                                        case ConnectionState.active:
                                                        case ConnectionState.done:
                                                            _alignment = CrossAxisAlignment.stretch;
                                                            if (snapshot.hasError) {
                                                                debugPrint("error pulling data : ${snapshot.error.toString()}");
                                                                if(snapshot.error.toString() == "Something went wrong, please try again later") {
                                                                    return const Text('Terjadi kesalahan, silahkan coba beberapa saat lagi');
                                                                } else if(snapshot.error.toString() == "Unauthorized request") {
                                                                    return AlertDialog(
                                                                        title: const Text('Session expired'),
                                                                        content: const Text("Silahkan login ulang"),
                                                                        actions: <Widget>[
                                                                            TextButton(
                                                                                onPressed: () async {
                                                                                    clearSession();
                                                                                    return context.go("/");
                                                                                },
                                                                                child: const Text('OK'),
                                                                            ),
                                                                        ],
                                                                    );
                                                                } else {
                                                                    return const Text('Terjadi kesalahan, silahkan coba beberapa saat lagi');
                                                                }
                                                            } else {
                                                                // setState(() {
                                                                jsonProfile = snapshot.data.toString();
                                                                // });
                                                                return ProfileComponent(
                                                                    username: snapshot.data?['data']['username'] ?? "", 
                                                                    nama: snapshot.data?['data']['firstName'] ?? "", 
                                                                    email: snapshot.data?['data']['email'] ?? "", 
                                                                    phone: snapshot.data?['data']['mobile'] ?? "",
                                                                    intro: snapshot.data?['data']['intro'] ?? "",
                                                                    birthdate: snapshot.data?['data']['birthdate'] ?? "",
                                                                    profile: snapshot.data?['data']['profile'] ?? "",
                                                                );
                                                            }
                                                    }
                                                },
                                            ),
                                        ),
                                    ],
                                ),
                            ),
                        );
                    }
                ) 
            ),
        );
        // return ;
  }
}

class ProfileComponent extends StatelessWidget {
    const ProfileComponent({
        super.key,
        required this.username, 
        required this.nama, 
        required this.email, 
        required this.phone,
        required this.intro,
        required this.birthdate,
        required this.profile,
    });

    final String username;
    final String nama;
    final String email;
    final String phone;
    final String intro;
    final String birthdate;
    final String profile;

    @override
    Widget build(BuildContext context){
        return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
                Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4.0),
                    child: Text("Username: $username"),
                ),
                Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4.0),
                    child: Text("Nama: $nama"),
                ),
                Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4.0),
                    child: Text("Email: $email"),
                ),
                Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4.0),
                    child: Text("No. Hp: (+62) $phone"),
                ),
                Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4.0),
                    child: Text("Intro: $intro"),
                ),
                Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4.0),
                    child: Text("Tgl. Lahir: ${datePrettier(birthdate)}"),
                ),
                Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4.0),
                    child: Text("Profile: $profile"),
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
                                        context.push("/profile/edit", extra: {
                                            "username": username,
                                            "nama": nama,
                                            "email": email,
                                            "phone": phone,
                                            "intro": intro,
                                            "birthdate": birthdate,
                                            "profile": profile,
                                        });
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
                                    onPressed: () { 
                                        removeJwtToken();
                                        context.go("/");
                                    }, 
                                    child: Text(
                                        "Logout", 
                                        style: TextStyle(color: Colors.red[600]),
                                    )
                                )
                            )
                        ],
                    )
                ),
            ],
        );
    }
}