import 'package:flutter/material.dart';
import 'package:linkup/screens/forgot_password_screen.dart';
import 'package:linkup/screens/profile_screen.dart';
import 'package:linkup/screens/register_screen.dart';
import 'package:linkup/widgets/custom__textfield.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  // Şifre görünürlüğü kontrolü için değişken
  bool _isPasswordVisible = false;

  // Email ve şifre alanları için TextEditingController'lar
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  // "Beni Hatırla" seçeneği için değişken
  bool _rememberMe = false;

  @override
  void dispose() {
    // Bellek yönetimi için controller'ları dispose ediyoruz
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // Üst Kısım - Renkli Arka Plan
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(22),
            color: const Color(0xFF2F3E46),
            child: SafeArea(
              bottom: false,
              child: Column(
                children: [
                  const SizedBox(height: 50),
                  // Logo veya Uygulama İsmi
                  const Text(
                    'LINK UP',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 34,
                      height: 2,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 30),
                  const Text(
                    'Giriş Yap',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 5),
                  const Text(
                    'Bilgilerinizi Girerek Giriş Yapın',
                    style: TextStyle(
                      fontSize: 15,
                      color: Colors.white70,
                    ),
                  ),
                  const SizedBox(height: 10),
                ],
              ),
            ),
          ),

          // Alt Kısım - Beyaz Arka Plan
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(30),
              color: Colors.white,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: 10),
                    // Email TextField
                    CustomTextField(
                      labelText: 'Email',
                      hintText: 'mail@example.com',
                      controller: _emailController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Email adresi gerekli';
                        }
                        if (!value.contains('@')) {
                          return 'Geçerli bir email adresi girin';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),
                    // Şifre TextField
                    CustomTextField(
                      labelText: 'Şifre',
                      hintText: '••••••••',
                      controller: _passwordController,
                      suffixIcon: IconButton(
                        icon: Icon(
                          _isPasswordVisible
                              ? Icons.visibility_outlined
                              : Icons.visibility_off_outlined,
                          color: Colors.grey.shade400,
                        ),
                        onPressed: () {
                          setState(() {
                            _isPasswordVisible = !_isPasswordVisible;
                          });
                        },
                      ),
                      isPassword: !_isPasswordVisible,
                    ),
                    const SizedBox(height: 20),
                    // Beni Hatırla ve Şifremi Unuttum
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Checkbox(
                              value: _rememberMe,
                              onChanged: (value) {
                                setState(() {
                                  _rememberMe = value ?? false;
                                });
                              },
                              fillColor:
                                  MaterialStateProperty.resolveWith<Color>(
                                (Set<MaterialState> states) {
                                  if (states.contains(MaterialState.selected)) {
                                    return const Color(0xFF84A98C);
                                  }
                                  return Colors.white;
                                },
                              ),
                              checkColor: Colors.white,
                            ),
                            Text(
                              'Beni Hatırla',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                color: Colors.grey.shade700,
                              ),
                            ),
                          ],
                        ),

                        // Şifremi Unuttum Butonu
                        TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ForgotPasswordScreen(),
                              ),
                            );
                          },
                          child: Text(
                            'Şifremi Unuttum',
                            style: TextStyle(
                              color: Colors.grey.shade700,
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 30),
                    // Giriş Yap Butonu
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ProfileScreen(),
                          ),
                        );
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
                        'Giriş Yap',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    const SizedBox(height: 26),
                    // Alternatif ile devam et
                    Row(
                      children: [
                        Expanded(
                          child: Divider(color: Colors.grey.shade300),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Text(
                            'ya da',
                            style: TextStyle(
                              color: Colors.grey.shade600,
                              fontSize: 16,
                            ),
                          ),
                        ),
                        Expanded(
                          child: Divider(color: Colors.grey.shade300),
                        ),
                      ],
                    ),
                    const SizedBox(height: 30),
                    // Sosyal Medya Giriş Butonları
                    Row(
                      children: [
                        Expanded(
                          child: _socialButton(
                            icon: Icons.g_mobiledata_rounded,
                            label: 'Google',
                            onTap: () {},
                          ),
                        ),
                        const SizedBox(width: 20),
                        Expanded(
                          child: _socialButton(
                            icon: Icons.facebook,
                            label: 'Facebook',
                            onTap: () {},
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 60),
                    // Kayıt Ol Linki
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Hesabın yok mu? ',
                          style: TextStyle(
                            color: Colors.grey.shade600,
                            fontSize: 16,
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => RegisterScreen(),
                              ),
                            );
                          },
                          child: const Text(
                            'Kayıt Ol',
                            style: TextStyle(
                              color: Color(0xFF2F3E46),
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Sosyal medya giriş butonu widget'ı
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
          color: Colors.grey.shade300,
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
