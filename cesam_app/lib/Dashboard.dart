import 'package:flutter/material.dart';

void main() {
  runApp(StudentApp());
}

class StudentApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CESAM Student App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: const Color(0xFFF5F7FA),
        fontFamily: 'Roboto',
      ),
      home: DashboardPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class DashboardPage extends StatefulWidget {
  @override
  _DashboardPageState createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  int _selectedIndex = 0;

  final List<DashboardModule> modules = [
    DashboardModule(
      title: 'Code Bourses',
      subtitle: 'Bourses nationales & internationales',
      icon: Icons.school,
      color: const Color(0xFF4CAF50),
    ),
    DashboardModule(
      title: 'Espace AMCI',
      subtitle: 'Infos, services & aides',
      icon: Icons.info,
      color: const Color(0xFF2196F3),
    ),
    DashboardModule(
      title: 'Stages & Emplois',
      subtitle: 'Opportunités locales & internationales',
      icon: Icons.work,
      color: const Color(0xFFFF9800),
    ),
    DashboardModule(
      title: 'Communautés',
      subtitle: 'Échange par ville/école/domaine',
      icon: Icons.people,
      color: const Color(0xFF9C27B0),
    ),
    DashboardModule(
      title: 'Logement',
      subtitle: 'Colocation & résidences',
      icon: Icons.home,
      color: const Color(0xFFE91E63),
    ),
    DashboardModule(
      title: 'Formations',
      subtitle: 'Écoles & universités',
      icon: Icons.library_books,
      color: const Color(0xFF607D8B),
    ),
    DashboardModule(
      title: 'Loisirs & Tourisme',
      subtitle: 'Découvrir le Maroc',
      icon: Icons.explore,
      color: const Color(0xFF795548),
    ),
    DashboardModule(
      title: 'Chaîne TV',
      subtitle: 'Vidéos, lives & rediffusions',
      icon: Icons.tv,
      color: const Color(0xFFF44336),
    ),
    DashboardModule(
      title: 'Valorisation',
      subtitle: 'CV, compétences & projets',
      icon: Icons.person,
      color: const Color(0xFF00BCD4),
    ),
    DashboardModule(
      title: 'Base PFE/Thèses',
      subtitle: 'Projets par thème & domaine',
      icon: Icons.folder,
      color: const Color(0xFF8BC34A),
    ),
    DashboardModule(
      title: 'Catalogue Entreprises',
      subtitle: 'Recherche par secteur',
      icon: Icons.business,
      color: const Color(0xFFFF5722),
    ),
    DashboardModule(
      title: 'Sports Live',
      subtitle: 'Scores en direct',
      icon: Icons.sports_soccer,
      color: const Color(0xFF3F51B5),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: Row(
          children: [
            CircleAvatar(
              backgroundColor: const Color(0xFF2196F3),
              child: Text(
                'CS',
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'CESAM Student',
                  style: TextStyle(
                    color: Colors.black87,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'Bienvenue Ahmed',
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.notifications_outlined, color: Colors.black87),
            onPressed: () {},
          ),
          IconButton(
            icon: Icon(Icons.search, color: Colors.black87),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Motivation matinale
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF4CAF50), Color(0xFF8BC34A)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.green.withOpacity(0.3),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.wb_sunny, color: Colors.white, size: 24),
                        const SizedBox(width: 8),
                        Text(
                          'Motivation du jour',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text(
                      '"Chaque jour est une nouvelle opportunité d\'apprendre et de grandir. Votre parcours académique au Maroc vous ouvre les portes du monde!"',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Section Accès rapide
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Accès rapide',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  TextButton(
                    onPressed: () {},
                    child: Text('Voir tout'),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              // Quick access cards
              SizedBox(
                height: 120,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: [
                    QuickAccessCard(
                      title: 'Mon Profil',
                      icon: Icons.person,
                      color: const Color(0xFF2196F3),
                    ),
                    QuickAccessCard(
                      title: 'Paiements',
                      icon: Icons.payment,
                      color: const Color(0xFF4CAF50),
                    ),
                    QuickAccessCard(
                      title: 'Messages',
                      icon: Icons.message,
                      color: const Color(0xFF9C27B0),
                    ),
                    QuickAccessCard(
                      title: 'Orientation',
                      icon: Icons.compass_calibration,
                      color: const Color(0xFFFF9800),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Section Tous les services
              Text(
                'Tous les services',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),

              const SizedBox(height: 16),

              // Modules grid
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: 1.2,
                ),
                itemCount: modules.length,
                itemBuilder: (context, index) {
                  return ModuleCard(module: modules[index]);
                },
              ),

              const SizedBox(height: 24),

              // Section Talents scientifiques
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.star, color: Colors.orange, size: 24),
                        const SizedBox(width: 8),
                        Text(
                          'Talents scientifiques',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Découvrez les portraits et interviews des étudiants qui font la fierté du Maroc',
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        type: BottomNavigationBarType.fixed,
        selectedItemColor: const Color(0xFF2196F3),
        unselectedItemColor: Colors.grey,
        backgroundColor: Colors.white,
        elevation: 8,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Accueil',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.chat),
            label: 'Messages',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.explore),
            label: 'Explorer',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profil',
          ),
        ],
      ),
    );
  }
}

class DashboardModule {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;

  DashboardModule({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
  });
}

class ModuleCard extends StatelessWidget {
  final DashboardModule module;

  const ModuleCard({Key? key, required this.module}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Ouverture de ${module.title}'),
            duration: const Duration(seconds: 2),
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: module.color.withOpacity(0.15),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                module.icon,
                color: module.color,
                size: 24,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              module.title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              module.subtitle,
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[600],
                height: 1.2,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}

class QuickAccessCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color color;

  const QuickAccessCard({
    Key? key,
    required this.title,
    required this.icon,
    required this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100,
      margin: const EdgeInsets.only(right: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color.withOpacity(0.15),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              icon,
              color: color,
              size: 24,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            title,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
