import 'dart:typed_data';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:uuid/uuid.dart';

class StorageMethods {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  //thêm hình ảnh vào bộ nhớ firebase
  Future<String> uploadImageToStorage(String childName, Uint8List file, bool isPost) async {
    // tạo vị trí cho bộ nhớ firebase của chúng tôi
    
    Reference ref =
        _storage.ref().child(childName).child(_auth.currentUser!.uid);
    if(isPost) {
      String id = const Uuid().v1();
      ref = ref.child(id);
    }

    // đặt ở định dạng uint8list -> Tải lên tác vụ giống như một tương lai nhưng không phải là tương lai
    UploadTask uploadTask = ref.putData(
      file
    );

    TaskSnapshot snapshot = await uploadTask;
    String downloadUrl = await snapshot.ref.getDownloadURL();
    return downloadUrl;
  }
}