import 'package:flutter/material.dart';

import '../data/account_store.dart';
import '../data/cpanel_client.dart';
import '../models/account_profile.dart';
import 'file_manager.dart';
import 'profile_editor.dart';

class AppHome extends StatefulWidget {
  const AppHome({super.key});

  @override
  State<AppHome> createState() => _AppHomeState();
}

class _AppHomeState extends State<AppHome> {
  final _store = AccountStore();
  List<AccountProfile> _profiles = const [];
  AccountProfile? _activeProfile;
  int _selectedIndex = 0;
  bool _loading = true;
  bool _checking = false;
  String? _connectionStatus;
  bool _connected = false;

  @override
  void initState() {
    super.initState();
    _loadProfiles();
  }

  Future<void> _loadProfiles() async {
    final profiles = await _store.loadProfiles();
    final activeId = await _store.loadActiveProfileId();
    if (!mounted) return;
    setState(() {
      _profiles = profiles;
      _activeProfile = profiles.where((item) => item.id == activeId).firstOrNull ??
          (profiles.isEmpty ? null : profiles.first);
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final profile = _activeProfile;
    final destinations = const [
      NavigationDestination(
        icon: Icon(Icons.dashboard_outlined),
        selectedIcon: Icon(Icons.dashboard_rounded),
        label: 'Overview',
      ),
      NavigationDestination(
        icon: Icon(Icons.folder_outlined),
        selectedIcon: Icon(Icons.folder_rounded),
        label: 'Files',
      ),
      NavigationDestination(
        icon: Icon(Icons.settings_outlined),
        selectedIcon: Icon(Icons.settings_rounded),
        label: 'Accounts',
      ),
    ];

    final pages = [
      _overviewPage(),
      profile == null
          ? _emptyPage(
              icon: Icons.folder_open_rounded,
              title: 'Add an account to browse files',
              actionLabel: 'Add account',
              onAction: _addProfile,
            )
          : FileManagerPage(
              key: ValueKey(profile.id),
              profile: profile,
              store: _store,
            ),
      _accountsPage(),
    ];

    return LayoutBuilder(
      builder: (context, constraints) {
        final wide = constraints.maxWidth >= 760;
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
                    semanticLabel: 'Hosting server',
                  ),
                ),
                const SizedBox(width: 11),
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'cPanel Admin',
                      style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700),
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
              if (_profiles.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: profile?.id,
                      hint: const Text('Choose account'),
                      items: _profiles
                          .map(
                            (item) => DropdownMenuItem<String>(
                              value: item.id,
                              child: ConstrainedBox(
                                constraints: const BoxConstraints(maxWidth: 150),
                                child: Text(
                                  item.label,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ),
                          )
                          .toList(),
                      onChanged: (id) {
                        if (id != null) _selectProfile(id);
                      },
                    ),
                  ),
                ),
              IconButton(
                tooltip: 'Add account',
                onPressed: _addProfile,
                icon: const Icon(Icons.add_circle_outline_rounded),
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
                    labelType: NavigationRailLabelType.all,
                    onDestinationSelected: (index) {
                      setState(() => _selectedIndex = index);
                    },
                    destinations: destinations
                        .map(
                          (item) => NavigationRailDestination(
                            icon: item.icon,
                            selectedIcon: item.selectedIcon,
                            label: Text(item.label),
                          ),
                        )
                        .toList(),
                  ),
                Expanded(child: pages[_selectedIndex]),
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
                  destinations: destinations,
                ),
        );
      },
    );
  }

  Widget _overviewPage() {
    final profile = _activeProfile;
    return _pageFrame(
      eyebrow: 'YOUR HOSTING, AT A GLANCE',
      title: 'Overview',
      subtitle: profile == null
          ? 'Connect a cPanel account to get started.'
          : profile.host + ' · ' + profile.username,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (profile == null)
            _welcomeCard()
          else
            _connectedCard(profile),
          const SizedBox(height: 22),
          const Text(
            'AVAILABLE IN THIS BUILD',
            style: TextStyle(
              color: Color(0xFF67E8D2),
              fontSize: 11,
              fontWeight: FontWeight.w700,
              letterSpacing: 1.4,
            ),
          ),
          const SizedBox(height: 10),
          _featureList(),
        ],
      ),
    );
  }

  Widget _welcomeCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(22),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Icon(
              Icons.dns_rounded,
              color: Color(0xFF67E8D2),
              size: 42,
            ),
            const SizedBox(height: 14),
            Text(
              'Connect your first account',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Add a server host, cPanel username, and API token. '
              'The token is stored in your device secure storage.',
              style: TextStyle(color: Color(0xFFB2C0CC), height: 1.5),
            ),
            const SizedBox(height: 16),
            FilledButton.icon(
              onPressed: _addProfile,
              icon: const Icon(Icons.add_rounded),
              label: const Text('Add cPanel account'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _connectedCard(AccountProfile profile) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(22),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.verified_user_outlined,
                    color: Color(0xFF67E8D2)),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    profile.label,
                    style: Theme.of(context)
                        .textTheme
                        .titleLarge
                        ?.copyWith(fontWeight: FontWeight.w700),
                  ),
                ),
                if (_checking)
                  const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                else
                  IconButton(
                    tooltip: 'Test cPanel connection',
                    onPressed: _testActiveConnection,
                    icon: const Icon(Icons.sync_rounded),
                  ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              'https://' + profile.host + ':' + profile.port.toString(),
              style: const TextStyle(color: Color(0xFFB2C0CC)),
            ),
            const SizedBox(height: 12),
            if (_connectionStatus != null)
              Text(
                _connectionStatus!,
                style: TextStyle(
                  color: _connected
                      ? const Color(0xFF8EF2DF)
                      : Theme.of(context).colorScheme.error,
                ),
              )
            else
              const Text(
                'Tap the sync button to check access.',
                style: TextStyle(color: Color(0xFF9DB0BF)),
              ),
            const SizedBox(height: 16),
            FilledButton.icon(
              onPressed: () => setState(() => _selectedIndex = 1),
              icon: const Icon(Icons.folder_open_rounded),
              label: const Text('Open File Manager'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _featureList() {
    const features = [
      (Icons.folder_open_rounded, 'File Manager', 'Browse and upload files'),
      (Icons.language_rounded, 'Domains', 'Planned'),
      (Icons.mail_outline_rounded, 'Email', 'Planned'),
      (Icons.storage_rounded, 'Databases', 'Planned'),
      (Icons.shield_outlined, 'SSL', 'Planned'),
      (Icons.schedule_rounded, 'Cron jobs', 'Planned'),
    ];
    return LayoutBuilder(
      builder: (context, constraints) {
        final columns = constraints.maxWidth > 650 ? 3 : 2;
        return GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: features.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: columns,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            mainAxisExtent: 92,
          ),
          itemBuilder: (context, index) {
            final item = features[index];
            final active = index == 0;
            return Card(
              child: ListTile(
                leading: Icon(
                  item.$1,
                  color: active
                      ? const Color(0xFF67E8D2)
                      : const Color(0xFF8393A0),
                ),
                title: Text(item.$2, maxLines: 1),
                subtitle: Text(item.$3, maxLines: 1),
                onTap: active
                    ? () => setState(() => _selectedIndex = 1)
                    : null,
              ),
            );
          },
        );
      },
    );
  }

  Widget _accountsPage() {
    return _pageFrame(
      eyebrow: 'CONNECTIONS',
      title: 'cPanel accounts',
      subtitle: 'Each profile keeps its token on this device.',
      child: Column(
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: FilledButton.icon(
              onPressed: _addProfile,
              icon: const Icon(Icons.add_rounded),
              label: const Text('Add account'),
            ),
          ),
          const SizedBox(height: 12),
          if (_loading)
            const Center(child: CircularProgressIndicator())
          else if (_profiles.isEmpty)
            _emptyPage(
              icon: Icons.dns_rounded,
              title: 'No accounts saved yet',
              actionLabel: 'Add cPanel account',
              onAction: _addProfile,
            )
          else
            for (final profile in _profiles) _profileCard(profile),
        ],
      ),
    );
  }

  Widget _profileCard(AccountProfile profile) {
    final active = _activeProfile?.id == profile.id;
    return Card(
      child: ListTile(
        leading: Icon(
          active ? Icons.dns_rounded : Icons.dns_outlined,
          color: const Color(0xFF67E8D2),
        ),
        title: Text(profile.label),
        subtitle: Text(profile.host + ' · ' + profile.username),
        onTap: () => _selectProfile(profile.id),
        trailing: PopupMenuButton<String>(
          tooltip: 'Account actions',
          onSelected: (action) {
            if (action == 'edit') _editProfile(profile);
            if (action == 'test') _testProfile(profile);
            if (action == 'delete') _deleteProfile(profile);
          },
          itemBuilder: (context) => const [
            PopupMenuItem(value: 'test', child: Text('Test connection')),
            PopupMenuItem(value: 'edit', child: Text('Edit profile')),
            PopupMenuItem(value: 'delete', child: Text('Delete profile')),
          ],
        ),
      ),
    );
  }

  Widget _emptyPage({
    required IconData icon,
    required String title,
    required String actionLabel,
    required VoidCallback onAction,
  }) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 42, color: const Color(0xFF67E8D2)),
            const SizedBox(height: 12),
            Text(title, textAlign: TextAlign.center),
            const SizedBox(height: 12),
            FilledButton(onPressed: onAction, child: Text(actionLabel)),
          ],
        ),
      ),
    );
  }

  Widget _pageFrame({
    required String eyebrow,
    required String title,
    required String subtitle,
    required Widget child,
  }) {
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
                        ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    subtitle,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: const Color(0xFFB2C0CC),
                        ),
                  ),
                  const SizedBox(height: 22),
                  child,
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Future<void> _addProfile() => _editProfile(null);

  Future<void> _editProfile(AccountProfile? profile) async {
    String? savedToken;
    if (profile != null) {
      savedToken = await _store.loadApiToken(profile.id);
    }
    if (!mounted) return;
    final draft = await showDialog<ProfileDraft>(
      context: context,
      builder: (context) => ProfileEditorDialog(
        profile: profile,
        existingToken: savedToken,
        onTest: (candidate, token) =>
            CpanelClient(profile: candidate, apiToken: token).testConnection(),
      ),
    );
    if (draft == null) return;
    final model = draft.toProfile(id: profile?.id);
    try {
      await _store.saveProfile(
        model,
        apiToken: draft.apiToken.isEmpty ? null : draft.apiToken,
      );
      await _loadProfiles();
      if (mounted) {
        _showMessage('Account saved securely on this device.');
      }
    } on Object catch (error) {
      if (mounted) _showMessage(error.toString());
    }
  }

  Future<void> _selectProfile(String id) async {
    await _store.setActiveProfileId(id);
    await _loadProfiles();
    setState(() {
      _connectionStatus = null;
      _connected = false;
    });
  }

  Future<void> _testActiveConnection() async {
    final profile = _activeProfile;
    if (profile != null) await _testProfile(profile);
  }

  Future<void> _testProfile(AccountProfile profile) async {
    setState(() {
      _checking = true;
      _connectionStatus = 'Testing secure connection…';
      _connected = false;
    });
    try {
      final token = await _store.loadApiToken(profile.id);
      if (token == null || token.isEmpty) {
        throw const CpanelApiException('No API token is saved for this profile.');
      }
      await CpanelClient(profile: profile, apiToken: token).testConnection();
      if (!mounted) return;
      setState(() {
        _checking = false;
        _connectionStatus = 'Connected to cPanel successfully.';
        _connected = true;
      });
    } on Object catch (error) {
      if (!mounted) return;
      setState(() {
        _checking = false;
        _connectionStatus = error.toString();
        _connected = false;
      });
    }
  }

  Future<void> _deleteProfile(AccountProfile profile) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete saved account?'),
        content: Text(
          'This removes ' +
              profile.label +
              ' and its API token from this device. It does not delete anything on the hosting server.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Delete account'),
          ),
        ],
      ),
    );
    if (confirm != true) return;
    await _store.deleteProfile(profile.id);
    await _loadProfiles();
    if (mounted) _showMessage('Saved profile removed.');
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), duration: const Duration(seconds: 4)),
    );
  }
}
