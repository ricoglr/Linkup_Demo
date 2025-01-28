import 'package:flutter/material.dart';
import 'package:linkup/screens/login_screen.dart';
import 'package:linkup/widgets/custom__textfield.dart';

class ForgotPasswordScreen extends StatelessWidget {
  ForgotPasswordScreen({super.key});

  // Email TextField için controller
  final TextEditingController emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF2F3E46),
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
          onPressed: () {
            // Geri butonuna basıldığında LoginScreen'e yönlendirme
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => LoginScreen()));
          },
        ),
      ),
      body: Column(
        children: [
          // Üst bilgi kısmı
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(22),
            color: const Color(0xFF2F3E46),
            child: SafeArea(
              bottom: false,
              child: Column(
                children: [
                  const SizedBox(height: 50),
                  const Text(
                    'Şifremi Unuttum',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'Şifre Sıfırlamak için mail adresinizi girin',
                    style: TextStyle(
                      fontSize: 15,
                      color: Colors.white70,
                    ),
                  ),
                  const SizedBox(height: 50),
                ],
              ),
            ),
          ),
          // Ana içerik kısmı
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(30),
              decoration: const BoxDecoration(
                color: Colors.white,
              ),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: 10),
                    // Email TextField
                    CustomTextField(
                      controller: emailController,
                      labelText: 'Email',
                      hintText: 'mail@example.com',
                    ),
                    const SizedBox(height: 20),
                    // Bağlantı gönder butonu
                    ElevatedButton(
                      onPressed: () {
                        if (emailController.text.isEmpty) {
                          // Email boş bırakılmışsa kullanıcıya hata göster
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Lütfen email adresinizi girin.'),
                            ),
                          );
                          return;
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF84A98C),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        elevation: 0,
                      ),
                      child: const Text(
                        'Bağlantı Gönder',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    const SizedBox(height: 26),
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
