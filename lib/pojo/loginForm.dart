class LoginForm {
  String userId;
  String password;
  String school;

  static Map<String, String> toJsonObj(userId, password, school) {
    return {
      'userId': userId,
      'password': password,
      'school': school,
    };
  }
}
