import 'dart:math';

import 'package:flutter/material.dart';

import '../models/account_profile.dart';

class ProfileDraft {
  const ProfileDraft({
    required this.label,
    required this.host,
    required this.port,
    required this.username,
    required this.apiToken,
  });

  final String label;
  final String host;
  final int port;
  final String username;
  final String apiToken;

  AccountProfile toProfile({String? id}) {
    final generatedId = DateTime.now().microsecondsSinceEpoch.toRadixString(36) +
        '-' +
        Random.secure().nextInt(0x7fffffff).toRadixString(36);
    return AccountProfile(
      id: id ?? generatedId,
      label: label,
      host: host,
      port: port,
      username: username,
    );
  }
}

class ProfileEditorDialog extends StatefulWidget {
  const ProfileEditorDialog({
    required this.onTest,
    this.profile,
    this.existingToken,
    super.key,
  });

  final AccountProfile? profile;
  final String? existingToken;
  final Future<void> Function(AccountProfile profile, String token) onTest;

  @override
  State<ProfileEditorDialog> createState() => _ProfileEditorDialogState();
}

class _ProfileEditorDialogState extends State<ProfileEditorDialog> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _label;
  late final TextEditingController _host;
  late final TextEditingController _port;
  late final TextEditingController _username;
  final _token = TextEditingController();
  bool _busy = false;
  bool _hideToken = true;
  String? _connectionMessage;
  bool _connected = false;

  @override
  void initState() {
    super.initState();
    final profile = widget.profile;
    _label = TextEditingController(text: profile?.label ?? '');
    _host = TextEditingController(text: profile?.host ?? '');
    _port = TextEditingController(text: (profile?.port ?? 2083).toString());
    _username = TextEditingController(text: profile?.username ?? '');
  }

  @override
  void dispose() {
    _label.dispose();
    _host.dispose();
    _port.dispose();
    _username.dispose();
    _token.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.profile == null ? 'Add cPanel account' : 'Edit account'),
      content: SizedBox(
        width: 440,
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: _label,
                  textCapitalization: TextCapitalization.words,
                  decoration: const InputDecoration(
                    labelText: 'Account name',
                    hintText: 'My website hosting',
                  ),
                  validator: _required,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _host,
                  keyboardType: TextInputType.url,
                  autocorrect: false,
                  decoration: const InputDecoration(
                    labelText: 'Server host',
                    hintText: 'server.example.com',
                  ),
                  validator: _validateHost,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _port,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Secure cPanel port',
                  ),
                  validator: (value) {
                    final port = int.tryParse(value ?? '');
                    if (port == null || port < 1 || port > 65535) {
                      return 'Enter a port from 1 to 65535';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _username,
                  autocorrect: false,
                  decoration: const InputDecoration(
                    labelText: 'cPanel username',
                  ),
                  validator: _required,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _token,
                  obscureText: _hideToken,
                  autocorrect: false,
                  decoration: InputDecoration(
                    labelText: 'cPanel API token',
                    hintText: widget.profile == null
                        ? 'Paste the token created in cPanel'
                        : 'Leave blank to keep the saved token',
                    suffixIcon: IconButton(
                      tooltip: _hideToken ? 'Show token' : 'Hide token',
                      onPressed: () => setState(() => _hideToken = !_hideToken),
                      icon: Icon(
                        _hideToken ? Icons.visibility : Icons.visibility_off,
                      ),
                    ),
                  ),
                  validator: (value) {
                    if (widget.profile == null &&
                        (value == null || value.trim().isEmpty)) {
                      return 'Enter an API token';
                    }
                    return null;
                  },
                ),
                if (_connectionMessage != null) ...[
                  const SizedBox(height: 12),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      _connectionMessage!,
                      style: TextStyle(
                        color: _connected
                            ? const Color(0xFF8EF2DF)
                            : Theme.of(context).colorScheme.error,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: _busy ? null : () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        OutlinedButton(
          onPressed: _busy ? null : _testConnection,
          child: const Text('Test connection'),
        ),
        FilledButton(
          onPressed: _busy ? null : _save,
          child: Text(_busy ? 'Please wait…' : 'Save account'),
        ),
      ],
    );
  }

  String? _required(String? value) =>
      value == null || value.trim().isEmpty ? 'This field is required' : null;

  String? _validateHost(String? value) {
    final host = (value ?? '').trim();
    if (host.isEmpty) return 'Enter a server host';
    if (host.contains('/') || host.contains('@') || host.contains(' ')) {
      return 'Enter a host only, without a path or scheme';
    }
    final parsed = Uri.tryParse('https://' + host);
    if (parsed == null || parsed.host.isEmpty || parsed.path != '/') {
      return 'Enter a valid host name or IP address';
    }
    return null;
  }

  Future<void> _testConnection() async {
    if (!_formKey.currentState!.validate()) return;
    final token = _effectiveToken;
    if (token.isEmpty) {
      setState(() {
        _connected = false;
        _connectionMessage = 'Enter the API token to test this account.';
      });
      return;
    }
    setState(() {
      _busy = true;
      _connectionMessage = 'Connecting securely…';
      _connected = false;
    });
    try {
      await widget.onTest(
        _profileDraft().toProfile(id: widget.profile?.id),
        token,
      );
      if (!mounted) return;
      setState(() {
        _busy = false;
        _connected = true;
        _connectionMessage = 'Connection succeeded.';
      });
    } on Object catch (error) {
      if (!mounted) return;
      setState(() {
        _busy = false;
        _connected = false;
        _connectionMessage = error.toString();
      });
    }
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    Navigator.of(context).pop(_profileDraft());
  }

  String get _effectiveToken {
    final typed = _token.text.trim();
    if (typed.isNotEmpty) return typed;
    return widget.existingToken ?? '';
  }

  ProfileDraft _profileDraft() {
    final parsed = Uri.tryParse('https://' + _host.text.trim());
    final host = (parsed?.host ?? _host.text.trim()).toLowerCase();
    return ProfileDraft(
      label: _label.text.trim(),
      host: host,
      port: int.parse(_port.text.trim()),
      username: _username.text.trim(),
      apiToken: _effectiveToken,
    );
  }
}
