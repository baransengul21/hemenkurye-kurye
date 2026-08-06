import 'http/http.dart' as http; // İleride API istekleri için kullanacağız
import 'dart:convert';

class ApiService {
  // Python backend adresimiz buraya gelecek
  final String baseUrl = "http://10.0.2.2:8000"; 

  // Havuzdaki siparişleri çekme metodu
  Future<void> getOrders() async {
    // Kodlar buraya eklenecek
  }
}
