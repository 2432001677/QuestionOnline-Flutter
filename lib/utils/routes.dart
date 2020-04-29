import 'package:flu1/pages/login.dart';
import 'package:flu1/pages/register.dart';
import 'package:flu1/pages/user.dart';

const loginPage = "/login";
const registerPage = "/register";
const userPage = "/user";

var RoutePath = {
  "$loginPage": (context) => LoginPage(),
  "$registerPage": (context) => RegisterPage(),
  "$userPage": (context) => UserPage(),
};
