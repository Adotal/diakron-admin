import 'package:diakron_admin/data/repositories/auth/auth_repository.dart';
import 'package:diakron_admin/utils/command.dart';
import 'package:diakron_admin/utils/result.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class LocationData {
  final String id;
  final String address;
  final Map<String, int>? stats;
  final bool isConnected;
  final LatLng coordinate;
  final String? avatarUrl;

  LocationData({
    required this.id,
    required this.address,
    this.stats,
    required this.isConnected,
    required this.coordinate,
    this.avatarUrl,
  });
}

class MapViewModel extends ChangeNotifier {
  //final AuthRepository _authRepository; // IDK
  MapViewModel({required AuthRepository authRepository}){
    // _authRepository = authRepository;
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

  // Mock Data
  final List<LocationData> _allLocations = [
    LocationData(
      id: "seg1",
      address: "C. Nueva Escocia 1885, Providencia 5a Secc., 44638 Guadalajara, Jal.",
      stats: {'ME': 80, 'PL': 77, 'PA': 33, 'VI': 93},
      isConnected: true,
      coordinate: const LatLng(20.671956, -103.348821),
    ),
    LocationData(
      id: "seg2",
      address: "C. Marcelino Dávalos 515, Jardines Alcalde, 44298 Guadalajara, Jal.",
      stats: {'ME': 30, 'PL': 97, 'PA': 12, 'VI': 67},
      isConnected: false,
      coordinate: const LatLng(20.671956, -103.348821),
    ),
    LocationData(
      id: "seg2",
      address: "C. Marcelino Dávalos 515, Jardines Alcalde, 44298 Guadalajara, Jal.",
      stats: {'ME': 30, 'PL': 97, 'PA': 12, 'VI': 67},
      isConnected: false,
      coordinate: const LatLng(20.671956, -103.348821),
    ),
    LocationData(
      id: "seg2",
      address: "C. Marcelino Dávalos 515, Jardines Alcalde, 44298 Guadalajara, Jal.",
      stats: {'ME': 30, 'PL': 97, 'PA': 12, 'VI': 67},
      isConnected: false,
      coordinate: const LatLng(20.671956, -103.348821),
    ),
    LocationData(
      id: "ca1",
      address: "Av. Chapultepec Norte 15. Col Americana",
      isConnected: true,
      coordinate: const LatLng(20.6766, -103.3663),
      avatarUrl: 'https://pbs.twimg.com/profile_images/911823928259092480/XP3kMA6y_400x400.jpg',
    ),
    LocationData(
      id: "ca2",
      address: "Benjamín Romero 95, Vallarta, 44690 Guadalajara, Jal.",
      isConnected: false,
      coordinate: const LatLng(20.6766, -103.3663),
      avatarUrl: 'https://pbs.twimg.com/profile_images/911823928259092480/XP3kMA6y_400x400.jpg',
    ),
  ];

  List<LocationData> _filteredLocations = [];
  List<LocationData> get filteredLocations => _filteredLocations;

  Set<Marker> _markers = {};
  Set<Marker> get markers => _markers;

  late Command0<void> loadLocations;

  Future<Result<void>> _loadLocations() async {
    _isLoading = true;
    notifyListeners();
    await Future.delayed(const Duration(seconds: 1)); // example
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

  void selectLocation(BuildContext context, LocationData data) {
    //context.go("${Routes.editLocation}/${data.id}");
  }

  void _applyFilters() {
    _filteredLocations = _allLocations.where((loc) {
      bool isTypeMatch = _showSegregadores ? loc.id.startsWith("seg") : loc.id.startsWith("ca");
      bool isTextMatch = _searchText.isEmpty || loc.address.toLowerCase().contains(_searchText.toLowerCase());
      return isTypeMatch && isTextMatch;
    }).toList();
    _generateMarkers();
  }

  void _generateMarkers() {
    _markers = _filteredLocations.map((loc) {
      double hue = loc.isConnected ? 120 : 0;
      return Marker(
        markerId: MarkerId(loc.id),
        position: loc.coordinate,
        icon: BitmapDescriptor.defaultMarkerWithHue(hue),
        infoWindow: InfoWindow(
          title: _showSegregadores ? "Segregador" : "Centro de Acopio",
          snippet: loc.address,
        ),
        onTap: () {},
      );
    }).toSet();
  }
}