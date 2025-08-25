import 'package:flutter/material.dart';

// Page des Cours
class CoursesPage extends StatefulWidget {
  const CoursesPage({super.key});

  @override
  State<CoursesPage> createState() => _CoursesPageState();
}

class _CoursesPageState extends State<CoursesPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  final List<DetailedCourse> _allCourses = [
    // Cours de programmation
    DetailedCourse(
      title: 'Learn Python',
      subtitle: 'Programming Fundamentals',
      description:
          'Complete Python programming course from beginner to advanced. Learn syntax, data structures, OOP, and build real projects.',
      duration: '12 weeks',
      level: 'Beginner',
      instructor: 'Dr. Sarah Johnson',
      rating: 4.8,
      studentsCount: 1250,
      price: '\$99',
      color: Colors.blue.shade800,
      imagePath: 'assets/programmation.jpg',
      category: CourseCategory.programming,
      modules: [
        'Python Basics & Syntax',
        'Data Types & Variables',
        'Control Structures',
        'Functions & Modules',
        'Object-Oriented Programming',
        'File Handling & APIs',
        'Final Project',
      ],
      skills: [
        'Python Programming',
        'Problem Solving',
        'Software Development',
        'Debugging',
      ],
    ),
    DetailedCourse(
      title: 'Web Development',
      subtitle: 'HTML, CSS, JavaScript',
      description:
          'Full-stack web development course covering front-end and back-end technologies. Build responsive websites and web applications.',
      duration: '16 weeks',
      level: 'Intermediate',
      instructor: 'Mark Thompson',
      rating: 4.9,
      studentsCount: 2100,
      price: '\$149',
      color: Colors.orange.shade700,
      imagePath: 'assets/ia.jpg',
      category: CourseCategory.webDevelopment,
      modules: [
        'HTML5 & Semantic Markup',
        'CSS3 & Responsive Design',
        'JavaScript Fundamentals',
        'DOM Manipulation',
        'React.js Framework',
        'Node.js & Express',
        'Database Integration',
        'Deployment & Hosting',
      ],
      skills: [
        'HTML5',
        'CSS3',
        'JavaScript',
        'React.js',
        'Node.js',
        'Responsive Design',
      ],
    ),
    DetailedCourse(
      title: 'Mobile App Development',
      subtitle: 'Flutter & React Native',
      description:
          'Learn to build native mobile apps for iOS and Android using Flutter and React Native frameworks.',
      duration: '14 weeks',
      level: 'Intermediate',
      instructor: 'Lisa Chen',
      rating: 4.7,
      studentsCount: 890,
      price: '\$129',
      color: Colors.purple.shade700,
      imagePath: 'assets/programmation2.jpg',
      category: CourseCategory.mobile,
      modules: [
        'Flutter Setup & Dart Language',
        'Widgets & Layouts',
        'Navigation & State Management',
        'APIs & Networking',
        'Local Storage & Databases',
        'Publishing to App Stores',
      ],
      skills: [
        'Flutter',
        'Dart',
        'React Native',
        'Mobile UI/UX',
        'App Store Deployment',
      ],
    ),

    // Cours de data science
    DetailedCourse(
      title: 'Data Science',
      subtitle: 'Analytics & Machine Learning',
      description:
          'Comprehensive data science course covering statistics, machine learning, and data visualization techniques.',
      duration: '18 weeks',
      level: 'Advanced',
      instructor: 'Dr. Michael Rodriguez',
      rating: 4.9,
      studentsCount: 750,
      price: '\$199',
      color: Colors.red.shade700,
      imagePath: 'assets/programmation.jpg',
      category: CourseCategory.dataScience,
      modules: [
        'Statistics & Probability',
        'Python for Data Science',
        'Data Cleaning & Preprocessing',
        'Exploratory Data Analysis',
        'Machine Learning Algorithms',
        'Deep Learning Basics',
        'Data Visualization',
        'Capstone Project',
      ],
      skills: [
        'Python',
        'Statistics',
        'Machine Learning',
        'Data Visualization',
        'SQL',
      ],
    ),

    // Cours de cybersécurité
    DetailedCourse(
      title: 'Cybersecurity',
      subtitle: 'Network Security',
      description:
          'Learn cybersecurity fundamentals, ethical hacking, and how to protect systems from cyber threats.',
      duration: '10 weeks',
      level: 'Intermediate',
      instructor: 'James Wilson',
      rating: 4.6,
      studentsCount: 650,
      price: '\$119',
      color: Colors.green.shade700,
      imagePath: 'assets/technology.jpg',
      category: CourseCategory.cybersecurity,
      modules: [
        'Cybersecurity Fundamentals',
        'Network Security',
        'Ethical Hacking',
        'Incident Response',
        'Security Tools & Frameworks',
        'Compliance & Risk Management',
      ],
      skills: [
        'Network Security',
        'Ethical Hacking',
        'Risk Assessment',
        'Security Tools',
      ],
    ),

    // Cours de cloud computing
    DetailedCourse(
      title: 'Cloud Computing',
      subtitle: 'AWS & Azure',
      description:
          'Master cloud computing platforms including AWS and Azure. Learn deployment, scaling, and cloud architecture.',
      duration: '12 weeks',
      level: 'Intermediate',
      instructor: 'Emma Davis',
      rating: 4.8,
      studentsCount: 980,
      price: '\$159',
      color: Colors.teal.shade700,
      imagePath: 'assets/ia.jpg',
      category: CourseCategory.cloud,
      modules: [
        'Cloud Computing Basics',
        'AWS Core Services',
        'Azure Fundamentals',
        'Cloud Storage Solutions',
        'Auto-scaling & Load Balancing',
        'Cloud Security',
        'Cost Optimization',
      ],
      skills: [
        'AWS',
        'Azure',
        'Cloud Architecture',
        'DevOps',
        'Serverless Computing',
      ],
    ),
  ];

  List<DetailedCourse> _filteredCourses = [];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 6, vsync: this);
    _filteredCourses = _allCourses;
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _filterCourses(String query) {
    setState(() {
      _searchQuery = query.toLowerCase();
      if (_searchQuery.isEmpty) {
        _filteredCourses = _allCourses;
      } else {
        _filteredCourses = _allCourses
            .where(
              (course) =>
                  course.title.toLowerCase().contains(_searchQuery) ||
                  course.subtitle.toLowerCase().contains(_searchQuery) ||
                  course.description.toLowerCase().contains(_searchQuery) ||
                  course.instructor.toLowerCase().contains(_searchQuery),
            )
            .toList();
      }
    });
  }

  List<DetailedCourse> _getFilteredByTab() {
    switch (_tabController.index) {
      case 0:
        return _filteredCourses;
      case 1:
        return _filteredCourses
            .where((c) => c.category == CourseCategory.programming)
            .toList();
      case 2:
        return _filteredCourses
            .where((c) => c.category == CourseCategory.webDevelopment)
            .toList();
      case 3:
        return _filteredCourses
            .where((c) => c.category == CourseCategory.mobile)
            .toList();
      case 4:
        return _filteredCourses
            .where((c) => c.category == CourseCategory.dataScience)
            .toList();
      case 5:
        return _filteredCourses
            .where(
              (c) =>
                  c.category == CourseCategory.cybersecurity ||
                  c.category == CourseCategory.cloud,
            )
            .toList();
      default:
        return _filteredCourses;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1F5AD2),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Courses',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.white,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          isScrollable: true,
          tabs: const [
            Tab(text: 'All'),
            Tab(text: 'Programming'),
            Tab(text: 'Web Dev'),
            Tab(text: 'Mobile'),
            Tab(text: 'Data Science'),
            Tab(text: 'Other'),
          ],
        ),
      ),
      body: Column(
        children: [
          // Barre de recherche
          Container(
            color: const Color(0xFF1F5AD2),
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(25),
              ),
              child: TextField(
                controller: _searchController,
                onChanged: _filterCourses,
                decoration: InputDecoration(
                  hintText: 'Search courses...',
                  hintStyle: const TextStyle(color: Colors.white70),
                  prefixIcon: const Icon(Icons.search, color: Colors.white70),
                  suffixIcon: _searchQuery.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.clear, color: Colors.white70),
                          onPressed: () {
                            _searchController.clear();
                            _filterCourses('');
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

          // Liste des cours
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildCourseList(_getFilteredByTab()),
                _buildCourseList(_getFilteredByTab()),
                _buildCourseList(_getFilteredByTab()),
                _buildCourseList(_getFilteredByTab()),
                _buildCourseList(_getFilteredByTab()),
                _buildCourseList(_getFilteredByTab()),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCourseList(List<DetailedCourse> courses) {
    if (courses.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.school_outlined, size: 80, color: Colors.grey.shade400),
            const SizedBox(height: 16),
            Text(
              _searchQuery.isEmpty
                  ? 'No courses available'
                  : 'No courses found',
              style: TextStyle(
                fontSize: 18,
                color: Colors.grey.shade600,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              _searchQuery.isEmpty
                  ? 'New courses coming soon!'
                  : 'Try different search terms',
              style: TextStyle(fontSize: 14, color: Colors.grey.shade500),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: courses.length,
      itemBuilder: (context, index) {
        final course = courses[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 16),
          elevation: 3,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: InkWell(
            onTap: () => _navigateToCourseDetail(course),
            borderRadius: BorderRadius.circular(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Image header
                Container(
                  height: 160,
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(16),
                      topRight: Radius.circular(16),
                    ),
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
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(16),
                        topRight: Radius.circular(16),
                      ),
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          course.color.withOpacity(0.8),
                        ],
                      ),
                    ),
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            course.level,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          course.title,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          course.subtitle,
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // Contenu de la carte
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Description
                      Text(
                        course.description,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey.shade700,
                          height: 1.4,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 12),

                      // Informations du cours
                      Row(
                        children: [
                          _buildInfoChip(Icons.person, course.instructor),
                          const SizedBox(width: 8),
                          _buildInfoChip(Icons.schedule, course.duration),
                        ],
                      ),
                      const SizedBox(height: 12),

                      // Rating et prix
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Icon(Icons.star, color: Colors.amber, size: 18),
                              const SizedBox(width: 4),
                              Text(
                                '${course.rating}',
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(width: 4),
                              Text(
                                '(${course.studentsCount})',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey.shade600,
                                ),
                              ),
                            ],
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: course.color,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              course.price,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildInfoChip(IconData icon, String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: Colors.grey.shade600),
          const SizedBox(width: 4),
          Text(
            text,
            style: TextStyle(fontSize: 12, color: Colors.grey.shade700),
          ),
        ],
      ),
    );
  }

  void _navigateToCourseDetail(DetailedCourse course) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => CourseDetailPage(course: course)),
    );
  }
}

// Page de détail d'un cours
class CourseDetailPage extends StatelessWidget {
  final DetailedCourse course;

  const CourseDetailPage({super.key, required this.course});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: CustomScrollView(
        slivers: [
          // App Bar avec image
          SliverAppBar(
            expandedHeight: 300,
            pinned: true,
            backgroundColor: course.color,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () => Navigator.pop(context),
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.favorite_border, color: Colors.white),
                onPressed: () {},
              ),
              IconButton(
                icon: const Icon(Icons.share, color: Colors.white),
                onPressed: () {},
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(course.imagePath),
                    fit: BoxFit.cover,
                    colorFilter: ColorFilter.mode(
                      course.color.withOpacity(0.7),
                      BlendMode.overlay,
                    ),
                  ),
                ),
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        course.color.withOpacity(0.8),
                      ],
                    ),
                  ),
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 40),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          course.level,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        course.title,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        course.subtitle,
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),

          // Contenu principal
          SliverToBoxAdapter(
            child: Container(
              color: Colors.white,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Statistiques du cours
                  Container(
                    padding: const EdgeInsets.all(20),
                    child: Row(
                      children: [
                        Expanded(
                          child: _buildStatCard(
                            Icons.star,
                            '${course.rating}',
                            'Rating',
                          ),
                        ),
                        Expanded(
                          child: _buildStatCard(
                            Icons.people,
                            '${course.studentsCount}',
                            'Students',
                          ),
                        ),
                        Expanded(
                          child: _buildStatCard(
                            Icons.schedule,
                            course.duration,
                            'Duration',
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Description
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'About this course',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          course.description,
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey.shade700,
                            height: 1.6,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Instructeur
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade50,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.grey.shade200),
                      ),
                      child: Row(
                        children: [
                          CircleAvatar(
                            radius: 25,
                            backgroundColor: course.color,
                            child: Text(
                              course.instructor
                                  .split(' ')
                                  .map((n) => n[0])
                                  .take(2)
                                  .join(),
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Instructor',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey,
                                  ),
                                ),
                                Text(
                                  course.instructor,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
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
                  ),

                  const SizedBox(height: 24),

                  // Modules du cours
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Course modules',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        const SizedBox(height: 12),
                        ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: course.modules.length,
                          itemBuilder: (context, index) {
                            return Container(
                              margin: const EdgeInsets.only(bottom: 8),
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: Colors.grey.shade50,
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(color: Colors.grey.shade200),
                              ),
                              child: Row(
                                children: [
                                  Container(
                                    width: 24,
                                    height: 24,
                                    decoration: BoxDecoration(
                                      color: course.color,
                                      shape: BoxShape.circle,
                                    ),
                                    child: Center(
                                      child: Text(
                                        '${index + 1}',
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Text(
                                      course.modules[index],
                                      style: const TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                  Icon(
                                    Icons.play_circle_outline,
                                    color: Colors.grey.shade400,
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Compétences acquises
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Skills you\'ll gain',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: course.skills
                              .map(
                                (skill) => Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 6,
                                  ),
                                  decoration: BoxDecoration(
                                    color: course.color.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(20),
                                    border: Border.all(
                                      color: course.color.withOpacity(0.3),
                                    ),
                                  ),
                                  child: Text(
                                    skill,
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: course.color,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              )
                              .toList(),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 100), // Espace pour le bouton flottant
                ],
              ),
            ),
          ),
        ],
      ),

      // Bouton d'inscription flottant
      floatingActionButton: Container(
        width: double.infinity,
        margin: const EdgeInsets.symmetric(horizontal: 20),
        child: FloatingActionButton.extended(
          backgroundColor: course.color,
          onPressed: () => _showEnrollDialog(context),
          label: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Enroll Now - ${course.price}',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  Widget _buildStatCard(IconData icon, String value, String label) {
    return Column(
      children: [
        Icon(icon, color: course.color, size: 24),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        Text(
          label,
          style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
        ),
      ],
    );
  }

  void _showEnrollDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Text(
            'Enroll in Course',
            style: TextStyle(color: course.color, fontWeight: FontWeight.bold),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'You\'re about to enroll in "${course.title}"',
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Price:',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(
                    course.price,
                    style: TextStyle(
                      color: course.color,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Duration:',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(course.duration),
                ],
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                'Cancel',
                style: TextStyle(color: Colors.grey.shade600),
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: course.color,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onPressed: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: const Text('Successfully enrolled in course!'),
                    backgroundColor: Colors.green,
                    behavior: SnackBarBehavior.floating,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                );
              },
              child: const Text('Enroll Now'),
            ),
          ],
        );
      },
    );
  }
}

// Modèles de données
enum CourseCategory {
  programming,
  webDevelopment,
  mobile,
  dataScience,
  cybersecurity,
  cloud,
}

class DetailedCourse {
  final String title;
  final String subtitle;
  final String description;
  final String duration;
  final String level;
  final String instructor;
  final double rating;
  final int studentsCount;
  final String price;
  final Color color;
  final String imagePath;
  final CourseCategory category;
  final List<String> modules;
  final List<String> skills;

  DetailedCourse({
    required this.title,
    required this.subtitle,
    required this.description,
    required this.duration,
    required this.level,
    required this.instructor,
    required this.rating,
    required this.studentsCount,
    required this.price,
    required this.color,
    required this.imagePath,
    required this.category,
    required this.modules,
    required this.skills,
  });
}
