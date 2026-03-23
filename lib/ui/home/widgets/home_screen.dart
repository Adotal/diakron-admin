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
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: Column(
        children: [
          _buildHeader(),
          
          // scrollable
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 25.0),
              child: ListenableBuilder(
                listenable: widget.viewModel,
                builder: (context, _) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Resumen de impacto",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 15),
                      SizedBox(
                        height: 200,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: widget.viewModel.stats.length,
                          itemBuilder: (context, index) {
                            final data = widget.viewModel.stats[index];
                            final isSelected = widget.viewModel.selectedCardIndex == index;
                            return Padding(
                              padding: const EdgeInsets.only(right: 12, bottom: 8),
                              child: SizedBox(
                                width: 180,
                                child: StatCard(
                                  title: data.title,
                                  value: data.value,
                                  percentage: data.percentage,
                                  isDark: isSelected,
                                  progressColor: isSelected ? data.color : Colors.grey,
                                  onTap: () => widget.viewModel.selectCard(index),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      const SizedBox(height: 35),
                      LineChartSection(
                        title: widget.viewModel.currentChartTitle,
                        selectedTab: widget.viewModel.selectedChartTab,
                        onTabChanged: (index) => widget.viewModel.selectChartTab(index),
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.only(top: 60, left: 24, right: 24, bottom: 30),
      decoration: const BoxDecoration(
        color: AppColors.greenDiakron1,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(32),
          bottomRight: Radius.circular(32),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Panel Administrativo",
                    style: TextStyle(color: Colors.white70, fontSize: 14),
                  ),
                  Text(
                    "Hola, ${widget.viewModel.userName}",
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  _buildLogoutButton(),
                  const SizedBox(width: 12),
                  const CircleAvatar(
                    radius: 24,
                    backgroundColor: Colors.white24,
                    child: Icon(Icons.person, color: Colors.white),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 25),
          // INFORMACIÓN RELEVANTE: ESTADO DEL SISTEMA
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.15),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              children: [
                const Icon(Icons.bolt, color: Colors.yellow, size: 28),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Estado del Sistema: Óptimo",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        "35 segregadores operando con normalidad.",
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.8),
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
                const Icon(Icons.chevron_right, color: Colors.white70),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLogoutButton() {
    return ListenableBuilder(
      listenable: widget.viewModel.logout,
      builder: (context, _) {
        return Container(
          decoration: BoxDecoration(
            color: Colors.white24,
            borderRadius: BorderRadius.circular(12),
          ),
          child: IconButton(
            icon: widget.viewModel.logout.running
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                    ),
                  )
                : const Icon(Icons.logout_rounded, color: Colors.white),
            onPressed: () => widget.viewModel.logout.execute(),
          ),
        );
      },
    );
  }
}