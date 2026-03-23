// home_viewmodel.dart
import 'package:diakron_admin/data/repositories/auth/auth_repository.dart';
import 'package:flutter/material.dart';

class StatData {
  final String title;
  final String value;
  final double percentage;
  final Color color;
  final List<double> chartPoints; // Puntos para la gráfica de esta categoría

  StatData({
    required this.title,
    required this.value,
    required this.percentage,
    required this.color,
    required this.chartPoints,
  });
}

class HomeViewModel extends ChangeNotifier {
  // It will eventually need UserRepository NOT authRepository
  HomeViewModel({required AuthRepository authRepository});
  // ui
  int _selectedCardIndex = 0;
  int get selectedCardIndex => _selectedCardIndex;

  int _selectedChartTab = 1; // 0: Mes, 1: Sem, 2: Hoy
  int get selectedChartTab => _selectedChartTab;

  //Ejemplos datos
  final List<StatData> stats = [
    StatData(
      title: "Negocios\nActivos",
      value: "13",
      percentage: 0.7,
      color: Colors.white, 
      chartPoints: [0.2, 0.5, 0.3, 0.8, 0.6, 0.9, 0.7],
    ),
    StatData(
      title: "Total\nSegregadores",
      value: "35",
      percentage: 0.4,
      color: Colors.white,
      chartPoints: [0.8, 0.7, 0.9, 0.5, 0.4, 0.6, 0.5],
    ),
    StatData(
      title: "Kg\nReciclados",
      value: "1,250",
      percentage: 0.85,
      color: Colors.white,
      chartPoints: [0.1, 0.3, 0.2, 0.5, 0.4, 0.7, 0.8],
    ),
    StatData(
      title: "Alertas\nActivas",
      value: "5",
      percentage: 0.15,
      color: Colors.white,
      chartPoints: [0.9, 0.2, 0.8, 0.1, 0.7, 0.3, 0.5],
    ),
  ];
  void selectCard(int index) {
    _selectedCardIndex = index;
    notifyListeners();
  }

  void selectChartTab(int index) {
    _selectedChartTab = index;
    notifyListeners();
  }

  // Helper para obtener los datos de la grafica actual segun la tarjeta seleccionada
  List<double> get currentChartPoints => stats[_selectedCardIndex].chartPoints;

  String get currentChartTitle =>
      stats[_selectedCardIndex].title.replaceAll('\n', ' ');

}
