import 'package:diakron_admin/data/services/database_service.dart';
import 'package:diakron_admin/utils/result.dart';

class GlobalRepository {
  GlobalRepository({required DatabaseService databaseService})
    : _databaseService = databaseService {
    init();
  }

  void init() async {
    // wasteTypesGlobal = await getWasteTypesTable();
  }

  final DatabaseService _databaseService;

  // WasteTypes
  Map<int, String> wasteTypesGlobal = {};

  // Helper method to resolve names
  String getWasteTypeName(int id) =>
      wasteTypesGlobal[id] ?? "Unknown waste type";

  Future<List<Map<int, String>>> getWasteTypesTable() async {
    final result = await _databaseService.fetchAllWasteTypes();
    switch (result) {      
      case Ok<List<Map<String, dynamic>>>():
        // return result.value;
      case Error<List<Map<String, dynamic>>>():
        // TODO: Handle this case.
        throw UnimplementedError();
    }
  }
}
