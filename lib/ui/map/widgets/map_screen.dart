import 'package:diakron_admin/ui/core/themes/colors.dart';
import 'package:diakron_admin/ui/core/ui/custom_map_header.dart';
import 'package:diakron_admin/ui/map/view_models/map_viewmodel.dart';
import 'package:diakron_admin/ui/map/widgets/location_card.dart';
import 'package:diakron_admin/ui/map/widgets/map_controls.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key, required this.viewModel});
  final MapViewModel viewModel;

  @override
  State<StatefulWidget> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  CircleAnnotationManager? _circleManager;
  @override
Widget build(BuildContext context) {
  return Scaffold(
    // 1. El fondo de la pantalla ahora es verde
    backgroundColor: AppColors.greenDiakron1, 
    body: ListenableBuilder(
      listenable: widget.viewModel,
      builder: (context, _) {
        WidgetsBinding.instance.addPostFrameCallback((_){
          _loadMarkers();
        });
        return Column(
          children: [
            CustomMapHeader(
              title: widget.viewModel.showSegregadores ? "Segregadores" : "Centros de Acopio",
              onSearch: (text) => widget.viewModel.updateSearchText(text),
              userAvatar: const Icon(Icons.account_circle_outlined, color: Colors.white, size: 35),
            ),

            // White card
            Expanded(
              child: Container(
                decoration: const BoxDecoration(
                  color: AppColors.backgroundDiakron,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                ),
                child: ClipRRect( // The map retains its rounded corners
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(24.0),
                        child: MapControls(
                          isMapSelected: widget.viewModel.isMapSelected,
                          showSegregadores: widget.viewModel.showSegregadores,
                          onToggleViewMode: () => widget.viewModel.toggleViewMode(),
                          onToggleLocationType: () => widget.viewModel.toggleLocationType(),
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 24.0),
                          child: widget.viewModel.isLoading
                              ? const Center(child: CircularProgressIndicator())
                              : widget.viewModel.isMapSelected
                                  ? _buildMapViewWidget()
                                  : _buildLocationListView(),
                        ),
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            ),
          ],
        );
      },
    ),
  );
}

  // WIDGET: Map
  Widget _buildMapViewWidget() {
    final accessToken = dotenv.get('MAPBOX_ACCESS_TOKEN');

    MapboxOptions.setAccessToken(accessToken);

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(25),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(25),
        child: MapWidget(
          cameraOptions: CameraOptions(
            center: Point(
              coordinates: Position(-103.348821, 20.671956), // Guadalajara
            ),
            zoom: 13,
          ),
          onMapCreated: (mapboxMap) async {

            _circleManager = await mapboxMap.annotations.createCircleAnnotationManager();

            _loadMarkers();
          },
        ),
      ),
    );
  }

  // WIDGET: list
  Widget _buildLocationListView() {
    return ListView.builder(
      padding: const EdgeInsets.only(top: 10),
      itemCount: widget.viewModel.filteredLocations.length,
      itemBuilder: (context, index) {
        final data = widget.viewModel.filteredLocations[index];
        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: LocationCard(
            address: data.address,
            stats: data.stats,
            isConnected: data.isConnected,
            avatarUrl: data.avatarUrl,
            onTap: () => (),
          ),
        );
      },
    );
  }

  Future<void> _loadMarkers() async {
  if (_circleManager == null) return;

  await _circleManager!.deleteAll();
  final locations = widget.viewModel.filteredLocations;

  for (var loc in locations) {
    final point = Point(coordinates: Position(loc.lng, loc.lat));

    await _circleManager!.create(
      CircleAnnotationOptions(
        geometry: point,
        circleColor: loc.isConnected ? Colors.green.value : Colors.red.value,
        circleRadius: 8.0,
        circleStrokeWidth: 2.0,
        circleStrokeColor: Colors.white.value,
      ),
    );
  }
}
}
