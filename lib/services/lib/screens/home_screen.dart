import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import '../services/api_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String _locationStatus = "Konum henüz alınmadı";
  bool _isLoading = false;

  // Gerçek GPS Konumunu Alma ve İzinleri Kontrol Etme Fonksiyonu
  Future<void> _getCurrentLocationAndSend() async {
    setState(() {
      _isLoading = true;
      _locationStatus = "Konum izinleri kontrol ediliyor...";
    });

    bool serviceEnabled;
    LocationPermission permission;

    // 1. Cihazın konum servisi açık mı kontrol et
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      setState(() {
        _locationStatus = "Lütfen telefonun konum (GPS) servisini açın.";
        _isLoading = false;
      });
      return;
    }

    // 2. Konum izin durumunu kontrol et
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        setState(() {
          _locationStatus = "Konum izni reddedildi.";
          _isLoading = false;
        });
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      setState(() {
        _locationStatus = "Konum izni kalıcı olarak reddedilmiş. Ayarlardan açmalısın.";
        _isLoading = false;
      });
      return;
    }

    // 3. İzinler tamamsa anlık gerçek koordinatı al
    setState(() {
      _locationStatus = "GPS uydularından konum alınıyor...";
    });

    try {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      setState(() {
        _locationStatus = "Enlem: ${position.latitude}\nBoylam: ${position.longitude}\nBackend'e gönderiliyor...";
      });

      // 4. FastAPI Backend'e gerçek koordinatları gönder
      // (Burada ApiService üzerinden backend endpoint'ine bağlanıyoruz)
      bool success = await ApiService.sendLocation(position.latitude, position.longitude);

      if (success) {
        setState(() {
          _locationStatus = "Enlem: ${position.latitude}\nBoylam: ${position.longitude}\n Başarıyla Backend'e iletildi!";
          _isLoading = false;
        });
      } else {
        setState(() {
          _locationStatus = "Konum alındı ancak Backend'e gönderilemedi.";
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _locationStatus = "Hata oluştu: $e";
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("HemenKurye - Canlı Konum"),
        backgroundColor: Colors.orange,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Icon(
              Icons.location_on,
              size: 80,
              color: Colors.orange,
            ),
            const SizedBox(height: 24),
            Text(
              _locationStatus,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 40),
            ElevatedButton(
              onPressed: _isLoading ? null : _getCurrentLocationAndSend,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: _isLoading
                  ? const CircularProgressIndicator(color: Colors.white)
                  : const Text(
                      "Konumu Al ve Siparişi Başlat",
                      style: TextStyle(fontSize: 16, color: Colors.white),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
