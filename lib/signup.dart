import 'package:flutter/material.dart';
import 'services/api_service.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  String? userType = 'Traveler';

  // 1. Khai báo các Controller
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _countryController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  // 2. Hàm xử lý Đăng ký
  Future<void> _handleSignUp() async {
    // Kiểm tra mật khẩu khớp nhau
    if (_passwordController.text != _confirmPasswordController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Mật khẩu xác nhận không khớp!"), backgroundColor: Colors.orange),
      );
      return;
    }

    try {
      // Gọi ApiService để tạo tài khoản
      await ApiService.signup(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
        firstName: _firstNameController.text.trim(),
        lastName: _lastNameController.text.trim(),
        country: _countryController.text.trim(),
        userType: userType ?? 'Traveler',
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Đăng ký thành công!"), backgroundColor: Colors.green),
        );
        Navigator.pop(context); // Quay lại trang Sign In
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Lỗi: ${e.toString()}"), backgroundColor: Colors.red),
      );
    }
  }

  @override
  void dispose() {
    // Giải phóng bộ nhớ của các controller
    _firstNameController.dispose();
    _lastNameController.dispose();
    _countryController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header (Giữ nguyên phần Stack cũ của bạn)
            Stack(
              children: [
                Container(
                  height: 200,
                  decoration: const BoxDecoration(
                    color: Color(0xFF00D1B2),
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.elliptical(200, 30),
                      bottomRight: Radius.elliptical(200, 30),
                    ),
                  ),
                ),
                Positioned(
                  top: 60,
                  left: 30,
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(Icons.face, color: Color(0xFF00D1B2), size: 40),
                  ),
                ),
              ],
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),
                  const Text('Sign Up', style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 20),

                  // Radio Buttons
                  Row(
                    children: [
                      Radio<String>(
                        value: 'Traveler',
                        groupValue: userType,
                        activeColor: const Color(0xFF00D1B2),
                        onChanged: (value) => setState(() => userType = value),
                      ),
                      const Text('Traveler'),
                      const SizedBox(width: 20),
                      Radio<String>(
                        value: 'Guide',
                        groupValue: userType,
                        activeColor: const Color(0xFF00D1B2),
                        onChanged: (value) => setState(() => userType = value),
                      ),
                      const Text('Guide'),
                    ],
                  ),

                  // First Name & Last Name
                  Row(
                    children: [
                      Expanded(child: _buildTextField("First Name", "Yoo", _firstNameController)),
                      const SizedBox(width: 20),
                      Expanded(child: _buildTextField("Last Name", "Jin", _lastNameController)),
                    ],
                  ),
                  
                  _buildTextField("Country", "Country", _countryController),
                  _buildTextField("Email", "Type email", _emailController),
                  _buildTextField("Password", "Type password", _passwordController, isPassword: true),
                  const Text("Password has more than 6 letters", style: TextStyle(color: Colors.grey, fontSize: 12)),
                  _buildTextField("Confirm Password", "••••••", _confirmPasswordController, isPassword: true),

                  const SizedBox(height: 20),
                  // Nút Sign Up
                  SizedBox(
                    width: double.infinity,
                    height: 55,
                    child: ElevatedButton(
                      onPressed: _handleSignUp, // Gọi hàm xử lý thực tế
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF00D1B2),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                      child: const Text('SIGN UP', style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
                  ),
                  const SizedBox(height: 30),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Cập nhật Widget _buildTextField để nhận controller
  Widget _buildTextField(String label, String hint, TextEditingController controller, {bool isPassword = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
          TextField(
            controller: controller, // Gán controller vào đây
            obscureText: isPassword,
            decoration: InputDecoration(
              hintText: hint,
              enabledBorder: const UnderlineInputBorder(borderSide: BorderSide(color: Colors.grey, width: 0.5)),
              focusedBorder: const UnderlineInputBorder(borderSide: BorderSide(color: Color(0xFF00D1B2))),
            ),
          ),
        ],
      ),
    );
  }
}