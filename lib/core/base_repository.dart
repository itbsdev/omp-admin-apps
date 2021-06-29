import 'package:flutter/material.dart';

/// base class for all repository classes
mixin BaseRepository<T> {
  /// inserts the datum of type [T] to a storage. Can be
  /// local or remote or both
  ///
  /// Returns the id of the inserted [T]
  Future<String> insert({@required T datum});

  /// updates the datum of type [T] to a storage. Can be local
  /// or remote or both
  ///
  /// Returns the id  of the updated [T]
  Future<String> update({@required T datum});

  /// deletes the datum of type [T] on remote or local or both
  /// based on id passed
  ///
  /// Returns id of the deleted [T]
  Future<String> delete({@required String id});

  /// loads the datum of type [T] based on the
  /// given id
  ///
  /// Returns [T] based on id
  Future<T> load({@required String id});

  /// loads list of data of type [T] based from the companyId
  /// provided.
  ///
  /// Returns list of data of type [T]
  Stream<List<T>> loadByCompany({@required String companyId});
}
