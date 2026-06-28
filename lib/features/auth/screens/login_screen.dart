import 'package:flutter/material.dart';
import 'package:grad_project/features/auth/screens/register_screen.dart';
import 'package:grad_project/features/auth/screens/forgot_password_screen.dart';
import 'package:grad_project/features/navigation/main_navigation_screen.dart';
import 'package:grad_project/features/auth/services/auth_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final emailController    = TextEditingController();
  final passwordController = TextEditingController();
  bool rememberMe      = false;
  bool isLoading       = false;
  bool isPasswordHidden = true;
  String? errorMessage;

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: SizedBox(
        height: screenHeight,
        child: Stack(
          children: [
            SizedBox(
              height: screenHeight * 0.35,
              width: double.infinity,
              child: Image.asset('assets/images/doctor.jpg', fit: BoxFit.cover),
            ),
            Container(
              height: screenHeight * 0.35,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withValues(alpha: 0.10),
                    Colors.black.withValues(alpha: 0.30),
                  ],
                ),
              ),
            ),
            Positioned(
              top: screenHeight * 0.25,
              left: 0, right: 0, bottom: 0,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
                decoration: const BoxDecoration(
                  color: Color(0xFFF8FAFC),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(40),
                    topRight: Radius.circular(40),
                  ),
                ),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Image.asset('assets/images/logo.png', width: 120),
                      const SizedBox(height: 20),
                      const Text("Welcome to Tamkeen",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF1E293B))),
                      const SizedBox(height: 8),
                      const Text("Sign in to continue your healthcare journey",
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.grey, fontSize: 14)),
                      const SizedBox(height: 25),

                      // Email
                      TextField(
                        controller: emailController,
                        onChanged: (_) {
                          if (errorMessage != null)
                            setState(() => errorMessage = null);
                        },
                        decoration: InputDecoration(
                          hintText: "email@tamkeen.com",
                          prefixIcon: const Icon(Icons.email_outlined),
                          filled: true, fillColor: Colors.white,
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16),
                              borderSide: BorderSide.none),
                          enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16),
                              borderSide: BorderSide.none),
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16),
                              borderSide: const BorderSide(color: Color(0xFF0E73B8))),
                        ),
                      ),
                      const SizedBox(height: 15),

                      // Password
                      TextField(
                        controller: passwordController,
                        obscureText: isPasswordHidden,
                        onChanged: (_) {
                          if (errorMessage != null)
                            setState(() => errorMessage = null);
                        },
                        decoration: InputDecoration(
                          hintText: "Password",
                          prefixIcon: const Icon(Icons.lock_outline),
                          suffixIcon: IconButton(
                            onPressed: () =>
                                setState(() => isPasswordHidden = !isPasswordHidden),
                            icon: Icon(isPasswordHidden
                                ? Icons.visibility_off_outlined
                                : Icons.visibility_outlined),
                          ),
                          filled: true, fillColor: Colors.white,
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16),
                              borderSide: BorderSide.none),
                          enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16),
                              borderSide: BorderSide.none),
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16),
                              borderSide: const BorderSide(color: Color(0xFF0E73B8))),
                        ),
                      ),

                      Row(
                        children: [
                          Checkbox(
                            value: rememberMe,
                            onChanged: (value) =>
                                setState(() => rememberMe = value ?? false),
                          ),
                          const Text("Remember Me"),
                        ],
                      ),

                      if (errorMessage != null) ...[
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            const Icon(Icons.error_outline,
                                color: Colors.red, size: 18),
                            const SizedBox(width: 6),
                            Expanded(
                              child: Text(errorMessage!,
                                  style: const TextStyle(
                                      color: Colors.red, fontSize: 14)),
                            ),
                          ],
                        ),
                      ],

                      const SizedBox(height: 10),
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          onPressed: () => Navigator.push(context,
                              MaterialPageRoute(
                                  builder: (_) => const ForgotPasswordScreen())),
                          child: const Text("Forgot Password?"),
                        ),
                      ),
                      const SizedBox(height: 10),

                      // Login Button
                      SizedBox(
                        width: double.infinity,
                        height: 55,
                        child: ElevatedButton(
                          onPressed: isLoading ? null : _login,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF0E73B8),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16)),
                          ),
                          child: isLoading
                              ? const CircularProgressIndicator(color: Colors.white)
                              : const Text("Login",
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 18)),
                        ),
                      ),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text("Don't have an account?"),
                          TextButton(
                            onPressed: () => Navigator.push(context,
                                MaterialPageRoute(
                                    builder: (_) => const RegisterScreen())),
                            child: const Text("Sign Up"),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _login() async {
    setState(() { isLoading = true; errorMessage = null; });

    try {
      // ✅ login بترجع Map مش bool دلوقتي
      await AuthService().login(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );

      if (rememberMe) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setBool("rememberMe", true);
      }

      if (!mounted) return;
      Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (_) => const MainNavigationScreen()));
    } catch (e) {
      if (!mounted) return;
      setState(() {
        errorMessage = e.toString().replaceAll("Exception: ", "");
      });
    } finally {
      if (mounted) setState(() => isLoading = false);
    }
  }
}
