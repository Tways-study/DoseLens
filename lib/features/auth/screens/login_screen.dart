import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/theme/color_tokens.dart';
import '../../../core/theme/text_styles.dart';
import '../../../core/utils/validators.dart';
import '../../../core/widgets/primary_action_button.dart';
import '../providers/auth_provider.dart';
import 'register_screen.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();
  bool _loading = false;
  bool _obscure = true;
  String? _error;

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passwordCtrl.dispose();
    super.dispose();
  }

  Future<void> _signIn() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() { _loading = true; _error = null; });
    try {
      await ref.read(authServiceProvider).signInWithEmailPassword(
        email: _emailCtrl.text.trim(),
        password: _passwordCtrl.text,
      );
    } catch (e) {
      setState(() => _error = _friendlyError(e.toString()));
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _signInAnonymously() async {
    setState(() { _loading = true; _error = null; });
    try {
      await ref.read(authServiceProvider).signInAnonymously();
    } catch (e) {
      setState(() => _error = _friendlyError(e.toString()));
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  String _friendlyError(String raw) {
    if (raw.contains('user-not-found') || raw.contains('wrong-password') || raw.contains('invalid-credential')) {
      return 'Incorrect email or password. Please try again.';
    }
    if (raw.contains('network')) return 'Network error. Check your connection.';
    return 'Sign-in failed. Please try again.';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorTokens.canvas,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: AppConstants.space28, vertical: AppConstants.space32),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),
                // Brand Mark
                Row(
                  children: [
                    Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: ColorTokens.electricBlue,
                        borderRadius: BorderRadius.circular(AppConstants.radiusMedium),
                      ),
                      child: const Icon(Icons.medication_rounded, color: Colors.white, size: 22),
                    ),
                    const SizedBox(width: AppConstants.space12),
                    Text(
                      'DoseLens',
                      style: TextStyles.headingLarge.copyWith(fontWeight: FontWeight.w700),
                    ),
                  ],
                ),
                const SizedBox(height: 48),

                // Whispered Display Headline
                Text(
                  'Welcome back.',
                  style: TextStyles.displayLarge,
                ),
                const SizedBox(height: 8),
                Text(
                  'Sign in to manage your medication schedule and adherence history.',
                  style: TextStyles.bodySecondary,
                ),
                const SizedBox(height: 36),

                // Error banner
                if (_error != null) ...[
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(AppConstants.space16),
                    decoration: BoxDecoration(
                      color: ColorTokens.emberBg,
                      borderRadius: BorderRadius.circular(AppConstants.radiusMedium),
                      border: Border.all(color: ColorTokens.emberBorder, width: 0.8),
                    ),
                    child: Text(
                      _error!,
                      style: const TextStyle(color: ColorTokens.ember, fontSize: 13, fontWeight: FontWeight.w500),
                    ),
                  ),
                  const SizedBox(height: 20),
                ],

                // Email field
                _ReferoTextField(
                  controller: _emailCtrl,
                  label: 'Email',
                  hint: 'you@example.com',
                  keyboardType: TextInputType.emailAddress,
                  validator: Validators.email,
                ),
                const SizedBox(height: 18),

                // Password field
                _ReferoTextField(
                  controller: _passwordCtrl,
                  label: 'Password',
                  hint: '••••••••',
                  obscureText: _obscure,
                  validator: Validators.password,
                  suffix: IconButton(
                    icon: Icon(
                      _obscure ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                      size: 20,
                      color: ColorTokens.midGray,
                    ),
                    onPressed: () => setState(() => _obscure = !_obscure),
                  ),
                ),
                const SizedBox(height: 32),

                // Electric Blue Filled Pill Button
                PrimaryActionButton(
                  title: 'Sign In',
                  isLoading: _loading,
                  onPressed: _signIn,
                ),
                const SizedBox(height: 14),

                // Ghost Pill Button
                PrimaryActionButton(
                  title: 'Continue as Guest',
                  isGhost: true,
                  isLoading: false,
                  onPressed: _loading ? null : _signInAnonymously,
                ),
                const SizedBox(height: 36),

                // Sign up Link
                Center(
                  child: GestureDetector(
                    onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const RegisterScreen())),
                    child: RichText(
                      text: const TextSpan(
                        text: "Don't have an account? ",
                        style: TextStyle(color: ColorTokens.midGray, fontSize: 14),
                        children: [
                          TextSpan(
                            text: 'Sign up',
                            style: TextStyle(color: ColorTokens.linkBlue, fontWeight: FontWeight.w600),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ReferoTextField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final String hint;
  final bool obscureText;
  final TextInputType? keyboardType;
  final String? Function(String?)? validator;
  final Widget? suffix;

  const _ReferoTextField({
    required this.controller,
    required this.label,
    required this.hint,
    this.obscureText = false,
    this.keyboardType,
    this.validator,
    this.suffix,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: ColorTokens.primaryInk, letterSpacing: -0.1),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          obscureText: obscureText,
          keyboardType: keyboardType,
          validator: validator,
          style: const TextStyle(fontSize: 15, color: ColorTokens.primaryInk),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: const TextStyle(color: ColorTokens.midGray),
            suffixIcon: suffix,
          ),
        ),
      ],
    );
  }
}
