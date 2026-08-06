import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  // Android emülatör için localhost adresi (Gerçek cihazda bilgisayarın IP'si yazılacak)
  static const String baseUrl = "http://10.0.2.2:8080";

  // 1. Kullanıcı Giriş Metodu
  static Future<Map<String, dynamic>?> login(String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/api/login'),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"email": email, "password": password}),
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        return null;
      }
    } catch (e) {
      print("Giriş Hatası: $e");
      return null;
    }
  }

  // 2. Aktif Siparişleri Çekme Metodu
  static Future<List<dynamic>> getOrders(String email) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/api/siparislerim?email=$email'),
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        return [];
      }
    } catch (e) {
      print("Siparişleri Çekme Hatası: $e");
      return [];
    }
  }

  // 3. Fiyat Hesaplama Metodu
  static Future<Map<String, dynamic>?> calculatePrice({
    required double cikisLat,
    required double cikisLon,
    required double aliciLat,
    required double aliciLon,
    required String hizmetTipi,
    required String arac,
    required int agirlik,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/api/fiyat-hesapla'),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "cikis_lat": cikisLat,
          "cikis_lon": cikisLon,
          "alici_lat": aliciLat,
          "alici_lon": aliciLon,
          "hizmet_tipi": hizmetTipi,
          "arac": arac,
          "agirlik": agirlik,
        }),
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        return null;
      }
    } catch (e) {
      print("Fiyat Hesaplama Hatası: $e");
      return null;
    }
  }
}
