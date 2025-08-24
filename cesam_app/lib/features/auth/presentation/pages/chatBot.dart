import 'package:flutter/material.dart';

class ChatbotScreen extends StatefulWidget {
  const ChatbotScreen({super.key});

  @override
  _ChatbotScreenState createState() => _ChatbotScreenState();
}

class _ChatbotScreenState extends State<ChatbotScreen> {
  final TextEditingController _controller = TextEditingController();
  final List<Map<String, String>> _messages = [];

  // Base FAQ CESAM (questions -> réponses)
  final Map<String, String> faq = {
    "à propos": "🌍 La CESAM est une organisation apolitique créée en 1981 à Rabat. "
        "Elle regroupe plus de 70 000 étudiants africains et organise des activités culturelles, sportives et académiques.",
    "pourquoi application": "🎯 L'application CESAM facilite l’accès à l’information, offre un portail de support et renforce la communication.",
    "connexion": "🔐 Vérifiez vos identifiants. Cliquez sur « Mot de passe oublié » si nécessaire. "
        "Sinon, contactez le support utilisateur.",
    "email confirmation": "📩 Vérifiez dans Spam/Indésirables et l'adresse email saisie. "
        "Contactez le support si le problème persiste.",
    "changer mot de passe": "Allez dans Paramètres → Sécurité → Modifier le mot de passe.",
    "créer compte": "Ouvrez l’application → cliquez sur « Créer un compte » → remplissez les champs → validez.",
    "supprimer compte": "⚠ Allez dans Paramètres → Compte → Supprimer mon compte. Action irréversible.",
    "modifier infos": "Allez dans Profil → Modifiez mes informations → enregistrez les changements.",
    "application lente": "⚙ Fermez et relancez l’app. Vérifiez s’il y a une mise à jour. "
        "Sinon, contactez le support avec détails (téléphone, version).",
    "bug": "📡 Merci de signaler le problème via le formulaire ou par email, avec une capture d’écran si possible.",
    "qui peut utiliser": "❓ L’app est réservée aux membres CESAM : élèves, étudiants ou stagiaires africains au Maroc.",
    "données sécurisées": "🔒 Oui. La CESAM respecte une politique stricte de confidentialité conforme aux lois marocaines.",
    "support": "📬 Contactez le support : cesamapplication@gmail.com",
  };

  // Fonction pour trouver une réponse basée sur mots-clés
  String _getResponse(String userInput) {
    userInput = userInput.toLowerCase();
    for (var entry in faq.entries) {
      if (userInput.contains(entry.key)) {
        return entry.value;
      }
    }
    return "🤔 Désolé, je n’ai pas trouvé de réponse. Contactez le support : cesamapplication@gmail.com";
  }

  void _sendMessage() {
    String userMessage = _controller.text.trim();
    if (userMessage.isEmpty) return;

    setState(() {
      _messages.add({"sender": "user", "text": userMessage});
      _messages.add({"sender": "bot", "text": _getResponse(userMessage)});
    });

    _controller.clear();
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
                      color: isUser ? Colors.blue[100] : Colors.grey[200],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(msg["text"] ?? ""),
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