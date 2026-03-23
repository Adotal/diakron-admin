import 'package:diakron_admin/routing/routes.dart';
import 'package:diakron_admin/ui/core/ui/line_chart_section.dart';
import 'package:diakron_admin/ui/core/ui/stat_card.dart';
import 'package:diakron_admin/ui/home/view_models/home_viewmodel.dart';
import 'package:diakron_admin/ui/core/themes/colors.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key, required this.viewModel});

  final HomeViewModel viewModel;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    widget.viewModel.logout.addListener(_onLogoutResult);
  }

  @override
  void dispose() {
    widget.viewModel.logout.removeListener(_onLogoutResult);
    super.dispose();
  }

  void _onLogoutResult() {
    if (widget.viewModel.logout.completed) {
      widget.viewModel.logout.clearResult();
      context.go(Routes.login);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
          child: ListenableBuilder(
            listenable: widget.viewModel,
            builder: (context, _) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeader(),
                  const SizedBox(height: 30),
                  SizedBox(
                    height: 200,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: widget.viewModel.stats.length,
                      itemBuilder: (context, index) {
                        final data = widget.viewModel.stats[index];
                        final isSelected =
                            widget.viewModel.selectedCardIndex == index;
                        return Padding(
                          padding: const EdgeInsets.only(right: 12),
                          child: SizedBox(
                            width: 180,
                            child: StatCard(
                              title: data.title,
                              value: data.value,
                              percentage: data.percentage,
                              isDark: isSelected,
                              progressColor: isSelected
                                  ? data.color
                                  : Colors.grey,
                              onTap: () => widget.viewModel.selectCard(index),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 35),
                  LineChartSection(
                    title:
                        widget.viewModel.currentChartTitle, // Función dinámica
                    selectedTab: widget.viewModel.selectedChartTab,
                    onTabChanged: (index) =>
                        widget.viewModel.selectChartTab(index),
                  ),
                ],
              );
            },
          ),
        ),
    );
  }

  // Components

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          "Dashboard",
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        Row(
          children: [
            ListenableBuilder(
              listenable: widget.viewModel.logout,
              builder: (context, _) {
                return IconButton(
                  icon: widget.viewModel.logout.running
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Icon(Icons.logout_rounded, color: Colors.grey),
                  onPressed: () => widget.viewModel.logout.execute(),
                );
              },
            ),
            const CircleAvatar(
              radius: 22,
              backgroundColor: AppColors.greenDiakron1,
              child: Icon(Icons.person, color: Colors.white),
            ),
          ],
        ),
      ],
    );
  }
}
