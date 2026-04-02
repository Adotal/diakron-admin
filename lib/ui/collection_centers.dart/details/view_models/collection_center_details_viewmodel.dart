import 'package:diakron_admin/data/repositories/users/collection_center_repository.dart';
import 'package:diakron_admin/domain/models/users/collection_center/collection_center.dart';
import 'package:diakron_admin/utils/command.dart';
import 'package:diakron_admin/utils/result.dart';
import 'package:flutter/material.dart';
import 'package:logger/web.dart';

class CollectionCenterDetailsViewModel extends ChangeNotifier {
  final CollectionCenterRepository _ccenterRepository;
  final String centerId;

  CollectionCenterDetailsViewModel({
    required CollectionCenterRepository repository,
    required this.centerId,
  }) : _ccenterRepository = repository {
    load = Command0(_load)..execute();
    deleteCCenter = Command1(_deleteCCenter);
  }

  late Command0 load;
  late Command1<void, String> deleteCCenter;
  CollectionCenter? center;

  final _logger = Logger();

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
