import 'package:flutter/material.dart';
import 'database_helper.dart'; // Yerel veritabanı bağlayıcımız

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await DatabaseHelper.instance.database;

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

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  // YEREL GİRİŞ YAPMA
  Future<void> _girisYap() async {
    final email = loginEmailController.text.trim();
    final password = loginPasswordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Lütfen tüm alanları doldurun")),
      );
      return;
    }

    try {
      final user = await DatabaseHelper.instance.loginUser(email, password);
      if (user != null) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => HomeScreen(kuryeData: user)),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("E-posta veya şifre hatalı!")),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Giriş hatası: $e")),
      );
    }
  }

  // YEREL KAYIT OLMA
  Future<void> _kayitOl() async {
    final name = regNameController.text.trim();
    final email = regEmailController.text.trim();
    final phone = regPhoneController.text.trim();
    final password = regPasswordController.text.trim();

    if (name.isEmpty || email.isEmpty || phone.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Lütfen tüm alanları doldurun")),
      );
      return;
    }

    try {
      Map<String, dynamic> row = {
        'name': name,
        'email': email,
        'phone': phone,
        'password': password,
      };

      await DatabaseHelper.instance.insertUser(row);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Kayıt başarılı! Şimdi giriş yapabilirsiniz.")),
      );

      // Kayıttan sonra otomatik olarak giriş sekmesine at ve emaili yaz
      setState(() {
        _tabController.index = 0;
        loginEmailController.text = email;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Kayıt hatası: $e")),
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
                const Text("Kurye Saha Operasyon Paneli (Offline)", style: TextStyle(fontSize: 12, color: Colors.grey)),
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
                  height: 300,
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
                      SingleChildScrollView(
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
class HomeScreen extends StatelessWidget {
  final Map<String, dynamic> kuryeData;
  const HomeScreen({Key? key, required this.kuryeData}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Hoş geldin, ${kuryeData["name"]}"),
        backgroundColor: const Color(0xFFD32F2F),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const AuthScreen()),
              );
            },
          )
        ],
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.offline_bolt, size: 80, color: Colors.green),
              const SizedBox(height: 20),
              const Text(
                "Yerel Veritabanı ile Çevrimdışı Mod",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              Text(
                "Kayıtlı E-posta: ${kuryeData["email"]}\nTelefon: ${kuryeData["phone"]}",
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 16, color: Colors.grey),
              ),
              const SizedBox(height: 30),
              const Text(
                "Artık tablet üzerinde internete ihtiyaç duymadan verilerini güvenle saklayabilir ve giriş yapabilirsin!",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 14),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
