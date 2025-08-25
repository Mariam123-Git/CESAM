import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../services/auth_services.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  bool rememberMe = false;
  bool obscurePassword = true;
  bool isLoading = false;
  bool acceptPolicy = false;
  late SharedPreferences _prefs;

  @override
  void initState() {
    super.initState();
    _initSharedPreferences();
  }

  // Initialiser SharedPreferences et charger les credentials
  Future<void> _initSharedPreferences() async {
    _prefs = await SharedPreferences.getInstance();
    _loadSavedCredentials();
  }

  // Charger les informations sauvegardées
  Future<void> _loadSavedCredentials() async {
    try {
      final savedEmail = _prefs.getString('saved_email') ?? '';
      final shouldRemember = _prefs.getBool('remember_me') ?? false;

      setState(() {
        if (savedEmail.isNotEmpty) emailController.text = savedEmail;
        rememberMe = shouldRemember;
      });
    } catch (e) {
      print('Erreur lors du chargement des credentials: $e');
    }
  }

  // Sauvegarder les informations de connexion
  Future<void> _saveCredentials() async {
    if (rememberMe) {
      await _prefs.setString('saved_email', emailController.text.trim());
      await _prefs.setBool('remember_me', true);
    } else {
      await _prefs.remove('saved_email');
      await _prefs.setBool('remember_me', false);
    }
  }

  // Fonction pour gérer la connexion
  Future<void> _handleLogin() async {
    if (emailController.text.isEmpty || passwordController.text.isEmpty) {
      _showSnackBar('Veuillez remplir tous les champs', isError: true);
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      final result = await AuthService.login(
        emailController.text.trim(),
        passwordController.text,
      );
      
      if (result['success']) {
        // Sauvegarder les credentials si "Remember me" est coché
        await _saveCredentials();
        
        _showSnackBar('Connexion réussie !');
        
        Navigator.pushNamed(
          context,
          '/home',
          arguments: {
            'email': emailController.text.trim(),
            'message': result['message'],
          },
        );
      } else {
        _showSnackBar(result['message'], isError: true);
      }
    } catch (e) {
      _showSnackBar('Erreur inattendue: $e', isError: true);
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  // Fonction pour afficher les messages
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
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF1F5AD2), Color(0xFF5C8FE9)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Header avec bouton retour
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Align(
                  alignment: Alignment.topLeft,
                  child: IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.white),
                    onPressed: () => Navigator.pop(context),
                  ),
                ),
              ),

              // Titre student hop.
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 10),
                child: Text(
                  'student hop.',
                  style: TextStyle(
                    fontSize: 36,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),

              // Container blanc avec le formulaire (scrollable)
              Expanded(
                child: SingleChildScrollView(
                  child: Container(
                    margin: const EdgeInsets.only(top: 30),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(30),
                        topRight: Radius.circular(30),
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 10),
                          const Text(
                            'Welcome Student!',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                          const Text(
                            'Login to continue with StudentHub',
                            style: TextStyle(fontSize: 14, color: Colors.grey),
                          ),
                          const SizedBox(height: 30),

                          // Email field
                          const Text(
                            'Email',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 8),
                          TextField(
                            controller: emailController,
                            keyboardType: TextInputType.emailAddress,
                            enabled: !isLoading,
                            decoration: InputDecoration(
                              hintText: 'exemple@email.com',
                              hintStyle: const TextStyle(color: Colors.grey),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: const BorderSide(
                                  color: Colors.grey,
                                ),
                              ),
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 12,
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),

                          // Password field
                          const Text(
                            'Password',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 8),
                          TextField(
                            controller: passwordController,
                            obscureText: obscurePassword,
                            enabled: !isLoading,
                            decoration: InputDecoration(
                              hintText: '••••••••••••',
                              hintStyle: const TextStyle(color: Colors.grey),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: const BorderSide(
                                  color: Colors.grey,
                                ),
                              ),
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 12,
                              ),
                              suffixIcon: IconButton(
                                icon: Icon(
                                  obscurePassword
                                      ? Icons.visibility_off
                                      : Icons.visibility,
                                  color: Colors.grey,
                                ),
                                onPressed: () {
                                  setState(() {
                                    obscurePassword = !obscurePassword;
                                  });
                                },
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),

                          // Remember me checkbox
                          Row(
                            children: [
                              Checkbox(
                                value: rememberMe,
                                onChanged: isLoading
                                    ? null
                                    : (val) async {
                                        setState(() {
                                          rememberMe = val ?? false;
                                        });
                                        // Sauvegarder immédiatement le choix
                                        await _prefs.setBool('remember_me', val ?? false);
                                        
                                        // Si on décoche, supprimer l'email sauvegardé
                                        if (!(val ?? false)) {
                                          await _prefs.remove('saved_email');
                                        }
                                      },
                                activeColor: const Color(0xFF1F5AD2),
                              ),
                              const Text(
                                'Remember me',
                                style: TextStyle(fontSize: 14),
                              ),
                            ],
                          ),
                          const SizedBox(height: 30),
                          
                          // Login button
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF1F5AD2),
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(25),
                                ),
                                padding: const EdgeInsets.symmetric(
                                  vertical: 16,
                                ),
                              ),
                              onPressed: isLoading ? null : _handleLogin,
                              child: isLoading
                                  ? const SizedBox(
                                      width: 20,
                                      height: 20,
                                      child: CircularProgressIndicator(
                                        color: Colors.white,
                                        strokeWidth: 2,
                                      ),
                                    )
                                  : const Text(
                                      'Log In',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                            ),
                          ),
                          const SizedBox(height: 20),

                          // Forgot password
                          Center(
                            child: TextButton(
                              onPressed: isLoading
                                  ? null
                                  : () {
                                      Navigator.pushNamed(
                                        context,
                                        '/forgot_password',
                                      );
                                    },
                              child: const Text(
                                'Forgot password?',
                                style: TextStyle(
                                  color: Color(0xFF1F5AD2),
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),

                          // Register link
                          Padding(
                            padding: const EdgeInsets.only(bottom: 20),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Text(
                                  "Don't have an account? ",
                                  style: TextStyle(fontSize: 14),
                                ),
                                TextButton(
                                  onPressed: isLoading
                                      ? null
                                      : () => Navigator.pushNamed(
                                          context,
                                          '/signup',
                                        ),
                                  child: const Text(
                                    'Register',
                                    style: TextStyle(
                                      color: Color(0xFF1F5AD2),
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                    ),
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
              ),
            ],
          ),
        ),
      ),
      // Bouton flottant pour le chatbot
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, '/chatbot');
        },
        backgroundColor: Colors.white,
        foregroundColor: const Color(0xFF1F5AD2),
        child: const Icon(Icons.chat_bubble_outline, size: 28),
        elevation: 8,
      ),
    );
  }
}