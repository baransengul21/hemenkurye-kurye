import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: const Color(0xFFD32F2F),
        elevation: 0,
        title: const Text(
          '🚨 HEMENKURYE',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white, letterSpacing: -1),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.support_agent, color: Colors.white),
            onPressed: () {
              // Canlı destek modal veya yönlendirmesi buraya gelecek
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // İstatistik Kartları Üst Kısım
            Row(
              children: [
                _buildStatCard('Aktif Kurye', '142', '● Bölgede', Colors.red),
                const SizedBox(width: 12),
                _buildStatCard('Ort. Teslim', '32 Dk', '⚡ Süper Hız', Colors.blue),
                const SizedBox(width: 12),
                _buildStatCard('Başarı', '%99.4', 'Güvenli', Colors.green),
              ],
            ),
            const SizedBox(height: 20),

            // Kurumsal Bilgilendirme Banner
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF1F2937), Color(0xFF111827)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: const Text(
                            'Kurumsal Avantaj',
                            style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'E-Ticaret Entegrasyonları Başladı',
                          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                        const SizedBox(height: 4),
                        const Text(
                          'API desteğiyle siparişleriniz doğrudan kurye ekibimize düşer.',
                          style: TextStyle(color: Colors.white75, fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                  const Text('📦', style: TextStyle(fontSize: 40)),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Hizmet Sınıfı Seçimi Başlığı
            const Text(
              'Hizmet Sınıfı Seçin',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF4B5563)),
            ),
            const SizedBox(height: 12),

            // Hizmet Kartları
            _buildServiceCard(
              context,
              title: '🚀 Hızlı Ekspres (45 Dakika)',
              description: 'En yakın saha kuryesi doğrudan adresinize yönlendirilir.',
              badge: 'Öncelikli',
              isHighlighted: true,
              onTap: () {
                // Yeni kurye çağır sayfasına servis türü ile yönlendir
              },
            ),
            const SizedBox(height: 10),
            _buildServiceCard(
              context,
              title: '⏱️ Standart Dağıtım (1-2 Saat)',
              description: 'Esnek zamanlı ve bütçe dostu kurye seçeneği.',
              badge: 'Standart',
              isHighlighted: false,
              onTap: () {},
            ),
            const SizedBox(height: 10),
            _buildServiceCard(
              context,
              title: '📅 Ekonomik Planlı Dağıtım',
              description: 'Gün içi toplanan paketleriniz toplu ve ekonomik ulaştırılır.',
              badge: '%30 İndirimli',
              isHighlighted: false,
              onTap: () {},
            ),
            const SizedBox(height: 24),

            // Aktif Sevkiyatlarım Başlığı
            const Text(
              'Aktif Sevkiyatlarım',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF4B5563)),
            ),
            const SizedBox(height: 12),

            // Aktif Sevkiyat Liste Kutusu (Python backend'den çekilecek veriler için alan)
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFFE2E8F0)),
              ),
              child: const Center(
                child: Text(
                  'Aktif sevkiyatınız bulunmuyor. Yeni kurye çağırarak başlayın.',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Color(0xFF9CA3AF), fontSize: 13),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // İstatistik Kartı Widget Yardımcısı
  Widget _buildStatCard(String title, String value, String subtitle, Color subColor) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.03),
              blurRadius: 6,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          children: [
            Text(title, style: const TextStyle(fontSize: 11, color: Color(0xFF6B7280), fontWeight: FontWeight.w600)),
            const SizedBox(height: 4),
            Text(value, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF1F2937))),
            const SizedBox(height: 2),
            Text(subtitle, style: TextStyle(fontSize: 10, color: subColor, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }

  // Hizmet Kartı Widget Yardımcısı
  Widget _buildServiceCard(BuildContext context, {required String title, required String description, required String badge, required bool isHighlighted, required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isHighlighted ? const Color(0xFFD32F2F) : const Color(0xFFE2E8F0),
            width: isHighlighted ? 1.5 : 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.02),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.between,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Color(0xFF1F2937))),
                  const SizedBox(height: 4),
                  Text(description, style: const TextStyle(fontSize: 12, color: Color(0xFF6B7280))),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: isHighlighted ? const Color(0xFFFFEBEE) : const Color(0xFFF1F5F9),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                badge,
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  color: isHighlighted ? const Color(0xFFD32F2F) : const Color(0xFF4B5563),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
