import 'package:flutter/material.dart';
import 'dart:async';
import '../services/debug/ai_debug_service.dart';

/// AI-Powered Debug Dashboard
/// Real-time code analysis, automated testing, and AI-suggested fixes
class AIDebugDashboard extends StatefulWidget {
  const AIDebugDashboard({Key? key}) : super(key: key);

  @override
  State<AIDebugDashboard> createState() => _AIDebugDashboardState();
}

class _AIDebugDashboardState extends State<AIDebugDashboard> with SingleTickerProviderStateMixin {
  final AIDebugService _debugService = AIDebugService();
  late TabController _tabController;
  
  Map<String, dynamic>? _codeHealth;
  List<Map<String, dynamic>>? _testSuggestions;
  List<Map<String, dynamic>>? _criticalIssues;
  List<Map<String, dynamic>>? _optimizations;
  Map<String, dynamic>? _realTimeInsights;
  List<Map<String, dynamic>> _recentFindings = [];
  
  bool _isLoading = true;
  StreamSubscription? _analysisSubscription;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this);
    _loadDashboardData();
    _startLiveAnalysis();
  }

  Future<void> _loadDashboardData() async {
    setState(() => _isLoading = true);
    
    final results = await Future.wait([
      _debugService.getCodeHealthMetrics(),
      _debugService.getTestSuggestions(),
      _debugService.getCriticalIssues(),
      _debugService.getOptimizationSuggestions(),
      _debugService.getRealTimeInsights(),
    ]);
    
    setState(() {
      _codeHealth = results[0] as Map<String, dynamic>;
      _testSuggestions = results[1] as List<Map<String, dynamic>>;
      _criticalIssues = results[2] as List<Map<String, dynamic>>;
      _optimizations = results[3] as List<Map<String, dynamic>>;
      _realTimeInsights = results[4] as Map<String, dynamic>;
      _isLoading = false;
    });
  }

  void _startLiveAnalysis() {
    _debugService.startAIAnalysis();
    _analysisSubscription = _debugService.analysisStream.listen((analysis) {
      setState(() {
        _recentFindings.insertAll(0, analysis['findings'] as List<Map<String, dynamic>>);
        if (_recentFindings.length > 20) {
          _recentFindings = _recentFindings.sublist(0, 20);
        }
      });
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    _analysisSubscription?.cancel();
    _debugService.stopAIAnalysis();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF0A0E27),
      appBar: AppBar(
        title: Row(
          children: [
            Icon(Icons.bug_report, color: Colors.greenAccent),
            SizedBox(width: 12),
            Text(
              'AI Debug Center',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            SizedBox(width: 12),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.greenAccent.withOpacity(0.2),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.greenAccent, width: 1),
              ),
              child: Row(
                children: [
                  Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: Colors.greenAccent,
                      shape: BoxShape.circle,
                    ),
                  ),
                  SizedBox(width: 6),
                  Text(
                    'AI Active',
                    style: TextStyle(
                      color: Colors.greenAccent,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        backgroundColor: Color(0xFF0A0E27),
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(Icons.refresh, color: Colors.white70),
            onPressed: _loadDashboardData,
            tooltip: 'Refresh Analysis',
          ),
          SizedBox(width: 8),
        ],
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          indicatorColor: Colors.cyanAccent,
          labelColor: Colors.cyanAccent,
          unselectedLabelColor: Colors.white54,
          tabs: [
            Tab(icon: Icon(Icons.dashboard), text: 'Overview'),
            Tab(icon: Icon(Icons.warning_amber), text: 'Critical Issues'),
            Tab(icon: Icon(Icons.science), text: 'AI Tests'),
            Tab(icon: Icon(Icons.speed), text: 'Optimizations'),
            Tab(icon: Icon(Icons.stream), text: 'Live Feed'),
          ],
        ),
      ),
      body: _isLoading
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(color: Colors.cyanAccent),
                  SizedBox(height: 20),
                  Text(
                    'AI analyzing your codebase...',
                    style: TextStyle(color: Colors.white70, fontSize: 16),
                  ),
                ],
              ),
            )
          : TabBarView(
              controller: _tabController,
              children: [
                _buildOverviewTab(),
                _buildCriticalIssuesTab(),
                _buildTestSuggestionsTab(),
                _buildOptimizationsTab(),
                _buildLiveFeedTab(),
              ],
            ),
    );
  }

  Widget _buildOverviewTab() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Real-time Insights
          _buildSectionTitle('⚡ Real-Time Insights', Icons.insights),
          SizedBox(height: 16),
          _buildRealTimeInsightsCard(),
          SizedBox(height: 30),
          
          // Code Health Score
          _buildSectionTitle('🏥 Code Health Metrics', Icons.favorite),
          SizedBox(height: 16),
          _buildCodeHealthCard(),
          SizedBox(height: 30),
          
          // Quick Stats
          _buildSectionTitle('📊 Quick Stats', Icons.analytics),
          SizedBox(height: 16),
          _buildQuickStatsGrid(),
        ],
      ),
    );
  }

  Widget _buildRealTimeInsightsCard() {
    if (_realTimeInsights == null) return SizedBox();
    
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF1a1f3a), Color(0xFF2a2f4a)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.greenAccent.withOpacity(0.3), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.greenAccent.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(Icons.auto_awesome, color: Colors.greenAccent, size: 24),
              ),
              SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'AI Analysis Status',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      _realTimeInsights!['activeScan'] ? 'Scanning in progress...' : 'Idle',
                      style: TextStyle(color: Colors.white60, fontSize: 14),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 20),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: [
              _buildInsightChip(
                'Active Issues',
                '${_realTimeInsights!['activeIssues']}',
                Colors.orangeAccent,
                Icons.warning,
              ),
              _buildInsightChip(
                'Resolved Today',
                '${_realTimeInsights!['issuesResolvedToday']}',
                Colors.greenAccent,
                Icons.check_circle,
              ),
              _buildInsightChip(
                'AI Fixes Applied',
                '${_realTimeInsights!['aiSuggestionsApplied']}',
                Colors.cyanAccent,
                Icons.auto_fix_high,
              ),
              _buildInsightChip(
                'Coverage Change',
                _realTimeInsights!['testCoverageChange'],
                Colors.purpleAccent,
                Icons.trending_up,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInsightChip(String label, String value, Color color, IconData icon) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.3), width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color, size: 16),
          SizedBox(width: 6),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                value,
                style: TextStyle(
                  color: color,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                label,
                style: TextStyle(color: Colors.white60, fontSize: 11),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCodeHealthCard() {
    if (_codeHealth == null) return SizedBox();
    
    final score = _codeHealth!['overallScore'];
    final color = score >= 90
        ? Colors.greenAccent
        : score >= 75
            ? Colors.orangeAccent
            : Colors.redAccent;
    
    return Container(
      padding: EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF1a1f3a), Color(0xFF2a2f4a)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withOpacity(0.3), width: 1),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Overall Health Score',
                      style: TextStyle(color: Colors.white70, fontSize: 16),
                    ),
                    SizedBox(height: 8),
                    Row(
                      children: [
                        Text(
                          '$score',
                          style: TextStyle(
                            color: color,
                            fontSize: 48,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          '/100',
                          style: TextStyle(
                            color: Colors.white38,
                            fontSize: 24,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 4),
                    Text(
                      'Grade: ${_codeHealth!['codeQuality']}',
                      style: TextStyle(color: Colors.white60, fontSize: 14),
                    ),
                  ],
                ),
              ),
              Container(
                width: 120,
                height: 120,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    CircularProgressIndicator(
                      value: score / 100,
                      strokeWidth: 8,
                      backgroundColor: Colors.white12,
                      color: color,
                    ),
                    Icon(
                      Icons.code,
                      size: 40,
                      color: color,
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 24),
          Divider(color: Colors.white12),
          SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildMetricColumn('Test Coverage', '${_codeHealth!['testCoverage']}%', Colors.cyanAccent),
              _buildMetricColumn('Security', '${_codeHealth!['securityScore']}', Colors.purpleAccent),
              _buildMetricColumn('Performance', '${_codeHealth!['performanceScore']}', Colors.greenAccent),
              _buildMetricColumn('Tech Debt', _codeHealth!['technicalDebt'], Colors.orangeAccent),
            ],
          ),
          SizedBox(height: 16),
          Container(
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.blueAccent.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.blueAccent.withOpacity(0.3), width: 1),
            ),
            child: Row(
              children: [
                Icon(Icons.psychology, color: Colors.blueAccent, size: 20),
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Analyzed by: ${_codeHealth!['aiModel']}',
                    style: TextStyle(color: Colors.white70, fontSize: 13),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMetricColumn(String label, String value, Color color) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            color: color,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(color: Colors.white60, fontSize: 12),
        ),
      ],
    );
  }

  Widget _buildQuickStatsGrid() {
    return GridView.count(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      mainAxisSpacing: 16,
      crossAxisSpacing: 16,
      childAspectRatio: 1.5,
      children: [
        _buildStatCard(
          'Files Analyzed',
          '${_codeHealth!['filesAnalyzed']}',
          Icons.folder,
          Colors.blueAccent,
        ),
        _buildStatCard(
          'Lines of Code',
          '${_codeHealth!['linesOfCode']}',
          Icons.code,
          Colors.purpleAccent,
        ),
        _buildStatCard(
          'Critical Issues',
          '${_criticalIssues?.length ?? 0}',
          Icons.error,
          Colors.redAccent,
        ),
        _buildStatCard(
          'AI Suggestions',
          '${_testSuggestions?.length ?? 0}',
          Icons.lightbulb,
          Colors.amberAccent,
        ),
      ],
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon, Color color) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF1a1f3a), Color(0xFF2a2f4a)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3), width: 1),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: color, size: 32),
          SizedBox(height: 12),
          Text(
            value,
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 4),
          Text(
            title,
            style: TextStyle(color: Colors.white60, fontSize: 13),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildCriticalIssuesTab() {
    return ListView.builder(
      padding: EdgeInsets.all(20),
      itemCount: _criticalIssues?.length ?? 0,
      itemBuilder: (context, index) {
        final issue = _criticalIssues![index];
        return _buildIssueCard(issue);
      },
    );
  }

  Widget _buildIssueCard(Map<String, dynamic> issue) {
    final severityColor = issue['severity'] == 'critical'
        ? Colors.redAccent
        : Colors.orangeAccent;
    
    return Container(
      margin: EdgeInsets.only(bottom: 16),
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF1a1f3a), Color(0xFF2a2f4a)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: severityColor.withOpacity(0.3), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: severityColor.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: severityColor, width: 1),
                ),
                child: Text(
                  issue['severity'].toString().toUpperCase(),
                  style: TextStyle(
                    color: severityColor,
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(width: 12),
              Expanded(
                child: Text(
                  issue['title'],
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 12),
          Text(
            issue['description'],
            style: TextStyle(color: Colors.white70, fontSize: 14, height: 1.5),
          ),
          SizedBox(height: 12),
          Container(
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.black26,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Icon(Icons.location_on, color: Colors.white54, size: 16),
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                    '${issue['file']}${issue['line'] != null ? ':${issue['line']}' : ''}',
                    style: TextStyle(color: Colors.white54, fontSize: 12, fontFamily: 'monospace'),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 12),
          Container(
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.blueAccent.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.blueAccent.withOpacity(0.3), width: 1),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.psychology, color: Colors.blueAccent, size: 16),
                    SizedBox(width: 8),
                    Text(
                      'AI Suggestion:',
                      style: TextStyle(
                        color: Colors.blueAccent,
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 8),
                Text(
                  issue['aiSuggestion'],
                  style: TextStyle(color: Colors.white70, fontSize: 13, height: 1.4),
                ),
              ],
            ),
          ),
          SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(Icons.schedule, color: Colors.white54, size: 16),
                  SizedBox(width: 6),
                  Text(
                    'Est. Fix: ${issue['estimatedFixTime']}',
                    style: TextStyle(color: Colors.white54, fontSize: 12),
                  ),
                  SizedBox(width: 16),
                  Icon(Icons.trending_up, color: Colors.orangeAccent, size: 16),
                  SizedBox(width: 6),
                  Text(
                    issue['impact'],
                    style: TextStyle(color: Colors.orangeAccent, fontSize: 12),
                  ),
                ],
              ),
              if (issue['autoFix'] == 'Available')
                ElevatedButton.icon(
                  onPressed: () => _applyAutoFix(issue['id']),
                  icon: Icon(Icons.auto_fix_high, size: 16),
                  label: Text('Auto Fix'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.greenAccent,
                    foregroundColor: Colors.black,
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTestSuggestionsTab() {
    return ListView.builder(
      padding: EdgeInsets.all(20),
      itemCount: _testSuggestions?.length ?? 0,
      itemBuilder: (context, index) {
        final suggestion = _testSuggestions![index];
        return _buildTestSuggestionCard(suggestion);
      },
    );
  }

  Widget _buildTestSuggestionCard(Map<String, dynamic> suggestion) {
    final priorityColor = suggestion['priority'] == 'high'
        ? Colors.redAccent
        : Colors.orangeAccent;
    
    return Container(
      margin: EdgeInsets.only(bottom: 16),
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF1a1f3a), Color(0xFF2a2f4a)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.cyanAccent.withOpacity(0.3), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.cyanAccent.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(Icons.science, color: Colors.cyanAccent, size: 20),
              ),
              SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      suggestion['title'],
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 4),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: priorityColor.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        '${suggestion['priority'].toString().toUpperCase()} PRIORITY',
                        style: TextStyle(
                          color: priorityColor,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.greenAccent.withOpacity(0.2),
                  shape: BoxShape.circle,
                ),
                child: Text(
                  '${suggestion['testCount']}',
                  style: TextStyle(
                    color: Colors.greenAccent,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 16),
          Text(
            suggestion['description'],
            style: TextStyle(color: Colors.white70, fontSize: 14, height: 1.5),
          ),
          SizedBox(height: 16),
          Wrap(
            spacing: 12,
            runSpacing: 8,
            children: [
              _buildInfoChip(Icons.timer, suggestion['estimatedTime'], Colors.blueAccent),
              _buildInfoChip(Icons.trending_up, suggestion['coverage'], Colors.greenAccent),
              _buildInfoChip(Icons.auto_awesome, 'AI Generated', Colors.purpleAccent),
            ],
          ),
          SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () => _viewTestCode(suggestion['file']),
                  icon: Icon(Icons.visibility, size: 16),
                  label: Text('View Code'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.white70,
                    side: BorderSide(color: Colors.white24),
                  ),
                ),
              ),
              SizedBox(width: 12),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () => _generateTests(suggestion['file']),
                  icon: Icon(Icons.flash_on, size: 16),
                  label: Text('Generate'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.cyanAccent,
                    foregroundColor: Colors.black,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInfoChip(IconData icon, String label, Color color) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withOpacity(0.3), width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color, size: 14),
          SizedBox(width: 6),
          Text(
            label,
            style: TextStyle(color: color, fontSize: 12, fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }

  Widget _buildOptimizationsTab() {
    return ListView.builder(
      padding: EdgeInsets.all(20),
      itemCount: _optimizations?.length ?? 0,
      itemBuilder: (context, index) {
        final opt = _optimizations![index];
        return _buildOptimizationCard(opt);
      },
    );
  }

  Widget _buildOptimizationCard(Map<String, dynamic> opt) {
    final typeColor = opt['type'] == 'performance'
        ? Colors.greenAccent
        : Colors.purpleAccent;
    
    return Container(
      margin: EdgeInsets.only(bottom: 16),
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF1a1f3a), Color(0xFF2a2f4a)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: typeColor.withOpacity(0.3), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                opt['type'] == 'performance' ? Icons.speed : Icons.star,
                color: typeColor,
                size: 24,
              ),
              SizedBox(width: 12),
              Expanded(
                child: Text(
                  opt['title'],
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 12),
          Text(
            opt['description'],
            style: TextStyle(color: Colors.white70, fontSize: 14, height: 1.5),
          ),
          SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: Container(
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.greenAccent.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    children: [
                      Icon(Icons.trending_up, color: Colors.greenAccent, size: 20),
                      SizedBox(height: 4),
                      Text(
                        opt['expectedGain'],
                        style: TextStyle(
                          color: Colors.greenAccent,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'Expected Gain',
                        style: TextStyle(color: Colors.white60, fontSize: 11),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(width: 12),
              Expanded(
                child: Container(
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.blueAccent.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    children: [
                      Icon(Icons.build, color: Colors.blueAccent, size: 20),
                      SizedBox(height: 4),
                      Text(
                        opt['difficulty'],
                        style: TextStyle(
                          color: Colors.blueAccent,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'Difficulty',
                        style: TextStyle(color: Colors.white60, fontSize: 11),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLiveFeedTab() {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.all(16),
          color: Color(0xFF1a1f3a),
          child: Row(
            children: [
              Container(
                width: 10,
                height: 10,
                decoration: BoxDecoration(
                  color: Colors.greenAccent,
                  shape: BoxShape.circle,
                ),
              ),
              SizedBox(width: 12),
              Text(
                'Live AI Analysis Feed',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Spacer(),
              Text(
                '${_recentFindings.length} findings',
                style: TextStyle(color: Colors.white60, fontSize: 14),
              ),
            ],
          ),
        ),
        Expanded(
          child: _recentFindings.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.auto_awesome, color: Colors.white24, size: 64),
                      SizedBox(height: 16),
                      Text(
                        'Waiting for AI analysis...',
                        style: TextStyle(color: Colors.white60, fontSize: 16),
                      ),
                    ],
                  ),
                )
              : ListView.builder(
                  padding: EdgeInsets.all(20),
                  itemCount: _recentFindings.length,
                  itemBuilder: (context, index) {
                    final finding = _recentFindings[index];
                    return _buildLiveFindingCard(finding);
                  },
                ),
        ),
      ],
    );
  }

  Widget _buildLiveFindingCard(Map<String, dynamic> finding) {
    final severityColor = _getSeverityColor(finding['severity']);
    
    return Container(
      margin: EdgeInsets.only(bottom: 12),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF1a1f3a), Color(0xFF2a2f4a)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: severityColor.withOpacity(0.3), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  color: severityColor,
                  shape: BoxShape.circle,
                ),
              ),
              SizedBox(width: 8),
              Text(
                finding['severity'].toString().toUpperCase(),
                style: TextStyle(
                  color: severityColor,
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(width: 12),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.white12,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  finding['type'].toString().toUpperCase(),
                  style: TextStyle(color: Colors.white70, fontSize: 10),
                ),
              ),
              Spacer(),
              if (finding['autoFixAvailable'])
                Icon(Icons.auto_fix_high, color: Colors.greenAccent, size: 16),
            ],
          ),
          SizedBox(height: 8),
          Text(
            finding['title'],
            style: TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 6),
          Text(
            '${finding['file']}:${finding['line']}',
            style: TextStyle(
              color: Colors.white54,
              fontSize: 12,
              fontFamily: 'monospace',
            ),
          ),
          if (finding['confidence'] != null) ...[
            SizedBox(height: 8),
            Row(
              children: [
                Icon(Icons.psychology, color: Colors.cyanAccent, size: 14),
                SizedBox(width: 6),
                Text(
                  'AI Confidence: ${finding['confidence']}%',
                  style: TextStyle(color: Colors.cyanAccent, fontSize: 11),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Color _getSeverityColor(String severity) {
    switch (severity) {
      case 'critical':
        return Colors.redAccent;
      case 'high':
        return Colors.orangeAccent;
      case 'medium':
        return Colors.amberAccent;
      case 'low':
        return Colors.greenAccent;
      default:
        return Colors.grey;
    }
  }

  Widget _buildSectionTitle(String title, IconData icon) {
    return Row(
      children: [
        Icon(icon, color: Colors.cyanAccent, size: 24),
        SizedBox(width: 12),
        Text(
          title,
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Future<void> _applyAutoFix(String issueId) async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Center(
        child: Container(
          padding: EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Color(0xFF1a1f3a),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircularProgressIndicator(color: Colors.cyanAccent),
              SizedBox(height: 16),
              Text(
                'AI applying automated fix...',
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
            ],
          ),
        ),
      ),
    );
    
    final result = await _debugService.applyAutoFix(issueId);
    Navigator.pop(context);
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(result['message']),
        backgroundColor: Colors.greenAccent,
        behavior: SnackBarBehavior.floating,
      ),
    );
    
    _loadDashboardData();
  }

  Future<void> _viewTestCode(String file) async {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Color(0xFF1a1f3a),
        title: Text('View Test Location', style: TextStyle(color: Colors.white)),
        content: Text(
          'Test file: test/${file.replaceAll('lib/', '').replaceAll('.dart', '_test.dart')}',
          style: TextStyle(color: Colors.white70, fontFamily: 'monospace'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Close'),
          ),
        ],
      ),
    );
  }

  Future<void> _generateTests(String serviceName) async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Center(
        child: Container(
          padding: EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Color(0xFF1a1f3a),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircularProgressIndicator(color: Colors.cyanAccent),
              SizedBox(height: 16),
              Text(
                'AI generating test code...',
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
            ],
          ),
        ),
      ),
    );
    
    final testCode = await _debugService.generateTestCode(serviceName);
    Navigator.pop(context);
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Color(0xFF1a1f3a),
        title: Row(
          children: [
            Icon(Icons.check_circle, color: Colors.greenAccent),
            SizedBox(width: 12),
            Text('Tests Generated', style: TextStyle(color: Colors.white)),
          ],
        ),
        content: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.black38,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              testCode,
              style: TextStyle(
                color: Colors.greenAccent,
                fontSize: 12,
                fontFamily: 'monospace',
              ),
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Close'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Test code copied to clipboard!'),
                  backgroundColor: Colors.greenAccent,
                ),
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.cyanAccent),
            child: Text('Copy Code', style: TextStyle(color: Colors.black)),
          ),
        ],
      ),
    );
  }
}
