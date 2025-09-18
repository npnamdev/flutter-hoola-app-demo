import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:my_app/app/router.dart';
import 'package:my_app/features/auth/providers/auth_providers.dart';

// Local provider for dark mode toggle (UI only placeholder)
final darkModeProvider = StateProvider<bool>((ref) => false);

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  Future<void> _logout(WidgetRef ref, BuildContext context) async {
    final repo = ref.read(authRepositoryProvider);
    await repo.logout();
    ref.invalidate(authStatusProvider);
    if (context.mounted) context.go(AppRoutes.login);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      body: Stack(
        children: [
          // Gradient header background
          Container(
            height: 260,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF5E4AE3), Color(0xFF3927D6)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
          SafeArea(
            child: CustomScrollView(
              slivers: [
                // Removed SliverAppBar as requested
                const SliverToBoxAdapter(child: SizedBox(height: 20)),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 0, 20, 28),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _ProfileHeader(
                          name: 'Nguyễn Phương Nam',
                          email: 'nam.dev@example.com',
                          avatarUrl: 'https://i.pravatar.cc/300?img=12',
                          badgeLabel: 'Pro Member',
                        ),
                        const SizedBox(height: 22),
                        _StatRow(
                          stats: const [
                            StatData(icon: Iconsax.book, label: 'Khoá học', value: '12'),
                            StatData(icon: Iconsax.play, label: 'Đang học', value: '3'),
                            StatData(icon: Iconsax.medal_star, label: 'Chứng chỉ', value: '5'),
                          ],
                        ),
                        const SizedBox(height: 26),
                        _SectionCard(
                          title: 'Tiến độ học tập',
                          child: _ProgressSection(
                            percent: 0.68,
                            label: 'Hoàn thành 68% mục tiêu tháng',
                          ),
                        ),
                        const SizedBox(height: 18),
                        _SectionCard(
                          title: 'Giới thiệu',
                          child: Text(
                            'Lập trình viên yêu thích Flutter & trải nghiệm người dùng. Đam mê chia sẻ kiến thức và xây dựng sản phẩm hữu ích.',
                            style: GoogleFonts.lato(fontSize: 14, height: 1.45, color: Colors.grey[800]),
                          ),
                        ),
                        const SizedBox(height: 18),
                        _QuickActions(
                          actions: [
                            QuickAction(icon: Iconsax.edit, label: 'Chỉnh sửa'),
                            QuickAction(icon: Iconsax.heart, label: 'Đã lưu'),
                            QuickAction(icon: Iconsax.security_user, label: 'Bảo mật'),
                            QuickAction(icon: Iconsax.award, label: 'Chứng chỉ'),
                          ],
                        ),
                        const SizedBox(height: 28),
                        _SettingsSection(
                          groups: [
                            SettingsGroup(
                              header: 'Tài khoản',
                              items: [
                                SettingItem(icon: Iconsax.user, label: 'Thông tin cá nhân'),
                                SettingItem(icon: Iconsax.password_check, label: 'Đổi mật khẩu'),
                                SettingItem(icon: Iconsax.shield_tick, label: 'Quyền riêng tư'),
                              ],
                            ),
                            SettingsGroup(
                              header: 'Ứng dụng',
                              items: [
                                SettingItem(
                                  icon: Iconsax.monitor_mobbile,
                                  label: 'Chế độ tối',
                                  trailing: Consumer(
                                    builder: (context, ref, _) {
                                      final enabled = ref.watch(darkModeProvider);
                                      return _DarkModeToggle(
                                        value: enabled,
                                        onChanged: (v) => ref.read(darkModeProvider.notifier).state = v,
                                      );
                                    },
                                  ),
                                ),
                                SettingItem(icon: Iconsax.notification, label: 'Thông báo'),
                                SettingItem(icon: Iconsax.language_circle, label: 'Ngôn ngữ: VI'),
                              ],
                            ),
                            SettingsGroup(
                              header: 'Hỗ trợ',
                              items: [
                                SettingItem(icon: Iconsax.message_question, label: 'Trung tâm trợ giúp'),
                                SettingItem(icon: Iconsax.document_text, label: 'Điều khoản & Chính sách'),
                                SettingItem(icon: Iconsax.info_circle, label: 'Giới thiệu ứng dụng'),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 4),
                          child: Material(
                            color: Colors.white,
                            elevation: 4,
                            borderRadius: BorderRadius.circular(22),
                            shadowColor: Colors.black.withOpacity(.08),
                            child: InkWell(
                              borderRadius: BorderRadius.circular(22),
                              onTap: () => _logout(ref, context),
                              child: Container(
                                width: double.infinity,
                                padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        Container(
                                          padding: const EdgeInsets.all(10),
                                          decoration: BoxDecoration(
                                            color: const Color(0xFFFFEBEE),
                                            shape: BoxShape.circle,
                                          ),
                                          child: const Icon(Icons.logout, color: Colors.redAccent, size: 20),
                                        ),
                                        const SizedBox(width: 14),
                                        Text(
                                          'Đăng xuất',
                                          style: GoogleFonts.lato(
                                            color: Colors.redAccent,
                                            fontWeight: FontWeight.w700,
                                            fontSize: 15,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.redAccent),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 40),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// -------------------- New Widgets --------------------

class _ProfileHeader extends StatelessWidget {
  final String name;
  final String email;
  final String avatarUrl;
  final String? badgeLabel;
  const _ProfileHeader({required this.name, required this.email, required this.avatarUrl, this.badgeLabel});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Stack(
          children: [
            Container(
              padding: const EdgeInsets.all(3),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: const LinearGradient(colors: [Color(0xFF7868E6), Color(0xFF3927D6)]),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(.15),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: CircleAvatar(
                radius: 44,
                backgroundImage: NetworkImage(avatarUrl),
              ),
            ),
            Positioned(
              bottom: 4,
              right: 4,
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: Colors.greenAccent.shade400,
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 2),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(width: 18),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      name,
                      style: GoogleFonts.lato(
                        fontSize: 18, // reduced from 20 per request
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Text(email, style: GoogleFonts.lato(color: Colors.white.withOpacity(.9), fontSize: 13)),
              if (badgeLabel != null) ...[
                const SizedBox(height: 10),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(.15),
                    borderRadius: BorderRadius.circular(30),
                    border: Border.all(color: Colors.white24),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Iconsax.crown, size: 14, color: Colors.amber),
                      const SizedBox(width: 6),
                      Text(badgeLabel!, style: GoogleFonts.lato(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w600)),
                    ],
                  ),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }
}

class StatData {
  final IconData icon;
  final String label;
  final String value;
  const StatData({required this.icon, required this.label, required this.value});
}

class _StatRow extends StatelessWidget {
  final List<StatData> stats;
  const _StatRow({required this.stats});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(.06),
            blurRadius: 14,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: stats.map((s) => _SingleStat(data: s)).toList(),
      ),
    );
  }
}

class _SingleStat extends StatelessWidget {
  final StatData data;
  const _SingleStat({required this.data});
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: const Color(0xFFEFF0FF),
            shape: BoxShape.circle,
          ),
          child: Icon(data.icon, size: 20, color: const Color(0xFF3927D6)),
        ),
        const SizedBox(height: 8),
        Text(data.value, style: GoogleFonts.lato(fontWeight: FontWeight.w700, fontSize: 15)),
        Text(data.label, style: GoogleFonts.lato(fontSize: 11, color: Colors.grey[600])),
      ],
    );
  }
}

class _SectionCard extends StatelessWidget {
  final String title;
  final Widget child;
  const _SectionCard({required this.title, required this.child});
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(18, 18, 18, 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(.05),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: GoogleFonts.lato(fontSize: 16, fontWeight: FontWeight.w700)),
          const SizedBox(height: 12),
          child,
        ],
      ),
    );
  }
}

class _ProgressSection extends StatelessWidget {
  final double percent;
  final String label;
  const _ProgressSection({required this.percent, required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(14),
          child: LinearProgressIndicator(
            minHeight: 14,
            value: percent,
            backgroundColor: const Color(0xFFE9ECF2),
            valueColor: const AlwaysStoppedAnimation(Color(0xFF3927D6)),
          ),
        ),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(label, style: GoogleFonts.lato(fontSize: 13, color: Colors.grey[800])),
            ),
            Text('${(percent * 100).round()}%', style: GoogleFonts.lato(fontWeight: FontWeight.w700, fontSize: 13)),
          ],
        ),
      ],
    );
  }
}

class QuickAction {
  final IconData icon;
  final String label;
  const QuickAction({required this.icon, required this.label});
}

class _QuickActions extends StatelessWidget {
  final List<QuickAction> actions;
  const _QuickActions({required this.actions});
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 92,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: actions.length,
        separatorBuilder: (_, __) => const SizedBox(width: 14),
        itemBuilder: (context, index) {
          final a = actions[index];
            return Container(
              width: 92,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(.05),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              padding: const EdgeInsets.all(12),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: const Color(0xFFEFF0FF),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(a.icon, size: 20, color: const Color(0xFF3927D6)),
                  ),
                  const SizedBox(height: 8),
                  Text(a.label, style: GoogleFonts.lato(fontSize: 11, fontWeight: FontWeight.w600), maxLines: 1, overflow: TextOverflow.ellipsis),
                ],
              ),
            );
        },
      ),
    );
  }
}

class SettingItem {
  final IconData icon;
  final String label;
  final Widget? trailing;
  const SettingItem({required this.icon, required this.label, this.trailing});
}

class SettingsGroup {
  final String header;
  final List<SettingItem> items;
  const SettingsGroup({required this.header, required this.items});
}

class _SettingsSection extends StatelessWidget {
  final List<SettingsGroup> groups;
  const _SettingsSection({required this.groups});
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: groups.map((g) => _SettingsGroupWidget(group: g)).toList(),
    );
  }
}

class _SettingsGroupWidget extends StatelessWidget {
  final SettingsGroup group;
  const _SettingsGroupWidget({required this.group});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 26),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 6),
            child: Text(group.header.toUpperCase(), style: GoogleFonts.lato(fontSize: 12, letterSpacing: 1, fontWeight: FontWeight.w700, color: Colors.grey[700])),
          ),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(.05),
                  blurRadius: 12,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: Column(
              children: [
                for (int i = 0; i < group.items.length; i++)
                  _SettingTile(
                    item: group.items[i],
                    showDivider: i != group.items.length - 1,
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SettingTile extends StatelessWidget {
  final SettingItem item;
  final bool showDivider;
  const _SettingTile({required this.item, required this.showDivider});
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: showDivider ? Border(bottom: BorderSide(color: Colors.grey.shade200, width: .9)) : null,
      ),
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: const Color(0xFFEFF0FF),
            shape: BoxShape.circle,
          ),
          child: Icon(item.icon, size: 20, color: const Color(0xFF3927D6)),
        ),
        title: Text(item.label, style: GoogleFonts.lato(fontSize: 14, fontWeight: FontWeight.w600)),
        trailing: item.trailing ?? const Icon(Icons.chevron_right, size: 20, color: Colors.black45),
        onTap: () {},
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      ),
    );
  }
}

class _DarkModeToggle extends StatelessWidget {
  final bool value;
  final ValueChanged<bool> onChanged;
  const _DarkModeToggle({required this.value, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onChanged(!value),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 220),
        curve: Curves.easeOutCubic,
        width: 58,
        height: 30,
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          gradient: value
              ? const LinearGradient(colors: [Color(0xFF5E4AE3), Color(0xFF3927D6)])
              : null,
          color: value ? null : const Color(0xFFE2E5EC),
          boxShadow: value
              ? [
                  BoxShadow(
                    color: const Color(0xFF3927D6).withOpacity(.4),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ]
              : [
                  BoxShadow(
                    color: Colors.black.withOpacity(.08),
                    blurRadius: 6,
                    offset: const Offset(0, 3),
                  ),
                ],
        ),
        child: Stack(
          children: [
            Align(
              alignment: value ? Alignment.centerRight : Alignment.centerLeft,
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 280),
                switchInCurve: Curves.easeOutBack,
                switchOutCurve: Curves.easeIn,
                child: Container(
                  key: ValueKey(value),
                  width: 22,
                  height: 22,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white,
                  ),
                  child: Icon(
                    value ? Icons.dark_mode_rounded : Icons.light_mode_rounded,
                    size: 14,
                    color: value ? const Color(0xFF3927D6) : Colors.grey[700],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
