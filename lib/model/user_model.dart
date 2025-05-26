class User {
  int? id;
  String userName;
  String email;
  String password;

  User({
    this.id,
    required this.userName,
    required this.email,
    required this.password,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userName': userName,
      'email': email,
      'password': password,
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'],
      userName: map['userName'],
      email: map['email'],
      password: map['password'],
    );
  }
}