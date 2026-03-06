import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_theme.dart';
import '../../core/services/auth_service.dart';
import '../../core/di/locator.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> with TickerProviderStateMixin {
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  
  bool _isLoading = false;
  bool _isPasswordVisible = false;
  bool _isSignUp = false;
  final _nameController = TextEditingController();
  
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
    );
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.2),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOut,
    ));
    _animationController.forward();
  }

  @override
  void dispose() {
    _phoneController.dispose();
    _passwordController.dispose();
    _nameController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _authenticate() async {
    if (!_formKey.currentState!.validate()) return;
    
    final phone = _phoneController.text.trim();
    final password = _passwordController.text.trim();
    final fullPhone = '+91$phone';
    
    setState(() => _isLoading = true);
    
    try {
      if (_isSignUp) {
        final name = _nameController.text.trim();
        await locator<AuthService>().signUpWithMobilePassword(
          fullPhone, 
          password, 
          name,
        );
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Row(
                children: [
                  Icon(Icons.check_circle, color: Colors.white),
                  SizedBox(width: 8),
                  Text('Account created successfully!'),
                ],
              ),
              backgroundColor: AppColors.success,
            ),
          );
        }
      } else {
        await locator<AuthService>().signInWithMobilePassword(
          fullPhone, 
          password,
        );
      }
      
      if (mounted) {
        context.go('/home');
      }
    } catch (e) {
      if (mounted) {
        String errorMessage = 'Authentication failed. Please try again.';
        if (e.toString().contains('Invalid login credentials')) {
          errorMessage = 'Invalid mobile number or password.';
        } else if (e.toString().contains('User already registered')) {
          errorMessage = 'Mobile number already registered. Please sign in.';
        }
        
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                Icon(Icons.error_outline, color: Colors.white),
                SizedBox(width: 8),
                Expanded(child: Text(errorMessage)),
              ],
            ),
            backgroundColor: AppColors.error,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  String? _validatePhone(String? value) {
    if (value == null || value.isEmpty) {
      return 'Mobile number is required';
    }
    if (value.length != 10 || !RegExp(r'^[6-9]\d{9}$').hasMatch(value)) {
      return 'Enter a valid 10-digit mobile number';
    }
    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }
    if (value.length < 6) {
      return 'Password must be at least 6 characters';
    }
    return null;
  }

  String? _validateName(String? value) {
    if (_isSignUp && (value == null || value.trim().isEmpty)) {
      return 'Full name is required';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: AnimatedBuilder(
          animation: _fadeAnimation,
          builder: (context, child) {
            return Opacity(
              opacity: _fadeAnimation.value,
              child: SlideTransition(
                position: _slideAnimation,
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const SizedBox(height: 40),

                        // ── NEARA Brand Header ────────────────────────────
                        Center(
                          child: Column(
                            children: [
                              Container(
                                width: 80,
                                height: 80,
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [AppColors.primary, AppColors.primaryLight],
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                  ),
                                  borderRadius: BorderRadius.circular(20),
                                  boxShadow: [
                                    BoxShadow(
                                      color: AppColors.primary.withOpacity(0.3),
                                      blurRadius: 20,
                                      offset: const Offset(0, 8),
                                    ),
                                  ],
                                ),
                                child: const Icon(
                                  Icons.location_on_rounded,
                                  color: Colors.white,
                                  size: 36,
                                ),
                              ),
                              const SizedBox(height: 16),
                              Text(
                                'NEARA',
                                style: AppTextStyles.brandTitle,
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Hyperlocal Service Discovery',
                                style: AppTextStyles.labelLarge.copyWith(
                                  color: AppColors.textTertiary,
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 48),

                        // ── Welcome Message ───────────────────────────────
                        Text(
                          _isSignUp ? 'Create Account 🚀' : 'Welcome Back 👋',
                          style: AppTextStyles.displaySmall,
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          _isSignUp 
                            ? 'Join thousands of users who trust NEARA for their service needs' 
                            : 'Sign in to connect with trusted workers near you',
                          style: AppTextStyles.bodyMedium.copyWith(
                            color: AppColors.textSecondary,
                          ),
                          textAlign: TextAlign.center,
                        ),

                        const SizedBox(height: 40),

                        // ── Full Name Field (Sign Up Only) ──────────────
                        if (_isSignUp) ...[
                          Text(
                            'Full Name',
                            style: AppTextStyles.labelLarge,
                          ),
                          const SizedBox(height: 8),
                          TextFormField(
                            controller: _nameController,
                            decoration: InputDecoration(
                              hintText: 'Enter your full name',
                              prefixIcon: const Icon(Icons.person_outline),
                            ),
                            validator: _validateName,
                            textInputAction: TextInputAction.next,
                            textCapitalization: TextCapitalization.words,
                          ),
                          const SizedBox(height: 24),
                        ],

                        // ── Mobile Number Field ───────────────────────────
                        Text(
                          'Mobile Number',
                          style: AppTextStyles.labelLarge,
                        ),
                        const SizedBox(height: 8),
                        TextFormField(
                          controller: _phoneController,
                          decoration: InputDecoration(
                            hintText: 'Enter 10-digit mobile number',
                            prefixIcon: Container(
                              margin: const EdgeInsets.only(left: 12, right: 8),
                              padding: const EdgeInsets.symmetric(horizontal: 8),
                              decoration: BoxDecoration(
                                color: AppColors.gray100,
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Text('🇮🇳', style: TextStyle(fontSize: 16)),
                                  const SizedBox(width: 4),
                                  Text(
                                    '+91',
                                    style: AppTextStyles.labelMedium.copyWith(
                                      fontWeight: FontWeight.w600,
                                      color: AppColors.textSecondary,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          keyboardType: TextInputType.phone,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                            LengthLimitingTextInputFormatter(10),
                          ],
                          validator: _validatePhone,
                          textInputAction: TextInputAction.next,
                        ),

                        const SizedBox(height: 24),

                        // ── Password Field ─────────────────────────────────
                        Text(
                          'Password',
                          style: AppTextStyles.labelLarge,
                        ),
                        const SizedBox(height: 8),
                        TextFormField(
                          controller: _passwordController,
                          decoration: InputDecoration(
                            hintText: _isSignUp ? 'Create a strong password (min. 6 chars)' : 'Enter your password',
                            prefixIcon: const Icon(Icons.lock_outline),
                            suffixIcon: IconButton(
                              icon: Icon(
                                _isPasswordVisible 
                                  ? Icons.visibility_off_outlined 
                                  : Icons.visibility_outlined,
                              ),
                              onPressed: () {
                                setState(() {
                                  _isPasswordVisible = !_isPasswordVisible;
                                });
                              },
                            ),
                          ),
                          obscureText: !_isPasswordVisible,
                          validator: _validatePassword,
                          textInputAction: TextInputAction.done,
                          onFieldSubmitted: (_) => _authenticate(),
                        ),

                        const SizedBox(height: 32),

                        // ── Sign In/Up Button ──────────────────────────────
                        ElevatedButton(
                          onPressed: _isLoading ? null : _authenticate,
                          child: _isLoading
                            ? SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation(Colors.white),
                                ),
                              )
                            : Text(_isSignUp ? 'Create Account' : 'Sign In'),
                        ),

                        const SizedBox(height: 16),

                        // ── Forgot Password ────────────────────────────────
                        if (!_isSignUp)
                          Center(
                            child: TextButton(
                              onPressed: _isLoading ? null : () {
                                // TODO: Implement forgot password
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Forgot password feature coming soon'),
                                  ),
                                );
                              },
                              child: Text(
                                'Forgot Password?',
                                style: AppTextStyles.buttonMedium,
                              ),
                            ),
                          ),

                        const SizedBox(height: 32),

                        // ── Divider ────────────────────────────────────────
                        Row(
                          children: [
                            const Expanded(child: Divider()),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 16),
                              child: Text(
                                'or',
                                style: AppTextStyles.labelMedium.copyWith(
                                  color: AppColors.textTertiary,
                                ),
                              ),
                            ),
                            const Expanded(child: Divider()),
                          ],
                        ),

                        const SizedBox(height: 32),

                        // ── Toggle Auth Mode ───────────────────────────────
                        OutlinedButton(
                          onPressed: _isLoading ? null : () {
                            setState(() {
                              _isSignUp = !_isSignUp;
                              // Clear form when switching modes
                              _nameController.clear();
                              _phoneController.clear();
                              _passwordController.clear();
                            });
                          },
                          child: Text(
                            _isSignUp 
                              ? 'Already have an account? Sign In' 
                              : 'New to NEARA? Create Account',
                          ),
                        ),

                        const SizedBox(height: 40),

                        // ── Trust Indicators ───────────────────────────────
                        if (_isSignUp)
                          Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: AppColors.backgroundSecondary,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: AppColors.borderDefault),
                            ),
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    Icon(
                                      Icons.verified_user,
                                      color: AppColors.success,
                                      size: 20,
                                    ),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: Text(
                                        'Your data is secure and encrypted',
                                        style: AppTextStyles.bodySmall,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 12),
                                Row(
                                  children: [
                                    Icon(
                                      Icons.support_agent,
                                      color: AppColors.info,
                                      size: 20,
                                    ),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: Text(
                                        '24/7 emergency support available',
                                        style: AppTextStyles.bodySmall,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),

                        const SizedBox(height: 32),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
                    ),
                    // Number input
                    Expanded(
                      child: TextField(
                        controller: _phoneController,
                        keyboardType: TextInputType.phone,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                          LengthLimitingTextInputFormatter(10),
                        ],
                        textInputAction: TextInputAction.done,
                        onSubmitted: (_) => _sendOtp(),
                        style: AppTextStyles.bodyMedium
                            .copyWith(color: AppColors.brightIvory),
                        decoration: const InputDecoration(
                          hintText: '98765 43210',
                          border: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(
                              horizontal: 14, vertical: 16),
                        ),
                      ),
                    ),
                  ],
                ),
              ).animate().fadeIn(delay: 260.ms),
              const SizedBox(height: 28),

              // CTA
              ElevatedButton(
                onPressed: _isLoading ? null : _sendOtp,
                child: _isLoading
                    ? const SizedBox(
                        height: 20, width: 20,
                        child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: AppColors.midnightNavy),
                      )
                    : const Text('Get OTP →'),
              ).animate().fadeIn(delay: 320.ms),
              const SizedBox(height: 20),

              Center(
                child: Text(
                  'By continuing, you agree to our Terms & Privacy Policy.',
                  style: AppTextStyles.micro,
                  textAlign: TextAlign.center,
                ),
              ).animate().fadeIn(delay: 380.ms),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}
