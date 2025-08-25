import 'package:flutter/material.dart';
import 'package:collection/collection.dart'; // Pour firstWhereOrNull
import 'package:diacritic/diacritic.dart';
class ChatbotScreen extends StatefulWidget {
  const ChatbotScreen({super.key});

  @override
  _ChatbotScreenState createState() => _ChatbotScreenState();
}

class _ChatbotScreenState extends State<ChatbotScreen> {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final List<Map<String, String>> _messages = [];

  // FAQ améliorée (plusieurs mots-clés possibles)
  final Map<List<String>, String> faq = {
    ["à propos", "apropos", "presentation"]: 
      "🌍 La CESAM est une organisation apolitique créée en 1981 à Rabat. "
      "Elle regroupe plus de 70 000 étudiants africains et organise des activités culturelles, sportives et académiques.",
    ["pourquoi application", "objectif", "utilité"]: 
      "🎯 L'application CESAM facilite l’accès à l’information, offre un portail de support et renforce la communication.",
    ["connexion", "login"]: 
      "🔐 Vérifiez vos identifiants. Cliquez sur « Mot de passe oublié » si nécessaire. "
      "Sinon, contactez le support utilisateur.",
    ["email confirmation", "mail", "activation"]: 
      "📩 Vérifiez dans Spam/Indésirables et l'adresse email saisie. "
      "Contactez le support si le problème persiste.",
    ["changer mot de passe", "reset", "password"]: 
      "Allez dans Paramètres → Sécurité → Modifier le mot de passe.",
    ["créer compte", "inscription", "register"]: 
      "Ouvrez l’application → cliquez sur « Créer un compte » → remplissez les champs → validez.",
    ["supprimer compte", "delete"]: 
      "⚠ Allez dans Paramètres → Compte → Supprimer mon compte. Action irréversible.",
    ["modifier infos", "profil", "update"]: 
      "Allez dans Profil → Modifiez mes informations → enregistrez les changements.",
    ["application lente", "lag", "lent"]: 
      "⚙ Fermez et relancez l’app. Vérifiez s’il y a une mise à jour. "
      "Sinon, contactez le support avec détails (téléphone, version).",
    ["bug", "erreur", "crash"]: 
      "📡 Merci de signaler le problème via le formulaire ou par email, avec une capture d’écran si possible.",
    ["qui peut utiliser", "utilisateurs", "membres"]: 
      "❓ L’app est réservée aux membres CESAM : élèves, étudiants ou stagiaires africains au Maroc.",
    ["données sécurisées", "sécurité", "confidentialité"]: 
      "🔒 Oui. La CESAM respecte une politique stricte de confidentialité conforme aux lois marocaines.",
    ["support", "aide", "contact"]: 
      "📬 Contactez le support : cesamapplication@gmail.com",
  };

  // Normalisation du texte (minuscule + sans accents)
  String _normalize(String text) {
    return removeDiacritics(text.toLowerCase().trim());
  }

  // Trouver une réponse
  String _getResponse(String userInput) {
    String normalizedInput = _normalize(userInput);

    final entry = faq.entries.firstWhereOrNull((element) {
      return element.key.any((keyword) => normalizedInput.contains(_normalize(keyword)));
    });

    return entry?.value ?? "🤔 Désolé, je n’ai pas trouvé de réponse. Contactez le support : cesamapplication@gmail.com";
  }

  void _sendMessage() {
    String userMessage = _controller.text.trim();
    if (userMessage.isEmpty) return;

    setState(() {
      _messages.add({"sender": "user", "text": userMessage});
      _messages.add({"sender": "bot", "text": _getResponse(userMessage)});
    });

    _controller.clear();

    // Scroll automatique vers le bas
    Future.delayed(const Duration(milliseconds: 100), () {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("🤖 Chatbot CESAM"),
        backgroundColor: Colors.green,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.all(10),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final msg = _messages[index];
                final isUser = msg["sender"] == "user";

                return Align(
                  alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 4),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: isUser ? Colors.blue[200] : Colors.grey[300],
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Text(msg["text"] ?? "",
                        style: TextStyle(
                          color: isUser ? Colors.black : Colors.black87,
                          fontWeight: FontWeight.w500,
                        )),
                  ),
                );
              },
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
            color: Colors.grey[100],
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: const InputDecoration(
                      hintText: "Écrivez votre question...",
                      border: InputBorder.none,
                    ),
                    onSubmitted: (_) => _sendMessage(),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send, color: Colors.green),
                  onPressed: _sendMessage,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}