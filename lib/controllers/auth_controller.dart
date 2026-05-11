import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/enums.dart';
import '../models/user_model.dart';

class AuthController extends ChangeNotifier {
  AuthController() {
    _initialize();
  }

  Future<void> _initialize() async {
    await loadSession();
  }

  UserModel? _currentUser;
  UserModel? get currentUser => _currentUser;
  
  // Registration Data (Single user for basic persistence)
  String? _registeredEmail;
  String? _registeredPassword;
  String? _registeredFirstName;
  String? _registeredLastName;
  Gender? _registeredGender;

  // Login Controllers
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  
  // Registration Controllers
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();
  
  Gender? _selectedGender;
  Gender? get selectedGender => _selectedGender;
  
  AppState _authState = AppState.initial;
  AppState get authState => _authState;
  
  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  String? _successMessage;
  String? get successMessage => _successMessage;

  bool _isPasswordVisible = false;
  bool get isPasswordVisible => _isPasswordVisible;

  bool _rememberMe = true; // Default to true for better experience
  bool get rememberMe => _rememberMe;

  final GlobalKey<FormState> loginFormKey = GlobalKey<FormState>();
  final GlobalKey<FormState> registerFormKey = GlobalKey<FormState>();

  bool _isLoginFormValid = false;
  bool get isLoginFormValid => _isLoginFormValid;

  bool _isRegisterFormValid = false;
  bool get isRegisterFormValid => _isRegisterFormValid;

  Future<void> loadSession() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      
      // 1. Load Registered User Info (Basic persistence instead of map)
      _registeredEmail = prefs.getString('reg_email');
      _registeredPassword = prefs.getString('reg_password');
      _registeredFirstName = prefs.getString('reg_firstName');
      _registeredLastName = prefs.getString('reg_lastName');
      final regGenderIndex = prefs.getInt('reg_gender');
      if (regGenderIndex != null) {
        _registeredGender = Gender.values[regGenderIndex];
      }

      // 2. Load Current Login Session
      final isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
      if (isLoggedIn) {
        final email = prefs.getString('userEmail');
        final firstName = prefs.getString('userFirstName');
        final lastName = prefs.getString('userLastName');
        final genderIndex = prefs.getInt('userGender');
        
        if (email != null && firstName != null) {
          _currentUser = UserModel(
            firstName: firstName,
            lastName: lastName ?? "",
            email: email,
            gender: genderIndex != null ? Gender.values[genderIndex] : Gender.male,
          );
          _authState = AppState.authenticated;
        } else {
          _authState = AppState.unauthenticated;
        }
      } else {
        _authState = AppState.unauthenticated;
      }
    } catch (e) {
      _authState = AppState.unauthenticated;
    }
    notifyListeners();
  }

  Future<void> saveSession() async {
    if (_currentUser == null) return;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLoggedIn', true);
    await prefs.setString('userEmail', _currentUser!.email);
    await prefs.setString('userFirstName', _currentUser!.firstName);
    await prefs.setString('userLastName', _currentUser!.lastName);
    await prefs.setInt('userGender', _currentUser!.gender?.index ?? 0);
  }

  Future<void> clearSession() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLoggedIn', false);
    await prefs.remove('userEmail');
    await prefs.remove('userFirstName');
    await prefs.remove('userLastName');
    await prefs.remove('userGender');
  }

  void validateLoginForm() {
    _isLoginFormValid = loginFormKey.currentState?.validate() ?? false;
    notifyListeners();
  }

  void validateRegisterForm() {
    _isRegisterFormValid = registerFormKey.currentState?.validate() ?? false;
    notifyListeners();
  }

  void togglePasswordVisibility() {
    _isPasswordVisible = !_isPasswordVisible;
    notifyListeners();
  }

  void toggleRememberMe(bool? value) {
    if (value != null) {
      _rememberMe = value;
      notifyListeners();
    }
  }

  void setGender(Gender? gender) {
    _selectedGender = gender;
    validateRegisterForm();
    notifyListeners();
  }

  Future<bool> login() async {
    if (loginFormKey.currentState == null || !loginFormKey.currentState!.validate()) {
      return false;
    }
    
    _authState = AppState.loading;
    _errorMessage = null;
    notifyListeners();
    
    await Future.delayed(const Duration(seconds: 1));
    
    final inputEmail = emailController.text.trim();
    final inputPassword = passwordController.text;

    // Verify against registered user data
    if (_registeredEmail == inputEmail && _registeredPassword == inputPassword) {
      _currentUser = UserModel(
        firstName: _registeredFirstName ?? "User",
        lastName: _registeredLastName ?? "",
        email: _registeredEmail!,
        gender: _registeredGender,
      );
      
      await saveSession();
      
      _authState = AppState.authenticated;
      notifyListeners();
      return true;
    } else if (_registeredEmail == null) {
      _authState = AppState.error;
      _errorMessage = "No registered user found. Please register first.";
    } else {
      _authState = AppState.error;
      _errorMessage = "Invalid email or password.";
    }
    notifyListeners();
    return false;
  }
  
  Future<bool> register() async {
    if (registerFormKey.currentState == null || !registerFormKey.currentState!.validate()) {
      return false;
    }
    
    _authState = AppState.loading;
    _errorMessage = null;
    _successMessage = null;
    notifyListeners();
    
    await Future.delayed(const Duration(seconds: 1));
    
    final prefs = await SharedPreferences.getInstance();
    
    _registeredEmail = emailController.text.trim();
    _registeredPassword = passwordController.text;
    _registeredFirstName = firstNameController.text.trim();
    _registeredLastName = lastNameController.text.trim();
    _registeredGender = _selectedGender;

    // Save registration info to persistent storage
    await prefs.setString('reg_email', _registeredEmail!);
    await prefs.setString('reg_password', _registeredPassword!);
    await prefs.setString('reg_firstName', _registeredFirstName!);
    await prefs.setString('reg_lastName', _registeredLastName!);
    if (_registeredGender != null) {
      await prefs.setInt('reg_gender', _registeredGender!.index);
    }

    _authState = AppState.success;
    _successMessage = "Registration successful! You can now log in.";
    notifyListeners();
    return true;
  }

  void clearForm() {
    emailController.clear();
    passwordController.clear();
    firstNameController.clear();
    lastNameController.clear();
    confirmPasswordController.clear();
    _selectedGender = null;
    _errorMessage = null;
    _successMessage = null;
    _authState = AppState.initial;
    _isLoginFormValid = false;
    _isRegisterFormValid = false;
    notifyListeners();
  }

  void logout() async {
    _authState = AppState.unauthenticated;
    _currentUser = null;
    await clearSession();
    clearForm();
    notifyListeners();
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    firstNameController.dispose();
    lastNameController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }
}
