import 'package:diakron_admin/domain/models/location/location_model.dart';
import 'package:diakron_admin/data/repositories/map/map_repository.dart';
import 'package:diakron_admin/utils/command.dart';
import 'package:diakron_admin/utils/result.dart';
import 'package:flutter/material.dart';

class MapViewModel extends ChangeNotifier {
  final MapRepository _repository;
  MapViewModel({required MapRepository repository}) : _repository = repository {
    loadLocations = Command0<void>(_loadLocations);
    loadLocations.execute();
  }
  

  // UI
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  bool _isMapSelected = true; // Mapa / Lista
  bool get isMapSelected => _isMapSelected;

  bool _showSegregadores = true; // Segregadores / Centros de Acopio
  bool get showSegregadores => _showSegregadores;

  String _searchText = "";
  String get searchText => _searchText;

  List<LocationModel> _allLocations = [];
  List<LocationModel> _filteredLocations = [];
  List<LocationModel> get filteredLocations => _filteredLocations;

  late Command0<void> loadLocations;
  Future<Result<void>> _loadLocations() async {
    _isLoading = true;
    notifyListeners();

    _allLocations = await _repository.getLocations();

    _applyFilters();

    _isLoading = false;
    notifyListeners();

    return Result.ok(null);
  }

  void toggleViewMode() {
    _isMapSelected = !_isMapSelected;
    notifyListeners();
  }

  void toggleLocationType() {
    _showSegregadores = !_showSegregadores;
    _applyFilters();
    notifyListeners();
  }

  void updateSearchText(String text) {
    _searchText = text;
    _applyFilters();
    notifyListeners();
  }

  void _applyFilters() {
    _filteredLocations = _allLocations.where((loc) {
      final isTypeMatch = _showSegregadores
          ? loc.id.startsWith("seg")
          : loc.id.startsWith("ca");

      final isTextMatch =
          _searchText.isEmpty ||
          loc.address.toLowerCase().contains(_searchText.toLowerCase());

      return isTypeMatch && isTextMatch;
    }).toList();

    notifyListeners();
  }
}
