import 'package:flutter/material.dart';
class StartupPage extends StatelessWidget {
  const StartupPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFF1F5AD2), // Bleu clair
              Color(0xFF1F5AD2), // même couleur répétée jusqu'à 62%
              Color(0xFF5C8FE9),
            ], // Bleu foncé], // Violet foncé → clair
            stops: [0, 0.62, 1.0], // pourcentage de transition
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 40,
            ), // Ajout de padding horizontal
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset('assets/cesam_logo.png', height: 120),
                const SizedBox(height: 150),
                const Text(
                  'student hop.',
                  style: TextStyle(
                    fontSize: 50,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 60),
                SizedBox(
                  width: double.infinity, // Prend toute la largeur
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: Color(0xFF7B1FA2),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    onPressed: () => Navigator.pushNamed(context, '/login'),
                    child: const Text('Log In'),
                  ),
                ),
                const SizedBox(height: 10),
                SizedBox(
                  width: double.infinity, // Prend toute la largeur
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF1F5AD2),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    onPressed: () => Navigator.pushNamed(context, '/signup'),
                    child: const Text('Sign Up'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
