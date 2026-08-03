import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

// Not: Android Emülatör için localhost adresi 10.0.2.2'dir.
// Gerçek cihaz testi için bilgisayarının yerel IP adresini yazabilirsin.
const String baseUrl = "http://10.0.2.2:8081";

void main() {
  runApp(const HemenKuryeApp());
}

class HemenKuryeApp extends StatelessWidget {
  const HemenKuryeApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'HemenKurye Kurye Paneli',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.red,
        scaffoldBackgroundColor: const Color(0xFFF8FAFC),
        fontFamily: 'sans-serif',
      ),
      home: const AuthScreen(),
    );
  }
}

// --- GİRİŞ VE KAYIT EKRANI ---
class AuthScreen extends StatefulWidget {
  const AuthScreen({Key? key}) : super(key: key);

  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  final TextEditingController loginEmailController = TextEditingController();
  final TextEditingController loginPasswordController = TextEditingController();

  final TextEditingController regNameController = TextEditingController();
  final TextEditingController regEmailController = TextEditingController();
  final TextEditingController regPhoneController = TextEditingController();
  final TextEditingController regPasswordController = TextEditingController();
  final TextEditingController regOtpController = TextEditingController();

  bool isRegisteringStep2 = false;
  String registeredEmail = "";

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  Future<void> _girisYap() async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/api/kurye/login'),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "email": loginEmailController.text.trim(),
          "password": loginPasswordController.text.trim(),
        }),
      );

      final data = jsonDecode(response.body);
      if (response.statusCode == 200) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => HomeScreen(kuryeData: data["user"])),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(data["detail"] ?? "Giriş başarısız")),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Bağlantı hatası: $e")),
      );
    }
  }

  Future<void> _kayitOl() async {
    try {
      // Not: Flutter'da ilk aşamada multipart dosya gönderimi için HTTP MultipartRequest kullanılır.
      // Şimdilik hızlıca test/altyapı için temel alanları bağlıyoruz.
      var request = http.MultipartRequest('POST', Uri.parse('$baseUrl/api/kurye/register'));
      request.fields['name'] = regNameController.text.trim();
      request.fields['email'] = regEmailController.text.trim();
      request.fields['phone'] = regPhoneController.text.trim();
      request.fields['password'] = regPasswordController.text.trim();
      
      // Test amaçlı boş bir byte alanı ekleyebiliriz veya dosya seçme eklenebilir
      request.files.add(http.MultipartFile.fromBytes(
        'profil_foto', 
        [0, 1, 2, 3], 
        filename: 'profil.jpg'
      ));

      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);
      var data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        setState(() {
          registeredEmail = regEmailController.text.trim();
          isRegisteringStep2 = true;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Kayıt başarılı! E-postanıza gelen kodu girin.")),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(data["detail"] ?? "Kayıt hatası")),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Hata: $e")),
      );
    }
  }

  Future<void> _kodDogrula() async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/api/kurye/verify-email'),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "email": registeredEmail,
          "otp_code": regOtpController.text.trim(),
        }),
      );

      final data = jsonDecode(response.body);
      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Doğrulama başarılı! Giriş yapabilirsiniz.")),
        );
        setState(() {
          isRegisteringStep2 = false;
          _tabController.index = 0;
          loginEmailController.text = registeredEmail;
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(data["detail"] ?? "Doğrulama başarısız")),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Hata: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Container(
            constraints: const BoxConstraints(maxWidth: 400),
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, spreadRadius: 2)
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  "🟡🔴 HEMENKURYE",
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Color(0xFFD32F2F)),
                ),
                const SizedBox(height: 6),
                const Text("Kurye Saha Operasyon Paneli", style: TextStyle(fontSize: 12, color: Colors.grey)),
                const SizedBox(height: 20),
                TabBar(
                  controller: _tabController,
                  labelColor: Colors.white,
                  unselectedLabelColor: Colors.grey,
                  indicator: BoxDecoration(
                    color: const Color(0xFFD32F2F),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  tabs: const [
                    Tab(text: "Oturum Aç"),
                    Tab(text: "Kayıt Ol"),
                  ],
                ),
                const SizedBox(height: 20),
                SizedBox(
                  height: 320,
                  child: TabBarView(
                    controller: _tabController,
                    children: [
                      // Giriş Sekmesi
                      Column(
                        children: [
                          TextField(
                            controller: loginEmailController,
                            decoration: const InputDecoration(labelText: "E-posta", border: OutlineInputBorder()),
                          ),
                          const SizedBox(height: 12),
                          TextField(
                            controller: loginPasswordController,
                            obscureText: true,
                            decoration: const InputDecoration(labelText: "Şifre", border: OutlineInputBorder()),
                          ),
                          const SizedBox(height: 20),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFFD32F2F),
                              minimumSize: const Size.fromHeight(50),
                            ),
                            onPressed: _girisYap,
                            child: const Text("Giriş Yap", style: TextStyle(color: Colors.white)),
                          ),
                        ],
                      ),
                      // Kayıt Sekmesi
                      isRegisteringStep2
                          ? Column(
                              children: [
                                const Text("E-postaya gelen 6 haneli kodu girin:", style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                                const SizedBox(height: 10),
                                TextField(
                                  controller: regOtpController,
                                  textAlign: TextAlign.center,
                                  maxLength: 6,
                                  decoration: const InputDecoration(border: OutlineInputBorder(), hintText: "123456"),
                                ),
                                const SizedBox(height: 10),
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.black,
                                    minimumSize: const Size.fromHeight(50),
                                  ),
                                  onPressed: _kodDogrula,
                                  child: const Text("Kodu Doğrula", style: TextStyle(color: Colors.white)),
                                ),
                              ],
                            )
                          : SingleChildScrollView(
                              child: Column(
                                children: [
                                  TextField(controller: regNameController, decoration: const InputDecoration(labelText: "Ad Soyad", isDense: true)),
                                  const SizedBox(height: 8),
                                  TextField(controller: regEmailController, decoration: const InputDecoration(labelText: "E-posta", isDense: true)),
                                  const SizedBox(height: 8),
                                  TextField(controller: regPhoneController, decoration: const InputDecoration(labelText: "Telefon", isDense: true)),
                                  const SizedBox(height: 8),
                                  TextField(controller: regPasswordController, obscureText: true, decoration: const InputDecoration(labelText: "Şifre", isDense: true)),
                                  const SizedBox(height: 12),
                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: const Color(0xFFD32F2F),
                                      minimumSize: const Size.fromHeight(45),
                                    ),
                                    onPressed: _kayitOl,
                                    child: const Text("Kayıt Ol", style: TextStyle(color: Colors.white)),
                                  ),
                                ],
                              ),
                            ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// --- ANA PANEL / SİPARİŞLER EKRANI ---
class HomeScreen extends StatefulWidget {
  final Map<String, dynamic> kuryeData;
  const HomeScreen({Key? key, required this.kuryeData}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List siparisler = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _siparisleriGetir();
  }

  Future<void> _siparisleriGetir() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/api/kurye/siparisler?kurye_email=${widget.kuryeData["email"]}'),
      );
      if (response.statusCode == 200) {
        setState(() {
          siparisler = jsonDecode(response.body);
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Hoş geldin, ${widget.kuryeData["name"]}"),
        backgroundColor: const Color(0xFFD32F2F),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : siparisler.isEmpty
              ? const Center(child: Text("Atama bekleyen veya aktif sipariş bulunmuyor."))
              : ListView.builder(
                  itemCount: siparisler.length,
                  itemBuilder: (context, index) {
                    var s = siparisler[index];
                    return Card(
                      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: Colors.red[100],
                          child: const Text("📦"),
                        ),
                        title: Text("Gönderi #${s["id"]} - ${s["tutar"]} ₺"),
                        subtitle: Text("Alım: ${s["cikis_adres"]}\nVarış: ${s["alici_adres"]}\nDurum: ${s["durum"]}"),
                        isThreeLine: true,
                      ),
                    );
                  },
                ),
    );
  }
}
