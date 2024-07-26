import 'package:firebase_auth/firebase_auth.dart';

class authen {
  final FirebaseAuth auth=FirebaseAuth.instance;
  getcurrent ()async{
    return await auth.currentUser;
  }
}