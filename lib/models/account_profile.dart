class AccountProfile {
  const AccountProfile({
    required this.id,
    required this.label,
    required this.host,
    required this.port,
    required this.username,
  });

  final String id;
  final String label;
  final String host;
  final int port;
  final String username;

  Uri endpoint(String module, String function, [Map<String, String>? query]) {
    final authority = host.contains(':') && !host.startsWith('[')
        ? '[' + host + ']:' + port.toString()
        : host + ':' + port.toString();
    return Uri.https(authority, '/execute/' + module + '/' + function, query);
  }

  Map<String, Object> toJson() => {
        'id': id,
        'label': label,
        'host': host,
        'port': port,
        'username': username,
      };

  factory AccountProfile.fromJson(Map<String, dynamic> json) {
    return AccountProfile(
      id: json['id'] as String,
      label: json['label'] as String,
      host: json['host'] as String,
      port: (json['port'] as num).toInt(),
      username: json['username'] as String,
    );
  }
}

class RemoteFile {
  const RemoteFile({
    required this.name,
    required this.isDirectory,
    required this.size,
    this.mimeType,
  });

  final String name;
  final bool isDirectory;
  final int size;
  final String? mimeType;

  factory RemoteFile.fromJson(Map<String, dynamic> json) {
    final rawName = json['file'] ??
        json['name'] ??
        json['filename'] ??
        json['basename'] ??
        json['fullpath'] ??
        '';
    final name = rawName.toString().split('/').where((part) => part.isNotEmpty).last;
    final type = (json['type'] ?? '').toString().toLowerCase();
    final isDirectory = type == 'dir' ||
        type == 'directory' ||
        json['is_directory'] == true ||
        json['isdir'] == true;
    final rawSize = json['size'];
    return RemoteFile(
      name: name,
      isDirectory: isDirectory,
      size: rawSize is num ? rawSize.toInt() : int.tryParse('$rawSize') ?? 0,
      mimeType: (json['mimetype'] ?? json['mime_type'])?.toString(),
    );
  }
}
