import 'package:flutter/material.dart';

// Modèle de données pour l'utilisateur
class User {
  final String id;
  final String name;
  final String email;
  final String status;
  final String idNumber;
  final String school;
  final String program;
  final String? profileImageUrl;
  final DateTime? lastLogin;

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.status,
    required this.idNumber,
    required this.school,
    required this.program,
    this.profileImageUrl,
    this.lastLogin,
  });
}

// Service simulé pour obtenir les données utilisateur
class UserService {
  static Future<User> getCurrentUser() async {
    // Simuler un appel API
    await Future.delayed(const Duration(seconds: 1));

    return User(
      id: "user_123",
      name: "Marie Dubois",
      email: "marie.dubois@ua.edu.ph",
      status: "Étudiante",
      idNumber: "2024001234",
      school: "Université de Technologie",
      program: "Master en Intelligence Artificielle",
      lastLogin: DateTime.now().subtract(const Duration(hours: 2)),
    );
  }
}

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage>
    with TickerProviderStateMixin {
  User? currentUser;
  bool isLoading = true;
  bool isEditing = false;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _initAnimations();
    _loadUserData();
  }

  void _initAnimations() {
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    _slideAnimation =
        Tween<Offset>(begin: const Offset(0, 0.3), end: Offset.zero).animate(
          CurvedAnimation(
            parent: _animationController,
            curve: Curves.easeOutCubic,
          ),
        );
  }

  Future<void> _loadUserData() async {
    try {
      final user = await UserService.getCurrentUser();
      setState(() {
        currentUser = user;
        isLoading = false;
      });
      _animationController.forward();
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      // Gestion d'erreur
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Erreur lors du chargement du profil')),
      );
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5E6E8),
      appBar: _buildAppBar(),
      body: isLoading ? _buildLoadingState() : _buildContent(),
      bottomNavigationBar: _buildBottomNav(),
      floatingActionButton: _buildEditButton(),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      backgroundColor: const Color(0xFF1F5AD2),
      elevation: 0,
      leading: IconButton(
        onPressed: () => Navigator.of(context).pop(),
        icon: const Icon(Icons.arrow_back, color: Colors.white),
      ),
      title: const Text(
        'Mon Profil',
        style: TextStyle(
          color: Colors.white,
          fontSize: 18,
          fontWeight: FontWeight.w500,
        ),
      ),
      actions: [
        IconButton(
          onPressed: _showOptionsMenu,
          icon: const Icon(Icons.more_vert, color: Colors.white),
        ),
      ],
    );
  }

  Widget _buildLoadingState() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF1F5AD2)),
          ),
          SizedBox(height: 16),
          Text('Chargement du profil...'),
        ],
      ),
    );
  }

  Widget _buildContent() {
    if (currentUser == null) {
      return const Center(child: Text('Erreur lors du chargement du profil'));
    }

    return FadeTransition(
      opacity: _fadeAnimation,
      child: SlideTransition(
        position: _slideAnimation,
        child: SingleChildScrollView(
          child: Column(
            children: [
              _buildHeader(),
              Transform.translate(
                offset: const Offset(0, -60),
                child: Column(
                  children: [
                    _buildProfileImage(),
                    const SizedBox(height: 16),
                    _buildUserInfo(),
                    const SizedBox(height: 24),
                    _buildInfoCards(),
                    const SizedBox(height: 20),
                    _buildStatsSection(),
                    const SizedBox(height: 100),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      height: 120,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF6B46C1), Color(0xFF8B5CF6), Color(0xFF1F5AD2)],
        ),
      ),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.white.withOpacity(0.1), Colors.transparent],
          ),
        ),
      ),
    );
  }

  Widget _buildProfileImage() {
    return Hero(
      tag: 'profile-image',
      child: Container(
        width: 120,
        height: 120,
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF1F5AD2), Color(0xFF6B46C1)],
          ),
          borderRadius: BorderRadius.circular(25),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF1F5AD2).withOpacity(0.3),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: currentUser?.profileImageUrl != null
            ? ClipRRect(
                borderRadius: BorderRadius.circular(25),
                child: Image.network(
                  currentUser!.profileImageUrl!,
                  fit: BoxFit.cover,
                ),
              )
            : Icon(
                Icons.person,
                size: 60,
                color: Colors.white.withOpacity(0.9),
              ),
      ),
    );
  }

  Widget _buildUserInfo() {
    return Column(
      children: [
        Text(
          currentUser!.name,
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 4),
        Text(
          currentUser!.status,
          style: TextStyle(
            fontSize: 16,
            color: Colors.grey[600],
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          decoration: BoxDecoration(
            color: const Color(0xFF10B981).withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            currentUser!.email,
            style: const TextStyle(
              fontSize: 14,
              color: Color(0xFF10B981),
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'ID: ${currentUser!.idNumber}',
          style: TextStyle(fontSize: 13, color: Colors.grey[500]),
        ),
        if (currentUser!.lastLogin != null) ...[
          const SizedBox(height: 4),
          Text(
            'Dernière connexion: ${_formatLastLogin(currentUser!.lastLogin!)}',
            style: TextStyle(fontSize: 12, color: Colors.grey[400]),
          ),
        ],
      ],
    );
  }

  Widget _buildInfoCards() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          _buildInfoCard(
            icon: Icons.school,
            title: 'École',
            subtitle: currentUser!.school,
            color: const Color(0xFF1F5AD2),
            delay: 0,
          ),
          const SizedBox(height: 12),
          _buildInfoCard(
            icon: Icons.computer,
            title: 'Programme',
            subtitle: currentUser!.program,
            color: const Color(0xFF10B981),
            delay: 100,
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required int delay,
  }) {
    return TweenAnimationBuilder<double>(
      duration: Duration(milliseconds: 600 + delay),
      tween: Tween(begin: 0.0, end: 1.0),
      builder: (context, value, child) {
        return Transform.translate(
          offset: Offset(0, 30 * (1 - value)),
          child: Opacity(opacity: value, child: child),
        );
      },
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.3),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: color, size: 28),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
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

  Widget _buildStatsSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Statistiques',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _buildStatItem(
                    'Cours',
                    '12',
                    Icons.book,
                    const Color(0xFF8B5CF6),
                  ),
                ),
                Expanded(
                  child: _buildStatItem(
                    'Projets',
                    '8',
                    Icons.assignment,
                    const Color(0xFF10B981),
                  ),
                ),
                Expanded(
                  child: _buildStatItem(
                    'Notes',
                    '85%',
                    Icons.grade,
                    const Color(0xFFFF6B6B),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(
    String label,
    String value,
    IconData icon,
    Color color,
  ) {
    return Column(
      children: [
        Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: color, size: 24),
        ),
        const SizedBox(height: 8),
        Text(
          value,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        Text(label, style: TextStyle(fontSize: 12, color: Colors.grey[600])),
      ],
    );
  }

  Widget _buildEditButton() {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      child: FloatingActionButton.extended(
        onPressed: _toggleEditMode,
        backgroundColor: isEditing
            ? const Color(0xFF10B981)
            : const Color(0xFF1F5AD2),
        icon: Icon(isEditing ? Icons.check : Icons.edit, color: Colors.white),
        label: Text(
          isEditing ? 'Sauver' : 'Modifier',
          style: const TextStyle(color: Colors.white),
        ),
      ),
    );
  }

  Widget _buildBottomNav() {
    return Container(
      height: 70,
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildNavItem(Icons.home_outlined, false),
          _buildNavItem(Icons.search_outlined, false),
          _buildNavItem(Icons.notifications_outlined, false),
          _buildNavItem(Icons.chat_bubble_outline, false),
          _buildNavItem(Icons.person, true),
        ],
      ),
    );
  }

  Widget _buildNavItem(IconData icon, bool isActive) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: isActive
            ? const Color(0xFF6B46C1).withOpacity(0.1)
            : Colors.transparent,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Icon(
        icon,
        color: isActive ? const Color(0xFF6B46C1) : Colors.grey,
        size: 24,
      ),
    );
  }

  void _toggleEditMode() {
    setState(() {
      isEditing = !isEditing;
    });

    if (!isEditing) {
      // Sauvegarder les modifications
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Profil sauvegardé avec succès!'),
          backgroundColor: Color(0xFF10B981),
        ),
      );
    }
  }

  void _showOptionsMenu() {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text('Paramètres'),
              onTap: () {
                Navigator.pop(context);
                // Naviguer vers les paramètres
              },
            ),
            ListTile(
              leading: const Icon(Icons.security),
              title: const Text('Confidentialité'),
              onTap: () {
                Navigator.pop(context);
                // Naviguer vers confidentialité
              },
            ),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('Déconnexion'),
              onTap: () {
                Navigator.pop(context);
                _showLogoutDialog();
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Déconnexion'),
        content: const Text('Êtes-vous sûr de vouloir vous déconnecter?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Annuler'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              // Logique de déconnexion
            },
            child: const Text('Déconnexion'),
          ),
        ],
      ),
    );
  }

  String _formatLastLogin(DateTime lastLogin) {
    final now = DateTime.now();
    final difference = now.difference(lastLogin);

    if (difference.inMinutes < 60) {
      return 'il y a ${difference.inMinutes} min';
    } else if (difference.inHours < 24) {
      return 'il y a ${difference.inHours}h';
    } else {
      return 'il y a ${difference.inDays} jour(s)';
    }
  }
}

// Classe principale de l'application
class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Profile App',
      theme: ThemeData(
        primarySwatch: Colors.purple,
        fontFamily: 'Roboto',
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const ProfilePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

/* import 'package:flutter/material.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(
        0xFFF5E6E8,
      ), // Couleur rose pâle de l'arrière-plan
      appBar: AppBar(
        backgroundColor: const Color(0xFF1F5AD2), // Violet foncé
        elevation: 0,
        leading: const Icon(Icons.arrow_back, color: Colors.white),
        title: const Text(
          'Profile',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w500,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.menu, color: Colors.white),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Header avec dégradé violet
            Container(
              height: 120,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color(0xFF6B46C1), // Violet foncé
                    Color(0xFF8B5CF6), // Violet moyen
                  ],
                ),
              ),
            ),

            // Section principale avec photo de profil
            Transform.translate(
              offset: const Offset(0, -60),
              child: Column(
                children: [
                  // Photo de profil
                  Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      color: const Color(0xFF1F5AD2), // Violet moyen
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 10,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.person,
                      size: 60,
                      color: Colors.black87,
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Nom
                  const Text(
                    'John Kenneth Cueva',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),

                  const SizedBox(height: 4),

                  // Statut
                  const Text(
                    'Student',
                    style: TextStyle(fontSize: 14, color: Colors.black54),
                  ),

                  const SizedBox(height: 4),

                  // Email
                  const Text(
                    'jkcueva.student@ua.edu.ph',
                    style: TextStyle(fontSize: 13, color: Colors.black54),
                  ),

                  const SizedBox(height: 4),

                  // ID Number
                  const Text(
                    '2023200855',
                    style: TextStyle(fontSize: 13, color: Colors.black54),
                  ),

                  const SizedBox(height: 24),

                  // Cartes d'information
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      children: [
                        // Carte Université
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(16),
                          margin: const EdgeInsets.only(bottom: 12),
                          decoration: BoxDecoration(
                            color: const Color(0xFF1F5AD2), // Bleu
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 8,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Row(
                            children: [
                              Container(
                                width: 40,
                                height: 40,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: const Icon(
                                  Icons.school,
                                  color: Color(0xFF1F5AD2),
                                  size: 24,
                                ),
                              ),
                              const SizedBox(width: 12),
                              const Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'School',
                                      style: TextStyle(
                                        color: Colors.white70,
                                        fontSize: 12,
                                      ),
                                    ),
                                    Text(
                                      'Bulacan State University',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),

                        // Carte Programme
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: const Color(0xFF10B981), // Vert
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 8,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Row(
                            children: [
                              Container(
                                width: 40,
                                height: 40,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: const Icon(
                                  Icons.computer,
                                  color: Color(0xFF10B981),
                                  size: 24,
                                ),
                              ),
                              const SizedBox(width: 12),
                              const Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Program',
                                      style: TextStyle(
                                        color: Colors.white70,
                                        fontSize: 12,
                                      ),
                                    ),
                                    Text(
                                      'Bachelor of Science in Information Technology',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 40),

            // Bouton Edit flottant
            Padding(
              padding: const EdgeInsets.only(right: 20, bottom: 20),
              child: Align(
                alignment: Alignment.bottomRight,
                child: FloatingActionButton(
                  onPressed: () {},
                  backgroundColor: const Color(0xFF1F5AD2),
                  child: const Icon(Icons.edit, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),

      // Barre de navigation inférieure
      bottomNavigationBar: Container(
        height: 70,
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildNavItem(Icons.home_outlined, false),
            _buildNavItem(Icons.search_outlined, false),
            _buildNavItem(Icons.notifications_outlined, false),
            _buildNavItem(Icons.chat_bubble_outline, false),
            _buildNavItem(Icons.person, true), // Profile activé
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem(IconData icon, bool isActive) {
    return Container(
      padding: const EdgeInsets.all(8),
      child: Icon(
        icon,
        color: isActive ? const Color(0xFF6B46C1) : Colors.grey,
        size: 24,
      ),
    );
  }
}

// Pour utiliser cette page dans votre app :
class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Profile App',
      theme: ThemeData(primarySwatch: Colors.purple, fontFamily: 'Roboto'),
      home: const ProfilePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}
 */
