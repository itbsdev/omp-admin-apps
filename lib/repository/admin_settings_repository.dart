import 'package:admin_app/core/base_repository.dart';
import 'package:admin_app/model/admin_settings.dart';
import 'package:admin_app/service/settings_firestore_service.dart';
import 'package:flutter/material.dart';

class AdminSettingsRepository with BaseRepository<AdminSettings> {
  final AdminSettingsFirestoreService adminSettingsFirestoreService;

  AdminSettingsRepository({@required this.adminSettingsFirestoreService})
      : assert(adminSettingsFirestoreService != null);

  @override
  Future<String> delete({String id}) {
    return adminSettingsFirestoreService.delete(version: id);
  }

  @override
  Future<String> insert({AdminSettings datum}) {
    return adminSettingsFirestoreService.store(adminSettings: datum);
  }

  @override
  Future<AdminSettings> load({String id}) {
    return adminSettingsFirestoreService.load(version: id);
  }

  Future<AdminSettings> loadLatest() {
    return adminSettingsFirestoreService.loadLatest();
  }

  @override
  Stream<List<AdminSettings>> loadByCompany({String companyId}) {
    // TODO: implement loadByCompany
    throw UnimplementedError();
  }

  @override
  Future<String> update({AdminSettings datum}) {
    // TODO: implement update
    throw UnimplementedError();
  }
}
