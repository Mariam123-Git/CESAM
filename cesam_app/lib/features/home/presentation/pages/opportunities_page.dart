import 'package:flutter/material.dart';

// Page des Opportunités
class OpportunitiesPage extends StatefulWidget {
  const OpportunitiesPage({super.key});

  @override
  State<OpportunitiesPage> createState() => _OpportunitiesPageState();
}

class _OpportunitiesPageState extends State<OpportunitiesPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  final List<DetailedOpportunity> _allOpportunities = [
    // Bourses
    DetailedOpportunity(
      category: 'Scholarship',
      title: 'Merit-based Academic Scholarship',
      description: 'Full tuition scholarship for outstanding academic performance. Covers tuition fees, books, and living allowance.',
      amount: '\$5,000 per year',
      deadline: '2024-12-15',
      requirements: ['GPA 3.5 or higher', 'Community service record', 'Essay submission'],
      icon: Icons.card_giftcard,
      color: Colors.green,
      type: OpportunityType.scholarship,
    ),
    DetailedOpportunity(
      category: 'Scholarship',
      title: 'Need-based Financial Aid',
      description: 'Financial assistance for students from low-income families. Partial tuition coverage.',
      amount: '\$3,000 per year',
      deadline: '2024-11-30',
      requirements: ['Family income below \$30,000', 'Academic standing', 'Financial documents'],
      icon: Icons.card_giftcard,
      color: Colors.orange,
      type: OpportunityType.scholarship,
    ),
    DetailedOpportunity(
      category: 'Scholarship',
      title: 'STEM Excellence Award',
      description: 'Scholarship for students pursuing Science, Technology, Engineering, and Mathematics degrees.',
      amount: '\$4,500 per year',
      deadline: '2024-12-01',
      requirements: ['STEM major', 'GPA 3.3+', 'Research project'],
      icon: Icons.science,
      color: Colors.blue,
      type: OpportunityType.scholarship,
    ),
    
    // Stages
    DetailedOpportunity(
      category: 'Internship',
      title: 'Software Development Internship',
      description: 'Summer internship program with leading tech companies. Gain hands-on experience in software development.',
      amount: '\$1,500 per month',
      deadline: '2024-11-15',
      requirements: ['Programming skills', 'Portfolio', 'Resume'],
      icon: Icons.work,
      color: Colors.purple,
      type: OpportunityType.internship,
    ),
    DetailedOpportunity(
      category: 'Internship',
      title: 'Data Analytics Internship',
      description: 'Work with real datasets and learn advanced analytics techniques in a professional environment.',
      amount: '\$1,200 per month',
      deadline: '2024-12-10',
      requirements: ['Statistics knowledge', 'Python/R skills', 'Academic transcript'],
      icon: Icons.analytics,
      color: Colors.teal,
      type: OpportunityType.internship,
    ),
    
    // Cours/Ateliers
    DetailedOpportunity(
      category: 'Workshop',
      title: 'AI and Machine Learning Workshop',
      description: 'Intensive 3-day workshop covering fundamentals of AI and ML with hands-on projects.',
      amount: 'Free',
      deadline: '2024-11-25',
      requirements: ['Basic programming', 'Laptop required', 'Registration'],
      icon: Icons.lightbulb,
      color: Colors.red,
      type: OpportunityType.workshop,
    ),
    DetailedOpportunity(
      category: 'Course',
      title: 'Cybersecurity Certification Course',
      description: 'Industry-recognized cybersecurity certification program with job placement assistance.',
      amount: '\$299 (scholarships available)',
      deadline: '2024-12-20',
      requirements: ['Basic IT knowledge', 'Commitment for 6 months', 'Background check'],
      icon: Icons.security,
      color: Colors.indigo,
      type: OpportunityType.course,
    ),
  ];

  List<DetailedOpportunity> _filteredOpportunities = [];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _filteredOpportunities = _allOpportunities;
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _filterOpportunities(String query) {
    setState(() {
      _searchQuery = query.toLowerCase();
      if (_searchQuery.isEmpty) {
        _filteredOpportunities = _allOpportunities;
      } else {
        _filteredOpportunities = _allOpportunities.where((opportunity) =>
          opportunity.title.toLowerCase().contains(_searchQuery) ||
          opportunity.category.toLowerCase().contains(_searchQuery) ||
          opportunity.description.toLowerCase().contains(_searchQuery)
        ).toList();
      }
    });
  }

  List<DetailedOpportunity> _getFilteredByTab() {
    switch (_tabController.index) {
      case 0:
        return _filteredOpportunities;
      case 1:
        return _filteredOpportunities.where((o) => o.type == OpportunityType.scholarship).toList();
      case 2:
        return _filteredOpportunities.where((o) => o.type == OpportunityType.internship).toList();
      case 3:
        return _filteredOpportunities.where((o) => o.type == OpportunityType.workshop || o.type == OpportunityType.course).toList();
      default:
        return _filteredOpportunities;
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
          'Opportunities',
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
          tabs: const [
            Tab(text: 'All'),
            Tab(text: 'Scholarships'),
            Tab(text: 'Internships'),
            Tab(text: 'Courses'),
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
                onChanged: _filterOpportunities,
                decoration: InputDecoration(
                  hintText: 'Search opportunities...',
                  hintStyle: const TextStyle(color: Colors.white70),
                  prefixIcon: const Icon(Icons.search, color: Colors.white70),
                  suffixIcon: _searchQuery.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear, color: Colors.white70),
                        onPressed: () {
                          _searchController.clear();
                          _filterOpportunities('');
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
          
          // Liste des opportunités
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildOpportunityList(_getFilteredByTab()),
                _buildOpportunityList(_getFilteredByTab()),
                _buildOpportunityList(_getFilteredByTab()),
                _buildOpportunityList(_getFilteredByTab()),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOpportunityList(List<DetailedOpportunity> opportunities) {
    if (opportunities.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.search_off, size: 80, color: Colors.grey.shade400),
            const SizedBox(height: 16),
            Text(
              _searchQuery.isEmpty ? 'No opportunities available' : 'No opportunities found',
              style: TextStyle(
                fontSize: 18,
                color: Colors.grey.shade600,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              _searchQuery.isEmpty ? 'Check back later for new opportunities' : 'Try different search terms',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey.shade500,
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: opportunities.length,
      itemBuilder: (context, index) {
        final opportunity = opportunities[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 16),
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: InkWell(
            onTap: () => _navigateToOpportunityDetail(opportunity),
            borderRadius: BorderRadius.circular(12),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: opportunity.color.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Icon(
                          opportunity.icon,
                          color: opportunity.color,
                          size: 24,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: opportunity.color,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                opportunity.category.toUpperCase(),
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              opportunity.title,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: Colors.green.shade50,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: Colors.green.shade200),
                        ),
                        child: Text(
                          opportunity.amount,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: Colors.green.shade700,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    opportunity.description,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey.shade700,
                      height: 1.4,
                    ),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.schedule, size: 16, color: Colors.grey.shade500),
                          const SizedBox(width: 4),
                          Text(
                            'Deadline: ${_formatDate(opportunity.deadline)}',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey.shade600,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Text(
                            'View Details',
                            style: TextStyle(
                              fontSize: 12,
                              color: opportunity.color,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(width: 4),
                          Icon(
                            Icons.arrow_forward_ios,
                            size: 12,
                            color: opportunity.color,
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  String _formatDate(String dateStr) {
    DateTime date = DateTime.parse(dateStr);
    return '${date.day}/${date.month}/${date.year}';
  }

  void _navigateToOpportunityDetail(DetailedOpportunity opportunity) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => OpportunityDetailPage(opportunity: opportunity),
      ),
    );
  }
}

// Page de détail d'une opportunité
class OpportunityDetailPage extends StatelessWidget {
  final DetailedOpportunity opportunity;

  const OpportunityDetailPage({super.key, required this.opportunity});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        backgroundColor: opportunity.color,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          opportunity.category,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.share, color: Colors.white),
            onPressed: () {
              // Logique de partage
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // En-tête avec gradient
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [opportunity.color, opportunity.color.withOpacity(0.7)],
                ),
              ),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 30),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Icon(
                            opportunity.icon,
                            color: Colors.white,
                            size: 32,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                opportunity.title,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Text(
                                  opportunity.amount,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            // Contenu principal
            Container(
              color: Colors.white,
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Description
                  const Text(
                    'Description',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    opportunity.description,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey.shade700,
                      height: 1.6,
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Informations importantes
                  _buildInfoCard(
                    'Important Information',
                    [
                      _buildInfoRow(Icons.attach_money, 'Amount', opportunity.amount),
                      _buildInfoRow(Icons.schedule, 'Deadline', _formatDate(opportunity.deadline)),
                      _buildInfoRow(Icons.category, 'Category', opportunity.category),
                    ],
                  ),

                  const SizedBox(height: 20),

                  // Exigences
                  _buildRequirementsCard(),

                  const SizedBox(height: 20),

                  // Bouton d'action
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: opportunity.color,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 2,
                      ),
                      onPressed: () {
                        _showApplicationDialog(context);
                      },
                      child: Text(
                        _getActionButtonText(),
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 12),

                  // Bouton secondaire
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        foregroundColor: opportunity.color,
                        side: BorderSide(color: opportunity.color),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: () {
                        // Logique pour plus d'informations
                      },
                      child: const Text(
                        'Contact for More Info',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
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

  Widget _buildInfoCard(String title, List<Widget> children) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 12),
          ...children,
        ],
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Icon(icon, size: 20, color: opportunity.color),
          const SizedBox(width: 12),
          Text(
            '$label: ',
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 14,
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey.shade700,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRequirementsCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Requirements',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 12),
          ...opportunity.requirements.map((requirement) => Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 6,
                      height: 6,
                      margin: const EdgeInsets.only(top: 6, right: 12),
                      decoration: BoxDecoration(
                        color: opportunity.color,
                        shape: BoxShape.circle,
                      ),
                    ),
                    Expanded(
                      child: Text(
                        requirement,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey.shade700,
                          height: 1.4,
                        ),
                      ),
                    ),
                  ],
                ),
              )),
        ],
      ),
    );
  }

  String _formatDate(String dateStr) {
    DateTime date = DateTime.parse(dateStr);
    List<String> months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return '${date.day} ${months[date.month - 1]} ${date.year}';
  }

  String _getActionButtonText() {
    switch (opportunity.type) {
      case OpportunityType.scholarship:
        return 'Apply for Scholarship';
      case OpportunityType.internship:
        return 'Apply for Internship';
      case OpportunityType.workshop:
        return 'Register for Workshop';
      case OpportunityType.course:
        return 'Enroll in Course';
      default:
        return 'Apply Now';
    }
  }

  void _showApplicationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Text(
            'Application Confirmation',
            style: TextStyle(
              color: opportunity.color,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: Text(
            'Are you ready to apply for "${opportunity.title}"? Make sure you have all the required documents.',
            style: const TextStyle(fontSize: 16),
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
                backgroundColor: opportunity.color,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onPressed: () {
                Navigator.pop(context);
                // Logique d'application
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: const Text('Application submitted successfully!'),
                    backgroundColor: Colors.green,
                    behavior: SnackBarBehavior.floating,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                );
              },
              child: const Text('Apply Now'),
            ),
          ],
        );
      },
    );
  }
}

// Modèles de données
enum OpportunityType { scholarship, internship, workshop, course }

class DetailedOpportunity {
  final String category;
  final String title;
  final String description;
  final String amount;
  final String deadline;
  final List<String> requirements;
  final IconData icon;
  final Color color;
  final OpportunityType type;

  DetailedOpportunity({
    required this.category,
    required this.title,
    required this.description,
    required this.amount,
    required this.deadline,
    required this.requirements,
    required this.icon,
    required this.color,
    required this.type,
  });
}