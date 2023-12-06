import 'package:flutter_application_1/dto/auth_dto.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class UserDataState extends Notifier<UserData?> {
    @override
    UserData? build() {
        UserData? userData;
        
        return userData;
    }
    
    void setData(UserData? data) {
        state = data;
    }
}

final userDataStateProvider = NotifierProvider<UserDataState, UserData?>(UserDataState.new);