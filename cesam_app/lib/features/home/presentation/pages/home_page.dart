import 'package:flutter/material.dart';

// Modèles de données
class Course {
  final String id;
  final String title;
  final String description;
  final Color color;
  final String imagePath;
  final String category;
  final double progress;

  Course({
    required this.id,
    required this.title,
    required this.description,
    required this.color,
    required this.imagePath,
    required this.category,
    this.progress = 0.0,
  });
}

class Opportunity {
  final String id;
  final String title;
  final String description;
  final String category;
  final IconData icon;
  final Color color;
  final DateTime? deadline;
  final String? amount;

  Opportunity({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.icon,
    required this.color,
    this.deadline,
    this.amount,
  });
}

class Event {
  final String id;
  final String title;
  final String description;
  final DateTime date;
  final String location;
  final String imagePath;

  Event({
    required this.id,
    required this.title,
    required this.description,
    required this.date,
    required this.location,
    required this.imagePath,
  });
}

// Page Homepage combinée avec recherche dynamique et structure complète
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int currentIndex = 0;
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  // Données complètes pour la démonstration
  final List<Course> _allCourses = [
    Course(
      id: '1',
      title: 'Web Development',
      description: 'Learn HTML, CSS, JavaScript and frameworks',
      color: Colors.blue.shade800,
      imagePath: 'assets/programmation.jpg',
      category: 'Programming',
      progress: 0.7,
    ),
    Course(
      id: '2',
      title: 'Mobile Development',
      description: 'Build apps with Flutter and React Native',
      color: Colors.orange.shade700,
      imagePath: 'assets/programmation2.jpg',
      category: 'Programming',
      progress: 0.3,
    ),
    Course(
      id: '3',
      title: 'Data Science',
      description: 'Master Python, ML and data analysis',
      color: Colors.purple.shade700,
      imagePath: 'assets/technology.jpg',
      category: 'Data',
      progress: 0.5,
    ),
    Course(
      id: '4',
      title: 'UI/UX Design',
      description: 'Create beautiful user experiences',
      color: Colors.red.shade700,
      imagePath: 'assets/ia.jpg',
      category: 'Design',
      progress: 0.2,
    ),
    Course(
      id: '5',
      title: 'Cybersecurity',
      description: 'Network Security and Ethical Hacking',
      color: Colors.green.shade700,
      imagePath: 'assets/programmation1.jpg',
      category: 'Security',
      progress: 0.4,
    ),
    Course(
      id: '6',
      title: 'Cloud Computing',
      description: 'AWS, Azure and Google Cloud Platform',
      color: Colors.teal.shade700,
      imagePath: 'assets/ia.jpg',
      category: 'Infrastructure',
      progress: 0.6,
    ),
  ];

  final List<Opportunity> _allOpportunities = [
    Opportunity(
      id: '1',
      title: 'Bourse d\'Excellence Académique',
      description: 'Bourse de 50,000 DH pour étudiants méritants',
      category: 'Bourse',
      icon: Icons.school,
      color: Colors.green,
      deadline: DateTime.now().add(const Duration(days: 30)),
      amount: '50,000 DH',
    ),
    Opportunity(
      id: '2',
      title: 'Stage en Entreprise Tech',
      description: 'Opportunité de stage chez Google Morocco',
      category: 'Stage',
      icon: Icons.work,
      color: Colors.blue,
      deadline: DateTime.now().add(const Duration(days: 15)),
    ),
    Opportunity(
      id: '3',
      title: 'Concours Innovation',
      description: 'Participez au concours national d\'innovation',
      category: 'Concours',
      icon: Icons.lightbulb,
      color: Colors.orange,
      deadline: DateTime.now().add(const Duration(days: 45)),
      amount: '100,000 DH',
    ),
    Opportunity(
      id: '4',
      title: 'Programme d\'Échange International',
      description: 'Étudiez à l\'étranger pendant un semestre',
      category: 'Échange',
      icon: Icons.flight_takeoff,
      color: Colors.purple,
      deadline: DateTime.now().add(const Duration(days: 60)),
      amount: 'Gratuit',
    ),
    Opportunity(
      id: '5',
      title: 'Hackathon National 2024',
      description: 'Compétition de développement de 48h',
      category: 'Concours',
      icon: Icons.code,
      color: Colors.red,
      deadline: DateTime.now().add(const Duration(days: 20)),
      amount: '25,000 DH',
    ),
  ];

  final List<Event> _allEvents = [
    Event(
      id: '1',
      title: 'Conférence Tech 2024',
      description: 'Découvrez les dernières tendances technologiques',
      date: DateTime.now().add(const Duration(days: 7)),
      location: 'Rabat, Morocco',
      imagePath: 'assets/code2.jpg',
    ),
    Event(
      id: '2',
      title: 'Workshop Flutter',
      description: 'Atelier pratique sur le développement Flutter',
      date: DateTime.now().add(const Duration(days: 14)),
      location: 'Casablanca, Morocco',
      imagePath: 'assets/event2.jpg',
    ),
    Event(
      id: '3',
      title: 'Salon de l\'Emploi IT',
      description: 'Rencontrez les recruteurs du secteur IT',
      date: DateTime.now().add(const Duration(days: 21)),
      location: 'Marrakech, Morocco',
      imagePath: 'assets/event1.jpg',
    ),
  ];

  // Listes filtrées pour la recherche
  List<Course> _filteredCourses = [];
  List<Opportunity> _filteredOpportunities = [];
  List<Event> _filteredEvents = [];

  @override
  void initState() {
    super.initState();
    _filteredCourses = _allCourses;
    _filteredOpportunities = _allOpportunities;
    _filteredEvents = _allEvents;
  }

  // Fonction de recherche dynamique
  void _filterContent(String query) {
    setState(() {
      _searchQuery = query.toLowerCase();

      if (_searchQuery.isEmpty) {
        _filteredCourses = _allCourses;
        _filteredOpportunities = _allOpportunities;
        _filteredEvents = _allEvents;
      } else {
        // Filtrage des cours
        _filteredCourses = _allCourses
            .where(
              (course) =>
                  course.title.toLowerCase().contains(_searchQuery) ||
                  course.description.toLowerCase().contains(_searchQuery) ||
                  course.category.toLowerCase().contains(_searchQuery),
            )
            .toList();

        // Filtrage des opportunités
        _filteredOpportunities = _allOpportunities
            .where(
              (opportunity) =>
                  opportunity.title.toLowerCase().contains(_searchQuery) ||
                  opportunity.description.toLowerCase().contains(
                    _searchQuery,
                  ) ||
                  opportunity.category.toLowerCase().contains(_searchQuery),
            )
            .toList();

        // Filtrage des événements
        _filteredEvents = _allEvents
            .where(
              (event) =>
                  event.title.toLowerCase().contains(_searchQuery) ||
                  event.description.toLowerCase().contains(_searchQuery) ||
                  event.location.toLowerCase().contains(_searchQuery),
            )
            .toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1F5AD2),
        elevation: 0,
        title: const Text(
          'Home',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.menu, color: Colors.white),
            onPressed: () {},
          ),
        ],
      ),
      body: _buildMainContent(),
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  Widget _buildMainContent() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSearchHeader(),
          if (_searchQuery.isNotEmpty)
            _buildSearchResults()
          else ...[
            _buildCourseSection(),
            const SizedBox(height: 10),
            _buildNetworkSection(),
            const SizedBox(height: 10),
            _buildOpportunitiesSection(),
            const SizedBox(height: 10),
            _buildEventsSection(),
          ],
        ],
      ),
    );
  }

  Widget _buildSearchHeader() {
    return Container(
      color: const Color(0xFF1F5AD2),
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 30),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.2),
          borderRadius: BorderRadius.circular(25),
        ),
        child: TextField(
          controller: _searchController,
          onChanged: _filterContent,
          decoration: InputDecoration(
            hintText: 'Rechercher des cours, bourses, événements...',
            hintStyle: const TextStyle(color: Colors.white70),
            prefixIcon: const Icon(Icons.search, color: Colors.white70),
            suffixIcon: _searchQuery.isNotEmpty
                ? IconButton(
                    icon: const Icon(Icons.clear, color: Colors.white70),
                    onPressed: () {
                      _searchController.clear();
                      _filterContent('');
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
    );
  }

  Widget _buildSearchResults() {
    final hasResults =
        _filteredCourses.isNotEmpty ||
        _filteredOpportunities.isNotEmpty ||
        _filteredEvents.isNotEmpty;

    if (!hasResults) {
      return Container(
        color: Colors.white,
        padding: const EdgeInsets.all(40),
        child: Center(
          child: Column(
            children: [
              Icon(Icons.search_off, size: 80, color: Colors.grey.shade300),
              const SizedBox(height: 20),
              Text(
                'Aucun résultat trouvé pour "$_searchQuery"',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.grey.shade600,
                  fontWeight: FontWeight.w500,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 10),
              Text(
                'Essayez des mots-clés différents',
                style: TextStyle(fontSize: 14, color: Colors.grey.shade500),
              ),
            ],
          ),
        ),
      );
    }

    return Column(
      children: [
        // Résultats des cours
        if (_filteredCourses.isNotEmpty) ...[
          Container(
            color: Colors.white,
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Cours (${_filteredCourses.length})',
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 15),
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 15,
                    mainAxisSpacing: 15,
                    childAspectRatio: 1.3,
                  ),
                  itemCount: _filteredCourses.length,
                  itemBuilder: (context, index) {
                    final course = _filteredCourses[index];
                    return _buildCourseCard(course);
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
        ],

        // Résultats des opportunités
        if (_filteredOpportunities.isNotEmpty) ...[
          Container(
            color: Colors.white,
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Opportunités (${_filteredOpportunities.length})',
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 15),
                ..._filteredOpportunities.map(
                  (opportunity) => Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: _buildOpportunityCard(opportunity),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
        ],

        // Résultats des événements
        if (_filteredEvents.isNotEmpty) ...[
          Container(
            color: Colors.white,
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Événements (${_filteredEvents.length})',
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 15),
                ..._filteredEvents.map(
                  (event) => Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: _buildEventCard(event),
                  ),
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildCourseSection() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'CESAM - Mes Cours',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              TextButton(
                onPressed: () => _navigateToCoursesPage(),
                child: const Text('Voir tout'),
              ),
            ],
          ),
          const SizedBox(height: 20),
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 2,
            crossAxisSpacing: 15,
            mainAxisSpacing: 15,
            childAspectRatio: 1.3,
            children: _allCourses
                .take(4)
                .map((course) => _buildCourseCard(course))
                .toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildNetworkSection() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(15),
            decoration: BoxDecoration(
              color: Colors.grey.shade50,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey.shade200),
            ),
            child: Row(
              children: [
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    image: const DecorationImage(
                      image: AssetImage('assets/code2.jpg'),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(width: 15),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Network Administration',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Text(
                        'Configuring and Securing Networks',
                        style: TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Container(
                            width: 100,
                            height: 6,
                            decoration: BoxDecoration(
                              color: Colors.green,
                              borderRadius: BorderRadius.circular(3),
                            ),
                          ),
                          const SizedBox(width: 10),
                          const Text('50%', style: TextStyle(fontSize: 12)),
                        ],
                      ),
                    ],
                  ),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 15,
                      vertical: 8,
                    ),
                  ),
                  onPressed: () => _navigateToNetworkAdminPage(),
                  child: const Text('Continue', style: TextStyle(fontSize: 12)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOpportunitiesSection() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Opportunités',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              TextButton(
                onPressed: () => _navigateToOpportunitiesPage(),
                child: const Text('Voir tout'),
              ),
            ],
          ),
          const SizedBox(height: 15),
          ..._allOpportunities
              .take(3)
              .map(
                (opportunity) => Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: _buildOpportunityCard(opportunity),
                ),
              ),
        ],
      ),
    );
  }

  Widget _buildEventsSection() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Événements',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              TextButton(
                onPressed: () => _navigateToEventsPage(),
                child: const Text('Voir tout'),
              ),
            ],
          ),
          const SizedBox(height: 15),
          ..._allEvents
              .take(2)
              .map(
                (event) => Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: _buildEventCard(event),
                ),
              ),
        ],
      ),
    );
  }

  Widget _buildCourseCard(Course course) {
    return GestureDetector(
      onTap: () => _navigateToCourseDetail(course),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          image: DecorationImage(
            image: AssetImage(course.imagePath),
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(
              course.color.withOpacity(0.8),
              BlendMode.overlay,
            ),
          ),
        ),
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Colors.transparent, course.color.withOpacity(0.8)],
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                course.title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 4),
              Text(
                course.category,
                style: const TextStyle(color: Colors.white70, fontSize: 10),
              ),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: Colors.green,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Text(
                  'Continuer',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOpportunityCard(Opportunity opportunity) {
    return GestureDetector(
      onTap: () => _navigateToOpportunityDetail(opportunity),
      child: Container(
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: opportunity.color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: opportunity.color.withOpacity(0.3)),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: opportunity.color,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(opportunity.icon, color: Colors.white, size: 24),
            ),
            const SizedBox(width: 15),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        opportunity.category,
                        style: TextStyle(
                          fontSize: 12,
                          color: opportunity.color,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      if (opportunity.amount != null) ...[
                        const Spacer(),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.green.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            opportunity.amount!,
                            style: const TextStyle(
                              fontSize: 10,
                              color: Colors.green,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                  Text(
                    opportunity.title,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  if (opportunity.deadline != null)
                    Text(
                      'Échéance: ${_formatDate(opportunity.deadline!)}',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.red.shade600,
                      ),
                    ),
                ],
              ),
            ),
            const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
          ],
        ),
      ),
    );
  }

  Widget _buildEventCard(Event event) {
    return GestureDetector(
      onTap: () => _navigateToEventDetail(event),
      child: Container(
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: Colors.purple.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.purple.withOpacity(0.3)),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.purple,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(Icons.event, color: Colors.white, size: 24),
            ),
            const SizedBox(width: 15),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Événement',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.purple.shade700,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    event.title,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  Text(
                    '${_formatDate(event.date)} - ${event.location}',
                    style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                  ),
                ],
              ),
            ),
            const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomNavigationBar() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: BottomNavigationBar(
        currentIndex: currentIndex,
        onTap: (index) {
          if (index == 4) {
            Navigator.pushNamed(context, '/profile');
          } else {
            setState(() {
              currentIndex = index;
              if (index == 0) {
                _searchController.clear();
                _filterContent('');
              }
            });
          }
        },
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        selectedItemColor: const Color(0xFF1F5AD2),
        unselectedItemColor: Colors.grey,
        elevation: 0,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Search'),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications),
            label: 'Notifications',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.chat_bubble_outline),
            label: 'Messages',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  // Fonctions de navigation
  void _navigateToCoursesPage() {
    // Navigation vers la page des cours
    Navigator.pushNamed(context, '/courses');
  }

  void _navigateToOpportunitiesPage() {
    // Navigation vers la page des opportunités
    Navigator.pushNamed(context, '/opportunities');
  }

  void _navigateToEventsPage() {
    // Navigation vers la page des événements
    Navigator.pushNamed(context, '/event-details');
  }

  void _navigateToCourseDetail(Course course) {
    // Navigation vers le détail d'un cours
    Navigator.pushNamed(context, '/courses', arguments: course);
  }

  void _navigateToOpportunityDetail(Opportunity opportunity) {
    // Navigation vers le détail d'une opportunité
    Navigator.pushNamed(context, '/opportunities', arguments: opportunity);
  }

  void _navigateToEventDetail(Event event) {
    // Navigation vers le détail d'un événement
    Navigator.pushNamed(context, '/event-details', arguments: event);
  }

  void _navigateToNetworkAdminPage() {
    Navigator.pushNamed(context, '/network-admin');
  }
}

/* import 'package:flutter/material.dart';
import 'package:cesam_app/core/app_router.dart';

// Page Homepage améliorée avec recherche dynamique
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int currentIndex = 0;
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  // Données simulées pour les cours
  final List<Course> _allCourses = [
    Course(
      'Learn Python',
      'Programming Fundamentals',
      Colors.blue.shade800,
      'assets/code1.jpg',
    ),
    Course(
      'Web Development',
      'HTML, CSS, JavaScript',
      Colors.orange.shade700,
      'assets/code2.jpg',
    ),
    Course(
      'Mobile App Development',
      'Flutter & React Native',
      Colors.purple.shade700,
      'assets/code1.jpg',
    ),
    Course(
      'Data Science',
      'Analytics & Machine Learning',
      Colors.red.shade700,
      'assets/code2.jpg',
    ),
    Course(
      'Cybersecurity',
      'Network Security',
      Colors.green.shade700,
      'assets/code1.jpg',
    ),
    Course(
      'Cloud Computing',
      'AWS & Azure',
      Colors.teal.shade700,
      'assets/code2.jpg',
    ),
  ];

  // Données simulées pour les opportunités
  final List<Opportunity> _allOpportunities = [
    Opportunity(
      'School',
      'Bulacan State University',
      Icons.school,
      Colors.blue,
    ),
    Opportunity(
      'Course',
      'Bachelor of Science in Information Technology',
      Icons.computer,
      Colors.orange,
    ),
    Opportunity(
      'Scholarship',
      'Merit-based Academic Scholarship',
      Icons.card_giftcard,
      Colors.green,
    ),
    Opportunity(
      'Internship',
      'Software Development Internship',
      Icons.work,
      Colors.purple,
    ),
    Opportunity(
      'Workshop',
      'AI and Machine Learning Workshop',
      Icons.lightbulb,
      Colors.red,
    ),
  ];

  List<Course> _filteredCourses = [];
  List<Opportunity> _filteredOpportunities = [];

  @override
  void initState() {
    super.initState();
    _filteredCourses = _allCourses;
    _filteredOpportunities = _allOpportunities;
  }

  void _filterContent(String query) {
    setState(() {
      _searchQuery = query.toLowerCase();
      if (_searchQuery.isEmpty) {
        _filteredCourses = _allCourses;
        _filteredOpportunities = _allOpportunities;
      } else {
        _filteredCourses = _allCourses
            .where(
              (course) =>
                  course.title.toLowerCase().contains(_searchQuery) ||
                  course.subtitle.toLowerCase().contains(_searchQuery),
            )
            .toList();

        _filteredOpportunities = _allOpportunities
            .where(
              (opportunity) =>
                  opportunity.category.toLowerCase().contains(_searchQuery) ||
                  opportunity.title.toLowerCase().contains(_searchQuery),
            )
            .toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1F5AD2),
        elevation: 0,
        title: const Text(
          'Home',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.menu, color: Colors.white),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header bleu avec barre de recherche fonctionnelle
            Container(
              color: const Color(0xFF1F5AD2),
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 30),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(25),
                ),
                child: TextField(
                  controller: _searchController,
                  onChanged: _filterContent,
                  decoration: InputDecoration(
                    hintText: 'Search courses, opportunities...',
                    hintStyle: const TextStyle(color: Colors.white70),
                    prefixIcon: const Icon(Icons.search, color: Colors.white70),
                    suffixIcon: _searchQuery.isNotEmpty
                        ? IconButton(
                            icon: const Icon(
                              Icons.clear,
                              color: Colors.white70,
                            ),
                            onPressed: () {
                              _searchController.clear();
                              _filterContent('');
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

            // Section CESAM avec résultats filtrés
            if (_filteredCourses.isNotEmpty)
              Container(
                color: Colors.white,
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          _searchQuery.isEmpty
                              ? 'CESAM'
                              : 'Courses (${_filteredCourses.length})',
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        if (_searchQuery.isEmpty)
                          TextButton(
                            onPressed: () => _navigateToCoursesPage(),
                            child: const Text('See All'),
                          ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 15,
                            mainAxisSpacing: 15,
                            childAspectRatio: 1.3,
                          ),
                      itemCount: _searchQuery.isEmpty
                          ? (_filteredCourses.length > 4
                                ? 4
                                : _filteredCourses.length)
                          : _filteredCourses.length,
                      itemBuilder: (context, index) {
                        final course = _filteredCourses[index];
                        return _buildCourseCard(
                          course.title,
                          course.subtitle,
                          'Enroll Now',
                          course.color,
                          course.imagePath,
                          () => _navigateToCourseDetail(course),
                        );
                      },
                    ),
                  ],
                ),
              ),

            // Message si aucun cours trouvé
            if (_filteredCourses.isEmpty && _searchQuery.isNotEmpty)
              Container(
                color: Colors.white,
                padding: const EdgeInsets.all(20),
                child: Center(
                  child: Column(
                    children: [
                      Icon(
                        Icons.search_off,
                        size: 60,
                        color: Colors.grey.shade400,
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'No courses found for "$_searchQuery"',
                        style: TextStyle(color: Colors.grey.shade600),
                      ),
                    ],
                  ),
                ),
              ),

            const SizedBox(height: 10),

            // Section Network Administration (toujours visible si pas de recherche)
            if (_searchQuery.isEmpty)
              Container(
                color: Colors.white,
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    GestureDetector(
                      onTap: () => _navigateToNetworkAdminPage(),
                      child: Container(
                        padding: const EdgeInsets.all(15),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade50,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.grey.shade200),
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 60,
                              height: 60,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                image: const DecorationImage(
                                  image: AssetImage('assets/code1.jpg'),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            const SizedBox(width: 15),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Network Administration',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const Text(
                                    'Configuring and Securing Networks',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Row(
                                    children: [
                                      Container(
                                        width: 100,
                                        height: 6,
                                        decoration: BoxDecoration(
                                          color: Colors.green,
                                          borderRadius: BorderRadius.circular(
                                            3,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 10),
                                      const Text(
                                        '50%',
                                        style: TextStyle(fontSize: 12),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.green,
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 15,
                                  vertical: 8,
                                ),
                              ),
                              onPressed: () => _navigateToNetworkAdminPage(),
                              child: const Text(
                                'Continue',
                                style: TextStyle(fontSize: 12),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),

            const SizedBox(height: 10),

            // Section Opportunities avec résultats filtrés
            if (_filteredOpportunities.isNotEmpty)
              Container(
                color: Colors.white,
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          _searchQuery.isEmpty
                              ? 'Opportunities'
                              : 'Opportunities (${_filteredOpportunities.length})',
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        if (_searchQuery.isEmpty)
                          TextButton(
                            onPressed: () => _navigateToOpportunitiesPage(),
                            child: const Text('See All'),
                          ),
                      ],
                    ),
                    const SizedBox(height: 15),
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: _searchQuery.isEmpty
                          ? (_filteredOpportunities.length > 3
                                ? 3
                                : _filteredOpportunities.length)
                          : _filteredOpportunities.length,
                      itemBuilder: (context, index) {
                        final opportunity = _filteredOpportunities[index];
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: _buildOpportunityCard(
                            opportunity.category,
                            opportunity.title,
                            opportunity.icon,
                            opportunity.color,
                            () => _navigateToOpportunityDetail(opportunity),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),

            // Message si aucune opportunité trouvée
            if (_filteredOpportunities.isEmpty && _searchQuery.isNotEmpty)
              Container(
                color: Colors.white,
                padding: const EdgeInsets.all(20),
                child: Center(
                  child: Column(
                    children: [
                      Icon(
                        Icons.event_busy,
                        size: 60,
                        color: Colors.grey.shade400,
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'No opportunities found for "$_searchQuery"',
                        style: TextStyle(color: Colors.grey.shade600),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.3),
              spreadRadius: 1,
              blurRadius: 5,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: BottomNavigationBar(
          currentIndex: currentIndex,
          onTap: (index) {
            if (index == 4) {
              Navigator.pushNamed(context, '/profile');
            } else {
              setState(() {
                currentIndex = index;
              });
            }
          },
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.white,
          selectedItemColor: const Color(0xFF1F5AD2),
          unselectedItemColor: Colors.grey,
          elevation: 0,
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
            BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Search'),
            BottomNavigationBarItem(
              icon: Icon(Icons.notifications),
              label: 'Notifications',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.chat_bubble_outline),
              label: 'Messages',
            ),
            BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
          ],
        ),
      ),
    );
  }

  Widget _buildCourseCard(
    String title,
    String subtitle,
    String buttonText,
    Color color,
    String imagePath,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          image: DecorationImage(
            image: AssetImage(imagePath),
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(
              color.withOpacity(0.8),
              BlendMode.overlay,
            ),
          ),
        ),
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Colors.transparent, color.withOpacity(0.8)],
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              Text(
                subtitle,
                style: const TextStyle(color: Colors.white70, fontSize: 10),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: Colors.green,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  buttonText,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOpportunityCard(
    String category,
    String title,
    IconData icon,
    Color color,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withOpacity(0.3)),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, color: Colors.white, size: 24),
            ),
            const SizedBox(width: 15),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    category,
                    style: TextStyle(
                      fontSize: 12,
                      color: color,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              size: 16,
              color: Colors.grey.shade400,
            ),
          ],
        ),
      ),
    );
  }

  // Méthodes de navigation
  void _navigateToCoursesPage() {
    Navigator.pushNamed(context, '/courses');
  }

  void _navigateToOpportunitiesPage() {
    Navigator.pushNamed(context, '/opportunities');
  }

  void _navigateToNetworkAdminPage() {
    Navigator.pushNamed(context, '/network-admin');
  }

  void _navigateToCourseDetail(Course course) {
    Navigator.pushNamed(context, '/courses', arguments: course);
  }

  void _navigateToOpportunityDetail(Opportunity opportunity) {
    Navigator.pushNamed(context, '/opportunities', arguments: opportunity);
  }
}

// Classes de modèles de données
class Course {
  final String title;
  final String subtitle;
  final Color color;
  final String imagePath;

  Course(this.title, this.subtitle, this.color, this.imagePath);
}

class Opportunity {
  final String category;
  final String title;
  final IconData icon;
  final Color color;

  Opportunity(this.category, this.title, this.icon, this.color);
}
 */


/* import 'package:flutter/material.dart';

// Page Homepage améliorée selon l'image
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1F5AD2),
        elevation: 0,
        title: const Text(
          'Home',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.menu, color: Colors.white),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header bleu avec barre de recherche
            Container(
              color: const Color(0xFF1F5AD2),
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 30),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(25),
                ),
                child: const TextField(
                  decoration: InputDecoration(
                    hintText: 'Search',
                    hintStyle: TextStyle(color: Colors.white70),
                    prefixIcon: Icon(Icons.search, color: Colors.white70),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 15,
                    ),
                  ),
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),

            // Section CESAM
            Container(
              color: Colors.white,
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'CESAM',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 20),
                  GridView.count(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisCount: 2,
                    crossAxisSpacing: 15,
                    mainAxisSpacing: 15,
                    childAspectRatio: 1.3,
                    children: [
                      _buildCourseCard(
                        'Learn to Code',
                        'Enroll Now',
                        Colors.blue.shade800,
                        'assets/code1.jpg',
                      ),
                      _buildCourseCard(
                        'Learn to Code',
                        'Enroll Now',
                        Colors.orange.shade700,
                        'assets/code2.jpg',
                      ),
                      _buildCourseCard(
                        'Learn to Code',
                        'Enroll Now',
                        Colors.purple.shade700,
                        'assets/code1.jpg',
                      ),
                      _buildCourseCard(
                        'Learn to Code',
                        'Enroll Now',
                        Colors.red.shade700,
                        'assets/code2.jpg',
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 10),

            // Section Network Administration
            Container(
              color: Colors.white,
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(15),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade50,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey.shade200),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 60,
                          height: 60,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            image: const DecorationImage(
                              image: AssetImage('assets/network.jpg'),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        const SizedBox(width: 15),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Network Administration',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const Text(
                                'Configuring and Securing Networks',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Row(
                                children: [
                                  Container(
                                    width: 100,
                                    height: 6,
                                    decoration: BoxDecoration(
                                      color: Colors.green,
                                      borderRadius: BorderRadius.circular(3),
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  const Text(
                                    '50%',
                                    style: TextStyle(fontSize: 12),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 15,
                              vertical: 8,
                            ),
                          ),
                          onPressed: () {},
                          child: const Text(
                            'Continue',
                            style: TextStyle(fontSize: 12),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 10),

            // Section Opportunities
            Container(
              color: Colors.white,
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Opportunities',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 15),
                  _buildOpportunityCard(
                    'School',
                    'Bulacan State University',
                    Icons.school,
                    Colors.blue,
                  ),
                  const SizedBox(height: 10),
                  _buildOpportunityCard(
                    'Course',
                    'Bachelor of Science in Information Technology',
                    Icons.computer,
                    Colors.orange,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.3),
              spreadRadius: 1,
              blurRadius: 5,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: BottomNavigationBar(
          currentIndex: currentIndex,
          onTap: (index) {
            if (index == 4) {
              // Naviguer vers la page Profile via la route définie dans AppRouter
              Navigator.pushNamed(context, '/profile');
            } else {
              setState(() {
                currentIndex = index;
              });
            }
          },
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.white,
          selectedItemColor: const Color(0xFF1F5AD2),
          unselectedItemColor: Colors.grey,
          elevation: 0,
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
            BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Search'),
            BottomNavigationBarItem(
              icon: Icon(Icons.notifications),
              label: 'Notifications',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.chat_bubble_outline),
              label: 'Messages',
            ),
            BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
          ],
        ),
      ),
    );
  }

  Widget _buildCourseCard(
    String title,
    String buttonText,
    Color color,
    String imagePath,
  ) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        image: DecorationImage(
          image: AssetImage(imagePath),
          fit: BoxFit.cover,
          colorFilter: ColorFilter.mode(
            color.withOpacity(0.8),
            BlendMode.overlay,
          ),
        ),
      ),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.transparent, color.withOpacity(0.8)],
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.green,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                buttonText,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 10,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOpportunityCard(
    String category,
    String title,
    IconData icon,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: Colors.white, size: 24),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  category,
                  style: TextStyle(
                    fontSize: 12,
                    color: color,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
 */