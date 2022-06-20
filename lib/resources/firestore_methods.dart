import 'dart:typed_data';
import 'package:appins/models/post.dart';
import 'package:appins/resources/storage_methods.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';

class FireStoreMethods {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<String> uploadPost(String description, Uint8List file, String uid,
      String username, String profImage) async {
    // hỏi uid ở đây vì chúng tôi không muốn thực hiện thêm lệnh gọi tới firebase auth khi chúng tôi có thể nhận được từ quản lý nhà nước của mình
    String res = "Lỗi khi đăng bài";
    try {
      String photoUrl =
          await StorageMethods().uploadImageToStorage('posts', file, true);
      String postId = const Uuid().v1(); // tạo id cho bài đăng
      Post post = Post(
        description: description,
        uid: uid,
        username: username,
        likes: [],
        postId: postId,
        datePublished: DateTime.now(),
        postUrl: photoUrl,
        profImage: profImage,
      );
      _firestore.collection('posts').doc(postId).set(post.toJson());
      res = "Thành công";
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  Future<String> likePost(String postId, String uid, List likes) async {
    String res = "Lỗi khi thích bài";
    try {
      if (likes.contains(uid)) {
        // nếu người dùng đã like bài đăng này rồi thì xóa like
        _firestore.collection('posts').doc(postId).update({
          'likes': FieldValue.arrayRemove([uid])
        });
      } else {
        // nếu người dùng chưa like bài đăng này thì thêm like
        _firestore.collection('posts').doc(postId).update({
          'likes': FieldValue.arrayUnion([uid])
        });
      }
      res = 'Thành công';
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  // đếm số like của bài đăng
  Future<String> postComment(String postId, String text, String uid,
      String name, String profilePic) async {
    String res = "Lỗi khi bình luận";
    try {
      if (text.isNotEmpty) {
        // nếu danh sách thích có chứa uid của người dùng, chúng tôi cần xóa nó
        String commentId = const Uuid().v1();
        _firestore
            .collection('posts')
            .doc(postId)
            .collection('comments')
            .doc(commentId)
            .set({
          'profilePic': profilePic,
          'name': name,
          'uid': uid,
          'text': text,
          'commentId': commentId,
          'datePublished': DateTime.now(),
        });
        res = 'Thành công';
      } else {
        res = "Bình luận không được để trống";
      }
    } catch (err) {
      res = err.toString();
    }
    return res;
  }
  //xóa bài đăng
  Future<String> deletePost(String postId) async {
    String res = "Lỗi khi xóa bài";
    try {
      await _firestore.collection('posts').doc(postId).delete();
      res = 'Thành công';
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  Future<void> followUser(String uid, String followId) async {
    try {
      DocumentSnapshot snap =
          await _firestore.collection('users').doc(uid).get();
      List following = (snap.data()! as dynamic)['following'];

      if (following.contains(followId)) {
        await _firestore.collection('users').doc(followId).update({
          'followers': FieldValue.arrayRemove([uid])
        });

        await _firestore.collection('users').doc(uid).update({
          'following': FieldValue.arrayRemove([followId])
        });
      } else {
        await _firestore.collection('users').doc(followId).update({
          'followers': FieldValue.arrayUnion([uid])
        });

        await _firestore.collection('users').doc(uid).update({
          'following': FieldValue.arrayUnion([followId])
        });
      }
    } catch (e) {
      // ignore: avoid_print
      print(e.toString());
    }
  }
}
