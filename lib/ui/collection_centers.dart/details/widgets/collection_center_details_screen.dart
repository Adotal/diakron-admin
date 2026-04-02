// import 'package:diakron_admin/ui/collection_centers.dart/details/view_models/collection_center_details_viewmodel.dart';
// import 'package:diakron_admin/ui/core/ui/custom_screen.dart';
// import 'package:diakron_admin/ui/core/ui/error_indicator.dart';
// import 'package:flutter/material.dart';
// import 'package:go_router/go_router.dart';

// class CollectionCenterDetailsScreen extends StatefulWidget {
//   const CollectionCenterDetailsScreen({super.key, required this.viewModel});

//   @override
//   State<CollectionCenterDetailsScreen> createState() =>
//       _CollectionCenterDetailsScreenState();
// }

// class _CollectionCenterDetailsScreenState
//     extends State<CollectionCenterDetailsScreen> {

//   @override
//   Widget build(BuildContext context) {
//     return CustomScreen(
//       // title: 'Detalles del Centro',
//       child: SafeArea(
//         child:
//       ),
//     );
//   }
// }
import 'package:diakron_admin/ui/collection_centers.dart/details/view_models/collection_center_details_viewmodel.dart';
import 'package:diakron_admin/ui/core/ui/error_indicator.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class CollectionCenterDetailsScreen extends StatefulWidget {
  const CollectionCenterDetailsScreen({super.key, required this.viewModel});

  final CollectionCenterDetailsViewModel viewModel;

  @override
  State<CollectionCenterDetailsScreen> createState() =>
      _CollectionCenterDetailsScreenState();
}

class _CollectionCenterDetailsScreenState
    extends State<CollectionCenterDetailsScreen> {
  @override
  void initState() {
    super.initState();
    widget.viewModel.deleteCCenter.addListener(_onDelete);
  }

  @override
  void didUpdateWidget(covariant CollectionCenterDetailsScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    oldWidget.viewModel.deleteCCenter.removeListener(_onDelete);
    widget.viewModel.deleteCCenter.addListener(_onDelete);
  }

  @override
  void dispose() {
    widget.viewModel.deleteCCenter.removeListener(_onDelete);
    widget.viewModel.deleteCCenter.addListener(_onDelete);
    super.dispose();
  }

  bool _isEditing = false;

  // Example controllers
  final TextEditingController _companyController = TextEditingController(
    text: "Global Logistics S.A.",
  );
  final TextEditingController _rfcController = TextEditingController(
    text: "GML120304H32",
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text("Entity Profile"),
        elevation: 0,
        actions: [
          // Edit Toggle
          IconButton(
            icon: Icon(
              _isEditing ? Icons.cancel_outlined : Icons.edit_note,
              color: _isEditing ? Colors.orange : Colors.blue,
            ),
            onPressed: () => setState(() => _isEditing = !_isEditing),
          ),
          // Delete remains separate
          IconButton(
            icon: const Icon(
              Icons.delete_sweep_outlined,
              color: Colors.redAccent,
            ),
            onPressed: () {
              if (widget.viewModel.center?.id != null) {
                _showDeleteConfirm(widget.viewModel.center!.id!);
              }
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListenableBuilder(
              listenable: widget.viewModel.load,
              builder: (context, _) {
                if (widget.viewModel.load.running) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (widget.viewModel.load.error) {
                  return ErrorIndicator(
                    title: "Problem charging Collection Center",
                    label: "Try again",
                    onPressed: widget.viewModel.load.execute,
                  );
                }

                return Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit, color: Colors.blue),
                            onPressed: () {
                              // Navigate to your edit logic
                            },
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () {},
                          ),
                        ],
                      ),

                      Text('${widget.viewModel.center?.toJson()}'),
                      const Divider(),
                      const Text(
                        'Tipos de Residuos Aceptados:',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          Expanded(
            child: ListenableBuilder(
              listenable: widget.viewModel.load,
              builder: (context, child) {
                if (widget.viewModel.load.running) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (widget.viewModel.load.error) {
                  return ErrorIndicator(
                    title: "Problem charging Collection Center",
                    label: "Try again",
                    onPressed: widget.viewModel.load.execute,
                  );
                }

                final center = widget.viewModel.center;

                if (center == null) {
                  return Center(
                    child: Text(
                      "No se encontró el centro \n ${widget.viewModel.centerId}",
                    ),
                  );
                }

                return child!;
              },
              child: Stack(
                children: [
                  ListView(
                    padding: const EdgeInsets.fromLTRB(20, 20, 20, 100),
                    children: [
                      _buildHeaderStatus(),
                      const SizedBox(height: 24),

                      _buildSection("Legal Representative"),
                      _buildDataRow(
                        "User",
                        "adotal_admin",
                        Icons.person_outline,
                      ),
                      _buildDataRow(
                        "CURP",
                        "CURP123456HDFRRR01",
                        Icons.fingerprint,
                      ),

                      const SizedBox(height: 24),

                      _buildSection("Tax & Bank Details"),
                      _buildDataRow(
                        "Company",
                        "",
                        Icons.business,
                        controller: _companyController,
                      ),
                      _buildDataRow(
                        "RFC",
                        "",
                        Icons.description_outlined,
                        controller: _rfcController,
                      ),
                      _buildDataRow(
                        "Bank",
                        "BBVA México",
                        Icons.account_balance_wallet_outlined,
                      ),
                    ],
                  ),

                  // Smooth Bottom Update Button
                  AnimatedPositioned(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                    bottom: _isEditing ? 20 : -100,
                    left: 20,
                    right: 20,
                    child: FloatingActionButton.extended(
                      backgroundColor: Colors.green[600],
                      onPressed: () => setState(() => _isEditing = false),
                      label: const Text(
                        "SAVE CHANGES",
                        style: TextStyle(color: Colors.white),
                      ),
                      icon: const Icon(Icons.check, color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSection(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: Colors.blueGrey,
        ),
      ),
    );
  }

  Widget _buildDataRow(
    String label,
    String value,
    IconData icon, {
    TextEditingController? controller,
  }) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      margin: const EdgeInsets.only(bottom: 12),
      padding: EdgeInsets.symmetric(
        horizontal: 12,
        vertical: _isEditing ? 4 : 12,
      ),
      decoration: BoxDecoration(
        color: _isEditing ? Colors.white : Colors.transparent,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: _isEditing ? Colors.blue.withOpacity(0.3) : Colors.transparent,
        ),
      ),
      child: Row(
        children: [
          Icon(icon, size: 20, color: Colors.grey[600]),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(fontSize: 12, color: Colors.grey[500]),
                ),
                _isEditing && controller != null
                    ? TextField(
                        controller: controller,
                        decoration: const InputDecoration(
                          isDense: true,
                          contentPadding: EdgeInsets.symmetric(vertical: 8),
                          border: InputBorder.none,
                        ),
                      )
                    : Text(
                        controller?.text ?? value,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeaderStatus() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(color: Colors.black12, blurRadius: 10),
        ],
      ),
      child: const Row(
        children: [
          CircleAvatar(
            backgroundColor: Colors.orangeAccent,
            child: Icon(Icons.hourglass_empty, color: Colors.white),
          ),
          SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Validation Status", style: TextStyle(fontSize: 12)),
              Text(
                "PENDING REVIEW",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.orange,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showDeleteConfirm(String id) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirm Delete'),
        content: const Text('Are you sure you want to delete this center?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              await widget.viewModel.deleteCCenter.execute(id);
              context.pop();
            },
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  void _onDelete() {
    if (widget.viewModel.deleteCCenter.completed) {
      widget.viewModel.deleteCCenter.clearResult();
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("SUCCESS DELETING CCENTER")));
    }

    if (widget.viewModel.deleteCCenter.error) {
      widget.viewModel.deleteCCenter.clearResult();

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("ERROR WHILE DELETING CCENTER")));
    }
  }
}
