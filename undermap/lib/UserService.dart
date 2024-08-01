import 'package:flutter/cupertino.dart';

class UserService extends ChangeNotifier {
   bool isOnboarded = true;

   void updateIsOnboared(isOnboarded) {
      this.isOnboarded = isOnboarded;
      notifyListeners();
   }
}