class UserKeys {
  static const uid = 'uid';
  static const email = 'email';
  static const firstname = 'firstname';
  static const lastname = 'lastname';
  static const role = 'role';
}

class CustomUser {
  final String uid;
  final String email;
  final String firstname;
  final String lastname;
  final String role;

  CustomUser(this.uid, this.email, this.firstname, this.lastname, this.role);

  //Getting user from firebase, then mapping user to a dart object
  CustomUser.fromMap(Map<String, dynamic> data)
      : uid = data[UserKeys.uid],
        email = data[UserKeys.email],
        firstname = data[UserKeys.firstname],
        lastname = data[UserKeys.lastname],
        role = data[UserKeys.role];

  Map<String, dynamic> toMap() {
    return {
      UserKeys.uid: uid,
      UserKeys.email: email,
      UserKeys.firstname: firstname,
      UserKeys.lastname: lastname,
      UserKeys.role: role,
    };
  }
}
