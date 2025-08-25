import 'package:flutter/material.dart';


class DashboardPage extends StatefulWidget {
  @override
  _DashboardPageState createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage>
    with TickerProviderStateMixin {
  int _selectedIndex = 0;
  late AnimationController _animationController;
  late AnimationController _pulseController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _slideAnimation;
  late Animation<double> _pulseAnimation;
  late ScrollController _scrollController;
  bool _showFloatingButton = false;

  final List<DashboardModule> modules = [
    DashboardModule(
      title: 'Code Bourses',
      subtitle: 'Bourses nationales & internationales',
      icon: Icons.school,
      color: const Color(0xFF4CAF50),
      notification: 3,
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
      notification: 7,
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
      notification: 2,
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
      isLive: true,
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
      isLive: true,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat(reverse: true);
    
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
    
    _slideAnimation = Tween<double>(
      begin: -50.0,
      end: 0.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.elasticOut,
    ));
    
    _pulseAnimation = Tween<double>(
      begin: 1.0,
      end: 1.1,
    ).animate(CurvedAnimation(
      parent: _pulseController,
      curve: Curves.easeInOut,
    ));

    _scrollController.addListener(() {
      if (_scrollController.offset > 200 && !_showFloatingButton) {
        setState(() {
          _showFloatingButton = true;
        });
      } else if (_scrollController.offset <= 200 && _showFloatingButton) {
        setState(() {
          _showFloatingButton = false;
        });
      }
    });
    
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _pulseController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(70),
        child: AnimatedBuilder(
          animation: _fadeAnimation,
          builder: (context, child) {
            return Opacity(
              opacity: _fadeAnimation.value,
              child: Transform.translate(
                offset: Offset(0, _slideAnimation.value),
                child: AppBar(
                  elevation: 0,
                  backgroundColor: Colors.white,
                  flexibleSpace: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Colors.white, Colors.blue.shade50],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                    ),
                  ),
                  title: Row(
                    children: [
                      Hero(
                        tag: 'avatar',
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          child: CircleAvatar(
                            backgroundColor: const Color(0xFF2196F3),
                            child: Text(
                              'CS',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'CESAM Student',
                            style: TextStyle(
                              color: Colors.black87,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          ShaderMask(
                            shaderCallback: (bounds) => LinearGradient(
                              colors: [Colors.blue, Colors.purple],
                            ).createShader(bounds),
                            child: Text(
                              'Bienvenue Ahmed',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  actions: [
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      child: IconButton(
                        icon: Stack(
                          children: [
                            Icon(Icons.notifications_outlined, color: Colors.black87),
                            Positioned(
                              right: 0,
                              top: 0,
                              child: Container(
                                padding: const EdgeInsets.all(2),
                                decoration: BoxDecoration(
                                  color: Colors.red,
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                constraints: const BoxConstraints(
                                  minWidth: 12,
                                  minHeight: 12,
                                ),
                                child: Text(
                                  '5',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 8,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                          ],
                        ),
                        onPressed: () {},
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.search, color: Colors.black87),
                      onPressed: () {},
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
      floatingActionButton: AnimatedScale(
        scale: _showFloatingButton ? 1.0 : 0.0,
        duration: const Duration(milliseconds: 300),
        child: FloatingActionButton(
          onPressed: () {
            _scrollController.animateTo(
              0,
              duration: const Duration(milliseconds: 500),
              curve: Curves.easeInOut,
            );
          },
          backgroundColor: const Color(0xFF2196F3),
          child: const Icon(Icons.keyboard_arrow_up),
        ),
      ),
      body: AnimatedBuilder(
        animation: _fadeAnimation,
        builder: (context, child) {
          return Opacity(
            opacity: _fadeAnimation.value,
            child: SingleChildScrollView(
              controller: _scrollController,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Motivation matinale avec animation
                    Transform.translate(
                      offset: Offset(0, _slideAnimation.value),
                      child: Hero(
                        tag: 'motivation_card',
                        child: Container(
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
                                blurRadius: 15,
                                offset: const Offset(0, 8),
                                spreadRadius: 2,
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  AnimatedBuilder(
                                    animation: _pulseAnimation,
                                    builder: (context, child) {
                                      return Transform.scale(
                                        scale: _pulseAnimation.value,
                                        child: Icon(
                                          Icons.wb_sunny,
                                          color: Colors.white,
                                          size: 24,
                                        ),
                                      );
                                    },
                                  ),
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
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Section Accès rapide avec animation
                    Transform.translate(
                      offset: Offset(0, _slideAnimation.value * 0.8),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          ShaderMask(
                            shaderCallback: (bounds) => LinearGradient(
                              colors: [Colors.black87, Colors.blue],
                            ).createShader(bounds),
                            child: Text(
                              'Accès rapide',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          TextButton(
                            onPressed: () {},
                            child: Text('Voir tout'),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Quick access cards avec animation en cascade
                    Transform.translate(
                      offset: Offset(0, _slideAnimation.value * 0.6),
                      child: SizedBox(
                        height: 120,
                        child: ListView(
                          scrollDirection: Axis.horizontal,
                          children: [
                            AnimatedQuickAccessCard(
                              title: 'Mon Profil',
                              icon: Icons.person,
                              color: const Color(0xFF2196F3),
                              delay: 100,
                            ),
                            AnimatedQuickAccessCard(
                              title: 'Paiements',
                              icon: Icons.payment,
                              color: const Color(0xFF4CAF50),
                              delay: 200,
                            ),
                            AnimatedQuickAccessCard(
                              title: 'Messages',
                              icon: Icons.message,
                              color: const Color(0xFF9C27B0),
                              delay: 300,
                            ),
                            AnimatedQuickAccessCard(
                              title: 'Orientation',
                              icon: Icons.compass_calibration,
                              color: const Color(0xFFFF9800),
                              delay: 400,
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Section Tous les services
                    Transform.translate(
                      offset: Offset(0, _slideAnimation.value * 0.4),
                      child: ShaderMask(
                        shaderCallback: (bounds) => LinearGradient(
                          colors: [Colors.black87, Colors.purple],
                        ).createShader(bounds),
                        child: Text(
                          'Tous les services',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Modules grid avec animation
                    Transform.translate(
                      offset: Offset(0, _slideAnimation.value * 0.2),
                      child: GridView.builder(
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
                          return AnimatedModuleCard(
                            module: modules[index],
                            delay: index * 50,
                          );
                        },
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Section Talents scientifiques avec animation
                    Transform.translate(
                      offset: Offset(0, _slideAnimation.value * 0.1),
                      child: Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 20,
                              offset: const Offset(0, 5),
                              spreadRadius: 2,
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                AnimatedBuilder(
                                  animation: _pulseAnimation,
                                  builder: (context, child) {
                                    return Transform.scale(
                                      scale: _pulseAnimation.value,
                                      child: Icon(
                                        Icons.star,
                                        color: Colors.orange,
                                        size: 24,
                                      ),
                                    );
                                  },
                                ),
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
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: BottomNavigationBar(
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
          elevation: 0,
          selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold),
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
      ),
    );
  }
}

class DashboardModule {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;
  final int? notification;
  final bool isLive;

  DashboardModule({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
    this.notification,
    this.isLive = false,
  });
}

class AnimatedModuleCard extends StatefulWidget {
  final DashboardModule module;
  final int delay;

  const AnimatedModuleCard({
    Key? key,
    required this.module,
    required this.delay,
  }) : super(key: key);

  @override
  _AnimatedModuleCardState createState() => _AnimatedModuleCardState();
}

class _AnimatedModuleCardState extends State<AnimatedModuleCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _rotationAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: Duration(milliseconds: 300 + widget.delay),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.elasticOut,
    ));

    _rotationAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));

    Future.delayed(Duration(milliseconds: widget.delay), () {
      if (mounted) _controller.forward();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: GestureDetector(
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Ouverture de ${widget.module.title}'),
                  duration: const Duration(seconds: 2),
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              );
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.08),
                    blurRadius: 15,
                    offset: const Offset(0, 4),
                    spreadRadius: 1,
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Stack(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: widget.module.color.withOpacity(0.15),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Icon(
                              widget.module.icon,
                              color: widget.module.color,
                              size: 24,
                            ),
                          ),
                          if (widget.module.notification != null)
                            Positioned(
                              right: -2,
                              top: -2,
                              child: Container(
                                padding: const EdgeInsets.all(4),
                                decoration: BoxDecoration(
                                  color: Colors.red,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                constraints: const BoxConstraints(
                                  minWidth: 18,
                                  minHeight: 18,
                                ),
                                child: Text(
                                  '${widget.module.notification}',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                          if (widget.module.isLive)
                            Positioned(
                              right: -2,
                              top: -2,
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 6,
                                  vertical: 2,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.red,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: const Text(
                                  'LIVE',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 8,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    widget.module.title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    widget.module.subtitle,
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
          ),
        );
      },
    );
  }
}

class AnimatedQuickAccessCard extends StatefulWidget {
  final String title;
  final IconData icon;
  final Color color;
  final int delay;

  const AnimatedQuickAccessCard({
    Key? key,
    required this.title,
    required this.icon,
    required this.color,
    required this.delay,
  }) : super(key: key);

  @override
  _AnimatedQuickAccessCardState createState() => _AnimatedQuickAccessCardState();
}

class _AnimatedQuickAccessCardState extends State<AnimatedQuickAccessCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _slideAnimation;
  bool _isPressed = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: Duration(milliseconds: 500 + widget.delay),
      vsync: this,
    );

    _slideAnimation = Tween<double>(
      begin: 100.0,
      end: 0.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.elasticOut,
    ));

    Future.delayed(Duration(milliseconds: widget.delay), () {
      if (mounted) _controller.forward();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _slideAnimation,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(_slideAnimation.value, 0),
          child: GestureDetector(
            onTapDown: (_) => setState(() => _isPressed = true),
            onTapUp: (_) => setState(() => _isPressed = false),
            onTapCancel: () => setState(() => _isPressed = false),
            child: AnimatedScale(
              scale: _isPressed ? 0.95 : 1.0,
              duration: const Duration(milliseconds: 100),
              child: Container(
                width: 100,
                margin: const EdgeInsets.only(right: 16),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.08),
                      blurRadius: 15,
                      offset: const Offset(0, 4),
                      spreadRadius: 1,
                    ),
                  ],
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: widget.color.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        widget.icon,
                        color: widget.color,
                        size: 24,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      widget.title,
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}


/* import 'package:flutter/material.dart';

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
 */