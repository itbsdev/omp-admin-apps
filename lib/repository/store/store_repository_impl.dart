import 'package:flutter/material.dart';
import 'package:admin_app/model/store.dart';
import 'package:admin_app/repository/store/store_repository.dart';
import 'package:admin_app/service/stores_firestore_service.dart';

class StoreRepositoryImpl extends StoreRepository {
  final StoresFirestoreService storesFirestoreService;

  StoreRepositoryImpl({@required this.storesFirestoreService});

  @override
  Future<String> delete({String id}) {
    return storesFirestoreService.delete(storeId: id);
  }

  @override
  Future<String> insert({Store datum}) {
    return storesFirestoreService.store(store: datum);
  }

  @override
  Future<Store> load({String id}) {
    return storesFirestoreService.load(storeId: id);
  }

  @override
  Stream<List<Store>> loadAll() {
    return storesFirestoreService.loadAll();
  }

  @override
  Future<String> update({Store datum}) {
    return storesFirestoreService.update(store: datum);
  }

  @override
  Stream<List<Store>> loadByCompany({String companyId}) {
    // TODO: implement loadByCompany
    throw UnimplementedError();
  }

}
