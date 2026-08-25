import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/theme/color_tokens.dart';
import '../../../core/theme/text_styles.dart';
import '../../../core/utils/validators.dart';
import '../../../core/widgets/doselens_logo.dart';
import '../../../core/widgets/primary_action_button.dart';
import '../providers/auth_provider.dart';
import 'register_screen.dart';
import 'role_selection_screen.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  bool _obscurePass = true;

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passCtrl.dispose();
    super.dispose();
  }

  Future<void> _signInWithEmail() async {
    if (!_formKey.currentState!.validate()) return;
    try {
      await ref.read(authNotifierProvider.notifier).signInWithEmail(
            _emailCtrl.text.trim(),
            _passCtrl.text.trim(),
          );
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const RoleSelectionScreen()),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.toString()),
            backgroundColor: ColorTokens.crimsonAlert,
          ),
        );
      }
    }
  }

  Future<void> _signInAsGuest() async {
    try {
      await ref.read(authNotifierProvider.notifier).signInAnonymously();
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const RoleSelectionScreen()),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.toString()),
            backgroundColor: ColorTokens.crimsonAlert,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authNotifierProvider);

    return Scaffold(
      backgroundColor: ColorTokens.fog,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: AppConstants.space24, vertical: AppConstants.space32),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 440),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Brand mark: The Optical Capsule
                    const DoseLensLogo(size: 34, showWordmark: true),
                    const SizedBox(height: AppConstants.space32),

                    // Display Headline
                    Text(
                      'Welcome to\nDoseLens.',
                      style: TextStyles.displayLarge,
                    ),
                    const SizedBox(height: AppConstants.space8),
                    Text(
                      'AI medication scanner, adherence tracker, and family health passport.',
                      style: TextStyles.bodySecondary,
                    ),
                    const SizedBox(height: AppConstants.space32),

                    // Form container
                    Container(
                      padding: const EdgeInsets.all(AppConstants.space24),
                      decoration: BoxDecoration(
                        color: ColorTokens.snow,
                        borderRadius: BorderRadius.circular(AppConstants.radiusCard),
                        border: Border.all(color: ColorTokens.silver, width: 1.0),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Email Address', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: ColorTokens.ink)),
                          const SizedBox(height: 6),
                          TextFormField(
                            controller: _emailCtrl,
                            keyboardType: TextInputType.emailAddress,
                            validator: Validators.email,
                            decoration: const InputDecoration(
                              hintText: 'name@example.com',
                              prefixIcon: Icon(Icons.mail_outline_rounded, size: 18, color: ColorTokens.ash),
                            ),
                          ),
                          const SizedBox(height: AppConstants.space16),

                          const Text('Password', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: ColorTokens.ink)),
                          const SizedBox(height: 6),
                          TextFormField(
                            controller: _passCtrl,
                            obscureText: _obscurePass,
                            validator: (v) => Validators.minLength(v, 6, 'Password'),
                            decoration: InputDecoration(
                              hintText: '••••••••',
                              prefixIcon: const Icon(Icons.lock_outline_rounded, size: 18, color: ColorTokens.ash),
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _obscurePass ? Icons.visibility_outlined : Icons.visibility_off_outlined,
                                  size: 18,
                                  color: ColorTokens.ash,
                                ),
                                onPressed: () => setState(() => _obscurePass = !_obscurePass),
                              ),
                            ),
                          ),
                          const SizedBox(height: AppConstants.space24),

                          // Primary Sign In Button (Electric Cerulean)
                          PrimaryActionButton(
                            title: 'Sign In',
                            isLoading: authState.isLoading,
                            onPressed: _signInWithEmail,
                          ),
                          const SizedBox(height: AppConstants.space12),

                          // Guest Access (Obsidian Button)
                          PrimaryActionButton(
                            title: 'Try Instant Guest Mode',
                            isObsidian: true,
                            isLoading: authState.isLoading,
                            onPressed: _signInAsGuest,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: AppConstants.space24),

                    Center(
                      child: TextButton(
                        onPressed: () => Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => const RegisterScreen()),
                        ),
                        child: Text(
                          'Don\'t have an account? Create one',
                          style: TextStyles.labelLarge.copyWith(color: ColorTokens.cobaltSignal),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
