import 'package:flutter/material.dart';

void main() {
  runApp(const CPanelAdminApp());
}

class CPanelAdminApp extends StatelessWidget {
  const CPanelAdminApp({super.key});

  @override
  Widget build(BuildContext context) {
    const accent = Color(0xFF67E8D2);
    const background = Color(0xFF0B1118);

    return MaterialApp(
      title: 'cPanel Admin',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        colorScheme: ColorScheme.fromSeed(
          seedColor: accent,
          brightness: Brightness.dark,
          surface: const Color(0xFF111B25),
        ),
        scaffoldBackgroundColor: background,
        appBarTheme: const AppBarTheme(
          backgroundColor: background,
          surfaceTintColor: Colors.transparent,
        ),
        cardTheme: CardThemeData(
          color: const Color(0xFF111B25),
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
            side: const BorderSide(color: Color(0xFF263746)),
          ),
        ),
      ),
      home: const AppShell(),
    );
  }
}

class AppShell extends StatefulWidget {
  const AppShell({super.key});

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  int _selectedIndex = 0;

  static const _destinations = <NavigationDestination>[
    NavigationDestination(
      icon: Icon(Icons.dashboard_outlined),
      selectedIcon: Icon(Icons.dashboard_rounded),
      label: 'Overview',
    ),
    NavigationDestination(
      icon: Icon(Icons.grid_view_rounded),
      label: 'Tools',
    ),
    NavigationDestination(
      icon: Icon(Icons.settings_outlined),
      selectedIcon: Icon(Icons.settings_rounded),
      label: 'Settings',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final pages = <Widget>[
      OverviewPage(onAddAccount: _showSetupNotice),
      ToolsPage(onAddAccount: _showSetupNotice),
      SettingsPage(onAddAccount: _showSetupNotice),
    ];

    return LayoutBuilder(
      builder: (context, constraints) {
        final wide = constraints.maxWidth >= 760;
        final selectedPage = pages[_selectedIndex];

        return Scaffold(
          appBar: AppBar(
            titleSpacing: 20,
            title: Row(
              children: [
                Container(
                  width: 38,
                  height: 38,
                  decoration: BoxDecoration(
                    color: const Color(0xFF17352F),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.dns_rounded,
                    color: Color(0xFF67E8D2),
                    size: 21,
                    semanticLabel: 'Server dashboard',
                  ),
                ),
                const SizedBox(width: 12),
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'cPanel Admin',
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Text(
                      'UNOFFICIAL CLIENT',
                      style: TextStyle(
                        fontSize: 10,
                        letterSpacing: 1.2,
                        color: Color(0xFF9DB0BF),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            actions: [
              IconButton(
                tooltip: 'Account profiles',
                onPressed: _showSetupNotice,
                icon: const Icon(Icons.account_circle_outlined),
              ),
              const SizedBox(width: 8),
            ],
          ),
          body: SafeArea(
            top: false,
            child: Row(
              children: [
                if (wide)
                  NavigationRail(
                    selectedIndex: _selectedIndex,
                    onDestinationSelected: (index) {
                      setState(() => _selectedIndex = index);
                    },
                    labelType: NavigationRailLabelType.all,
                    destinations: _destinations
                        .map(
                          (destination) => NavigationRailDestination(
                            icon: destination.icon,
                            selectedIcon: destination.selectedIcon,
                            label: Text(destination.label),
                          ),
                        )
                        .toList(),
                  ),
                Expanded(child: selectedPage),
              ],
            ),
          ),
          bottomNavigationBar: wide
              ? null
              : NavigationBar(
                  selectedIndex: _selectedIndex,
                  onDestinationSelected: (index) {
                    setState(() => _selectedIndex = index);
                  },
                  destinations: _destinations,
                ),
        );
      },
    );
  }

  void _showSetupNotice() {
    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Account setup is next'),
        content: const Text(
          'This is the app foundation. Secure account profiles and cPanel '
          'connection testing are the next implementation milestone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Got it'),
          ),
        ],
      ),
    );
  }
}

class OverviewPage extends StatelessWidget {
  const OverviewPage({required this.onAddAccount, super.key});

  final VoidCallback onAddAccount;

  @override
  Widget build(BuildContext context) {
    return _PageFrame(
      eyebrow: 'YOUR HOSTING, AT A GLANCE',
      title: 'Overview',
      subtitle: 'A clearer way to manage your cPanel accounts.',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _WelcomeCard(onAddAccount: onAddAccount),
          const SizedBox(height: 24),
          const _SectionHeading(
            title: 'Quick access',
            trailing: 'Available as features are built',
          ),
          const SizedBox(height: 12),
          const FeatureGrid(compact: true),
        ],
      ),
    );
  }
}

class ToolsPage extends StatelessWidget {
  const ToolsPage({required this.onAddAccount, super.key});

  final VoidCallback onAddAccount;

  @override
  Widget build(BuildContext context) {
    return _PageFrame(
      eyebrow: 'ACCOUNT MANAGEMENT',
      title: 'Tools',
      subtitle: 'Common hosting tasks, organized in one place.',
      child: const FeatureGrid(compact: false),
    );
  }
}

class SettingsPage extends StatelessWidget {
  const SettingsPage({required this.onAddAccount, super.key});

  final VoidCallback onAddAccount;

  @override
  Widget build(BuildContext context) {
    return _PageFrame(
      eyebrow: 'PREFERENCES',
      title: 'Settings',
      subtitle: 'Account profiles and app security are coming next.',
      child: Column(
        children: [
          _SettingsRow(
            icon: Icons.manage_accounts_outlined,
            title: 'cPanel accounts',
            subtitle: 'Add and manage named server profiles',
            onTap: onAddAccount,
          ),
          const SizedBox(height: 10),
          const _SettingsRow(
            icon: Icons.lock_outline_rounded,
            title: 'App security',
            subtitle: 'Secure storage and optional app lock',
            enabled: false,
          ),
          const SizedBox(height: 10),
          const _SettingsRow(
            icon: Icons.info_outline_rounded,
            title: 'About this app',
            subtitle: 'Open-source, unofficial cPanel companion',
            enabled: false,
          ),
        ],
      ),
    );
  }
}

class _PageFrame extends StatelessWidget {
  const _PageFrame({
    required this.eyebrow,
    required this.title,
    required this.subtitle,
    required this.child,
  });

  final String eyebrow;
  final String title;
  final String subtitle;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final maxWidth = constraints.maxWidth > 1100 ? 1100.0 : 820.0;
        return Align(
          alignment: Alignment.topCenter,
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(20, 24, 20, 32),
            child: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: maxWidth),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    eyebrow,
                    style: const TextStyle(
                      color: Color(0xFF67E8D2),
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 1.5,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    title,
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.w700,
                          letterSpacing: -0.7,
                        ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    subtitle,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: const Color(0xFFB2C0CC),
                        ),
                  ),
                  const SizedBox(height: 24),
                  child,
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class _WelcomeCard extends StatelessWidget {
  const _WelcomeCard({required this.onAddAccount});

  final VoidCallback onAddAccount;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(22),
        child: LayoutBuilder(
          builder: (context, constraints) {
            final narrow = constraints.maxWidth < 520;
            final message = Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFF17352F),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: const Text(
                    'READY WHEN YOU ARE',
                    style: TextStyle(
                      color: Color(0xFF8EF2DF),
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 1,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'Connect your first account',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Your saved server profiles will appear here. '
                  'Credentials will be protected by your device.',
                  style: TextStyle(
                    color: Color(0xFFB2C0CC),
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 18),
                FilledButton.icon(
                  onPressed: onAddAccount,
                  icon: const Icon(Icons.add_rounded),
                  label: const Text('Set up an account'),
                ),
              ],
            );

            if (narrow) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const _ServerIllustration(),
                  const SizedBox(height: 18),
                  message,
                ],
              );
            }

            return Row(
              children: [
                const Expanded(child: _ServerIllustration()),
                const SizedBox(width: 26),
                Expanded(flex: 2, child: message),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _ServerIllustration extends StatelessWidget {
  const _ServerIllustration();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 150,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF17352F), Color(0xFF152633)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: const Center(
        child: Icon(
          Icons.dns_rounded,
          size: 66,
          color: Color(0xFF67E8D2),
          semanticLabel: 'Hosting server',
        ),
      ),
    );
  }
}

class FeatureGrid extends StatelessWidget {
  const FeatureGrid({required this.compact, super.key});

  final bool compact;

  static const features = <_FeatureData>[
    _FeatureData(Icons.folder_open_rounded, 'File manager', 'Planned'),
    _FeatureData(Icons.language_rounded, 'Domains', 'Planned'),
    _FeatureData(Icons.mail_outline_rounded, 'Email', 'Planned'),
    _FeatureData(Icons.storage_rounded, 'Databases', 'Planned'),
    _FeatureData(Icons.shield_outlined, 'SSL status', 'Planned'),
    _FeatureData(Icons.schedule_rounded, 'Cron jobs', 'Planned'),
  ];

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final columns = constraints.maxWidth >= 700
            ? 3
            : constraints.maxWidth >= 430
                ? 2
                : 1;
        final spacing = compact ? 10.0 : 12.0;

        return GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: features.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: columns,
            crossAxisSpacing: spacing,
            mainAxisSpacing: spacing,
            mainAxisExtent: compact ? 92 : 104,
          ),
          itemBuilder: (context, index) => _FeatureCard(
            feature: features[index],
          ),
        );
      },
    );
  }
}

class _FeatureData {
  const _FeatureData(this.icon, this.title, this.status);

  final IconData icon;
  final String title;
  final String status;
}

class _FeatureCard extends StatelessWidget {
  const _FeatureCard({required this.feature});

  final _FeatureData feature;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        child: Row(
          children: [
            Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                color: const Color(0xFF1B2A36),
                borderRadius: BorderRadius.circular(13),
              ),
              child: Icon(feature.icon, color: const Color(0xFF8EF2DF)),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    feature.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    feature.status,
                    style: const TextStyle(
                      color: Color(0xFF9DB0BF),
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.lock_outline_rounded,
              size: 17,
              color: Color(0xFF7D909F),
              semanticLabel: 'Not available yet',
            ),
          ],
        ),
      ),
    );
  }
}

class _SectionHeading extends StatelessWidget {
  const _SectionHeading({required this.title, required this.trailing});

  final String title;
  final String trailing;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      alignment: WrapAlignment.spaceBetween,
      runSpacing: 4,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w700,
              ),
        ),
        Text(
          trailing,
          style: const TextStyle(
            color: Color(0xFF9DB0BF),
            fontSize: 12,
          ),
        ),
      ],
    );
  }
}

class _SettingsRow extends StatelessWidget {
  const _SettingsRow({
    required this.icon,
    required this.title,
    required this.subtitle,
    this.onTap,
    this.enabled = true,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback? onTap;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        enabled: enabled,
        leading: Icon(icon, color: const Color(0xFF8EF2DF)),
        title: Text(title),
        subtitle: Text(subtitle),
        trailing: const Icon(Icons.chevron_right_rounded),
        onTap: enabled ? onTap : null,
      ),
    );
  }
}
