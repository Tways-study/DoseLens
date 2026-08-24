import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/constants/app_constants.dart';
import 'core/services/firebase_service.dart';
import 'core/theme/app_theme.dart';
import 'core/theme/color_tokens.dart';
import 'features/auth/providers/auth_provider.dart';
import 'features/auth/screens/login_screen.dart';
import 'features/caregiver/screens/caregiver_dashboard_screen.dart';
import 'features/medications/screens/home_screen.dart';
import 'features/passport/screens/passport_screen.dart';
import 'features/scanner/screens/scanner_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await FirebaseService.initialize();
  } catch (e) {
    debugPrint('Firebase init note: $e');
  }
  runApp(const ProviderScope(child: DoseLensApp()));
}

class DoseLensApp extends StatelessWidget {
  const DoseLensApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'DoseLens',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.light,
      home: const _AuthGate(),
    );
  }
}

/// Auth gate: routes to LoginScreen or main shell based on Firebase auth state
class _AuthGate extends ConsumerWidget {
  const _AuthGate();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(firebaseAuthStateProvider);

    return authState.when(
      data: (user) {
        if (user == null) return const LoginScreen();
        return const MainAppShell();
      },
      loading: () => const Scaffold(
        backgroundColor: ColorTokens.icePaper,
        body: Center(
          child: CircularProgressIndicator(color: ColorTokens.electricCerulean, strokeWidth: 2.5),
        ),
      ),
      error: (_, __) => const LoginScreen(),
    );
  }
}

/// Main bottom navigation shell with prominent CENTERED Scan action button
class MainAppShell extends StatefulWidget {
  const MainAppShell({super.key});

  @override
  State<MainAppShell> createState() => _MainAppShellState();
}

class _MainAppShellState extends State<MainAppShell> {
  int _currentIndex = 0;

  final List<Widget> _screens = const [
    HomeScreen(),
    PassportScreen(),
    CaregiverDashboardScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorTokens.icePaper,
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      // Prominent Centered Scan Button
      floatingActionButton: Container(
        height: 60,
        width: 60,
        margin: const EdgeInsets.only(top: 18),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              ColorTokens.electricCerulean,
              ColorTokens.ceruleanDark,
            ],
          ),
          border: Border.all(
            color: ColorTokens.cyanLaser.withValues(alpha: 0.9),
            width: 2.2,
          ),
          boxShadow: const [
            BoxShadow(
              color: Color(0x400284C7),
              blurRadius: 14,
              offset: Offset(0, 5),
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(30),
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const ScannerScreen()),
            ),
            child: const Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.document_scanner_rounded, color: Colors.white, size: 24),
                SizedBox(height: 1),
                Text(
                  'SCAN',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 8.5,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 0.6,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          color: ColorTokens.snow,
          border: Border(
            top: BorderSide(color: ColorTokens.coolHairline, width: 1.0),
          ),
        ),
        child: SafeArea(
          child: SizedBox(
            height: 64,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                // Tab 0: Today
                Expanded(
                  child: _NavBarItem(
                    icon: Icons.calendar_today_rounded,
                    label: 'Today',
                    isSelected: _currentIndex == 0,
                    onTap: () => setState(() => _currentIndex = 0),
                  ),
                ),

                // Tab 1: Passport
                Expanded(
                  child: _NavBarItem(
                    icon: Icons.verified_user_outlined,
                    label: 'Passport',
                    isSelected: _currentIndex == 1,
                    onTap: () => setState(() => _currentIndex = 1),
                  ),
                ),

                // Center Spacer reserved for the floating Scan button
                const SizedBox(width: 72),

                // Tab 2: Caregiver
                Expanded(
                  child: _NavBarItem(
                    icon: Icons.favorite_border_rounded,
                    label: 'Caregiver',
                    isSelected: _currentIndex == 2,
                    onTap: () => setState(() => _currentIndex = 2),
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

class _NavBarItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _NavBarItem({
    required this.icon,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppConstants.radiusButton),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 20,
              color: isSelected ? ColorTokens.electricCerulean : ColorTokens.coolSlate,
            ),
            const SizedBox(height: 3),
            Text(
              label,
              style: TextStyle(
                fontSize: 11,
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                color: isSelected ? ColorTokens.electricCerulean : ColorTokens.coolSlate,
                letterSpacing: -0.1,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
