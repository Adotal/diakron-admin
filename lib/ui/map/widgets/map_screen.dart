import 'package:diakron_admin/ui/core/ui/custom_map_header.dart';
import 'package:diakron_admin/ui/map/view_models/map_viewmodel.dart';
import 'package:diakron_admin/ui/map/widgets/location_card.dart';
import 'package:diakron_admin/ui/map/widgets/map_controls.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key, required this.viewModel});
  final MapViewModel viewModel;

  @override
  State<StatefulWidget> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: ListenableBuilder(
        listenable: widget.viewModel,
        builder: (context, _) {
          return Column(
            children: [
              CustomMapHeader(
                title: widget.viewModel.showSegregadores
                    ? "Segregadores"
                    : "Centros de Acopio",
                onSearch: (text) => widget.viewModel.updateSearchText(text),
                userAvatar: const CircleAvatar(
                  radius: 22,
                  backgroundColor: Colors.white24,
                  child: Icon(Icons.person, color: Colors.white),
                ),
              ),

              Expanded(
                child: SafeArea(
                  top: false,
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(24.0),
                        child: MapControls(
                          isMapSelected: widget.viewModel.isMapSelected,
                          showSegregadores: widget.viewModel.showSegregadores,
                          onToggleViewMode: () =>
                              widget.viewModel.toggleViewMode(),
                          onToggleLocationType: () =>
                              widget.viewModel.toggleLocationType(),
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
            ],
          );
        },
      ),
    );
  }

  // WIDGET: Map
  Widget _buildMapViewWidget() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(25),
        boxShadow: [
          BoxShadow(
            color: Colors.grey,
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(25),
        child: GoogleMap(
          initialCameraPosition: const CameraPosition(
            target: LatLng(20.671956, -103.348821),
            zoom: 13,
          ),
          markers: widget.viewModel.markers,
          myLocationEnabled: true,
          mapType: MapType.normal,
          onTap: (_) {},
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
            onTap: () => widget.viewModel.selectLocation(context, data),
          ),
        );
      },
    );
  }
}
