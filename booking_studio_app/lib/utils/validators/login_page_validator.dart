import 'dart:async';

mixin LoginPageValidators {
  var usernameValidator = StreamTransformer<String, String>.fromHandlers(
    handleData: (username, sink) {
      if(username.length >= 4){
        sink.add(username);
      } else {
        sink.addError("Username is Invalid");
      }
    }
  );

  var passwordValidator = StreamTransformer<String, String>.fromHandlers(
    handleData: (password, sink) {
      if(password.length > 6){
        sink.add(password);
      } else {
        sink.addError("Password length should be greater than 6 characters");
      }
    }
  );
}