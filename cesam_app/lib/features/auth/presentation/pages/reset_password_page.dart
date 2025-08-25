import 'package:flutter/material.dart';
import '../../services/auth_services.dart';

class ResetPasswordPage extends StatefulWidget {
  final String email;

  const ResetPasswordPage({super.key, required this.email});

  @override
  State<ResetPasswordPage> createState() => _ResetPasswordPageState();
}

class _ResetPasswordPageState extends State<ResetPasswordPage> {
  final otpController = TextEditingController();
  final newPasswordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  bool isLoading = false;
  bool obscureNewPassword = true;
  bool obscureConfirmPassword = true;

  Future<void> _resetPassword() async {
    if (otpController.text.isEmpty || 
        newPasswordController.text.isEmpty || 
        confirmPasswordController.text.isEmpty) {
      _showSnackBar('Veuillez remplir tous les champs', isError: true);
      return;
    }

    if (newPasswordController.text != confirmPasswordController.text) {
      _showSnackBar('Les mots de passe ne correspondent pas', isError: true);
      return;
    }

    setState(() => isLoading = true);

    try {
      final result = await AuthService.resetPassword(
        email: widget.email,
        otp: otpController.text,
        newPassword: newPasswordController.text,
      );

      if (result['success']) {
        _showSnackBar('Mot de passe réinitialisé avec succès');
        Navigator.popUntil(context, (route) => route.isFirst);
      } else {
        _showSnackBar(result['message'], isError: true);
      }
    } catch (e) {
      _showSnackBar('Erreur inattendue: $e', isError: true);
    } finally {
      setState(() => isLoading = false);
    }
  }

  void _showSnackBar(String message, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.red : Colors.green,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Nouveau mot de passe'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Réinitialisation pour ${widget.email}',
              style: const TextStyle(fontSize: 16, color: Colors.grey),
            ),
            const SizedBox(height: 32),
            
            // OTP field
            const Text('Code OTP', style: TextStyle(fontWeight: FontWeight.w500)),
            const SizedBox(height: 8),
            TextField(
              controller: otpController,
              keyboardType: TextInputType.number,
              enabled: !isLoading,
              decoration: InputDecoration(
                hintText: '123456',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
              ),
            ),
            const SizedBox(height: 16),
            
            // New password field
            const Text('Nouveau mot de passe', style: TextStyle(fontWeight: FontWeight.w500)),
            const SizedBox(height: 8),
            TextField(
              controller: newPasswordController,
              obscureText: obscureNewPassword,
              enabled: !isLoading,
              decoration: InputDecoration(
                hintText: '••••••••',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                suffixIcon: IconButton(
                  icon: Icon(obscureNewPassword ? Icons.visibility_off : Icons.visibility),
                  onPressed: () => setState(() => obscureNewPassword = !obscureNewPassword),
                ),
              ),
            ),
            const SizedBox(height: 16),
            
            // Confirm password field
            const Text('Confirmer le mot de passe', style: TextStyle(fontWeight: FontWeight.w500)),
            const SizedBox(height: 8),
            TextField(
              controller: confirmPasswordController,
              obscureText: obscureConfirmPassword,
              enabled: !isLoading,
              decoration: InputDecoration(
                hintText: '••••••••',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                suffixIcon: IconButton(
                  icon: Icon(obscureConfirmPassword ? Icons.visibility_off : Icons.visibility),
                  onPressed: () => setState(() => obscureConfirmPassword = !obscureConfirmPassword),
                ),
              ),
            ),
            const SizedBox(height: 32),
            
            // Reset button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: isLoading ? null : _resetPassword,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1F5AD2),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                ),
                child: isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text('Réinitialiser le mot de passe'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}