import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'package:http/http.dart' as http;

class AuthService extends ChangeNotifier {
  final String _baseUrl = 'identitytoolkit.googleapis.com';
  final String _firebaseToken = 'AIzaSyBr-dkmURKIaOdVkAcspeZLHJ8K_PMGyPI';

  final storage = FlutterSecureStorage();
  
  Future<String?> createUser(String email, String password) async {
    final Map<String, dynamic> authData = {
      'email': email,
      'password': password,
      'returnSecureToken': true
    };

    final url =
        Uri.https(_baseUrl, '/v1/accounts:signUp', {'key': _firebaseToken});

    final resp = await http.post(url, body: json.encode(authData));
    final Map<String, dynamic> decodedResp = json.decode(resp.body);

    if (decodedResp.containsKey('idToken')) {
      await storage.write(key: 'token', value: decodedResp['idToken']);
      await storage.write(key: 'uid', value: decodedResp['localId']);
      return null;
    } else {
      return decodedResp['error']['message'];
    }
  }

  Future<String?> login(String email, String password) async {
    final Map<String, dynamic> authData = {
      'email': email,
      'password': password,
      'returnSecureToken': true
    };

    final url = Uri.https(
        _baseUrl, '/v1/accounts:signInWithPassword', {'key': _firebaseToken});

    final resp = await http.post(url, body: json.encode(authData));
    final Map<String, dynamic> decodedResp = json.decode(resp.body);

    //print("=============================================");
    // Imprimir todos los parámetros de la respuesta
    //print("UID almacenado: ${decodedResp['localId']}");
    //print("=============================================");

    if (decodedResp.containsKey('idToken')) {
      //await storage.write(key: 'token', value: decodedResp['idToken']);
      await storage.write(key: 'uid', value: decodedResp['localId']);
      return null;
    } else {
      return decodedResp['error']['message'];
    }
  }

  Future logout() async {
    await storage.delete(key: 'token');
    return;
  }

  Future<String> readUid() async {
    String? uid = await storage.read(key: 'uid');
    //print("=============================================");
    //print("UID recuperado: $uid");
    //print("=============================================");
    return uid ?? '';
  }
}
