import 'package:diakron_admin/data/repositories/users/collection_center_repository.dart';
import 'package:diakron_admin/domain/models/users/collection_center/collection_center.dart';
import 'package:diakron_admin/utils/command.dart';
import 'package:diakron_admin/utils/result.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

class CollectionCentersViewmodel extends ChangeNotifier {
  CollectionCentersViewmodel({
    required CollectionCenterRepository ccenterRepository,
  }) : _ccenterRepository = ccenterRepository {
    
    load = Command0(_load);
    // updateCCenter  = Command1(_deleteBooking);
    // deleteCCenter = Command1(_deleteBooking);
  }

  final CollectionCenterRepository _ccenterRepository;

  List<Map<String, dynamic>> _allWasteTypes = [];
  List<Map<String, dynamic>> get allWasteTypes => _allWasteTypes;
  List<CollectionCenter> _collectionCenters = [];
  List<CollectionCenter> get collectionCenters => _collectionCenters;

  late Command0 load;
  final Logger _logger = Logger();

  Future<Result> _load() async {
    try {
      // Fetch all waste types

      final wasteTypesresult = await _ccenterRepository.fetchAllWasteTypes();
      ();
      switch (wasteTypesresult) {
        case Ok<List<Map<String, dynamic>>>():
          _allWasteTypes = wasteTypesresult.value;
        case Error<List<Map<String, dynamic>>>():
          _logger.w('Failed to load Waste types ${wasteTypesresult.error}');
          return wasteTypesresult;
      }

      _logger.d('Waste types SUCCESS: $allWasteTypes');

      // Fetch all CollectionCenters
      final result = await _ccenterRepository.fetchCCenters();
      ();

      switch (result) {
        case Ok<List<CollectionCenter>>():
          _collectionCenters = result.value;

          _logger.d(
            'Loaded CCenters ${collectionCenters.map((e) => e.toJson()).toList()}',
          );

        case Error<List<CollectionCenter>>():
          _logger.w('Failed to load CCenters ${result.error}');
          return result;
      }
      return result;
    } finally {
      notifyListeners();
    }
  }
}
