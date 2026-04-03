//   Widget build(BuildContext context) {
//     return CustomScreen(
//       // title: 'Detalles del Centro',
import 'package:diakron_admin/domain/models/core/taxpayer_type/taxpayer_type.dart';
import 'package:diakron_admin/domain/models/core/validation_status/validation_status.dart';
import 'package:diakron_admin/ui/collection_centers/details/view_models/collection_center_details_viewmodel.dart';
import 'package:diakron_admin/ui/collection_centers/details/widgets/file_picker_tile.dart';
import 'package:diakron_admin/ui/core/themes/colors.dart';
import 'package:diakron_admin/ui/core/ui/custom_alert_dialog.dart';
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
    widget.viewModel.updateCCenter.addListener(_onUpdate);
    widget.viewModel.changeValidationStatus.addListener(_onChangedValidation);
  }

  @override
  void didUpdateWidget(covariant CollectionCenterDetailsScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    oldWidget.viewModel.deleteCCenter.removeListener(_onDelete);
    widget.viewModel.deleteCCenter.addListener(_onDelete);

    oldWidget.viewModel.updateCCenter.removeListener(_onUpdate);
    widget.viewModel.updateCCenter.addListener(_onUpdate);

    oldWidget.viewModel.changeValidationStatus.removeListener(_onChangedValidation);
    widget.viewModel.changeValidationStatus.addListener(_onChangedValidation);
  }

  @override
  void dispose() {
    widget.viewModel.deleteCCenter.removeListener(_onDelete);
    widget.viewModel.updateCCenter.removeListener(_onUpdate);
    widget.viewModel.changeValidationStatus.removeListener(_onChangedValidation);
    // DISPOSE ALL CONTROLLERS
    _usernameController.dispose();
    _surnamesController.dispose();
    _phoneNumberController.dispose();
    _curpRepController.dispose();
    _companyNameController.dispose();
    _rfcController.dispose();
    _taxRegimeController.dispose();
    _clabeController.dispose();
    _bankController.dispose();
    _commercialNameController.dispose();
    _addressController.dispose();
    _billingEmailController.dispose();
    _postCodeController.dispose();
    super.dispose();
  }

  // UserBase Text controllers
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _surnamesController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _createdAtController = TextEditingController();
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
  final TextEditingController _postCodeController = TextEditingController();

  bool? _isActive;
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
              widget.viewModel.isEditing
                  ? Icons.cancel_outlined
                  : Icons.edit_note,
              color: widget.viewModel.isEditing ? Colors.orange : Colors.blue,
            ),
            onPressed: () {
              setState(() {
                // Start editing -> Initialize controllers
                if (!widget.viewModel.isEditing) {
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
                    _postCodeController.text = center.postCode ?? '';

                    _schedule = center.schedule;
                    _validationStatus = center.validationStatus;
                    _isActive = center.isActive;

                    widget.viewModel.toggleEdit();
                  }
                } else {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return CustomAlertDialog(
                        title: 'Salir del modo edición',
                        content:
                            '¿Estás seguro de salir del modo edición?\nSe perderán los cambios no guardados',
                        onPressed: () {
                          setState(() {
                            widget.viewModel.toggleEdit();
                          });
                        },
                        actionText: 'Salir',
                      );
                    },
                  );
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
                          "Código postal",
                          center.postCode ?? '',
                          Icons.person_outline,

                          controller: _postCodeController,
                        ),

                        _buildDataRow(
                          "Correo electrónico de facturación",
                          center.billingEmail ?? '',
                          Icons.person_outline,

                          controller: _billingEmailController,
                        ),

                        Text("Tipo de contribuyente"),
                        ListenableBuilder(
                          listenable: widget.viewModel,
                          builder: (context, _) {
                            return IgnorePointer(
                              ignoring: !widget.viewModel.isEditing,
                              child: Opacity(
                                opacity: widget.viewModel.isEditing ? 1.0 : 0.6,
                                child: RadioGroup<TaxpayerType>(
                                  groupValue: widget.viewModel.taxpayerType,
                                  onChanged: (TaxpayerType? value) {
                                    setState(() {
                                      widget.viewModel.taxpayerType = value!;
                                    });
                                  },
                                  child: Column(
                                    children: [
                                      const RadioListTile<TaxpayerType>(
                                        title: Text("Persona Moral"),
                                        value: TaxpayerType.moral,
                                        activeColor: AppColors.greenDiakron1,
                                      ),
                                      const RadioListTile<TaxpayerType>(
                                        title: Text("Persona Física"),
                                        value: TaxpayerType.physical,
                                        activeColor: AppColors.greenDiakron1,
                                      ),

                                      const Text('Calendario'),
                                      ListenableBuilder(
                                        listenable: widget.viewModel,
                                        builder: (context, _) {
                                          return SegmentedButton<int>(
                                            segments: const [
                                              ButtonSegment(
                                                value: 0,
                                                label: Text('Lu'),
                                              ),
                                              ButtonSegment(
                                                value: 1,
                                                label: Text('Ma'),
                                              ),
                                              ButtonSegment(
                                                value: 2,
                                                label: Text('Mi'),
                                              ),
                                              ButtonSegment(
                                                value: 3,
                                                label: Text('Ju'),
                                              ),
                                              ButtonSegment(
                                                value: 4,
                                                label: Text('Vi'),
                                              ),
                                              ButtonSegment(
                                                value: 5,
                                                label: Text('Sá'),
                                              ),
                                              ButtonSegment(
                                                value: 6,
                                                label: Text('Do'),
                                              ),
                                            ],
                                            showSelectedIcon: false,
                                            emptySelectionAllowed: true,
                                            multiSelectionEnabled: true,
                                            selected: widget.viewModel.daysOpen,
                                            onSelectionChanged:
                                                (newSelection) => widget
                                                    .viewModel
                                                    .onDaysChanged(
                                                      newSelection,
                                                    ),
                                          );
                                        },
                                      ),

                                      const SizedBox(height: 20),

                                      // Dynamic schedule list
                                      ListenableBuilder(
                                        listenable: widget.viewModel,
                                        builder: (context, _) {
                                          final selectedIndices =
                                              widget.viewModel.daysOpen.toList()
                                                ..sort();

                                          if (selectedIndices.isEmpty) {
                                            return const Padding(
                                              padding: EdgeInsets.symmetric(
                                                vertical: 20,
                                              ),
                                              child: Text(
                                                "No hay días seleccionados",
                                                style: TextStyle(
                                                  color: Colors.grey,
                                                ),
                                              ),
                                            );
                                          }

                                          return Column(
                                            children: selectedIndices.map((
                                              index,
                                            ) {
                                              final error = widget.viewModel
                                                  .getErrorMessage(index);
                                              final day = widget
                                                  .viewModel
                                                  .weekSchedules[index];

                                              return Card(
                                                margin: const EdgeInsets.only(
                                                  bottom: 12,
                                                ),
                                                elevation: 2,
                                                child: Padding(
                                                  padding: const EdgeInsets.all(
                                                    8.0,
                                                  ),
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      ListTile(
                                                        contentPadding:
                                                            const EdgeInsets.symmetric(
                                                              horizontal: 12,
                                                            ),
                                                        title: Text(
                                                          day.dayName,
                                                          style:
                                                              const TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                              ),
                                                        ),
                                                        trailing:
                                                            (day.openTime !=
                                                                    null &&
                                                                day.closeTime !=
                                                                    null)
                                                            ? IconButton(
                                                                icon: const Icon(
                                                                  Icons
                                                                      .copy_all,
                                                                  color: Colors
                                                                      .blue,
                                                                ),
                                                                tooltip:
                                                                    "Copiar a toda la semana",
                                                                onPressed: null,
                                                                // () => _confirmCopy(context, widget.viewModel, index),
                                                              )
                                                            : null,
                                                      ),
                                                      const Divider(height: 1),
                                                      TimePickerTile(
                                                        label:
                                                            "Hora de apertura",
                                                        time: day.openTime,
                                                        onTap: () async {
                                                          final t = await showTimePicker(
                                                            context: context,
                                                            initialTime:
                                                                day.openTime ??
                                                                TimeOfDay.now(),
                                                          );
                                                          if (t != null) {
                                                            widget.viewModel
                                                                .updateTime(
                                                                  index,
                                                                  true,
                                                                  t,
                                                                );
                                                          }
                                                        },
                                                      ),
                                                      TimePickerTile(
                                                        label: "Hora de Cierre",
                                                        time: day.closeTime,
                                                        onTap: () async {
                                                          final t = await showTimePicker(
                                                            context: context,
                                                            initialTime:
                                                                day.closeTime ??
                                                                TimeOfDay.now(),
                                                          );
                                                          if (t != null) {
                                                            widget.viewModel
                                                                .updateTime(
                                                                  index,
                                                                  false,
                                                                  t,
                                                                );
                                                          }
                                                        },
                                                      ),
                                                      if (error != null)
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets.fromLTRB(
                                                                16,
                                                                0,
                                                                16,
                                                                8,
                                                              ),
                                                          child: Text(
                                                            error,
                                                            style:
                                                                const TextStyle(
                                                                  color: Colors
                                                                      .red,
                                                                  fontSize: 12,
                                                                ),
                                                          ),
                                                        ),
                                                    ],
                                                  ),
                                                ),
                                              );
                                            }).toList(),
                                          );
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        ),

                        const Text(
                          "Documentación PDF",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 20),
                        FilePickerTile(
                          label: "Identificación Representante",
                          onPick: () => {
                            widget.viewModel.viewDocument(center.pathIdRep!),
                          },
                        ),
                        FilePickerTile(
                          label: "Comprobante de Domicilio",
                          onPick: () => {
                            widget.viewModel.viewDocument(
                              center.pathProofAddress!,
                            ),
                          },
                        ),
                        FilePickerTile(
                          label: "Constancia Situación Fiscal",
                          onPick: () => {
                            widget.viewModel.viewDocument(
                              center.pathTaxCertificate!,
                            ),
                          },
                        ),
                      ],
                    ),

                    // Smooth Bottom Update Button and validate/deny
                    ListenableBuilder(
                      listenable: widget.viewModel,
                      builder: (context, _) {
                        if (widget.viewModel.updateCCenter.running) {
                          return Center(child: CircularProgressIndicator());
                        }

                        if (widget.viewModel.isEditing) {
                          return AnimatedPositioned(
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeInOut,
                            bottom: 20,
                            left: 20,
                            right: 20,
                            child: FloatingActionButton.extended(
                              backgroundColor: Colors.green[600],
                              onPressed: () {
                                // UPDATE EDITCCENTER
                                widget.viewModel.editedCenter = widget
                                    .viewModel
                                    .editedCenter
                                    ?.copyWith(
                                      address: _addressController.text,
                                      bank: _bankController.text,
                                      billingEmail:
                                          _billingEmailController.text,
                                      clabe: _clabeController.text,
                                      commercialName:
                                          _commercialNameController.text,
                                      companyName: _companyNameController.text,
                                      createdAt: DateTime.tryParse(
                                        _createdAtController.text,
                                      ),
                                      curpRep: _curpRepController.text,

                                      isActive: _isActive,
                                      phoneNumber: _phoneNumberController.text,
                                      postCode: _postCodeController.text,
                                      rfc: _rfcController.text,
                                      schedule: _schedule,
                                      surnames: _surnamesController.text,
                                      taxRegime: _taxRegimeController.text,
                                      taxpayerType:
                                          widget.viewModel.taxpayerType?.label,
                                      userName: _usernameController.text,
                                      // id: '',
                                      // pathIdRep: '',
                                      // pathProofAddress: '',
                                      // pathTaxCertificate: '',
                                      // userType: '',
                                      validationStatus: _validationStatus,
                                    );

                                // EXEC UPDATE
                                widget.viewModel.updateCCenter.execute();
                              },
                              label: const Text(
                                "GUARDAR CAMBIOS",
                                style: TextStyle(color: Colors.white),
                              ),
                              icon: const Icon(
                                Icons.check,
                                color: Colors.white,
                              ),
                            ),
                          );
                        }

                        // IF NOT EDITING SHOW VALIDATE/DENY

                        return Positioned(
                          bottom: 20,
                          right: 20,
                          left: 20,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              ElevatedButton(
                                style: ButtonStyle(
                                  iconColor: WidgetStatePropertyAll(
                                    Colors.white,
                                  ),
                                  backgroundColor: WidgetStatePropertyAll(
                                    Colors.red,
                                  ),
                                  foregroundColor: WidgetStatePropertyAll(
                                    Colors.white,
                                  ),
                                ),

                                child: Row(
                                  children: [
                                    Icon(Icons.close),
                                    SizedBox(width: 10),
                                    Text('Rechazar'),
                                  ],
                                ),
                                onPressed: () {
                                  showDialog(
                                    context: context,
                                    builder: (context) {
                                      return CustomAlertDialog(
                                        title: 'Rechazar centro',
                                        content:
                                            '¿Seguro que quieres rechazar este centro?',
                                        actionText: 'Rechazar',
                                        actionTextColor: Colors.red,
                                        onPressed: () {
                                          widget
                                              .viewModel
                                              .changeValidationStatus
                                              .execute(ValidationStatus.denied);
                                        },
                                      );
                                    },
                                  );
                                },
                              ),

                              ElevatedButton(
                                style: ButtonStyle(
                                  iconColor: WidgetStatePropertyAll(
                                    Colors.white,
                                  ),
                                  backgroundColor: WidgetStatePropertyAll(
                                    Colors.green,
                                  ),
                                  foregroundColor: WidgetStatePropertyAll(
                                    Colors.white,
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    Icon(Icons.check),
                                    SizedBox(width: 10),
                                    Text('Validar'),
                                  ],
                                ),
                                onPressed: () {
                                  showDialog(
                                    context: context,
                                    builder: (context) {
                                      return CustomAlertDialog(
                                        title: 'Validar centro',
                                        content:
                                            '¿Seguro que quieres validar este centro?',
                                        actionText: 'Validar',
                                        actionTextColor: Colors.green,
                                        onPressed: () {
                                          widget
                                              .viewModel
                                              .changeValidationStatus
                                              .execute(
                                                ValidationStatus.approved,
                                              );
                                        },
                                      );
                                    },
                                  );
                                },
                              ),
                            ],
                          ),
                        );
                      },
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
        vertical: widget.viewModel.isEditing ? 4 : 12,
      ),
      decoration: BoxDecoration(
        color: widget.viewModel.isEditing ? Colors.white : Colors.transparent,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: widget.viewModel.isEditing ? Colors.green : Colors.transparent,
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
                widget.viewModel.isEditing && controller != null
                    ? TextField(
                        enabled: widget.viewModel.isEditing,
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
            backgroundColor: status.statusColor.withValues(alpha: 0.1),
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

  void _showDeleteConfirm(String id) {
    showDialog(
      context: context,
      builder: (context) => CustomAlertDialog(
        title: 'Confirmar eliminación',
        content: '¿Estás seguro de querer borrar este centro?',
        actionText: 'Eliminar',
        onPressed: () async {
          await widget.viewModel.deleteCCenter.execute(id);
        },
        actionTextColor: Colors.red,
      ),
    );
  }

  void _onUpdate() {
    if (widget.viewModel.updateCCenter.completed) {
      widget.viewModel.updateCCenter.clearResult();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Centro de recolección Actualizado")),
      );
    }

    if (widget.viewModel.updateCCenter.error) {
      widget.viewModel.updateCCenter.clearResult();

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("ERROR WHILE UPDATING CCENTER")));
    }
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

  void _onChangedValidation() {
    if (widget.viewModel.changeValidationStatus.completed) {
      widget.viewModel.changeValidationStatus.clearResult();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Cambiado estado de validación")),
      );
    }

    if (widget.viewModel.changeValidationStatus.error) {
      widget.viewModel.changeValidationStatus.clearResult();
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("ERROR CAMBIANDO ESTADO DE VALIDACIÓN")));
    }
  }
}

class TimePickerTile extends StatelessWidget {
  final String label;
  final TimeOfDay? time;
  final VoidCallback onTap;

  const TimePickerTile({
    super.key,
    required this.label,
    this.time,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(label),
      trailing: Text(
        time?.format(context) ?? "Seleccionar",
        style: TextStyle(color: time == null ? Colors.grey : Colors.blue),
      ),
      onTap: onTap,
    );
  }
}
