class UserKeys{
  static const uid = 'uid';
  static const email = 'email';
  static const firstname = 'firstname';
  static const lastname = 'lastname';
}

class CustomUser{
  final String uid;
  final String email;
  final String firstname;
  final String lastname;

  CustomUser(this.uid, this.email, this.firstname, this.lastname);

  //Getting tour from firebase, then mapping tour to a dart object
  CustomUser.fromMap(Map<String, dynamic> data)
      :
        uid = data[UserKeys.uid],
        email = data[UserKeys.email],
        firstname = data[UserKeys.firstname],
        lastname = data[UserKeys.lastname];

  Map<String, dynamic> toMap(){
    return {
      UserKeys.uid: uid,
      UserKeys.email: email,
      UserKeys.firstname: firstname,
      UserKeys.lastname: lastname,
    };
  }
}