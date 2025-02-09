import 'package:uas_flutter/models/user.model.dart';

abstract class UserService {
  Future<void> googleSignIn();
  Future<UserModel?> getUserData();
  void subscribeToUserChanges(Function callback);
}
