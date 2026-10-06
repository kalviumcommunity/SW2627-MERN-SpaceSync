import 'package:flutter/material.dart';

import '../theme/app_theme.dart';
import '../widgets/app_header.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({
    super.key,
    this.themeMode = ThemeMode.system,
    this.onThemeModeChanged,
  });

  final ThemeMode themeMode;
  final ValueChanged<ThemeMode>? onThemeModeChanged;

  static const _groups = <_ProfileSettingGroup>[
    _ProfileSettingGroup('Account', [
      _ProfileSetting(
        Icons.person_outline_rounded,
        'Personal Information',
        'Manage your profile details',
      ),
      _ProfileSetting(
        Icons.notifications_none_rounded,
        'Notifications',
        'Manage booking and workspace alerts',
      ),
      _ProfileSetting(
        Icons.lock_outline_rounded,
        'Security',
        'Password and account security',
      ),
    ]),
    _ProfileSettingGroup('Workspace', [
      _ProfileSetting(
        Icons.apartment_rounded,
        'Locations',
        'Manage coworking locations',
      ),
      _ProfileSetting(
        Icons.tune_rounded,
        'Booking Preferences',
        'Manage booking settings',
      ),
      _ProfileSetting(
        Icons.schedule_rounded,
        'Operating Hours',
        'Configure workspace hours',
      ),
    ]),
    _ProfileSettingGroup('App', [
      _ProfileSetting(
        Icons.palette_outlined,
        'Appearance',
        'Theme and display preferences',
      ),
      _ProfileSetting(
        Icons.help_outline_rounded,
        'Help & Support',
        'Get help with CoWorkHub',
      ),
      _ProfileSetting(
        Icons.info_outline_rounded,
        'About CoWorkHub',
        'Version information',
      ),
    ]),
  ];

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final contentWidth = constraints.maxWidth.isFinite
            ? (constraints.maxWidth - 36).clamp(0.0, 400.0).toDouble()
            : 360.0;
        return SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(18, 14, 18, 26),
          child: Center(
            child: SizedBox(
              width: contentWidth,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppHeader(
                    onNotificationsTap: () => _showMessage(
                      context,
                      'You have 2 unread notifications.',
                    ),
                    onAvatarTap: () => _showMessage(context, 'Admin profile'),
                  ),
                  const SizedBox(height: 21),
                  Text(
                    'Profile',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Manage your account and preferences',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 18),
                  const _ProfileHero(),
                  const SizedBox(height: 22),
                  for (final group in _groups) ...[
                    Text(
                      group.title,
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 10),
                    _SettingsGroup(
                      group: group,
                      themeMode: themeMode,
                      onSettingTap: (setting) => setting.title == 'Appearance'
                          ? _showAppearance(context)
                          : _showSetting(context, setting),
                    ),
                    const SizedBox(height: 20),
                  ],
                  _LogoutButton(onTap: () => _confirmLogout(context)),
                  const SizedBox(height: 20),
                  const _ProfileFooter(),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _showMessage(BuildContext context, String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }

  void _showSetting(BuildContext context, _ProfileSetting setting) {
    final colors = AppColors.of(context);
    showModalBottomSheet<void>(
      context: context,
      useSafeArea: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        padding: const EdgeInsets.fromLTRB(22, 10, 22, 24),
        decoration: BoxDecoration(
          color: colors.surface,
          borderRadius: BorderRadius.vertical(top: Radius.circular(26)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 38,
                height: 4,
                decoration: BoxDecoration(
                  color: colors.outline,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Text(setting.title, style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 7),
            Text(
              '${setting.subtitle}. This setting can be configured here when account preferences are connected.',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 18),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Close'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showAppearance(BuildContext context) {
    final options = <(ThemeMode, String, String, IconData)>[
      (
        ThemeMode.light,
        'Light',
        'A bright, clear workspace',
        Icons.light_mode_rounded,
      ),
      (
        ThemeMode.dark,
        'Dark',
        'A softer view for low light',
        Icons.dark_mode_rounded,
      ),
      (
        ThemeMode.system,
        'System default',
        'Follow your device setting',
        Icons.settings_suggest_rounded,
      ),
    ];
    showModalBottomSheet<void>(
      context: context,
      useSafeArea: true,
      backgroundColor: Colors.transparent,
      builder: (sheetContext) {
        final colors = AppColors.of(sheetContext);
        return Container(
          padding: const EdgeInsets.fromLTRB(20, 10, 20, 24),
          decoration: BoxDecoration(
            color: colors.surface,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(26)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 38,
                  height: 4,
                  decoration: BoxDecoration(
                    color: colors.outline,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
              const SizedBox(height: 18),
              Text(
                'Appearance',
                style: Theme.of(sheetContext).textTheme.titleLarge,
              ),
              const SizedBox(height: 10),
              for (final option in options)
                _AppearanceOption(
                  title: option.$2,
                  subtitle: option.$3,
                  icon: option.$4,
                  selected: themeMode == option.$1,
                  onTap: () {
                    onThemeModeChanged?.call(option.$1);
                    Navigator.of(sheetContext).pop();
                  },
                ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _confirmLogout(BuildContext context) async {
    final shouldLogout = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Log out?'),
        content: const Text(
          'You will remain signed in until authentication is connected.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Log Out'),
          ),
        ],
      ),
    );
    if (shouldLogout == true && context.mounted) {
      _showMessage(context, 'Authentication is not connected yet.');
    }
  }
}

class _ProfileHero extends StatelessWidget {
  const _ProfileHero();

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(17),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(19),
        border: Border.all(color: colors.outline),
        boxShadow: [
          BoxShadow(
            color: colors.shadow,
            blurRadius: 14,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 29,
            backgroundColor: colors.primarySoft,
            child: Text(
              'A',
              style: TextStyle(
                color: Theme.of(context).colorScheme.primary,
                fontSize: 21,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          const SizedBox(width: 13),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Admin', style: Theme.of(context).textTheme.titleLarge),
                const SizedBox(height: 3),
                Text(
                  'Workspace Administrator',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    Icon(
                      Icons.workspaces_rounded,
                      size: 13,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    const SizedBox(width: 5),
                    Text(
                      'CoWorkHub',
                      style: Theme.of(context).textTheme.labelMedium?.copyWith(
                        color: Theme.of(context).colorScheme.primary,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ProfileSettingGroup {
  const _ProfileSettingGroup(this.title, this.settings);

  final String title;
  final List<_ProfileSetting> settings;
}

class _ProfileSetting {
  const _ProfileSetting(this.icon, this.title, this.subtitle);

  final IconData icon;
  final String title;
  final String subtitle;
}

class _SettingsGroup extends StatelessWidget {
  const _SettingsGroup({
    required this.group,
    required this.themeMode,
    required this.onSettingTap,
  });

  final _ProfileSettingGroup group;
  final ThemeMode themeMode;
  final ValueChanged<_ProfileSetting> onSettingTap;

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    return Container(
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(17),
        border: Border.all(color: colors.outline),
        boxShadow: [
          BoxShadow(
            color: colors.shadow,
            blurRadius: 12,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        children: [
          for (var index = 0; index < group.settings.length; index++) ...[
            _ProfileSettingTile(
              setting: group.settings[index],
              themeMode: themeMode,
              onTap: () => onSettingTap(group.settings[index]),
            ),
            if (index < group.settings.length - 1)
              Padding(
                padding: EdgeInsets.only(left: 58),
                child: Divider(height: 1, color: colors.outlineSoft),
              ),
          ],
        ],
      ),
    );
  }
}

class _ProfileSettingTile extends StatelessWidget {
  const _ProfileSettingTile({
    required this.setting,
    required this.themeMode,
    required this.onTap,
  });

  final _ProfileSetting setting;
  final ThemeMode themeMode;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    final subtitle = setting.title == 'Appearance'
        ? switch (themeMode) {
            ThemeMode.light => 'Light theme',
            ThemeMode.dark => 'Dark theme',
            ThemeMode.system => 'System default',
          }
        : setting.subtitle;
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(17),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 11),
          child: Row(
            children: [
              Container(
                width: 34,
                height: 34,
                decoration: BoxDecoration(
                  color: colors.iconSurface,
                  borderRadius: BorderRadius.circular(11),
                ),
                child: Icon(setting.icon, size: 18, color: colors.info),
              ),
              const SizedBox(width: 11),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      setting.title,
                      style: Theme.of(context).textTheme.titleMedium
                          ?.copyWith(fontSize: 13),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.labelMedium
                          ?.copyWith(fontSize: 10),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right_rounded, size: 20),
            ],
          ),
        ),
      ),
    );
  }
}

class _LogoutButton extends StatelessWidget {
  const _LogoutButton({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton.icon(
        onPressed: onTap,
        icon: const Icon(Icons.logout_rounded, size: 18),
        label: const Text('Log Out'),
        style: OutlinedButton.styleFrom(
          foregroundColor: colors.danger,
          side: BorderSide(color: colors.danger.withValues(alpha: 0.35)),
          padding: const EdgeInsets.symmetric(vertical: 13),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
      ),
    );
  }
}

class _ProfileFooter extends StatelessWidget {
  const _ProfileFooter();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          Text(
            'CoWorkHub',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: AppColors.of(context).info,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 3),
          Text(
            'Workspace management, simplified.',
            style: Theme.of(context).textTheme.labelMedium,
          ),
          const SizedBox(height: 3),
          Text(
            'Version 1.0.0',
            style: Theme.of(context).textTheme.labelMedium
                ?.copyWith(fontSize: 10),
          ),
        ],
      ),
    );
  }
}

class _AppearanceOption extends StatelessWidget {
  const _AppearanceOption({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.selected,
    required this.onTap,
  });

  final String title;
  final String subtitle;
  final IconData icon;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    final primary = Theme.of(context).colorScheme.primary;
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 180),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 11),
            decoration: BoxDecoration(
              color: selected ? colors.primarySoft : colors.surfaceRaised,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: selected ? primary : colors.outlineSoft,
              ),
            ),
            child: Row(
              children: [
                Icon(icon, color: selected ? primary : colors.muted, size: 21),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 2),
                      Text(
                        subtitle,
                        style: Theme.of(context).textTheme.labelMedium,
                      ),
                    ],
                  ),
                ),
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 160),
                  child: selected
                      ? Icon(
                          Icons.check_circle_rounded,
                          key: const ValueKey('selected'),
                          color: primary,
                          size: 21,
                        )
                      : Icon(
                          Icons.radio_button_unchecked_rounded,
                          key: const ValueKey('unselected'),
                          color: colors.tertiary,
                          size: 21,
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
