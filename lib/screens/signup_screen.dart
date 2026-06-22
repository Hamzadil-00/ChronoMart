import 'dart:ui';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class SignUpScreen extends StatefulWidget {
  static const String routeName = '/signup';
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  final _confirmCtrl = TextEditingController();

  bool _rememberMe = false;
  bool _obscurePass = true;
  bool _obscureConfirm = true;
  bool _isLoading = false;

  final Color _accent = const Color(0xFF7DA7FF);

  @override
  void dispose() {
    _nameCtrl.dispose();
    _emailCtrl.dispose();
    _passCtrl.dispose();
    _confirmCtrl.dispose();
    super.dispose();
  }

  // fake sign-up action
  Future<void> _attemptSignUp() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);
    await Future.delayed(const Duration(seconds: 2));
    setState(() => _isLoading = false);

    // Navigate to HomeScreen after successful signup
    Navigator.pushReplacementNamed(context, '/home');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: LayoutBuilder(
        builder: (context, constraints) {
          // ---- Scroll only when necessary ----
          return SingleChildScrollView(
            padding: EdgeInsets.only(
              left: 16,
              right: 16,
              top: 20,
              // make room for on-screen keyboard as well
              bottom: max(20.0, MediaQuery.of(context).viewInsets.bottom + 20),
            ),
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: constraints.maxHeight),
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
                        border: Border.all(color: Colors.white.withOpacity(.1)),
                      ),
                      child: _buildCardContent(context),
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  // ---------------- Card Content ----------------

  Widget _buildCardContent(BuildContext context) => Column(
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
      const SizedBox(height: 12),
      const Text(
        'Create your account',
        style:
        TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: Colors.white),
      ),
      const SizedBox(height: 24),

      // ---------- FORM ----------
      Form(
        key: _formKey,
        child: Column(
          children: [
            _inputField(
              controller: _nameCtrl,
              hint: 'Full name',
              icon: Icons.person_outline,
              keyboardType: TextInputType.name,
            ),
            const SizedBox(height: 14),
            _inputField(
              controller: _emailCtrl,
              hint: 'email@domain.com',
              icon: Icons.email_outlined,
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 14),
            _inputField(
              controller: _passCtrl,
              hint: 'Password',
              icon: Icons.lock_outline,
              isPassword: true,
              obscure: _obscurePass,
              onToggleObscure: () => setState(() => _obscurePass = !_obscurePass),
            ),
            const SizedBox(height: 14),
            _inputField(
              controller: _confirmCtrl,
              hint: 'Confirm password',
              icon: Icons.lock_reset_outlined,
              isPassword: true,
              obscure: _obscureConfirm,
              onToggleObscure: () =>
                  setState(() => _obscureConfirm = !_obscureConfirm),
              confirmValidator: () =>
              _confirmCtrl.text.trim() != _passCtrl.text.trim()
                  ? 'Passwords do not match'
                  : null,
            ),
          ],
        ),
      ),

      const SizedBox(height: 8),
      _rememberMeRow(),
      const SizedBox(height: 14),

      _isLoading
          ? const CircularProgressIndicator(color: Colors.white)
          : _primaryButton(label: 'Sign up', onPressed: _attemptSignUp),

      const SizedBox(height: 22),
      _divider('or continue with'),
      const SizedBox(height: 16),

      Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _socialIcon(FontAwesomeIcons.facebookF, Colors.blueAccent),
          _socialIcon(FontAwesomeIcons.google, Colors.redAccent),
          _socialIcon(FontAwesomeIcons.apple, Colors.white),
        ],
      ),
      const SizedBox(height: 18),

      GestureDetector(
        onTap: () => Navigator.pushNamed(context, '/signin'),
        child: const Text(
          'Already have an account?  Sign in',
          style: TextStyle(
            fontSize: 13,
            color: Colors.white70,
            decoration: TextDecoration.underline,
          ),
        ),
      ),
    ],
  );

  // -------------- Helper Widgets --------------

  Widget _inputField({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    bool isPassword = false,
    bool obscure = false,
    VoidCallback? onToggleObscure,
    TextInputType? keyboardType,
    String? Function()? confirmValidator,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.white.withOpacity(.1)),
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
              obscureText: isPassword ? obscure : false,
              style: const TextStyle(color: Colors.white, fontSize: 14),
              decoration: InputDecoration(
                hintText: hint,
                hintStyle:
                const TextStyle(color: Colors.white54, fontSize: 14),
                border: InputBorder.none,
              ),
              validator: (v) {
                if (v == null || v.trim().isEmpty) return 'Required';
                if (confirmValidator != null) return confirmValidator();
                return null;
              },
            ),
          ),
          if (isPassword)
            IconButton(
              icon: Icon(
                obscure ? Icons.visibility_off : Icons.visibility,
                color: Colors.white60,
              ),
              onPressed: onToggleObscure,
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
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(26),
            ),
          ),
          onPressed: onPressed,
          child:
          Text(label, style: const TextStyle(color: Colors.white, fontSize: 16)),
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

  Widget _socialIcon(IconData i, Color c) => InkWell(
    borderRadius: BorderRadius.circular(14),
    onTap: () {
      // social auth placeholder
    },
    child: Ink(
      height: 50,
      width: 50,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(.07),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Center(child: FaIcon(i, color: c, size: 22)),
    ),
  );
}