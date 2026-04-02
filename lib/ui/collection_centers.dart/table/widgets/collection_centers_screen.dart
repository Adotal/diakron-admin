import 'package:diakron_admin/domain/models/validation_status/validation_status.dart';
import 'package:diakron_admin/routing/routes.dart';
import 'package:diakron_admin/ui/collection_centers.dart/table/view_models/collection_centers_viewmodel.dart';
import 'package:diakron_admin/ui/core/themes/dimens.dart';
import 'package:diakron_admin/ui/core/ui/custom_screen.dart';
import 'package:diakron_admin/ui/core/ui/error_indicator.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class CollectionCentersScreen extends StatefulWidget {
  const CollectionCentersScreen({super.key, required this.viewModel});

  final CollectionCentersViewmodel viewModel;

  @override
  State<CollectionCentersScreen> createState() =>
      _CollectionCentersScreenState();
}

class _CollectionCentersScreenState extends State<CollectionCentersScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // ListenableBuilder is the modern way to listen to a ChangeNotifier ViewModel
    return CustomScreen(
      child: Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            // Add your action here, e.g., show a snackbar or navigate
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(const SnackBar(content: Text('FAB tapped!')));
          },
          shape: CircleBorder(),
          foregroundColor: Colors.white,
          backgroundColor: Colors.blueGrey,
          child: const Icon(Icons.add),
        ),
        body: ListenableBuilder(
          listenable: widget.viewModel.load,
          builder: (context, child) {
            if (widget.viewModel.load.running) {
              return const Center(child: CircularProgressIndicator());
            }

            if (widget.viewModel.load.error) {
              return Center(
                child: ErrorIndicator(
                  title: 'Error loading Collection Centers',
                  label: 'Try again',
                  onPressed: widget.viewModel.load.execute,
                ),
              );
            }

            return child!;
          },
          child: ListenableBuilder(
            listenable: widget.viewModel,
            builder: (context, _) {
              return RefreshIndicator(
                onRefresh: () => widget.viewModel.load.execute(),
                child: Column(
                  children: [
                    Padding(
                      // 2. El título con un poco de margen
                      padding: EdgeInsets.all(20),
                      child: Column(
                        children: [
                          Text(
                            'Centros de Recolección',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          // Basic Material 3 SearchBar Example
                          SearchBar(
                            hintText: 'Buscar...',
                            leading: const Icon(Icons.search),
                            onChanged: (value) => print(value), // Handle input
                          ),

                          SizedBox(height: Dimens.paddingVertical),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              IconButton(
                                onPressed: _showStatusInfo,
                                icon: const Icon(
                                  Icons.error,
                                  color: Colors.blueAccent,
                                ),
                              ),

                              SizedBox(width: 15,),
                            ],
                          ),
                        ],
                      ),
                    ),

                    Expanded(
                      child: Padding(
                        padding: EdgeInsetsGeometry.all(20),

                        child: ListView.builder(
                          itemCount: widget.viewModel.collectionCenters.length,
                          itemBuilder: (context, index) {
                            final center =
                                widget.viewModel.collectionCenters[index];

                            return Card(
                              margin: const EdgeInsets.symmetric(
                                horizontal: 0,
                                vertical: 5,
                              ),
                              child: ListTile(
                                leading: const CircleAvatar(
                                  child: Icon(Icons.business),
                                ),
                                title: Text(center.companyName ?? 'No Name'),
                                subtitle: Text('RFC: ${center.rfc ?? "N/A"}'),
                                trailing: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    if (center.validationStatus ==
                                        ValidationStatus.uploading)
                                      const Icon(
                                        Icons.error,
                                        color: Colors.blueGrey,
                                      ),

                                    if (center.validationStatus ==
                                        ValidationStatus.pending)
                                      const Icon(
                                        Icons.error,
                                        color: Colors.amber,
                                      ),

                                    if (center.validationStatus ==
                                        ValidationStatus.denied)
                                      const Icon(
                                        Icons.cancel,
                                        color: Colors.red,
                                      ),

                                    if (center.validationStatus ==
                                        ValidationStatus.approved)
                                      const Icon(
                                        Icons.check_circle,
                                        color: Colors.greenAccent,
                                      ),
                                  ],
                                ),
                                onTap: () {
                                  // Read/Details
                                  context.push(
                                    Routes.collectionCenterById(center.id!),
                                  );
                                },
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  void _showStatusInfo() {
    showDialog(
      context: context, // The BuildContext of the current widget
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Tipos de estado"),
          content: Column(     
            mainAxisSize: MainAxisSize.min,        
            children: [

              ListTile(
                leading: Icon(Icons.error, color: Colors.amber),
                title: Text('VALIDACIÓN PENDIENTE'),
              ),
              ListTile(
                leading: Icon(Icons.error, color: Colors.blueGrey),
                title: Text('SUBIENDO ARCHIVOS'),
              ),
              ListTile(
                leading: Icon(Icons.cancel, color: Colors.red),
                title: Text('RECHAZADO'),
              ),
              ListTile(
                leading: Icon(Icons.check_circle, color: Colors.greenAccent),
                title: Text('APROVADO'),
              ),
            ],
          ),
          actions: [
            TextButton(
              child: Text("OK"),
              onPressed: () {
                Navigator.of(context).pop(); // Closes the dialog
              },
            ),
          ],
        );
      },
    );
  }
}
