import 'dart:convert';

import 'package:appwrite/enums.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:admin/src/config/index.dart';
import 'package:admin/src/core/index.dart';
import 'package:admin/src/feature/dashboard/provider/fetch_dashboard_data.dart';

// Provider to fetch dashboard data

class Dashboard extends ConsumerWidget {
  const Dashboard({super.key});

  Future<Map<String, dynamic>> future(body) async {
    final functionId = getFunctionId('dashboard-stats');

    final response = await functions.createExecution(
      functionId: functionId,
      method: ExecutionMethod.gET,
      body: body,
    );

    return json.decode(response.responseBody);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final auth = ref.read(authenticationProvider);

    return FutureBuilder(
      future: future(auth.logDetails('dashboard-stats')),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: ProgressBar());
        }

        if (snapshot.hasError) {
          return Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Error loading dashboard data: ${snapshot.error.toString()}',
                ),
                gap16,
                FilledButton(
                  child: const Text('Retry'),
                  onPressed: () => ref.refresh(dashboardProvider),
                ),
              ],
            ),
          );
        }

        final data = snapshot.data!['data'];

        return ScaffoldPage.scrollable(
          // padding: EdgeInsets.zero,
          children: [
            _buildStatCards(context, data),
            gap24,
            _buildPatientChart(context, data),
            gap24,
            _buildRecentActivitySection(context, data),
          ],
        );
      },
    );
  }

  Widget _buildStatCards(BuildContext context, Map<String, dynamic> data) {
    return Wrap(
      spacing: Sizes.p16,
      runSpacing: Sizes.p16,
      children: [
        _buildStatCard(
          context,
          'Users',
          data['users_count'] ?? 0,
          FluentIcons.people,
          AppColors.primary,
        ),
        _buildStatCard(
          context,
          'User Roles',
          data['roles_count'] ?? 0,
          FluentIcons.settings_secure,
          AppColors.primary,
        ),
        _buildStatCard(
          context,
          'Teams',
          data['teams_count'] ?? 0,
          FluentIcons.teamwork,
          AppColors.primary,
        ),
        _buildStatCard(
          context,
          'Patient Files',
          data['files_count'] ?? 0,
          FluentIcons.document_management,
          AppColors.primary,
        ),
        _buildStatCard(
          context,
          'Active Users',
          data['active_users'] ?? 0,
          FluentIcons.document_management,
          AppColors.primary,
        ),
        _buildStatCard(
          context,
          'Inactive Users',
          data['blocked_users'] ?? 0,
          FluentIcons.document_management,
          AppColors.primary,
        ),
      ],
    );
  }

  Widget _buildStatCard(
    BuildContext context,
    String title,
    int value,
    IconData icon,
    Color iconColor,
  ) {
    return Card(
      padding: const EdgeInsets.all(Sizes.p16),
      child: SizedBox(
        width: 250,
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: context.theme.cardColor,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Center(child: Icon(icon, color: iconColor, size: 24)),
            ),
            gap16,
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: const TextStyle(fontSize: 14)),
                  gap4,
                  Text(
                    value.toString(),
                    style: const TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
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

  Widget _buildPatientChart(BuildContext context, Map<String, dynamic> data) {
    List<Map<String, dynamic>> schoolData =
        (data['patients_per_school'] as List?)?.cast<Map<String, dynamic>>() ??
        [];

    if (schoolData.isEmpty) {
      return const Card(
        padding: EdgeInsets.all(Sizes.p24),
        child: Center(child: Text('No patient data available')),
      );
    }

    return Card(
      padding: const EdgeInsets.all(Sizes.p24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Number of Patients Per School',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          gap24,
          SizedBox(
            height: 300,
            child: BarChart(
              BarChartData(
                alignment: BarChartAlignment.spaceAround,
                maxY: _getMaxPatientCount(schoolData) * 1.2,
                barTouchData: BarTouchData(
                  enabled: true,
                  touchTooltipData: BarTouchTooltipData(
                    // tooltipBgColor: context.theme.cardColor,
                    getTooltipItem: (group, groupIndex, rod, rodIndex) {
                      return BarTooltipItem(
                        '${schoolData[groupIndex]['school']}: ${rod.toY.round()}',
                        TextStyle(color: context.theme.typography.body?.color),
                      );
                    },
                  ),
                ),
                titlesData: const FlTitlesData(
                  show: true,
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  topTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  rightTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                ),
                borderData: FlBorderData(show: false),
                gridData: const FlGridData(show: false),
                barGroups: _createBarGroups(schoolData),
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<BarChartGroupData> _createBarGroups(List<Map<String, dynamic>> data) {
    return List.generate(data.length, (index) {
      final school = data[index];
      final count = (school['patient_count'] as num).toDouble();

      return BarChartGroupData(
        x: index,
        barRods: [
          BarChartRodData(
            toY: count,
            color: AppColors.primary,
            width: 16,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(4),
              topRight: Radius.circular(4),
            ),
          ),
        ],
      );
    });
  }

  double _getMaxPatientCount(List<Map<String, dynamic>> data) {
    if (data.isEmpty) return 10;
    return data
        .map((school) => (school['patient_count'] as num).toDouble())
        .reduce((a, b) => a > b ? a : b);
  }

  Widget _buildRecentActivitySection(
    BuildContext context,
    Map<String, dynamic> data,
  ) {
    List<Map<String, dynamic>> activities =
        (data['recent_activities'] as List?)?.cast<Map<String, dynamic>>() ??
        [];

    return Card(
      padding: const EdgeInsets.all(Sizes.p24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Recent Activity',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          gap16,
          activities.isEmpty
              ? const Center(
                child: Padding(
                  padding: EdgeInsets.all(Sizes.p24),
                  child: Text('No recent activity'),
                ),
              )
              : ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: activities.length,
                separatorBuilder: (context, index) => const Divider(),
                itemBuilder: (context, index) {
                  final activity = activities[index];
                  return ListTile(
                    leading: CircleAvatar(
                      backgroundColor: context.theme.cardColor,
                      child: Icon(
                        _getActivityIcon(activity['type']),
                        color: AppColors.primary,
                        size: 16,
                      ),
                    ),
                    title: Text(activity['description'] ?? 'Unknown activity'),
                    subtitle: Text(activity['user_name'] ?? 'Unknown user'),
                    trailing: Text(activity['time'] ?? 'Unknown time'),
                  );
                },
              ),
        ],
      ),
    );
  }

  IconData _getActivityIcon(String? type) {
    switch (type) {
      case 'login':
        return FluentIcons.signin;
      case 'logout':
        return FluentIcons.accept;
      case 'create':
        return FluentIcons.add;
      case 'update':
        return FluentIcons.edit;
      case 'delete':
        return FluentIcons.delete;
      case 'view':
        return FluentIcons.view;
      default:
        return FluentIcons.history;
    }
  }
}
