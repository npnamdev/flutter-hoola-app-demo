// Simplified login screen (no glass, no gradient)
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../app/router.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:my_app/core/constants/app_svg_icons.dart';
import 'package:my_app/core/constants/app_shadows.dart';
import '../../providers/auth_providers.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscure = true;
  bool _googleLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _submit() async {
    if (!_formKey.currentState!.validate()) return;
    final loginState = ref.read(loginControllerProvider.notifier);
    await loginState.login(
      _emailController.text.trim(),
      _passwordController.text,
    );
    final state = ref.read(loginControllerProvider);
    state.when(
      data: (_) {
        // Refresh auth status cache so if user somehow returns to splash same session it sees logged-in
        ref.invalidate(authStatusProvider);
        if (!mounted) return;
        context.go(AppRoutes.homeShell);
      },
      loading: () {},
      error: (e, _) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(e.toString())));
      },
    );
  }

  Future<void> _loginWithGoogle() async {
    if (_googleLoading) return;
    setState(() => _googleLoading = true);
    final controller = ref.read(loginControllerProvider.notifier);
    await controller.loginWithGoogle();
    final state = ref.read(loginControllerProvider);
    state.when(
      data: (_) {
        ref.invalidate(authStatusProvider);
        if (!mounted) return;
        context.go(AppRoutes.homeShell);
      },
      loading: () {},
      error: (e, _) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(e.toString())));
      },
    );
    if (mounted) setState(() => _googleLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    final loginState = ref.watch(loginControllerProvider);
    final isLoading = loginState.isLoading;
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 420),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  width: 120,
                  height: 120,
                  child: SvgPicture.network(
                    'https://res.cloudinary.com/dpufemrnq/image/upload/v1758179126/demo/1.svg.svg',
                    fit: BoxFit.contain,
                    placeholderBuilder: (c) => const Center(
                      child: SizedBox(
                        width: 30,
                        height: 30,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 22),
                Text(
                  'Hoola',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.pacifico(
                    fontSize: 54,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF3927D6),
                    height: 1.0,
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  'Đăng nhập tài khoản của bạn',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.lato(
                    fontSize: 16,
                    color: Colors.grey[600],
                  ),
                ),
                const SizedBox(height: 25),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: AppShadows.card,
                    border: Border.all(color: Colors.grey.shade100),
                  ),
                  padding: const EdgeInsets.fromLTRB(22, 26, 22, 30),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        _ModernField(
                          controller: _emailController,
                          label: 'Email',
                          textInputType: TextInputType.emailAddress,
                          validator: (v) => (v == null || v.isEmpty)
                              ? 'Vui lòng nhập email'
                              : null,
                          prefixSvg: SvgPicture.string(
                            AppSvgIcons.username,
                            width: 20,
                            height: 20,
                            colorFilter: const ColorFilter.mode(
                              Color(0xFF3927D6),
                              BlendMode.srcIn,
                            ),
                          ),
                          verticalPadding: 10,
                        ),
                        const SizedBox(height: 18),
                        _ModernField(
                          controller: _passwordController,
                          label: 'Mật khẩu',
                          isPassword: true,
                          obscure: _obscure,
                          onToggleObscure: () =>
                              setState(() => _obscure = !_obscure),
                          validator: (v) => (v == null || v.isEmpty)
                              ? 'Vui lòng nhập mật khẩu'
                              : null,
                          prefixSvg: SvgPicture.string(
                            AppSvgIcons.lock,
                            width: 20,
                            height: 20,
                            colorFilter: const ColorFilter.mode(
                              Color(0xFF3927D6),
                              BlendMode.srcIn,
                            ),
                          ),
                          suffixWidget: IconButton(
                            splashRadius: 20,
                            icon: SvgPicture.string(
                              _obscure ? AppSvgIcons.eye : AppSvgIcons.eyeoff,
                              width: 20,
                              height: 20,
                              colorFilter: ColorFilter.mode(
                                const Color(0xFF3927D6),
                                BlendMode.srcIn,
                              ),
                            ),
                            onPressed: () =>
                                setState(() => _obscure = !_obscure),
                          ),
                          verticalPadding: 10,
                        ),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            const Spacer(),
                            TextButton(
                              onPressed: isLoading ? null : () {},
                              child: const Text('Quên mật khẩu?'),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        _PrimaryGradientButton(
                          onPressed: (isLoading || _googleLoading)
                              ? null
                              : _submit,
                          loading: isLoading,
                          label: 'Đăng nhập',
                        ),
                        const SizedBox(height: 20),
                        Row(
                          children: [
                            Expanded(
                              child: Container(
                                height: 1,
                                color: Colors.grey.shade300,
                              ),
                            ),
                            const Padding(
                              padding: EdgeInsets.symmetric(horizontal: 12),
                              child: Text(
                                'Hoặc',
                                style: TextStyle(
                                  fontSize: 12,
                                  letterSpacing: .5,
                                ),
                              ),
                            ),
                            Expanded(
                              child: Container(
                                height: 1,
                                color: Colors.grey.shade300,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 18),
                        _GoogleOutlinedButton(
                          onPressed: (isLoading || _googleLoading)
                              ? null
                              : _loginWithGoogle,
                          loading: _googleLoading,
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 42),
                Text(
                  'Bằng việc tiếp tục bạn đồng ý với Điều khoản & Chính sách',
                  style: TextStyle(color: Colors.black54, fontSize: 14),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ModernField extends StatefulWidget {
  final TextEditingController controller;
  final String label;
  final bool isPassword;
  final bool? obscure;
  final VoidCallback? onToggleObscure;
  final String? Function(String?)? validator;
  final TextInputType? textInputType;
  final Widget? prefixSvg;
  final Widget? suffixWidget;
  final double verticalPadding;

  const _ModernField({
    required this.controller,
    required this.label,
    this.isPassword = false,
    this.obscure,
    this.onToggleObscure,
    this.validator,
    this.textInputType,
    this.prefixSvg,
    this.suffixWidget,
    this.verticalPadding = 16,
  });

  @override
  State<_ModernField> createState() => _ModernFieldState();
}

class _ModernFieldState extends State<_ModernField> {
  late FocusNode _focusNode;
  bool _hovering = false;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
    _focusNode.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final focused = _focusNode.hasFocus;
    return AnimatedContainer(
      duration: const Duration(milliseconds: 180),
      curve: Curves.easeOut,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        color: focused
            ? const Color(0xFF3927D6).withOpacity(.06)
            : const Color(0xFFF5F7FA),
        boxShadow: focused
            ? AppShadows.subtle
            : (_hovering ? AppShadows.subtle : const []),
        border: Border.all(
          color: focused ? const Color(0xFF3927D6) : Colors.transparent,
          width: 1.1,
        ),
      ),
      child: MouseRegion(
        onEnter: (_) => setState(() => _hovering = true),
        onExit: (_) => setState(() => _hovering = false),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4),
          child: Row(
            children: [
              if (widget.prefixSvg != null)
                Padding(
                  padding: const EdgeInsets.only(left: 12, right: 10),
                  child: SizedBox(
                    width: 20,
                    height: 20,
                    child: Center(child: widget.prefixSvg!),
                  ),
                ),
              Expanded(
                child: TextFormField(
                  focusNode: _focusNode,
                  controller: widget.controller,
                  keyboardType: widget.textInputType,
                  obscureText: widget.isPassword
                      ? (widget.obscure ?? true)
                      : false,
                  validator: widget.validator,
                  decoration: InputDecoration(
                    labelText: widget.label,
                    labelStyle: TextStyle(
                      fontSize: 14,
                      color: focused
                          ? const Color(0xFF3927D6)
                          : Colors.grey[600],
                    ),
                    floatingLabelStyle: const TextStyle(
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF3927D6),
                    ),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 4,
                      vertical: widget.verticalPadding,
                    ),
                  ),
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              if (widget.suffixWidget != null)
                Padding(
                  padding: const EdgeInsets.only(right: 6),
                  child: widget.suffixWidget!,
                )
              else if (widget.isPassword)
                Padding(
                  padding: const EdgeInsets.only(right: 6),
                  child: IconButton(
                    splashRadius: 20,
                    icon: Icon(
                      (widget.obscure ?? true)
                          ? Icons.visibility
                          : Icons.visibility_off,
                      size: 20,
                      color: focused
                          ? const Color(0xFF3927D6)
                          : Colors.grey[600],
                    ),
                    onPressed: widget.onToggleObscure,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _PrimaryGradientButton extends StatefulWidget {
  final VoidCallback? onPressed;
  final bool loading;
  final String label;
  const _PrimaryGradientButton({
    required this.onPressed,
    required this.loading,
    required this.label,
  });

  @override
  State<_PrimaryGradientButton> createState() => _PrimaryGradientButtonState();
}

class _PrimaryGradientButtonState extends State<_PrimaryGradientButton> {
  bool _hover = false;
  bool _pressed = false;
  @override
  Widget build(BuildContext context) {
    final disabled = widget.onPressed == null;
    final gradient = LinearGradient(
      colors: disabled
          ? [const Color(0xFFB9BEEA), const Color(0xFFA6ACDF)]
          : [const Color(0xFF3927D6), const Color(0xFF5E4FF3)],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    );
    return AnimatedScale(
      scale: _pressed ? 0.97 : 1,
      duration: const Duration(milliseconds: 120),
      curve: Curves.easeOut,
      child: MouseRegion(
        onEnter: (_) => setState(() => _hover = true),
        onExit: (_) => setState(() => _hover = false),
        child: GestureDetector(
          onTapDown: disabled ? null : (_) => setState(() => _pressed = true),
          onTapCancel: () => setState(() => _pressed = false),
          onTapUp: (_) => setState(() => _pressed = false),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 220),
            curve: Curves.easeOut,
            width: double.infinity,
            decoration: BoxDecoration(
              gradient: gradient,
              borderRadius: BorderRadius.circular(16),
              boxShadow: disabled
                  ? []
                  : (_hover
                        ? [
                            const BoxShadow(
                              color: Color(0x26000000),
                              blurRadius: 18,
                              offset: Offset(0, 6),
                            ),
                          ]
                        : const [
                            BoxShadow(
                              color: Color(0x1F000000),
                              blurRadius: 14,
                              offset: Offset(0, 6),
                            ),
                          ]),
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: disabled ? null : widget.onPressed,
                borderRadius: BorderRadius.circular(16),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  child: Center(
                    child: widget.loading
                        ? const SizedBox(
                            width: 22,
                            height: 22,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : Text(
                            widget.label,
                            style: const TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 16,
                              letterSpacing: .3,
                              color: Colors.white,
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
}

class _GoogleOutlinedButton extends StatefulWidget {
  final VoidCallback? onPressed;
  final bool loading;
  const _GoogleOutlinedButton({required this.onPressed, required this.loading});

  @override
  State<_GoogleOutlinedButton> createState() => _GoogleOutlinedButtonState();
}

class _GoogleOutlinedButtonState extends State<_GoogleOutlinedButton> {
  bool _hover = false;
  bool _pressed = false;
  @override
  Widget build(BuildContext context) {
    final disabled = widget.onPressed == null;
    return AnimatedScale(
      scale: _pressed ? 0.975 : 1,
      duration: const Duration(milliseconds: 120),
      curve: Curves.easeOut,
      child: MouseRegion(
        onEnter: (_) => setState(() => _hover = true),
        onExit: (_) => setState(() => _hover = false),
        child: GestureDetector(
          onTapDown: disabled ? null : (_) => setState(() => _pressed = true),
          onTapCancel: () => setState(() => _pressed = false),
          onTapUp: (_) => setState(() => _pressed = false),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeOut,
            width: double.infinity,
            decoration: BoxDecoration(
              color: disabled ? const Color(0xFFF3F4F7) : Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: disabled
                    ? const Color(0xFFE0E3E9)
                    : (_hover
                          ? const Color(0xFF8E95A3)
                          : const Color(0xFFD5DAE1)),
              ),
              boxShadow: disabled
                  ? []
                  : (_hover
                        ? [
                            const BoxShadow(
                              color: Color(0x14000000),
                              blurRadius: 12,
                              offset: Offset(0, 4),
                            ),
                          ]
                        : AppShadows.subtle),
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(16),
                onTap: disabled ? null : widget.onPressed,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 15,
                    horizontal: 14,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (widget.loading)
                        const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      else ...[
                        SvgPicture.string(
                          AppSvgIcons.google,
                          width: 20,
                          height: 20,
                        ),
                        const SizedBox(width: 10),
                      ],
                      Flexible(
                        child: Text(
                          widget.loading
                              ? 'Đang xử lý...'
                              : 'Đăng nhập với Google',
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 14.5,
                            letterSpacing: .2,
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
      ),
    );
  }
}
