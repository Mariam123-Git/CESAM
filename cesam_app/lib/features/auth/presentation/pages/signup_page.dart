import 'package:flutter/material.dart';
import '../../services/auth_services.dart';
import 'package:flutter/services.dart';
import 'package:pdfx/pdfx.dart';
import 'package:flutter/gestures.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final nomController = TextEditingController();
  final prenomController = TextEditingController();
  final emailController = TextEditingController();
  final motDePasseController = TextEditingController();
  final nationaliteController = TextEditingController();
  final domaineEtudesController = TextEditingController();
  final personneAPrevenirController = TextEditingController();
  final numeroTelController = TextEditingController();

  String? selectedNiveauEtudes;
  String? selectedRole;
  bool obscurePassword = true;
  bool isLoading = false;
  bool acceptPolicy = false;

  // Listes pour les dropdowns
  final List<String> niveauxEtudes = [
    'Baccalauréat',
    'Licence',
    'Master',
    'Doctorat',
    'BTS',
    'DUT',
    'Classes préparatoires',
    'École d\'ingénieur',
    'École de commerce',
    'Autre',
  ];

  final List<String> roles = [
    'Étudiant',
    'Enseignant',
    'Administrateur',
    'Autre',
  ];

  // Fonction pour gérer l'inscription
  Future<void> _handleSignup() async {
    if (!_validateForm()) {
      return;
    }

    if (!acceptPolicy) {
      _showSnackBar(
        'Veuillez accepter les politiques de confidentialité',
        isError: true,
      );
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      final result = await AuthService.register(
        nom: nomController.text.trim(),
        prenom: prenomController.text.trim(),
        email: emailController.text.trim(),
        password: motDePasseController.text,
        nationalite: nationaliteController.text.trim(),
        niveauEtudes: selectedNiveauEtudes!,
        domaineEtudes: domaineEtudesController.text.trim(),
        personneAPrevenir: personneAPrevenirController.text.trim(),
        numeroTel: numeroTelController.text.trim(),
        role: selectedRole!,
      );

      if (!mounted) return;

      if (result['success']) {
        // Envoyer l'OTP après l'inscription réussie
        final otpResult = await AuthService.sendOtp(emailController.text.trim());
        
        if (!mounted) return;
        
        if (otpResult['success']) {
          // Rediriger vers la page OTP avec l'email
          Navigator.pushNamed(
            context,
            '/otp',
            arguments: {
              'email': emailController.text.trim(),
              'message': result['message'],
              'fromSignup': true,
            },
          );
        } else {
          _showSnackBar(otpResult['message'], isError: true);
        }
      } else {
        _showSnackBar(result['message'], isError: true);
      }
    } catch (e) {
      if (mounted) {
        _showSnackBar('Erreur inattendue: $e', isError: true);
      }
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  void _openLegalNotice() async {
    try {
      setState(() => isLoading = true);

      // Charger le PDF
      final byteData = await rootBundle.load('assets/Mention_legales.pdf');
      final pdfController = PdfController(
        document: PdfDocument.openData(byteData.buffer.asUint8List()),
      );

      if (!mounted) return;
      
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => Scaffold(
            appBar: AppBar(title: const Text('Mentions Légales')),
            body: PdfView(controller: pdfController),
          ),
        ),
      );
    } catch (e) {
      if (mounted) {
        _showSnackBar('Impossible d\'ouvrir le fichier PDF: $e', isError: true);
      }
    } finally {
      if (mounted) {
        setState(() => isLoading = false);
      }
    }
  }

  void _openPrivacyPolicy() async {
    try {
      setState(() => isLoading = true);

      // Charger le PDF
      final byteData = await rootBundle.load(
        'assets/Politique_de_confidentialite.pdf',
      );

      final pdfController = PdfController(
        document: PdfDocument.openData(byteData.buffer.asUint8List()),
      );

      if (!mounted) return;
      
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => Scaffold(
            appBar: AppBar(title: const Text('Politique de confidentialité')),
            body: PdfView(controller: pdfController),
          ),
        ),
      );
    } catch (e) {
      if (mounted) {
        _showSnackBar('Impossible d\'ouvrir le fichier PDF: $e', isError: true);
      }
    } finally {
      if (mounted) {
        setState(() => isLoading = false);
      }
    }
  }

  // Fonction pour afficher les messages
  void _showSnackBar(String message, {bool isError = false}) {
    if (!mounted) return;
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.red : Colors.green,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  bool _validateForm() {
    if (nomController.text.isEmpty ||
        prenomController.text.isEmpty ||
        emailController.text.isEmpty ||
        motDePasseController.text.isEmpty ||
        nationaliteController.text.isEmpty ||
        selectedNiveauEtudes == null ||
        domaineEtudesController.text.isEmpty ||
        selectedRole == null) {
      _showSnackBar(
        'Veuillez remplir tous les champs obligatoires',
        isError: true,
      );
      return false;
    }

    // Validation de l'email
    final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
    if (!emailRegex.hasMatch(emailController.text.trim())) {
      _showSnackBar('Veuillez entrer un email valide', isError: true);
      return false;
    }

    // Validation du mot de passe
    if (motDePasseController.text.length < 6) {
      _showSnackBar(
        'Le mot de passe doit contenir au moins 6 caractères',
        isError: true,
      );
      return false;
    }

    return true;
  }

  @override
  void dispose() {
    nomController.dispose();
    prenomController.dispose();
    emailController.dispose();
    motDePasseController.dispose();
    nationaliteController.dispose();
    domaineEtudesController.dispose();
    personneAPrevenirController.dispose();
    numeroTelController.dispose();
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
                          const Center(
                            child: Text(
                              'Inscription',
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                          ),
                          const SizedBox(height: 30),

                          // Nom et Prénom
                          Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      'Nom *',
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    TextField(
                                      controller: nomController,
                                      enabled: !isLoading,
                                      decoration: InputDecoration(
                                        hintText: 'Dupont',
                                        hintStyle: const TextStyle(
                                          color: Colors.grey,
                                        ),
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(
                                            8,
                                          ),
                                          borderSide: const BorderSide(
                                            color: Colors.grey,
                                          ),
                                        ),
                                        contentPadding:
                                            const EdgeInsets.symmetric(
                                              horizontal: 12,
                                              vertical: 12,
                                            ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      'Prénom *',
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    TextField(
                                      controller: prenomController,
                                      enabled: !isLoading,
                                      decoration: InputDecoration(
                                        hintText: 'Jean',
                                        hintStyle: const TextStyle(
                                          color: Colors.grey,
                                        ),
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(
                                            8,
                                          ),
                                          borderSide: const BorderSide(
                                            color: Colors.grey,
                                          ),
                                        ),
                                        contentPadding:
                                            const EdgeInsets.symmetric(
                                              horizontal: 12,
                                              vertical: 12,
                                            ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),

                          // Email
                          const Text(
                            'Email *',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 8),
                          TextField(
                            controller: emailController,
                            keyboardType: TextInputType.emailAddress,
                            enabled: !isLoading,
                            decoration: InputDecoration(
                              hintText: 'jean.dupont@email.com',
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

                          // Mot de passe
                          const Text(
                            'Mot de passe *',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 8),
                          TextField(
                            controller: motDePasseController,
                            obscureText: obscurePassword,
                            enabled: !isLoading,
                            decoration: InputDecoration(
                              hintText: '••••••••••••••',
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
                                onPressed: isLoading
                                    ? null
                                    : () {
                                        setState(() {
                                          obscurePassword = !obscurePassword;
                                        });
                                      },
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),

                          // Nationalité
                          const Text(
                            'Nationalité *',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 8),
                          TextField(
                            controller: nationaliteController,
                            enabled: !isLoading,
                            decoration: InputDecoration(
                              hintText: 'Française',
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

                          // Niveau d'études (Dropdown)
                          const Text(
                            'Niveau d\'études *',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 8),
                          DropdownButtonFormField<String>(
                            value: selectedNiveauEtudes,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 12,
                              ),
                            ),
                            hint: const Text('Sélectionnez votre niveau'),
                            items: niveauxEtudes
                                .map(
                                  (niveau) => DropdownMenuItem(
                                    value: niveau,
                                    child: Text(niveau),
                                  ),
                                )
                                .toList(),
                            onChanged: isLoading
                                ? null
                                : (value) {
                                    setState(() {
                                      selectedNiveauEtudes = value;
                                    });
                                  },
                          ),
                          const SizedBox(height: 20),

                          // Domaine d'études
                          const Text(
                            'Domaine d\'études *',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 8),
                          TextField(
                            controller: domaineEtudesController,
                            enabled: !isLoading,
                            decoration: InputDecoration(
                              hintText: 'Informatique, Médecine, Droit...',
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

                          // Personne à prévenir
                          const Text(
                            'Personne à prévenir',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 8),
                          TextField(
                            controller: personneAPrevenirController,
                            enabled: !isLoading,
                            decoration: InputDecoration(
                              hintText: 'Nom et prénom',
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

                          // Numéro de téléphone
                          const Text(
                            'Numéro de téléphone',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 8),
                          TextField(
                            controller: numeroTelController,
                            keyboardType: TextInputType.phone,
                            enabled: !isLoading,
                            decoration: InputDecoration(
                              hintText: '+33 6 12 34 56 78',
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

                          // Rôle (Dropdown)
                          const Text(
                            'Rôle *',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 8),
                          DropdownButtonFormField<String>(
                            value: selectedRole,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 12,
                              ),
                            ),
                            hint: const Text('Sélectionnez votre rôle'),
                            items: roles
                                .map(
                                  (role) => DropdownMenuItem(
                                    value: role,
                                    child: Text(role),
                                  ),
                                )
                                .toList(),
                            onChanged: isLoading
                                ? null
                                : (value) {
                                    setState(() {
                                      selectedRole = value;
                                    });
                                  },
                          ),
                          const SizedBox(height: 20),

                          // Politique de confidentialité checkbox
                          Row(
                            children: [
                              Checkbox(
                                value: acceptPolicy,
                                onChanged: isLoading
                                    ? null
                                    : (val) {
                                        setState(() {
                                          acceptPolicy = val ?? false;
                                        });
                                      },
                                activeColor: const Color(0xFF1F5AD2),
                              ),
                              Expanded(
                                child: RichText(
                                  text: TextSpan(
                                    style: const TextStyle(
                                      fontSize: 14,
                                      color: Colors.black,
                                    ),
                                    children: [
                                      const TextSpan(
                                        text: 'Vous acceptez les ',
                                      ),
                                      TextSpan(
                                        text: 'conditions générales',
                                        style: const TextStyle(
                                          color: Color(0xFF1F5AD2),
                                          decoration: TextDecoration.underline,
                                        ),
                                        recognizer: TapGestureRecognizer()
                                          ..onTap = _openLegalNotice,
                                      ),
                                      const TextSpan(text: ' et les '),
                                      TextSpan(
                                        text: 'politiques de confidentialité',
                                        style: const TextStyle(
                                          color: Color(0xFF1F5AD2),
                                          decoration: TextDecoration.underline,
                                        ),
                                        recognizer: TapGestureRecognizer()
                                          ..onTap = _openPrivacyPolicy,
                                      ),
                                      const TextSpan(
                                        text:
                                            ' de l\'application en vous inscrivant.',
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 30),

                          // Submit button
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
                              onPressed: isLoading ? null : _handleSignup,
                              child: isLoading
                                  ? const SizedBox(
                                      height: 20,
                                      width: 20,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        valueColor:
                                            AlwaysStoppedAnimation<Color>(
                                          Colors.white,
                                        ),
                                      ),
                                    )
                                  : const Text(
                                      'S\'inscrire',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                            ),
                          ),
                          const SizedBox(height: 20),
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