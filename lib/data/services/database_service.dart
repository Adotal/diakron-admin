import 'dart:io';
import 'package:diakron_admin/utils/result.dart';
import 'package:logger/logger.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class DatabaseService {
  final SupabaseClient _supabase = Supabase.instance.client;
  final _logger = Logger();

  Future<Result<String>> getValidationStatus(String userId) async {
    _logger.w('User id: $userId');
    try {
      // 1. Consultamos solo la columna necesaria para ahorrar ancho de banda
      final data = await _supabase
          .from('collection_centers')
          .select('validation_status')
          .eq('id', userId)
          .single();

      // 2. Mapeamos el String de la DB al Enum que creaste
      final String status = data['validation_status'] ?? 'UPLOADING';
      _logger.w(data['validation_status']);

      return Result.ok(status);
    } on Exception catch (error) {
      _logger.e('User id: $userId');
      return Result.error(error);
    }
  }

  /// Actualiza datos en una tabla específica
  Future<Result<void>> uploadUserData({
    required String table,
    required String id,
    required Map<String, dynamic> data,
  }) async {
    try {
      await _supabase.from(table).update(data).eq('id', id);
      return Result.ok(null);
    } catch (e) {
      // This will catch if the table doesn't exist or a constraint is violated
      return Result.error(e as Exception);
    }
  }

  // --- Operaciones de Storage (Archivos) ---

  /// Sube un archivo y retorna la ruta interna (path)
  Future<String?> uploadFile({
    required String id,
    required String fileName,
    required File file,
  }) async {
    try {
      // The path MUST start with the userId for the RLS to pass
      final String path = '$id/$fileName';
      // Usamos 'upsert: true' por si el usuario reintenta una subida fallida
      final String fullPath = await _supabase.storage
          .from('diakron_storage_private')
          .upload(path, file, fileOptions: const FileOptions(upsert: true));

      return fullPath; // Retornamos el path para guardarlo en la DB
    } catch (e) {
      _logger.e("Upload failed: $e");
      return null;
    }
  }

  // Obtain all data in table
  Future<Result<List<Map<String, dynamic>>>> fetchTable({
    required String table,
  }) async {
    try {
      // ONLY ID AND COMPANY NAME
      final result = await _supabase.from(table).select(
        '''id, company_name, validation_status''',
      );
      return Result.ok(result);
    } on Exception catch (error) {
      return Result.error(error);
    }
  }

  /// Obtiene un registro único por ID de cualquier tabla
  Future<Result<Map<String, dynamic>>> getRecordById({
    required String table,
    required String id,
  }) async {
    try {
      final result = await _supabase.from(table).select().eq('id', id).single();
      _logger.i(result);
      return Result.ok(result);
    } on Exception catch (error) {
      return Result.error(error);
    }
  }

  /// Obtiene un registro único por ID de cualquier tabla
  Future<Result<Map<String, dynamic>>> getUserById({
    required String table,
    required String id,
  }) async {
    try {
      final result = await _supabase
          .from('full_collection_centers')
          .select()
          .eq('id', id)
          .single();
      _logger.i(result);
      return Result.ok(result);
    } on Exception catch (error) {
      return Result.error(error);
    }
  }

  Future<Result<void>> deleteUserById({required String id}) async {
    try {
      await _supabase.auth.admin.deleteUser(id);
      return Result.ok(null);
    } on Exception catch (error) {
      _logger.e(error);
      return Result.error(Exception(error));
    }
  }

  Future<Result<void>> deleteRecordById({
    required String table,
    required String id,
  }) async {
    try {
      await _supabase.from(table).delete().eq('id', id);
      _logger.i('DELETED FROM SERVICE $table $id');
      return Result.ok(null);
    } on Exception catch (error) {
      _logger.e(error);
      return Result.error(Exception(error));
    }
  }

  Future<Result<List<Map<String, dynamic>>>> fetchAllWasteTypes() async {
    try {
      final data = await _supabase
          .from('waste_types')
          .select('*')
          .order('waste_type', ascending: true); // Keeps the list alphabetical
      return Result.ok(List<Map<String, dynamic>>.from(data));
    } catch (e) {
      _logger.e(e);
      return Result.error(Exception(e));
    }
  }

  // Inserts in intermediate table for waste types
  Future<void> saveCenterCapabilities({
    required String centerId,
    required List<int> selectedWasteIds,
  }) async {
    try {
      // 1. Clear old selections for this center
      await _supabase
          .from('collection_center_waste')
          .delete()
          .eq('id_collection_center', centerId);

      // 2. Prepare the new rows
      final newRows = selectedWasteIds
          .map((id) => {'id_collection_center': centerId, 'id_waste_type': id})
          .toList();

      // 3. Bulk insert
      if (newRows.isNotEmpty) {
        await _supabase.from('collection_center_waste').insert(newRows);
      }
    } catch (e) {
      _logger.e(e);
    }
  }
}
