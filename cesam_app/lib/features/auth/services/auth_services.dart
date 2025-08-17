import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  // Utilise 10.0.2.2 pour l'émulateur Android
  static const String baseUrl = 'http://localhost:3000/api';

  // Connexion utilisateur
  static Future<Map<String, dynamic>> login(
    String email,
    String password,
  ) async {
    try {
      final url = Uri.parse('$baseUrl/users/login');
      final body = jsonEncode({"email": email, "mot_de_passe": password});

      print("📤 Envoi à $url - Body: $body");

      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: body,
      );

      print("📥 Réponse: ${response.statusCode} - ${response.body}");

      final data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        return data;
      } else if (response.statusCode == 401) {
        return {
          "success": false,
          "message": data['message'] ?? "Email ou mot de passe incorrect",
        };
      } else {
        return {
          "success": false,
          "message": "Erreur serveur (${response.statusCode})",
        };
      }
    } catch (e) {
      print("🚨 Erreur réseau: $e");
      return {
        "success": false,
        "message": "Impossible de se connecter au serveur",
      };
    }
  }

  // Inscription
  static Future<Map<String, dynamic>> register({
    required String lastName,
    required String firstName,
    required String email,
    required String username,
    required String phone,
    required String password,
    required String birthDate,
    required String gender,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/users/register'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'lastName': lastName,
          'firstName': firstName,
          'email': email,
          'username': username,
          'phone': phone,
          'password': password,
          'birthDate': birthDate,
          'gender': gender,
        }),
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 201 || response.statusCode == 200) {
        return {'success': true, 'data': data};
      } else {
        return {
          'success': false,
          'message': data['message'] ?? 'Erreur d\'inscription',
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'Erreur de connexion au serveur: $e',
      };
    }
  }

  // Rafraîchir le token
  static Future<Map<String, dynamic>> refreshToken() async {
    try {
      final token = await getToken();
      final response = await http.post(
        Uri.parse('$baseUrl/users/refresh-token'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        if (data['accessToken'] != null) {
          await _saveToken(data['accessToken']);
        }
        return {'success': true, 'data': data};
      } else {
        return {
          'success': false,
          'message': data['message'] ?? 'Erreur de refresh',
        };
      }
    } catch (e) {
      return {'success': false, 'message': 'Erreur serveur: $e'};
    }
  }

  // Déconnexion
  static Future<void> logout() async {
    try {
      final token = await getToken();
      if (token != null) {
        await http.post(
          Uri.parse('$baseUrl/users/revoke-tokens'),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token',
          },
        );
      }
    } catch (_) {}
    await _removeToken();
  }

  // Gestion du token en local
  static Future<void> _saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('access_token', token);
  }

  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('access_token');
  }

  static Future<void> _removeToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('access_token');
  }

  static Future<bool> isLoggedIn() async {
    final token = await getToken();
    return token != null;
  }

  // Envoi de l'OTP par email
  // Dans AuthService
  static Future<Map<String, dynamic>> sendOtp(String email) async {
    try {
      final url = Uri.parse('$baseUrl/users/send-otp');
      final body = jsonEncode({"email": email});

      print("📤 Envoi OTP à $url - Email: $email");

      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: body,
      );

      print("📥 Réponse OTP: ${response.statusCode} - ${response.body}");

      final data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        return data;
      } else {
        return {
          "success": false,
          "message": data['message'] ?? "Erreur lors de l'envoi du code OTP",
        };
      }
    } catch (e) {
      print("🚨 Erreur réseau OTP: $e");
      return {
        "success": false,
        "message": "Impossible de se connecter au serveur",
      };
    }
  }

  // Dans auth_services.dart
  static Future<void> saveToken(String token) async {
    // Changé de _saveToken à saveToken
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('access_token', token);
  }
}
