import 'package:flutter/material.dart';
import '../../services/auth_services.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

class OtpPage extends StatefulWidget {
  final String? email;
  final String? message;

  const OtpPage({super.key, this.email, this.message});

  @override
  State<OtpPage> createState() => _OtpPageState();
}

class _OtpPageState extends State<OtpPage> {
  final List<TextEditingController> otpControllers = List.generate(
    4,
    (index) => TextEditingController(),
  );
  final List<FocusNode> focusNodes = List.generate(4, (index) => FocusNode());

  bool isLoading = false;
  int _resendTimer = 30;
  bool _canResend = false;

  Timer? _timer; // 🔴 pour gérer le Timer

  @override
  void initState() {
    super.initState();
    _startResendTimer();

    // Déplacer l'envoi initial de l'OTP après un court délai
    // pour éviter les conflits avec le build initial
    if (widget.email != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          _resendOtp();

          if (widget.message != null) {
            _showSnackBar(widget.message!, isError: false);
          }
        }
      });
    }
  }

  void _startResendTimer() {
    _canResend = false;
    _resendTimer = 30;

    const oneSec = Duration(seconds: 1);

    _timer = Timer.periodic(oneSec, (timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }

      if (_resendTimer == 0) {
        setState(() {
          timer.cancel();
          _canResend = true;
        });
      } else {
        setState(() {
          _resendTimer--;
        });
      }
    });
  }

  Future<void> _handleOtpVerification() async {
    String otpCode = otpControllers.map((controller) => controller.text).join();

    if (otpCode.length != 4) {
      _showSnackBar('Veuillez saisir le code à 4 chiffres', isError: true);
      return;
    }

    if (widget.email == null) {
      _showSnackBar('Email manquant. Veuillez recommencer.', isError: true);

      // Ajouter un délai avant de naviguer pour éviter les erreurs de contexte
      Future.delayed(const Duration(milliseconds: 500), () {
        if (mounted) {
          Navigator.pop(context);
        }
      });
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      final result = await _verifyOtp(otpCode);

      if (result['success']) {
        _showSnackBar('Vérification réussie !', isError: false);

        await Future.delayed(const Duration(seconds: 1));

        if (!mounted) return; // 🔴 sécurité après Future.delayed

        final role = result['role'] ?? 'Etudiant';
        if (role == 'Admin') {
          Navigator.pushNamedAndRemoveUntil(
            context,
            '/dashboard',
            (route) => false,
          );
        } else {
          Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => false);
        }
      } else {
        _showSnackBar(result['message'], isError: true);
        _clearOtpFields();
      }
    } catch (e) {
      _showSnackBar('Erreur inattendue: $e', isError: true);
      _clearOtpFields();
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  Future<Map<String, dynamic>> _verifyOtp(String otp) async {
    try {
      final url = Uri.parse('${AuthService.baseUrl}/users/verify-opt');
      final body = jsonEncode({"email": widget.email, "otp": otp});

      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: body,
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        if (data['accessToken'] != null) {
          await AuthService.saveToken(data['accessToken']);
        }
        return {"success": true, "message": "Vérification réussie"};
      } else {
        return {
          "success": false,
          "message": data['message'] ?? "Code OTP invalide",
        };
      }
    } catch (e) {
      return {"success": false, "message": "Erreur de connexion au serveur"};
    }
  }

  Future<void> _resendOtp() async {
    if (widget.email == null) {
      _showSnackBar('Email manquant. Veuillez recommencer.', isError: true);
      return;
    }

    if (!_canResend && _resendTimer > 0) return;

    setState(() {
      isLoading = true;
      _canResend = false;
    });

    try {
      final result = await AuthService.sendOtp(widget.email!);

      if (mounted) {
        if (result['success']) {
          _showSnackBar('Nouveau code envoyé !', isError: false);
          _clearOtpFields();
          _startResendTimer();
        } else {
          _showSnackBar(result['message'], isError: true);
        }
      }
    } catch (e) {
      if (mounted) {
        _showSnackBar('Erreur lors du renvoi: $e', isError: true);
      }
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  void _clearOtpFields() {
    for (var controller in otpControllers) {
      controller.clear();
    }
    if (mounted) {
      focusNodes[0].requestFocus();
    }
  }

  String _getMaskedEmail() {
    if (widget.email == null) return 'votre email';

    final parts = widget.email!.split('@');
    if (parts.length != 2) return widget.email!;

    final localPart = parts[0];
    final domain = parts[1];

    if (localPart.length <= 4) {
      return '${localPart[0]}${'*' * (localPart.length - 2)}${localPart[localPart.length - 1]}@$domain';
    }

    return '${localPart.substring(0, 2)}${'*' * (localPart.length - 4)}${localPart.substring(localPart.length - 2)}@$domain';
  }

  void _showSnackBar(String message, {bool isError = false}) {
    if (!mounted) return; //  évite d'utiliser context après dispose

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
    _timer?.cancel(); //  annulation du Timer

    for (var controller in otpControllers) {
      controller.dispose();
    }
    for (var node in focusNodes) {
      node.dispose();
    }
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
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 40),
                child: Text(
                  'student hop.',
                  style: TextStyle(
                    fontSize: 36,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),

              Expanded(
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
                    padding: const EdgeInsets.all(40.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          'Verification Code',
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        Text(
                          'email: ${_getMaskedEmail()}',
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.grey,
                          ),
                        ),
                        const SizedBox(height: 50),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: List.generate(4, (index) {
                            return Container(
                              width: 60,
                              height: 60,
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: Colors.grey.shade300,
                                  width: 2,
                                ),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: TextField(
                                controller: otpControllers[index],
                                focusNode: focusNodes[index],
                                textAlign: TextAlign.center,
                                enabled: !isLoading,
                                style: const TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                ),
                                keyboardType: TextInputType.number,
                                maxLength: 1,
                                decoration: const InputDecoration(
                                  border: InputBorder.none,
                                  counterText: '',
                                ),
                                onChanged: (value) {
                                  if (value.isNotEmpty && index < 3) {
                                    FocusScope.of(
                                      context,
                                    ).requestFocus(focusNodes[index + 1]);
                                  } else if (value.isEmpty && index > 0) {
                                    FocusScope.of(
                                      context,
                                    ).requestFocus(focusNodes[index - 1]);
                                  }

                                  // SUPPRIMER LA VÉRIFICATION AUTOMATIQUE
                                  // La vérification ne se déclenchera que via le bouton
                                },
                              ),
                            );
                          }),
                        ),
                        const SizedBox(height: 40),

                        TextButton(
                          onPressed: _canResend ? _resendOtp : null,
                          child: Text(
                            _canResend
                                ? 'Renvoyer le code'
                                : 'Renvoyer dans $_resendTimer s',
                            style: TextStyle(
                              color: _canResend
                                  ? const Color(0xFF1F5AD2)
                                  : Colors.grey,
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),

                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF1F5AD2),
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                              padding: const EdgeInsets.symmetric(vertical: 18),
                              elevation: 0,
                            ),
                            onPressed: isLoading
                                ? null
                                : _handleOtpVerification,
                            child: isLoading
                                ? const SizedBox(
                                    height: 20,
                                    width: 20,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                        Colors.white,
                                      ),
                                    ),
                                  )
                                : const Text(
                                    'Authenticate',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
