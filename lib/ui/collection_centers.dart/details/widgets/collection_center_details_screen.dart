//   Widget build(BuildContext context) {
//     return CustomScreen(
//       // title: 'Detalles del Centro',
import 'package:diakron_admin/domain/models/validation_status/validation_status.dart';
import 'package:diakron_admin/ui/collection_centers.dart/details/view_models/collection_center_details_viewmodel.dart';
import 'package:diakron_admin/ui/core/themes/colors.dart';
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
    // DISPOSE ALL CONTROLLERS
    _usernameController.dispose();
    _companyNameController.dispose();
    _rfcController.dispose();
    super.dispose();
  }

  bool _isEditing = false;

  // UserBase Text controllers
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _surnamesController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  bool? _isActive;
  final TextEditingController _createdAtController = TextEditingController();
  // Example controllers
  final TextEditingController _companyNameController = TextEditingController();
  final TextEditingController _rfcController = TextEditingController();

  final TextEditingController _taxRegimeController = TextEditingController();

  final TextEditingController _curpRepController = TextEditingController();

  final TextEditingController _bankController = TextEditingController();

  final TextEditingController _clabeController = TextEditingController();

  final TextEditingController _commercialNameController =
      TextEditingController();

  final TextEditingController _addressController = TextEditingController();

  final TextEditingController _billingEmailController = TextEditingController();

  final TextEditingController _taxpayerTypeController = TextEditingController();

  final TextEditingController _postCodeController = TextEditingController();
  Map<String, dynamic>? _schedule;
  String? _validationStatus;

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
            onPressed: () {
              setState(() {
                // Start editing -> Initialize controllers
                if (!_isEditing) {
                  final center = widget.viewModel.center;
                  if (center != null) {
                    _usernameController.text = center.userName ?? '';
                    _surnamesController.text = center.surnames ?? '';
                    _phoneNumberController.text = center.phoneNumber ?? '';
                    _createdAtController.text = center.createdAt.toString();
                    _taxRegimeController.text = center.taxRegime ?? '';
                    _clabeController.text = center.clabe ?? '';
                    _curpRepController.text = center.curpRep ?? '';
                    _bankController.text = center.bank ?? '';
                    _companyNameController.text = center.companyName ?? '';
                    _rfcController.text = center.rfc ?? '';
                    _commercialNameController.text =
                        center.commercialName ?? '';
                    _addressController.text = center.address ?? '';
                    _billingEmailController.text = center.billingEmail ?? '';
                    _taxpayerTypeController.text = center.taxpayerType ?? '';
                    _postCodeController.text = center.postCode ?? '';

                    _schedule = center.schedule;
                    _validationStatus = center.validationStatus;
                    _isActive = center.isActive;

                    _isEditing = !_isEditing;
                  } 
                } else {
                  _exitEditDialog();
                }
              });
            },
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

                final center = widget.viewModel.center;

                if (center == null) {
                  return Center(
                    child: Text(
                      "No se encontró el centro \n ${widget.viewModel.centerId}",
                    ),
                  );
                }

                return Stack(
                  children: [
                    ListView(
                      padding: const EdgeInsets.fromLTRB(20, 20, 20, 100),
                      children: [
                        const Text(
                          'Tipos de Residuos Aceptados:',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),

                        _buildHeaderStatus(
                          status: center.validationStatus ?? 'UPLOADING',
                        ),
                        const SizedBox(height: 24),

                        _buildSection("Representante legal"),
                        _buildDataRow(
                          "Nombre",
                          center.userName ?? '',
                          Icons.person_outline,
                          controller: _usernameController,
                        ),
                        _buildDataRow(
                          "Apellidos",
                          center.surnames ?? '',
                          Icons.person_outline,

                          controller: _surnamesController,
                        ),
                        _buildDataRow(
                          "Número telefónico",
                          center.phoneNumber ?? '',
                          Icons.person_outline,

                          controller: _phoneNumberController,
                        ),
                        Text("ACTIVE: ${center.isActive}"),
                        _buildDataRow(
                          "Creado en",
                          center.createdAt.toString(),
                          Icons.person_outline,

                          controller: _createdAtController,
                        ),
                        _buildDataRow(
                          "CURP",
                          center.curpRep ?? '',
                          Icons.fingerprint,

                          controller: _curpRepController,
                        ),

                        // COMPANY DATA
                        const SizedBox(height: 24),

                        _buildSection("Tax & Bank Details"),
                        _buildDataRow(
                          "Company Name",
                          center.companyName ?? '',
                          Icons.business,
                          controller: _companyNameController,
                        ),
                        _buildDataRow(
                          "RFC",
                          center.rfc ?? '',
                          Icons.description_outlined,
                          controller: _rfcController,
                        ),
                        _buildDataRow(
                          "Regimen fiscal",
                          center.taxRegime ?? '',
                          Icons.person_outline,

                          controller: _taxRegimeController,
                        ),
                        _buildDataRow(
                          "CLABE",
                          center.clabe ?? '',
                          Icons.person_outline,

                          controller: _clabeController,
                        ),
                        _buildDataRow(
                          "Bank",
                          center.bank ?? '',
                          Icons.account_balance_wallet_outlined,

                          controller: _bankController,
                        ),
                        _buildDataRow(
                          "Nombre comercial",
                          center.commercialName ?? '',
                          Icons.person_outline,

                          controller: _commercialNameController,
                        ),

                        _buildDataRow(
                          "Dirección",
                          center.address ?? '',
                          Icons.person_outline,

                          controller: _addressController,
                        ),

                        _buildDataRow(
                          "Correo electrónico de facturación",
                          center.billingEmail ?? '',
                          Icons.person_outline,

                          controller: _billingEmailController,
                        ),

                        _buildDataRow(
                          "Tipo de contribuyente",
                          center.clabe ?? '',
                          Icons.person_outline,

                          controller: _taxpayerTypeController,
                        ),

                        _buildDataRow(
                          "Código postal",
                          center.postCode ?? '',
                          Icons.person_outline,

                          controller: _postCodeController,
                        ),

                        _buildDataRow(
                          "Calendario",
                          center.schedule.toString(),
                          Icons.person_outline,
                          // SCHEDULE
                        ),

                        _buildDataRow(
                          "Identificación del representante",
                          center.pathIdRep ?? '',
                          Icons.person_outline,
                        ),

                        _buildDataRow(
                          "Comprobante de domicilio",
                          center.pathIdRep ?? '',
                          Icons.person_outline,
                        ),

                        _buildDataRow(
                          "Constancia de situación fiscal",
                          center.pathTaxCertificate ?? '',
                          Icons.person_outline,
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
                          "GUARDAR CAMBIOS",
                          style: TextStyle(color: Colors.white),
                        ),
                        icon: const Icon(Icons.check, color: Colors.white),
                      ),
                    ),
                  ],
                );
              },
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
          color: _isEditing ? Colors.green : Colors.transparent,
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
                        // Show simply the value
                        value,
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

  Widget _buildHeaderStatus({required String? status}) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 10)],
      ),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: status.statusColor.withOpacity(0.1),
            child: Icon(status.statusIcon, color: status.statusColor),
          ),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("Validación", style: TextStyle(fontSize: 12)),
              Text(
                status.statusLabel, // Uses the extension
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: status.statusColor, // Uses the extension
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

   void _exitEditDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Exit edit mode'),
        content: const Text('Are you sure you want to exit edito mode?\nNo saved data will be lost'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              _isEditing = !_isEditing;
            },
            child: const Text('Exit', style: TextStyle(color: AppColors.greenDiakron1)),
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
              Navigator.pop(context);
              await widget.viewModel.deleteCCenter.execute(id);
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
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Centro de recolección eliminado")),
      );
      context.pop();
    }

    if (widget.viewModel.deleteCCenter.error) {
      widget.viewModel.deleteCCenter.clearResult();

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("ERROR WHILE DELETING CCENTER")));
    }
  }
}
