import 'package:flutter/material.dart';

// Modèle Event (même que dans le code principal)
class Event {
  final String id;
  final String title;
  final String description;
  final DateTime date;
  final String location;
  final String imagePath;
  final String category;
  final int maxParticipants;
  final int currentParticipants;
  final bool isFree;
  final String? price;

  Event({
    required this.id,
    required this.title,
    required this.description,
    required this.date,
    required this.location,
    required this.imagePath,
    this.category = 'Événement',
    this.maxParticipants = 100,
    this.currentParticipants = 0,
    this.isFree = true,
    this.price,
  });
}

class EventsPage extends StatefulWidget {
  const EventsPage({super.key});

  @override
  State<EventsPage> createState() => _EventsPageState();
}

class _EventsPageState extends State<EventsPage> {
  final TextEditingController _searchController = TextEditingController();
  String _selectedCategory = 'Tous';
  String _searchQuery = '';

  final List<String> _categories = [
    'Tous',
    'Conférence',
    'Workshop',
    'Formation',
    'Networking',
    'Compétition',
    'Salon'
  ];

  // Données complètes des événements
  final List<Event> _allEvents = [
    Event(
      id: '1',
      title: 'Conférence Tech Morocco 2024',
      description: 'La plus grande conférence technologique du Maroc. Découvrez les dernières innovations en IA, blockchain, et développement web.',
      date: DateTime.now().add(const Duration(days: 7)),
      location: 'Centre de Conférences, Rabat',
      imagePath: 'assets/event1.jpg',
      category: 'Conférence',
      maxParticipants: 500,
      currentParticipants: 324,
      isFree: false,
      price: '200 DH',
    ),
    Event(
      id: '2',
      title: 'Workshop Flutter Avancé',
      description: 'Atelier pratique sur le développement d\'applications mobiles avec Flutter. Niveau intermédiaire à avancé.',
      date: DateTime.now().add(const Duration(days: 14)),
      location: 'ENSA, Casablanca',
      imagePath: 'assets/event2.jpg',
      category: 'Workshop',
      maxParticipants: 40,
      currentParticipants: 28,
      isFree: true,
    ),
    Event(
      id: '3',
      title: 'Salon de l\'Emploi IT',
      description: 'Rencontrez les recruteurs du secteur informatique. Plus de 50 entreprises présentes.',
      date: DateTime.now().add(const Duration(days: 21)),
      location: 'Palais des Congrès, Marrakech',
      imagePath: 'assets/code1.jpg',
      category: 'Salon',
      maxParticipants: 1000,
      currentParticipants: 456,
      isFree: true,
    ),
    Event(
      id: '4',
      title: 'Formation Cybersécurité',
      description: 'Formation intensive de 3 jours sur la sécurité informatique et l\'ethical hacking.',
      date: DateTime.now().add(const Duration(days: 28)),
      location: 'Institut Spécialisé, Fès',
      imagePath: 'assets/code2.jpg',
      category: 'Formation',
      maxParticipants: 25,
      currentParticipants: 18,
      isFree: false,
      price: '1500 DH',
    ),
    Event(
      id: '5',
      title: 'Meetup Développeurs Web',
      description: 'Rencontre informelle entre développeurs web. Échanges d\'expériences et networking.',
      date: DateTime.now().add(const Duration(days: 35)),
      location: 'Co-working Space, Tanger',
      imagePath: 'assets/event1.jpg',
      category: 'Networking',
      maxParticipants: 80,
      currentParticipants: 35,
      isFree: true,
    ),
    Event(
      id: '6',
      title: 'Hackathon National 2024',
      description: 'Compétition de développement de 48h. Thème : Solutions pour l\'éducation digitale.',
      date: DateTime.now().add(const Duration(days: 42)),
      location: 'Université Mohammed V, Rabat',
      imagePath: 'assets/event2.jpg',
      category: 'Compétition',
      maxParticipants: 200,
      currentParticipants: 156,
      isFree: true,
    ),
  ];

  List<Event> get _filteredEvents {
    List<Event> filtered = _allEvents;

    // Filtrage par catégorie
    if (_selectedCategory != 'Tous') {
      filtered = filtered.where((event) => event.category == _selectedCategory).toList();
    }

    // Filtrage par recherche
    if (_searchQuery.isNotEmpty) {
      filtered = filtered.where((event) =>
        event.title.toLowerCase().contains(_searchQuery.toLowerCase()) ||
        event.description.toLowerCase().contains(_searchQuery.toLowerCase()) ||
        event.location.toLowerCase().contains(_searchQuery.toLowerCase()) ||
        event.category.toLowerCase().contains(_searchQuery.toLowerCase())
      ).toList();
    }

    // Tri par date
    filtered.sort((a, b) => a.date.compareTo(b.date));
    return filtered;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        backgroundColor: Colors.purple,
        foregroundColor: Colors.white,
        title: const Text(
          'Événements',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: Container(
            padding: const EdgeInsets.all(16),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(25),
              ),
              child: TextField(
                controller: _searchController,
                onChanged: (value) {
                  setState(() {
                    _searchQuery = value;
                  });
                },
                decoration: InputDecoration(
                  hintText: 'Rechercher un événement...',
                  hintStyle: const TextStyle(color: Colors.white70),
                  prefixIcon: const Icon(Icons.search, color: Colors.white70),
                  suffixIcon: _searchQuery.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.clear, color: Colors.white70),
                          onPressed: () {
                            _searchController.clear();
                            setState(() {
                              _searchQuery = '';
                            });
                          },
                        )
                      : null,
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 15,
                  ),
                ),
                style: const TextStyle(color: Colors.white),
              ),
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          // Filtres par catégorie
          Container(
            color: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 15),
            child: SizedBox(
              height: 40,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                itemCount: _categories.length,
                itemBuilder: (context, index) {
                  final category = _categories[index];
                  final isSelected = _selectedCategory == category;
                  return Padding(
                    padding: const EdgeInsets.only(right: 10),
                    child: FilterChip(
                      label: Text(
                        category,
                        style: TextStyle(
                          color: isSelected ? Colors.white : Colors.purple,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      selected: isSelected,
                      onSelected: (selected) {
                        setState(() {
                          _selectedCategory = category;
                        });
                      },
                      backgroundColor: Colors.white,
                      selectedColor: Colors.purple,
                      side: BorderSide(color: Colors.purple.withOpacity(0.3)),
                    ),
                  );
                },
              ),
            ),
          ),

          // Statistiques
          Container(
            color: Colors.white,
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                Expanded(
                  child: _buildStatCard(
                    'Total Événements',
                    _filteredEvents.length.toString(),
                    Icons.event,
                    Colors.purple,
                  ),
                ),
                const SizedBox(width: 15),
                Expanded(
                  child: _buildStatCard(
                    'Gratuits',
                    _filteredEvents.where((e) => e.isFree).length.toString(),
                    Icons.money_off,
                    Colors.green,
                  ),
                ),
                const SizedBox(width: 15),
                Expanded(
                  child: _buildStatCard(
                    'Cette Semaine',
                    _filteredEvents.where((e) => 
                      e.date.isBefore(DateTime.now().add(const Duration(days: 7)))
                    ).length.toString(),
                    Icons.today,
                    Colors.orange,
                  ),
                ),
              ],
            ),
          ),

          // Liste des événements
          Expanded(
            child: _filteredEvents.isEmpty
                ? _buildEmptyState()
                : ListView.builder(
                    padding: const EdgeInsets.all(20),
                    itemCount: _filteredEvents.length,
                    itemBuilder: (context, index) {
                      final event = _filteredEvents[index];
                      return _buildEventCard(event);
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          Text(
            title,
            style: const TextStyle(
              fontSize: 12,
              color: Colors.grey,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildEventCard(Event event) {
    final daysUntil = event.date.difference(DateTime.now()).inDays;
    final isUpcoming = daysUntil >= 0;
    final occupancyRate = event.currentParticipants / event.maxParticipants;

    return Card(
      margin: const EdgeInsets.only(bottom: 15),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image avec overlay d'informations
          Container(
            height: 180,
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
              image: DecorationImage(
                image: AssetImage(event.imagePath),
                fit: BoxFit.cover,
                colorFilter: ColorFilter.mode(
                  Colors.black.withOpacity(0.3),
                  BlendMode.darken,
                ),
              ),
            ),
            child: Stack(
              children: [
                // Badge catégorie
                Positioned(
                  top: 15,
                  left: 15,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.purple,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      event.category,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                // Badge prix
                Positioned(
                  top: 15,
                  right: 15,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: event.isFree ? Colors.green : Colors.orange,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      event.isFree ? 'GRATUIT' : event.price ?? '',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                // Titre sur l'image
                Positioned(
                  bottom: 15,
                  left: 15,
                  right: 15,
                  child: Text(
                    event.title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      shadows: [
                        Shadow(
                          offset: Offset(1, 1),
                          blurRadius: 3,
                          color: Colors.black54,
                        ),
                      ],
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),

          // Contenu de la card
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Description
                Text(
                  event.description,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                    height: 1.4,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 15),

                // Informations pratiques
                Row(
                  children: [
                    Icon(Icons.calendar_today, size: 16, color: Colors.grey.shade600),
                    const SizedBox(width: 8),
                    Text(
                      _formatDate(event.date),
                      style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                    ),
                    const Spacer(),
                    if (isUpcoming) ...[
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: daysUntil <= 7 ? Colors.red.withOpacity(0.2) : Colors.blue.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          daysUntil == 0 ? 'Aujourd\'hui' : 
                          daysUntil == 1 ? 'Demain' : 
                          'Dans $daysUntil jours',
                          style: TextStyle(
                            fontSize: 12,
                            color: daysUntil <= 7 ? Colors.red.shade700 : Colors.blue.shade700,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
                const SizedBox(height: 10),

                Row(
                  children: [
                    Icon(Icons.location_on, size: 16, color: Colors.grey.shade600),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        event.location,
                        style: const TextStyle(fontSize: 14),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 15),

                // Jauge de participation
                Row(
                  children: [
                    Icon(Icons.people, size: 16, color: Colors.grey.shade600),
                    const SizedBox(width: 8),
                    Text(
                      '${event.currentParticipants}/${event.maxParticipants} participants',
                      style: const TextStyle(fontSize: 12),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: LinearProgressIndicator(
                        value: occupancyRate,
                        backgroundColor: Colors.grey.shade300,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          occupancyRate > 0.8 ? Colors.red : 
                          occupancyRate > 0.6 ? Colors.orange : Colors.green,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                // Boutons d'action
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.purple,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        onPressed: occupancyRate >= 1.0 ? null : () => _registerForEvent(event),
                        icon: Icon(
                          occupancyRate >= 1.0 ? Icons.block : Icons.event_available,
                          size: 18,
                        ),
                        label: Text(
                          occupancyRate >= 1.0 ? 'Complet' : 'S\'inscrire',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    OutlinedButton.icon(
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.purple,
                        side: const BorderSide(color: Colors.purple),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      onPressed: () => _viewEventDetails(event),
                      icon: const Icon(Icons.info_outline, size: 18),
                      label: const Text('Détails'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.event_busy,
            size: 80,
            color: Colors.grey.shade300,
          ),
          const SizedBox(height: 20),
          Text(
            _searchQuery.isNotEmpty
                ? 'Aucun événement trouvé pour "$_searchQuery"'
                : 'Aucun événement dans cette catégorie',
            style: TextStyle(
              fontSize: 18,
              color: Colors.grey.shade600,
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 10),
          Text(
            'Essayez de modifier vos critères de recherche',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade500,
            ),
          ),
          const SizedBox(height: 30),
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.purple,
              foregroundColor: Colors.white,
            ),
            onPressed: () {
              setState(() {
                _selectedCategory = 'Tous';
                _searchController.clear();
                _searchQuery = '';
              });
            },
            icon: const Icon(Icons.refresh),
            label: const Text('Réinitialiser les filtres'),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    final weekdays = ['Lun', 'Mar', 'Mer', 'Jeu', 'Ven', 'Sam', 'Dim'];
    final months = ['Jan', 'Fév', 'Mar', 'Avr', 'Mai', 'Juin', 
                   'Juil', 'Aoû', 'Sep', 'Oct', 'Nov', 'Déc'];
    
    return '${weekdays[date.weekday - 1]} ${date.day} ${months[date.month - 1]} ${date.year}';
  }

  void _registerForEvent(Event event) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          title: const Text('Confirmer l\'inscription'),
          content: Text('Voulez-vous vous inscrire à "${event.title}" ?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Annuler'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.purple),
              onPressed: () {
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Inscription confirmée pour "${event.title}"'),
                    backgroundColor: Colors.green,
                  ),
                );
              },
              child: const Text('Confirmer', style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );
  }

  void _viewEventDetails(Event event) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EventDetailPage(event: event),
      ),
    );
  }
}

// Page de détail d'un événement (optionnelle)
class EventDetailPage extends StatelessWidget {
  final Event event;

  const EventDetailPage({super.key, required this.event});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.purple,
        foregroundColor: Colors.white,
        title: const Text('Détails de l\'événement'),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image de l'événement
            Container(
              height: 250,
              width: double.infinity,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(event.imagePath),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            // Contenu détaillé
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    event.title,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    event.description,
                    style: const TextStyle(fontSize: 16, height: 1.5),
                  ),
                  const SizedBox(height: 20),
                  // Informations détaillées...
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.purple,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 15),
                      ),
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Inscription confirmée!'),
                            backgroundColor: Colors.green,
                          ),
                        );
                      },
                      child: const Text('S\'inscrire à l\'événement'),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}