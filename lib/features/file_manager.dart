import 'dart:convert';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

import '../data/account_store.dart';
import '../data/cpanel_client.dart';
import '../models/account_profile.dart';

class FileManagerPage extends StatefulWidget {
  const FileManagerPage({
    required this.profile,
    required this.store,
    super.key,
  });

  final AccountProfile profile;
  final AccountStore store;

  @override
  State<FileManagerPage> createState() => _FileManagerPageState();
}

class _FileManagerPageState extends State<FileManagerPage> {
  late String _directory;
  late Future<CpanelClient> _clientFuture;
  List<RemoteFile> _files = const [];
  bool _loading = true;
  bool _working = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _directory = 'public_html';
    _clientFuture = _createClient();
    _loadFiles();
  }

  Future<CpanelClient> _createClient() async {
    final token = await widget.store.loadApiToken(widget.profile.id);
    if (token == null || token.isEmpty) {
      throw const CpanelApiException('This account has no saved API token.');
    }
    return CpanelClient(profile: widget.profile, apiToken: token);
  }

  Future<void> _loadFiles() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final client = await _clientFuture;
      final files = await client.listFiles(_directory);
      if (!mounted) return;
      setState(() {
        _files = files;
        _loading = false;
      });
    } on Object catch (error) {
      if (!mounted) return;
      setState(() {
        _error = error.toString();
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 14, 16, 8),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  _directory,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontWeight: FontWeight.w700),
                ),
              ),
              IconButton(
                tooltip: 'Upload file',
                onPressed: _working || _loading ? null : _uploadFile,
                icon: const Icon(Icons.upload_file_rounded),
              ),
              IconButton(
                tooltip: 'Refresh directory',
                onPressed: _working ? null : _loadFiles,
                icon: const Icon(Icons.refresh_rounded),
              ),
            ],
          ),
        ),
        const Divider(height: 1),
        Expanded(child: _buildBody()),
      ],
    );
  }

  Widget _buildBody() {
    if (_loading) return const Center(child: CircularProgressIndicator());
    if (_error != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.cloud_off_rounded, size: 38),
              const SizedBox(height: 12),
              Text(_error!, textAlign: TextAlign.center),
              const SizedBox(height: 12),
              FilledButton.icon(
                onPressed: _loadFiles,
                icon: const Icon(Icons.refresh_rounded),
                label: const Text('Try again'),
              ),
            ],
          ),
        ),
      );
    }
    if (_files.isEmpty) {
      return const Center(
        child: Text('This directory is empty or has no visible files.'),
      );
    }
    return Stack(
      children: [
        RefreshIndicator(
          onRefresh: _loadFiles,
          child: ListView.separated(
            physics: const AlwaysScrollableScrollPhysics(),
            itemCount: _files.length + (_directory == 'public_html' ? 0 : 1),
            separatorBuilder: (context, index) => const Divider(
              height: 1,
              indent: 70,
            ),
            itemBuilder: (context, index) {
              if (_directory != 'public_html' && index == 0) {
                return ListTile(
                  leading: const Icon(Icons.arrow_upward_rounded),
                  title: const Text('Parent directory'),
                  onTap: _goUp,
                );
              }
              final fileIndex =
                  index - (_directory == 'public_html' ? 0 : 1);
              return _fileRow(_files[fileIndex]);
            },
          ),
        ),
        if (_working)
          const Positioned.fill(
            child: ColoredBox(
              color: Color(0x660B1118),
              child: Center(child: CircularProgressIndicator()),
            ),
          ),
      ],
    );
  }

  Widget _fileRow(RemoteFile file) {
    final canReadAsText = !file.isDirectory && _isTextFile(file.name);
    return ListTile(
      leading: Icon(
        file.isDirectory ? Icons.folder_rounded : Icons.insert_drive_file_outlined,
        color: file.isDirectory
            ? const Color(0xFF67E8D2)
            : const Color(0xFF9DB0BF),
      ),
      title: Text(file.name, maxLines: 1, overflow: TextOverflow.ellipsis),
      subtitle: Text(
        file.isDirectory ? 'Folder' : _formatSize(file.size),
      ),
      onTap: file.isDirectory ? () => _openDirectory(file.name) : null,
      trailing: canReadAsText
          ? IconButton(
              tooltip: 'Save UTF-8 text file',
              onPressed: _working ? null : () => _downloadText(file),
              icon: const Icon(Icons.download_rounded),
            )
          : null,
    );
  }

  Future<void> _openDirectory(String name) async {
    setState(() {
      _directory = _join(_directory, name);
    });
    await _loadFiles();
  }

  Future<void> _goUp() async {
    final parts = _directory.split('/')..removeWhere((part) => part.isEmpty);
    if (parts.length <= 1) {
      setState(() => _directory = 'public_html');
    } else {
      parts.removeLast();
      setState(() => _directory = parts.join('/'));
    }
    await _loadFiles();
  }

  Future<void> _uploadFile() async {
    try {
      final file = await FilePicker.platform.pickFile();
      if (file == null) return;
      final length = file.lengthSync() ?? await file.length();
      if (length != null && length > 50 * 1024 * 1024) {
        _showMessage('Choose a file smaller than 50 MB for this build.');
        return;
      }
      setState(() => _working = true);
      final bytes = await file.readAsBytes();
      final client = await _clientFuture;
      await client.uploadFile(
        directory: _directory,
        fileName: file.name,
        bytes: bytes,
      );
      if (!mounted) return;
      setState(() => _working = false);
      _showMessage('Upload finished.');
      await _loadFiles();
    } on Object catch (error) {
      if (!mounted) return;
      setState(() => _working = false);
      _showMessage(error.toString());
    }
  }

  Future<void> _downloadText(RemoteFile file) async {
    setState(() => _working = true);
    try {
      final client = await _clientFuture;
      final content = await client.readTextFile(
        directory: _directory,
        fileName: file.name,
      );
      await FilePicker.saveFile(
        fileName: file.name,
        bytes: utf8.encode(content),
        mimeType: 'text/plain',
      );
      if (!mounted) return;
      setState(() => _working = false);
      _showMessage('File saved.');
    } on Object catch (error) {
      if (!mounted) return;
      setState(() => _working = false);
      _showMessage(error.toString());
    }
  }

  bool _isTextFile(String name) {
    final lower = name.toLowerCase();
    const extensions = [
      '.txt',
      '.html',
      '.htm',
      '.css',
      '.js',
      '.json',
      '.xml',
      '.csv',
      '.md',
      '.php',
      '.htaccess',
      '.conf',
      '.yml',
      '.yaml',
      '.sql',
      '.log',
    ];
    return extensions.any(lower.endsWith);
  }

  String _join(String directory, String child) =>
      directory.isEmpty || directory == '.' ? child : directory + '/' + child;

  String _formatSize(int bytes) {
    if (bytes < 1024) return bytes.toString() + ' B';
    if (bytes < 1024 * 1024) {
      return (bytes / 1024).toStringAsFixed(1) + ' KB';
    }
    return (bytes / (1024 * 1024)).toStringAsFixed(1) + ' MB';
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), duration: const Duration(seconds: 4)),
    );
  }
}
