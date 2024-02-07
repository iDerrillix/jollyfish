import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserModel {
  String uId = "";
  final CollectionReference users = FirebaseFirestore.instance.collection(
    'users',
  );

  UserModel() {
    String uID;
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      uID = user.uid;
    } else {
      uID = "";
    }
    uId = uID;
  }

  static Future<Map<String, dynamic>?> getUserById(String userId) async {
    DocumentSnapshot userDoc =
        await FirebaseFirestore.instance.collection('users').doc(userId).get();

    if (userDoc.exists) {
      print(userDoc.data());
      return userDoc.data() as Map<String, dynamic>;
    } else {
      print('Document does not exist');
    }
  }

  Future<void> updateUserDetails(
    String docID,
    String full_name,
    String phone_number,
    String address1,
    String barangay,
    String city,
    String province,
  ) {
    return users.doc(docID).update({
      'full_name': full_name,
      'phone_number': phone_number,
      'address1': address1,
      'barangay': barangay,
      'city': city,
      'province': province,
    });
  }
}
