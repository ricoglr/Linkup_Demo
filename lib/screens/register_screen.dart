import 'package:flutter/material.dart';
import 'package:linkup/screens/login_screen.dart';
import 'package:linkup/widgets/custom__textfield.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;

  // Form anahtarı ile form doğrulama kontrolü
  final _formKey = GlobalKey<FormState>();

  // TextField controller'ları
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // Üst bölüm - Başlık ve açıklama
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(24),
            color: const Color(0xFF2F3E46),
            child: SafeArea(
              bottom: false,
              child: Column(
                children: [
                  const SizedBox(height: 40),
                  const Text(
                    'Hesap Oluştur',
                    style: TextStyle(
                      fontSize: 34,
                      height: 1.2,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Bilgilerinizi girerek üye olun',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white70,
                    ),
                  ),
                  const SizedBox(height: 30),
                ],
              ),
            ),
          ),

          // Alt bölüm - Kayıt formu
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(22),
              decoration: const BoxDecoration(
                color: Colors.white,
              ),
              child: SingleChildScrollView(),
            ),
          ),
        ],
      ),
    );
  }
}

// Sosyal Medya ile Bağlanma Butonları Widget'ı
Widget _socialButton({
  required IconData icon,
  required String label,
  required VoidCallback onTap,
}) {
  return InkWell(
    onTap: onTap,
    borderRadius: BorderRadius.circular(8),
    child: Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 12,
      ),
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.grey[300]!,
          width: 1,
        ),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: 24,
            color: Colors.grey.shade700,
          ),
          const SizedBox(width: 8),
          Flexible(
            child: Text(
              label,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey.shade700,
                fontWeight: FontWeight.w500,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    ),
  );
}
