import 'package:diakron_admin/data/repositories/users/collection_center_repository.dart';
import 'package:diakron_admin/domain/models/users/collection_center/collection_center.dart';
import 'package:diakron_admin/utils/command.dart';
import 'package:diakron_admin/utils/result.dart';
import 'package:flutter/material.dart';
import 'package:logger/web.dart';

class CollectionCenterDetailsViewModel extends ChangeNotifier {
  CollectionCenterDetailsViewModel({
    required CollectionCenterRepository repository,
    required this.centerId,
  }) : _ccenterRepository = repository {
    load = Command0(_load)..execute();
    deleteCCenter = Command1(_deleteCCenter);
    updateCCenter = Command0(_updateCCenter);
  }

  bool _isEditing = false;
  bool get isEditing => _isEditing;

  void toggleEdit() {
    _isEditing = !_isEditing;
    if (_isEditing) {
      editedCenter = center;
    }
    notifyListeners();
  }

  final CollectionCenterRepository _ccenterRepository;
  final String centerId;

  late Command0 load;
  late Command1<void, String> deleteCCenter;
  late Command0 updateCCenter;
  CollectionCenter? center;
  CollectionCenter? editedCenter;

  final _logger = Logger();

  Future<Result> _updateCCenter() async {
    try {
      final result = await _ccenterRepository.updateCCenter(editedCenter!);

      switch (result) {
        case Ok<void>():
          _logger.i('Updated CCenter successfully');
        case Error<void>():
          _logger.e('ERROR UPDATING CCENTER');
      }
      return result;
    } finally {
      notifyListeners();
    }
  }

  Future<Result> _load() async {
    try {
      // Fetch fresh data for this specific center
      final result = await _ccenterRepository.getCollectionCenterById(centerId);

      switch (result) {
        case Ok<CollectionCenter>():
          center = result.value;
        case Error<CollectionCenter>():
          return result;
      }
      return result;
    } on Exception catch (error) {
      return Result.error(error);
    } finally {
      notifyListeners();
    }
  }

  Future<Result<void>> _deleteCCenter(String id) async {
    try {
      final result = await _ccenterRepository.deleteCCenter(id: id);
      switch (result) {
        case Ok<void>():
          _logger.i('Successfully deleted center');
        case Error<void>():
          _logger.e('Error deleted center');
      }

      return result;
    } finally {
      notifyListeners();
    }
  }
}
