import 'package:flutter/material.dart';
import 'package:ptest/main/utils/is_mobile.dart';
import 'package:ptest/user/models/topic_model.dart';
import 'package:ptest/user/services/topic_service.dart';

class TopicsPage extends StatefulWidget {
  const TopicsPage({super.key});

  @override
  State<TopicsPage> createState() => _TopicsPageState();
}

class _TopicsPageState extends State<TopicsPage> {
  final TopicService _topicService = TopicService();
  List<TopicModel>? _topics;
  bool _isLoading = true;
  String? _errorMessage;
  String _selectedLanguage = 'uz';

  @override
  void initState() {
    super.initState();
    _loadTopics();
  }

  Future<void> _loadTopics() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final topics = await _topicService.getTopics();

      if (!mounted) return;

      setState(() {
        if (topics == null) {
          _errorMessage = 'Server bilan bog\'lanishda xatolik';
          _topics = null;
        } else if (topics.isEmpty) {
          _errorMessage = 'Mavzular topilmadi';
          _topics = [];
        } else {
          _topics = topics;
          _errorMessage = null;
        }
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _errorMessage = 'Xatolik yuz berdi: ${e.toString()}';
        _topics = null;
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Mavzular'),
        actions: [
          if (_topics != null && _topics!.isNotEmpty)
            PopupMenuButton<String>(
              icon: Icon(Icons.language, color: Colors.white),
              onSelected: (value) {
                setState(() => _selectedLanguage = value);
              },
              itemBuilder: (context) => [
                PopupMenuItem(value: 'uz', child: Text('O\'zbekcha')),
                PopupMenuItem(value: 'ru', child: Text('Русский')),
                PopupMenuItem(value: 'cy', child: Text('Ўзбекча')),
              ],
            ),
        ],
      ),
      body: _isLoading
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(color: Colors.white),
                  SizedBox(height: 16),
                  Text(
                    'Yuklanmoqda...',
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ],
              ),
            )
          : _errorMessage != null
          ? _buildErrorWidget()
          : _topics!.isEmpty
          ? _buildEmptyWidget()
          : RefreshIndicator(
              onRefresh: _loadTopics,
              child: GridView.builder(
                padding: EdgeInsets.all(
                  ResponsiveManager.pick(mobile: 12, tablet: 16, desktop: 24),
                ),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: ResponsiveManager.pick(
                    mobile: 2,
                    tablet: 3,
                    desktop: 4,
                  ),
                  crossAxisSpacing: ResponsiveManager.pick(
                    mobile: 12,
                    tablet: 16,
                    desktop: 20,
                  ),
                  mainAxisSpacing: ResponsiveManager.pick(
                    mobile: 12,
                    tablet: 16,
                    desktop: 20,
                  ),
                  childAspectRatio: ResponsiveManager.pick(
                    mobile: 0.85,
                    tablet: 1.0,
                    desktop: 1.1,
                  ),
                ),
                itemCount: _topics!.length,
                itemBuilder: (context, index) {
                  final topic = _topics![index];
                  return _TopicCard(
                    topic: topic,
                    language: _selectedLanguage,
                    index: index,
                    onTap: () {
                      // Navigate to topic details
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            '${topic.name[_selectedLanguage]} tanlandi',
                          ),
                          duration: Duration(seconds: 1),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
    );
  }

  Widget _buildErrorWidget() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: ResponsiveManager.pick(mobile: 64, tablet: 80, desktop: 96),
              color: Colors.red.withOpacity(0.7),
            ),
            SizedBox(height: 24),
            Text(
              'Xatolik',
              style: TextStyle(
                color: Colors.white,
                fontSize: ResponsiveManager.pick(
                  mobile: 20,
                  tablet: 24,
                  desktop: 28,
                ),
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 12),
            Text(
              _errorMessage ?? 'Noma\'lum xatolik',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white.withOpacity(0.8),
                fontSize: ResponsiveManager.pick(
                  mobile: 14,
                  tablet: 16,
                  desktop: 18,
                ),
              ),
            ),
            SizedBox(height: 32),
            ElevatedButton.icon(
              onPressed: _loadTopics,
              icon: Icon(Icons.refresh),
              label: Text('Qayta urinish'),
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                textStyle: TextStyle(
                  fontSize: ResponsiveManager.pick(
                    mobile: 14,
                    tablet: 16,
                    desktop: 18,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyWidget() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.inbox_outlined,
            size: ResponsiveManager.pick(mobile: 64, tablet: 80, desktop: 96),
            color: Colors.white.withOpacity(0.5),
          ),
          SizedBox(height: 24),
          Text(
            'Mavzular topilmadi',
            style: TextStyle(
              color: Colors.white,
              fontSize: ResponsiveManager.pick(
                mobile: 18,
                tablet: 22,
                desktop: 26,
              ),
            ),
          ),
          SizedBox(height: 32),
          ElevatedButton.icon(
            onPressed: _loadTopics,
            icon: Icon(Icons.refresh),
            label: Text('Yangilash'),
          ),
        ],
      ),
    );
  }
}

class _TopicCard extends StatelessWidget {
  final TopicModel topic;
  final String language;
  final int index;
  final VoidCallback onTap;

  const _TopicCard({
    required this.topic,
    required this.language,
    required this.index,
    required this.onTap,
  });

  Color _getCardColor(int index) {
    final colors = [
      Colors.blue,
      Colors.green,
      Colors.orange,
      Colors.purple,
      Colors.teal,
      Colors.pink,
    ];
    return colors[index % colors.length];
  }

  IconData _getIcon(int index) {
    final icons = [
      Icons.school,
      Icons.lightbulb,
      Icons.book,
      Icons.quiz,
      Icons.workspace_premium,
      Icons.psychology,
    ];
    return icons[index % icons.length];
  }

  @override
  Widget build(BuildContext context) {
    final topicName = topic.name[language] ?? topic.name['uz'] ?? 'No name';
    final cardColor = _getCardColor(index);
    final icon = _getIcon(index);

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      color: Colors.white.withOpacity(0.1),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [cardColor.withOpacity(0.2), cardColor.withOpacity(0.05)],
            ),
          ),
          padding: EdgeInsets.all(
            ResponsiveManager.pick(mobile: 12, tablet: 16, desktop: 20),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                padding: EdgeInsets.all(
                  ResponsiveManager.pick(mobile: 12, tablet: 16, desktop: 20),
                ),
                decoration: BoxDecoration(
                  color: cardColor.withOpacity(0.3),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  icon,
                  color: cardColor,
                  size: ResponsiveManager.pick(
                    mobile: 32,
                    tablet: 40,
                    desktop: 48,
                  ),
                ),
              ),
              SizedBox(height: 12),
              Flexible(
                child: Text(
                  topicName,
                  textAlign: TextAlign.center,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: ResponsiveManager.pick(
                      mobile: 13,
                      tablet: 15,
                      desktop: 17,
                    ),
                    fontWeight: FontWeight.w600,
                    height: 1.3,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
