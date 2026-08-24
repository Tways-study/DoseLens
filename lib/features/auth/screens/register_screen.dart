import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/theme/color_tokens.dart';
import '../../../core/theme/text_styles.dart';
import '../../../core/utils/validators.dart';
import '../../../core/widgets/primary_action_button.dart';
import '../providers/auth_provider.dart';
import 'role_selection_screen.dart';

class RegisterScreen extends ConsumerStatefulWidget {
  const RegisterScreen({super.key});

  @override
  ConsumerState<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends ConsumerState<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();
  bool _loading = false;
  bool _obscure = true;
  String? _error;

  @override
  void dispose() {
    _nameCtrl.dispose();
    _emailCtrl.dispose();
    _passwordCtrl.dispose();
    super.dispose();
  }

  Future<void> _register() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() { _loading = true; _error = null; });
    try {
      final cred = await ref.read(authServiceProvider).signUpWithEmailPassword(
        email: _emailCtrl.text.trim(),
        password: _passwordCtrl.text,
      );
      await cred.user?.updateDisplayName(_nameCtrl.text.trim());
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => RoleSelectionScreen(
              uid: cred.user!.uid,
              email: _emailCtrl.text.trim(),
              displayName: _nameCtrl.text.trim(),
            ),
          ),
        );
      }
    } catch (e) {
      setState(() => _error = _friendlyError(e.toString()));
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  String _friendlyError(String raw) {
    if (raw.contains('email-already-in-use')) return 'An account with this email already exists.';
    if (raw.contains('weak-password')) return 'Password is too weak. Use at least 6 characters.';
    if (raw.contains('network')) return 'Network error. Check your connection.';
    return 'Sign-up failed. Please try again.';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorTokens.canvas,
      appBar: AppBar(
        backgroundColor: ColorTokens.canvas,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 18, color: ColorTokens.primaryInk),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: AppConstants.space28, vertical: AppConstants.space16),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Create account.',
                  style: TextStyles.displayLarge,
                ),
                const SizedBox(height: 8),
                Text(
                  'Start tracking your medications and health passport today.',
                  style: TextStyles.bodySecondary,
                ),
                const SizedBox(height: 36),

                if (_error != null) ...[
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(AppConstants.space16),
                    decoration: BoxDecoration(
                      color: ColorTokens.emberBg,
                      borderRadius: BorderRadius.circular(AppConstants.radiusMedium),
                      border: Border.all(color: ColorTokens.emberBorder, width: 0.8),
                    ),
                    child: Text(_error!, style: const TextStyle(color: ColorTokens.ember, fontSize: 13, fontWeight: FontWeight.w500)),
                  ),
                  const SizedBox(height: 20),
                ],

                _ReferoField(
                  controller: _nameCtrl,
                  label: 'Full Name',
                  hint: 'Jane Doe',
                  validator: (v) => Validators.requiredField(v, 'Name'),
                ),
                const SizedBox(height: 18),
                _ReferoField(
                  controller: _emailCtrl,
                  label: 'Email',
                  hint: 'you@example.com',
                  keyboardType: TextInputType.emailAddress,
                  validator: Validators.email,
                ),
                const SizedBox(height: 18),
                _ReferoField(
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
                const SizedBox(height: 36),

                PrimaryActionButton(
                  title: 'Create Account',
                  isLoading: _loading,
                  onPressed: _register,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ReferoField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final String hint;
  final bool obscureText;
  final TextInputType? keyboardType;
  final String? Function(String?)? validator;
  final Widget? suffix;

  const _ReferoField({
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
