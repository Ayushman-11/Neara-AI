import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:worker_app/core/theme/app_colors.dart';
import 'package:worker_app/core/theme/app_theme.dart';
import 'package:worker_app/core/services/auth_service.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> with TickerProviderStateMixin {
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _nameController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  
  bool _isLoading = false;
  bool _isPasswordVisible = false;
  bool _isSignUp = false;
  String _selectedCategory = 'plumber';
  
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  final List<Map<String, dynamic>> _serviceCategories = [
    {'id': 'plumber', 'name': 'Plumber', 'icon': Icons.plumbing},
    {'id': 'electrician', 'name': 'Electrician', 'icon': Icons.electrical_services},
    {'id': 'mechanic', 'name': 'Mechanic', 'icon': Icons.build},
    {'id': 'cleaner', 'name': 'House Cleaner', 'icon': Icons.cleaning_services},
    {'id': 'carpenter', 'name': 'Carpenter', 'icon': Icons.carpenter},
    {'id': 'painter', 'name': 'Painter', 'icon': Icons.format_paint},
  ];

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
      final authService = AuthService();
      
      if (_isSignUp) {
        final name = _nameController.text.trim();
        await authService.signUpWithMobilePassword(
          fullPhone, 
          password, 
          name,
          _selectedCategory,
        );
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Row(
                children: [
                  Icon(Icons.check_circle, color: Colors.white),
                  SizedBox(width: 8),
                  Text('Worker account created successfully!'),
                ],
              ),
              backgroundColor: AppColors.success,
            ),
          );
          // Navigate to dashboard or onboarding
        }
      } else {
        await authService.signInWithMobilePassword(fullPhone, password);
        if (mounted) {
          // Navigate to worker dashboard
        }
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
                        const SizedBox(height: 32),

                        // ── NEARA Worker Brand Header ─────────────────────
                        Center(
                          child: Column(
                            children: [
                              Container(
                                width: 80,
                                height: 80,
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [AppColors.primary, AppColors.earnings],
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
                                  Icons.work,
                                  color: Colors.white,
                                  size: 36,
                                ),
                              ),
                              const SizedBox(height: 16),
                              Text(
                                'NEARA PARTNER',
                                style: TextStyle(
                                  fontSize: 28,
                                  fontWeight: FontWeight.w800,
                                  color: AppColors.primary,
                                  letterSpacing: 1.0,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Grow Your Service Business',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  color: AppColors.textTertiary,
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 40),

                        // ── Welcome Message ───────────────────────────────
                        Text(
                          _isSignUp ? 'Join as Partner 🤝' : 'Partner Login 👋',
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textPrimary,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          _isSignUp 
                            ? 'Start earning with NEARA\'s 3-5% commission model' 
                            : 'Welcome back! Sign in to manage your bookings',
                          style: TextStyle(
                            fontSize: 14,
                            color: AppColors.textSecondary,
                          ),
                          textAlign: TextAlign.center,
                        ),

                        const SizedBox(height: 32),

                        // ── Full Name Field (Sign Up Only) ──────────────
                        if (_isSignUp) ...[
                          Text(
                            'Full Name',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: AppColors.textSecondary,
                            ),
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
                          const SizedBox(height: 20),
                        ],

                        // ── Service Category (Sign Up Only) ──────────────
                        if (_isSignUp) ...[
                          Text(
                            'Service Category',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: AppColors.textSecondary,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            decoration: BoxDecoration(
                              color: AppColors.background,
                              border: Border.all(color: AppColors.borderDefault),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton<String>(
                                value: _selectedCategory,
                                isExpanded: true,
                                icon: const Icon(Icons.keyboard_arrow_down),
                                items: _serviceCategories.map((category) {
                                  return DropdownMenuItem<String>(
                                    value: category['id'],
                                    child: Row(
                                      children: [
                                        Icon(
                                          category['icon'],
                                          size: 20,
                                          color: AppColors.textSecondary,
                                        ),
                                        const SizedBox(width: 12),
                                        Text(category['name']),
                                      ],
                                    ),
                                  );
                                }).toList(),
                                onChanged: (value) {
                                  if (value != null) {
                                    setState(() => _selectedCategory = value);
                                  }
                                },
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                        ],

                        // ── Mobile Number Field ───────────────────────────
                        Text(
                          'Mobile Number',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: AppColors.textSecondary,
                          ),
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
                                    style: TextStyle(
                                      fontSize: 12,
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

                        const SizedBox(height: 20),

                        // ── Password Field ─────────────────────────────────
                        Text(
                          'Password',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: AppColors.textSecondary,
                          ),
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
                            : Text(_isSignUp ? 'Join as Partner' : 'Sign In'),
                        ),

                        const SizedBox(height: 24),

                        // ── Partner Benefits (Sign Up) ────────────────────
                        if (_isSignUp)
                          Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: AppColors.backgroundSecondary,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: AppColors.borderDefault),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '✨ Partner Benefits',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.textPrimary,
                                  ),
                                ),
                                const SizedBox(height: 12),
                                _benefitRow('Low 3-5% commission', Icons.trending_down, AppColors.earnings),
                                _benefitRow('Flexible schedule', Icons.schedule, AppColors.info),
                                _benefitRow('Secure payments', Icons.security, AppColors.primary),
                                _benefitRow('24/7 support', Icons.support_agent, AppColors.warning),
                              ],
                            ),
                          ),

                        const SizedBox(height: 24),

                        // ── Toggle Auth Mode ───────────────────────────────
                        OutlinedButton(
                          onPressed: _isLoading ? null : () {
                            setState(() {
                              _isSignUp = !_isSignUp;
                              _nameController.clear();
                              _phoneController.clear();
                              _passwordController.clear();
                            });
                          },
                          child: Text(
                            _isSignUp 
                              ? 'Already a partner? Sign In' 
                              : 'New partner? Join NEARA',
                          ),
                        ),

                        const SizedBox(height: 24),
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

  Widget _benefitRow(String text, IconData icon, Color color) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Icon(icon, color: color, size: 18),
          const SizedBox(width: 8),
          Text(
            text,
            style: TextStyle(
              fontSize: 13,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}
              ),
              const SizedBox(height: 8),
              Text(
                'Empowering Hyperlocal Service Providers',
                style: AppTextStyles.bodyLarge,
              ),
              const SizedBox(height: 60),
              Text('Login with Phone', style: AppTextStyles.titleLarge),
              const SizedBox(height: 8),
              Text(
                'We will send a 6-digit OTP to verify your number',
                style: AppTextStyles.bodyMedium,
              ),
              const SizedBox(height: 32),
              TextField(
                controller: _phoneController,
                keyboardType: TextInputType.phone,
                style: AppTextStyles.monoMedium,
                decoration: const InputDecoration(
                  hintText: 'Enter Phone Number',
                  prefixIcon: Icon(
                    Icons.phone_iphone,
                    color: AppColors.mutedFog,
                  ),
                  prefixText: '+91 ',
                ),
              ),
              const Spacer(),
              ElevatedButton(
                onPressed: _isValidPhone && !_isLoading
                    ? () async {
                        setState(() {
                          _isLoading = true;
                        });

                        final fullPhone = '+91${_phoneController.text}';
                        final success = await ref
                            .read(authProvider.notifier)
                            .sendOtp(fullPhone);

                        setState(() {
                          _isLoading = false;
                        });

                        if (success) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  OtpScreen(phoneNumber: fullPhone),
                            ),
                          );
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content:
                                  Text('Failed to send OTP. Please try again.'),
                            ),
                          );
                        }
                      }
                    : null,
                child: _isLoading
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Text('Send OTP'),
              ),
              const SizedBox(height: 24),
              Center(
                child: Text(
                  'By continuing, you agree to Neara\'s Terms of Service',
                  style: AppTextStyles.bodySmall,
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
