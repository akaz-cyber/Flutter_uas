import 'package:google_sign_in/google_sign_in.dart';
import 'package:logger/logger.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uas_flutter/models/user.model.dart';
import 'package:uas_flutter/services/user/user_services.dart';

class UserServicesImplmpl implements UserService {
  final supabase = Supabase.instance.client;
  final logger = Logger();

  @override
  Future<void> googleSignIn() async {
    try {
      const webClientId =
          '23714171420-0mm7gpf1go1ao8jfp1rqu7kfc6d0iums.apps.googleusercontent.com';

      final GoogleSignIn googleSignIn = GoogleSignIn(
        serverClientId: webClientId,
      );

      final googleUser = await googleSignIn.signIn();
      if (googleUser == null) {
        throw 'Login dibatalkan oleh user.';
      }

      final googleAuth = await googleUser.authentication;
      final accessToken = googleAuth.accessToken;
      final idToken = googleAuth.idToken;

      if (idToken == null || accessToken == null) {
        throw 'Gagal mendapatkan token dari Google.';
      }

      final loginResponse = await supabase.auth.signInWithIdToken(
        provider: OAuthProvider.google,
        idToken: idToken,
        accessToken: accessToken,
      );

      final userData = loginResponse.user?.userMetadata;

      final email = userData?['email'];
      final username = userData?['name'];
      final profileImage = userData?['picture'];

      logger.i("Berhasil login dengan Google");

      await supabase.rpc('upsert_user', params: {
        'emailarg': email,
        'profileimagearg': profileImage,
        'usernamearg': username
      });

      logger.i("Berhasil upsert data user");
    } catch (error) {
      logger.e("Gagal login dengan Google $error");
    }
  }

  @override
  Future<UserModel?> getUserData() async {
    try {
      User? user = supabase.auth.currentUser;

      final response = await supabase
          .from('tb_users')
          .select('username,bio, email, profile_image, id')
          .eq('email', user!.email!);

      logger.i(response);

      logger.i("Successfully fetched logged user");

      return UserModel.fromJson(response[0]);
    } catch (error) {
      logger.e("Failed to fetch logged user");
      logger.e(error.toString());
      return null;
    }
  }

  @override
  void subscribeToUserChanges(Function callback) {
    supabase
        .channel('public:tb_users')
        .onPostgresChanges(
            event: PostgresChangeEvent.all,
            schema: 'public',
            table: 'tb_users',
            callback: (payload) {
              logger.i('Change received: ${payload.toString()}');
              callback();
            })
        .subscribe();
  }
}
