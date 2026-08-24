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
  final _emailCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  final _confirmPassCtrl = TextEditingController();
  bool _obscurePass = true;

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passCtrl.dispose();
    _confirmPassCtrl.dispose();
    super.dispose();
  }

  Future<void> _signUp() async {
    if (!_formKey.currentState!.validate()) return;
    try {
      await ref.read(authNotifierProvider.notifier).signUpWithEmail(
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
          SnackBar(content: Text(e.toString()), backgroundColor: ColorTokens.vermillion),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authNotifierProvider);

    return Scaffold(
      backgroundColor: ColorTokens.paper,
      appBar: AppBar(
        backgroundColor: ColorTokens.paper,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded, color: ColorTokens.inkBlack),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: AppConstants.space24, vertical: AppConstants.space16),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 440),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Create\nAccount.',
                      style: TextStyles.displayLarge,
                    ),
                    const SizedBox(height: AppConstants.space8),
                    Text(
                      'Start tracking your daily regimens with AI precision.',
                      style: TextStyles.bodySecondary,
                    ),
                    const SizedBox(height: AppConstants.space32),

                    Container(
                      padding: const EdgeInsets.all(AppConstants.space24),
                      decoration: BoxDecoration(
                        color: ColorTokens.snow,
                        borderRadius: BorderRadius.circular(AppConstants.radiusCard),
                        border: Border.all(color: ColorTokens.hairline, width: 1.0),
                        boxShadow: const [ColorTokens.cardShadow],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Email Address', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: ColorTokens.inkBlack)),
                          const SizedBox(height: 6),
                          TextFormField(
                            controller: _emailCtrl,
                            keyboardType: TextInputType.emailAddress,
                            validator: Validators.email,
                            decoration: const InputDecoration(
                              hintText: 'name@example.com',
                              prefixIcon: Icon(Icons.mail_outline_rounded, size: 18, color: ColorTokens.graphite),
                            ),
                          ),
                          const SizedBox(height: AppConstants.space16),

                          const Text('Password', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: ColorTokens.inkBlack)),
                          const SizedBox(height: 6),
                          TextFormField(
                            controller: _passCtrl,
                            obscureText: _obscurePass,
                            validator: (v) => Validators.minLength(v, 6, 'Password'),
                            decoration: InputDecoration(
                              hintText: '••••••••',
                              prefixIcon: const Icon(Icons.lock_outline_rounded, size: 18, color: ColorTokens.graphite),
                              suffixIcon: IconButton(
                                icon: Icon(_obscurePass ? Icons.visibility_outlined : Icons.visibility_off_outlined, size: 18, color: ColorTokens.graphite),
                                onPressed: () => setState(() => _obscurePass = !_obscurePass),
                              ),
                            ),
                          ),
                          const SizedBox(height: AppConstants.space16),

                          const Text('Confirm Password', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: ColorTokens.inkBlack)),
                          const SizedBox(height: 6),
                          TextFormField(
                            controller: _confirmPassCtrl,
                            obscureText: _obscurePass,
                            validator: (v) {
                              if (v != _passCtrl.text) return 'Passwords do not match';
                              return null;
                            },
                            decoration: const InputDecoration(
                              hintText: '••••••••',
                              prefixIcon: Icon(Icons.lock_outline_rounded, size: 18, color: ColorTokens.graphite),
                            ),
                          ),
                          const SizedBox(height: AppConstants.space24),

                          PrimaryActionButton(
                            title: 'Register & Continue',
                            isLoading: authState.isLoading,
                            onPressed: _signUp,
                          ),
                        ],
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
