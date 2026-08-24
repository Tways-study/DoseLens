import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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
      loading: () => const Scaffold(
        backgroundColor: ColorTokens.canvas,
        body: Center(
          child: CircularProgressIndicator(
            color: ColorTokens.electricBlue,
            strokeWidth: 2.5,
          ),
        ),
      ),
      error: (_, __) => const LoginScreen(),
      data: (user) {
        if (user == null) return const LoginScreen();
        return const MainShell();
      },
    );
  }
}

/// Refero-styled Bottom Navigation Shell with 3 tabs + Central Scanner Action
class MainShell extends ConsumerStatefulWidget {
  const MainShell({super.key});

  @override
  ConsumerState<MainShell> createState() => _MainShellState();
}

class _MainShellState extends ConsumerState<MainShell> {
  int _currentIndex = 0;

  static const _screens = [
    HomeScreen(),
    PassportScreen(),
    CaregiverDashboardScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorTokens.canvas,
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      floatingActionButton: Container(
        height: 56,
        width: 56,
        margin: const EdgeInsets.only(top: 24),
        child: FloatingActionButton(
          heroTag: 'scanner_fab',
          backgroundColor: ColorTokens.electricBlue,
          elevation: 0,
          shape: const CircleBorder(),
          onPressed: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const ScannerScreen()),
          ),
          child: const Icon(Icons.document_scanner_rounded, color: Colors.white, size: 24),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: _BottomNav(
        currentIndex: _currentIndex,
        onTap: (i) => setState(() => _currentIndex = i),
      ),
    );
  }
}

class _BottomNav extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const _BottomNav({required this.currentIndex, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: ColorTokens.paper,
        border: Border(top: BorderSide(color: ColorTokens.hairline, width: 0.5)),
      ),
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: 60,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _NavItem(
                icon: Icons.home_outlined,
                activeIcon: Icons.home_rounded,
                label: 'Home',
                isActive: currentIndex == 0,
                onTap: () => onTap(0),
              ),
              // Gap for Floating Scanner Button
              const SizedBox(width: 56),
              _NavItem(
                icon: Icons.description_outlined,
                activeIcon: Icons.description_rounded,
                label: 'Passport',
                isActive: currentIndex == 1,
                onTap: () => onTap(1),
              ),
              _NavItem(
                icon: Icons.favorite_outline_rounded,
                activeIcon: Icons.favorite_rounded,
                label: 'Caregiver',
                isActive: currentIndex == 2,
                onTap: () => onTap(2),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final IconData icon;
  final IconData activeIcon;
  final String label;
  final bool isActive;
  final VoidCallback onTap;

  const _NavItem({
    required this.icon,
    required this.activeIcon,
    required this.label,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              isActive ? activeIcon : icon,
              color: isActive ? ColorTokens.electricBlue : ColorTokens.midGray,
              size: 22,
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: TextStyle(
                fontSize: 11,
                fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
                color: isActive ? ColorTokens.electricBlue : ColorTokens.midGray,
                letterSpacing: -0.1,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
