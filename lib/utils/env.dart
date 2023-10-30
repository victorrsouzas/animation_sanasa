import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class Env {
  // Singleton para FlutterSecureStorage
  static const FlutterSecureStorage _storage = FlutterSecureStorage();
  // Método para armazenar a URI do Keycloak
  static Future<void> storeKeycloakUri() async {
    await _storage.write(
        key: 'keycloakUri', value: "https://sso.sanasa.com.br/realms/dev");
  }

  // Método para obter a URI do Keycloak
  static Future<String?> getKeycloakUri() async {
    return await _storage.read(key: 'keycloakUri');
  }

  // Método para armazenar o client ID
  static Future<void> storeClientId() async {
    await _storage.write(key: 'clientId', value: "app-sanasa");
  }

  // Método para obter o client ID
  static Future<String?> getClientId() async {
    return await _storage.read(key: 'clientId');
  }

  // Método para armazenar o client secret
  static Future<void> storeClientSecret() async {
    await _storage.write(
        key: 'clientSecret', value: "OnAozVgW1ENF1THDOpJbY42ux5Vonk3G");
  }

  // Método para obter o client secret
  static Future<String?> getClientSecret() async {
    return await _storage.read(key: 'clientSecret');
  }

  // Método para armazenar as scopes
  static Future<void> storeScopes() async {
    final jsonString =
        jsonEncode(['openid', 'profile', 'cpf', 'phone', 'email']);
    await _storage.write(key: 'scopes', value: jsonString);
  }

  // Método para obter as scopes
  static Future<List<String>?> getScopes() async {
    final jsonString = await _storage.read(key: 'scopes');
    if (jsonString != null) {
      final decoded = jsonDecode(jsonString);
      if (decoded is List) {
        return decoded.map((e) => e.toString()).toList();
      }
    }
    return null;
  }

  // Método para armazenar o tempo de expiração do token
  static Future<void> storeTokenExp(String tokenExpValue) async {
    await _storage.write(key: 'tokenExp', value: tokenExpValue);
  }

  // Método para obter o token
  static Future<String?> getTokenExp() async {
    return await _storage.read(key: 'tokenExp');
  }

  // Método para deletar o token
  static Future<void> deleteTokenExp() async {
    await _storage.delete(key: 'tokenExp');
  }

  // Método para armazenar o token
  static Future<void> storeToken(String tokenValue) async {
    await _storage.write(key: 'token', value: tokenValue);
  }

  // Método para obter o token
  static Future<String?> getToken() async {
    return await _storage.read(key: 'token');
  }

  // Método para deletar o token
  static Future<void> deleteToken() async {
    await _storage.delete(key: 'token');
  }

  // Método para armazenar o token decodificado
  static Future<void> storeDecodedToken(Map<String, dynamic> decoded) async {
    String jsonString = jsonEncode(decoded);
    await _storage.write(key: 'decodedToken', value: jsonString);
  }

  // Método para obter o token decodificado
  static Future<Map<String, dynamic>?> getDecodedToken() async {
    String? jsonString = await _storage.read(key: 'decodedToken');
    if (jsonString != null) {
      return jsonDecode(jsonString);
    }
    return null;
  }

  // Método para deletar o token decodificado
  static Future<void> deleteDecodedToken() async {
    await _storage.delete(key: 'decodedToken');
  }

  // Método para armazenar o token decodificado
  static Future<void> storeCredentials(String credentials) async {
    await _storage.write(key: 'credentials', value: credentials);
  }

  static Future<String?> getCredentials() async {
    return await _storage.read(key: 'credentials');
  }

  // Método para deletar o token
  static Future<void> deleteCredentials() async {
    await _storage.delete(key: 'credentials');
  }

  // Método para armazenar o token
  static Future<void> storeCod(String cod) async {
    await _storage.write(key: 'cod', value: cod);
  }

  // Método para obter o token
  static Future<String?> getCod() async {
    return await _storage.read(key: 'cod');
  }

  // Método para deletar o token
  static Future<void> deletecod() async {
    await _storage.delete(key: 'cod');
  }
}
