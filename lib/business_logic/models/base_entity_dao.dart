import 'package:floor/floor.dart';

abstract class BaseEntityDao<T> {
  @insert
  Future<int> insertEntity(T entity);

  @insert
  Future<List<int>> insertEntities(List<T> entities);

  @update
  Future<int> updateEntity(T entity);

  @update
  Future<int> updateEntities(List<T> entities);

  @delete
  Future<int> deleteEntity(T entity);

  @delete
  Future<int> deleteEntities(List<T> entities);
}
