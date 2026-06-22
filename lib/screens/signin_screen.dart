import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class SignInScreen extends StatefulWidget {
  static const String routeName = '/signin';
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailCtrl = TextEditingController();
  final _passCtrl = TextEditingController();

  bool _rememberMe = false;
  bool _obscure = true;
  bool _isLoading = false;

  final Color _accent = const Color(0xFF7DA7FF);

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passCtrl.dispose();
    super.dispose();
  }

  void _attemptLogin() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);
    await Future.delayed(const Duration(seconds: 2)); // fake delay
    setState(() => _isLoading = false);

    // Navigate to HomeScreen after successful login
    Navigator.pushReplacementNamed(context, '/home');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: SingleChildScrollView( // Added for scroll effect
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: MediaQuery.of(context).size.height - MediaQuery.of(context).padding.top,
            ),
            child: IntrinsicHeight(
              child: Center(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(32),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
                    child: Container(
                      padding: const EdgeInsets.fromLTRB(24, 20, 24, 20),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.04),
                        borderRadius: BorderRadius.circular(32),
                        border: Border.all(color: Colors.white.withOpacity(0.1)),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Align(
                            alignment: Alignment.centerLeft,
                            child: IconButton(
                              icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
                              onPressed: () => Navigator.pop(context),
                            ),
                          ),
                          Image.asset('assets/images/logo.png', height: 70),
                          const SizedBox(height: 20),
                          const Text(
                            'Sign in to your account',
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 30),

                          // ---------- FORM ----------
                          Form(
                            key: _formKey,
                            child: Column(
                              children: [
                                _inputField(
                                  controller: _emailCtrl,
                                  hint: 'email@domain.com',
                                  icon: Icons.email_outlined,
                                  keyboardType: TextInputType.emailAddress,
                                ),
                                const SizedBox(height: 20),
                                _inputField(
                                  controller: _passCtrl,
                                  hint: 'Password',
                                  icon: Icons.lock_outline,
                                  isPassword: true,
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(height: 10),
                          _rememberMeRow(),
                          const SizedBox(height: 20),

                          _isLoading
                              ? const CircularProgressIndicator(color: Colors.white)
                              : _primaryButton(
                            label: 'Sign in',
                            onPressed: _attemptLogin,
                          ),

                          const SizedBox(height: 25),
                          _divider('or continue with'),
                          const SizedBox(height: 20),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              _socialIcon(FontAwesomeIcons.facebookF, Colors.blueAccent),
                              _socialIcon(FontAwesomeIcons.google, Colors.redAccent),
                              _socialIcon(FontAwesomeIcons.apple, Colors.white),
                            ],
                          ),
                          const SizedBox(height: 25),

                          GestureDetector(
                            onTap: () => Navigator.pushNamed(context, '/signup'),
                            child: const Text(
                              "Don't have an account?  Sign up",
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.white70,
                                decoration: TextDecoration.underline,
                              ),
                            ),
                          ),
                          const SizedBox(height: 20), // Added extra space at the bottom
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  // ---------------- helper widgets ----------------

  Widget _inputField({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    bool isPassword = false,
    TextInputType? keyboardType,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.white.withOpacity(0.1)),
      ),
      child: Row(
        children: [
          const SizedBox(width: 14),
          Icon(icon, color: Colors.white60, size: 20),
          const SizedBox(width: 10),
          Expanded(
            child: TextFormField(
              controller: controller,
              keyboardType: keyboardType,
              obscureText: isPassword ? _obscure : false,
              style: const TextStyle(color: Colors.white, fontSize: 14),
              decoration: InputDecoration(
                hintText: hint,
                hintStyle: const TextStyle(color: Colors.white54, fontSize: 14),
                border: InputBorder.none,
              ),
              validator: (v) => (v == null || v.trim().isEmpty) ? 'Required' : null,
            ),
          ),
          if (isPassword)
            IconButton(
              icon: Icon(
                _obscure ? Icons.visibility_off : Icons.visibility,
                color: Colors.white60,
              ),
              onPressed: () => setState(() => _obscure = !_obscure),
            ),
        ],
      ),
    );
  }

  Widget _rememberMeRow() => Row(
    children: [
      Checkbox(
        value: _rememberMe,
        onChanged: (v) => setState(() => _rememberMe = v!),
        activeColor: _accent,
        checkColor: Colors.black,
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      ),
      const Text('Remember me', style: TextStyle(color: Colors.white70)),
    ],
  );

  Widget _primaryButton({
    required String label,
    required VoidCallback onPressed,
  }) =>
      SizedBox(
        width: double.infinity,
        child: FilledButton(
          style: FilledButton.styleFrom(
            backgroundColor: _accent,
            padding: const EdgeInsets.symmetric(vertical: 14),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(26)),
          ),
          onPressed: onPressed,
          child: Text(label, style: const TextStyle(color: Colors.white, fontSize: 16)),
        ),
      );

  Widget _divider(String t) => Row(
    children: [
      const Expanded(child: Divider(color: Colors.white24)),
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: Text(t, style: const TextStyle(color: Colors.white60)),
      ),
      const Expanded(child: Divider(color: Colors.white24)),
    ],
  );

  Widget _socialIcon(IconData icon, Color c) => InkWell(
    borderRadius: BorderRadius.circular(14),
    onTap: () {
      // social auth later
    },
    child: Ink(
      height: 50,
      width: 50,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.07),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Center(child: FaIcon(icon, color: c, size: 22)),
    ),
  );
}