import 'package:flutter/material.dart';
import 'package:my_app/core/constants/app_colors.dart';
import 'package:flutter_svg/flutter_svg.dart';

class WelcomeSection extends StatelessWidget {
  final String title; // e.g. 'Chào mừng quay trở lại'
  final String subtitle; // e.g. 'Tiếp tục học để giữ streak 5 ngày'
  final VoidCallback? onPrimary;
  final String? primaryLabel;
  final VoidCallback? onSecondary;
  final String? secondaryLabel;
  const WelcomeSection({
    super.key,
    required this.title,
    required this.subtitle,
    this.onPrimary,
    this.primaryLabel,
    this.onSecondary,
    this.secondaryLabel,
  });

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: _GradientCard(
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 17,
                        fontWeight: FontWeight.w700,
                        height: 1.1,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      subtitle,
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        height: 1.2,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Wrap(
                      spacing: 12,
                      runSpacing: 8,
                      children: [
                        if (primaryLabel != null)
                          _WhiteFilledButton(
                            label: primaryLabel!,
                            onTap: onPrimary,
                          ),
                        if (secondaryLabel != null)
                          _OutlinedTransButton(
                            label: secondaryLabel!,
                            onTap: onSecondary,
                          ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              const _WelcomeIllustration(),
            ],
          ),
        ),
      ),
    );
  }
}

class _GradientCard extends StatelessWidget {
  final Widget child;
  const _GradientCard({required this.child});
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(22),
        gradient: const LinearGradient(
          colors: AppColors.primaryGradient,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.purple.shade200.withOpacity(.4),
            blurRadius: 18,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: child,
    );
  }
}

class _WhiteFilledButton extends StatelessWidget {
  final String label;
  final VoidCallback? onTap;
  const _WhiteFilledButton({required this.label, this.onTap});
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(40),
        ),
        child: Text(
          label,
          style: const TextStyle(
            color: AppColors.primary,
            fontWeight: FontWeight.w700,
            fontSize: 13,
          ),
        ),
      ),
    );
  }
}

class _OutlinedTransButton extends StatelessWidget {
  final String label;
  final VoidCallback? onTap;
  const _OutlinedTransButton({required this.label, this.onTap});
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 9),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(.18),
          borderRadius: BorderRadius.circular(40),
          border: Border.all(color: Colors.white24, width: 1),
        ),
        child: Text(
          label,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
            fontSize: 13,
          ),
        ),
      ),
    );
  }
}

class _WelcomeIllustration extends StatelessWidget {
  const _WelcomeIllustration();
  static const String _robotUrl = 'https://res.cloudinary.com/dpufemrnq/image/upload/v1758179126/demo/1.svg.svg';
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 90,
      height: 90,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            width: 90,
            height: 90,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white.withOpacity(.12),
            ),
          ),
            Container(
              width: 75,
              height: 75,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white30, width: 2),
              ),
              clipBehavior: Clip.antiAlias,
              child: SvgPicture.network(
                _robotUrl,
                fit: BoxFit.contain,
                placeholderBuilder: (_) => const Center(
                  child: SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white70),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}


