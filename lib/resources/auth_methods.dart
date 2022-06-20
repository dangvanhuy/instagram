import 'dart:typed_data';
import 'package:appins/resources/storage_methods.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:appins/models/user.dart' as model;


class AuthMethods {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // lấy thông tin chi tiết về người dùng
  Future<model.User> getUserDetails() async {
    User currentUser = _auth.currentUser!;

    DocumentSnapshot documentSnapshot =
        await _firestore.collection('users').doc(currentUser.uid).get();

    return model.User.fromSnap(documentSnapshot);
  }

  //Đăng ký người dùng

  Future<String> signUpUser({
    required String email,
    required String password,
    required String username,
    required String bio,
    required Uint8List file,
  }) async {
    String res = "Lỗi khi đăng ký";
    try {
      if (email.isNotEmpty ||
          password.isNotEmpty ||
          username.isNotEmpty ||
          bio.isNotEmpty ||
          // ignore: unnecessary_null_comparison
          file != null) {
        //đăng ký xác thực người dùng bằng email và mật khẩu
        UserCredential cred = await _auth.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );

        String photoUrl =
            await StorageMethods().uploadImageToStorage('profilePics', file, false);

        // ignore: no_leading_underscores_for_local_identifiers
        model.User _user = model.User(
          username: username,
          uid: cred.user!.uid,
          photoUrl: photoUrl,
          email: email,
          bio: bio,
          followers: [],
          following: [],
        );

        // lưu thông tin người dùng vào Firestore
        await _firestore
            .collection("users")
            .doc(cred.user!.uid)
            .set(_user.toJson());

        res = "Thành công";
      } else {
        res = "Vui lòng nhập đầy đủ thông tin";
      }
    } catch (err) {
      return err.toString();
    }
    return res;
  }

  // Đăng nhập người dùng
  Future<String> loginUser({
    required String email,
    required String password,
  }) async {
    String res = "Lỗi xảy ra";
    try {
      if (email.isNotEmpty || password.isNotEmpty) {
        // đăng nhập xác thực người dùng bằng email và mật khẩu
        await _auth.signInWithEmailAndPassword(
          email: email,
          password: password,
        );
        res = "Thành công";
      } else {
        res = "Vui lòng nhập đầy đủ thông tin";
      }
    } catch (err) {
      return err.toString();
    }
    return res;
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }
}
