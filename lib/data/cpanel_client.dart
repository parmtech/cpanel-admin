import 'dart:convert';
import 'dart:typed_data';

import 'package:http/http.dart' as http;

import '../models/account_profile.dart';

class CpanelApiException implements Exception {
  const CpanelApiException(this.message);

  final String message;

  @override
  String toString() => message;
}

class CpanelClient {
  CpanelClient({
    required this.profile,
    required this.apiToken,
    http.Client? client,
  }) : _http = client ?? http.Client();

  final AccountProfile profile;
  final String apiToken;
  final http.Client _http;

  Map<String, String> get _headers => {
        'Authorization': 'cpanel ' + profile.username + ':' + apiToken,
        'Accept': 'application/json',
      };

  Future<void> testConnection() async {
    await _get('Variables', 'get_user_information');
  }

  Future<List<RemoteFile>> listFiles(String directory) async {
    final result = await _get('Fileman', 'list_files', {'dir': directory});
    final data = result['data'];
    if (data is List) {
      return data
          .whereType<Map>()
          .map((item) => RemoteFile.fromJson(Map<String, dynamic>.from(item)))
          .where((item) => item.name.isNotEmpty)
          .toList(growable: false);
    }
    if (data is Map) {
      return data.values
          .whereType<Map>()
          .map((item) => RemoteFile.fromJson(Map<String, dynamic>.from(item)))
          .where((item) => item.name.isNotEmpty)
          .toList(growable: false);
    }
    return const [];
  }

  Future<void> uploadFile({
    required String directory,
    required String fileName,
    required Uint8List bytes,
  }) async {
    final request = http.MultipartRequest(
      'POST',
      profile.endpoint('Fileman', 'upload_files'),
    )
      ..headers.addAll(_headers)
      ..fields['dir'] = directory
      ..files.add(
        http.MultipartFile.fromBytes('file-1', bytes, filename: fileName),
      );

    final streamed = await _http.send(request).timeout(
          const Duration(seconds: 90),
        );
    final response = await http.Response.fromStream(streamed);
    _decodeResponse(response);
  }

  Future<String> readTextFile({
    required String directory,
    required String fileName,
  }) async {
    final result = await _get('Fileman', 'get_file_content', {
      'dir': directory,
      'file': fileName,
      'to_charset': 'utf-8',
    });
    final data = result['data'];
    if (data is String) return data;
    if (data is Map && data['content'] is String) {
      return data['content'] as String;
    }
    if (data is List && data.isNotEmpty && data.first is Map) {
      final content = (data.first as Map)['content'];
      if (content is String) return content;
    }
    throw const CpanelApiException(
      'The server did not return readable UTF-8 file content.',
    );
  }

  Future<Map<String, dynamic>> _get(
    String module,
    String function, [
    Map<String, String>? query,
  ]) async {
    final response = await _http
        .get(profile.endpoint(module, function, query), headers: _headers)
        .timeout(const Duration(seconds: 30));
    return _decodeResponse(response);
  }

  Map<String, dynamic> _decodeResponse(http.Response response) {
    if (response.statusCode < 200 || response.statusCode >= 300) {
      if (response.statusCode == 401 || response.statusCode == 403) {
        throw const CpanelApiException(
          'cPanel rejected this token or denied this API permission.',
        );
      }
      throw CpanelApiException(
        'cPanel returned HTTP ' + response.statusCode.toString() + '.',
      );
    }

    dynamic decoded;
    try {
      decoded = jsonDecode(utf8.decode(response.bodyBytes));
    } on Object {
      throw const CpanelApiException(
        'cPanel returned a response that was not valid JSON.',
      );
    }

    if (decoded is! Map) {
      throw const CpanelApiException('Unexpected cPanel API response.');
    }
    final root = Map<String, dynamic>.from(decoded);
    final rawResult = root['result'];
    if (rawResult is! Map) {
      throw const CpanelApiException('cPanel did not return a UAPI result.');
    }
    final result = Map<String, dynamic>.from(rawResult);
    final status = result['status'];
    if (status == 0 || status == false) {
      final errors = result['errors'];
      final message = errors is List
          ? errors.map((item) => item.toString()).join(' ')
          : 'The cPanel API request failed.';
      throw CpanelApiException(message);
    }
    return result;
  }
}
