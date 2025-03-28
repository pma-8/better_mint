// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'db.dart';

// **************************************************************************
// FloorGenerator
// **************************************************************************

class $FloorDB {
  /// Creates a database builder for a persistent database.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static _$DBBuilder databaseBuilder(String name) => _$DBBuilder(name);

  /// Creates a database builder for an in memory database.
  /// Information stored in an in memory database disappears when the process is killed.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static _$DBBuilder inMemoryDatabaseBuilder() => _$DBBuilder(null);
}

class _$DBBuilder {
  _$DBBuilder(this.name);

  final String name;

  final List<Migration> _migrations = [];

  Callback _callback;

  /// Adds migrations to the builder.
  _$DBBuilder addMigrations(List<Migration> migrations) {
    _migrations.addAll(migrations);
    return this;
  }

  /// Adds a database [Callback] to the builder.
  _$DBBuilder addCallback(Callback callback) {
    _callback = callback;
    return this;
  }

  /// Creates the database and initializes it.
  Future<DB> build() async {
    final path = name != null
        ? await sqfliteDatabaseFactory.getDatabasePath(name)
        : ':memory:';
    final database = _$DB();
    database.database = await database.open(
      path,
      _migrations,
      _callback,
    );
    return database;
  }
}

class _$DB extends DB {
  _$DB([StreamController<String> listener]) {
    changeListener = listener ?? StreamController<String>.broadcast();
  }

  CardEntityDao _cardEntityDaoInstance;

  CardCollectionDao _cardCollectionDaoInstance;

  CardCollectionCardsDao _cardCollectionCardsDaoInstance;

  CardInformationDao _cardInformationDaoInstance;

  CardInformationCardEntityDao _cardInformationCardEntityDaoInstance;

  FilterSettingsDao _filterSettingsDaoInstance;

  SetCodeDao _setCodeDaoInstance;

  SetPriceDao _setPriceDaoInstance;

  SetPricePricesDao _setPricePricesDaoInstance;

  ImageEntityDao _imageEntityDaoInstance;

  Future<sqflite.Database> open(String path, List<Migration> migrations,
      [Callback callback]) async {
    final databaseOptions = sqflite.OpenDatabaseOptions(
      version: 1,
      onConfigure: (database) async {
        await database.execute('PRAGMA foreign_keys = ON');
      },
      onOpen: (database) async {
        await callback?.onOpen?.call(database);
      },
      onUpgrade: (database, startVersion, endVersion) async {
        await MigrationAdapter.runMigrations(
            database, startVersion, endVersion, migrations);

        await callback?.onUpgrade?.call(database, startVersion, endVersion);
      },
      onCreate: (database, version) async {
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `card` (`set_code` TEXT, `favorite` INTEGER, `first_edition` INTEGER, `condition` TEXT, `id` INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, `create_time` TEXT NOT NULL, FOREIGN KEY (`set_code`) REFERENCES `set_code` (`set_code`) ON UPDATE NO ACTION ON DELETE CASCADE)');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `card_collection` (`name` TEXT, `favorite` INTEGER NOT NULL, `id` INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, `create_time` TEXT NOT NULL)');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `card_collection_cards` (`card_collection_id` INTEGER, `card_entity_id` INTEGER, FOREIGN KEY (`card_collection_id`) REFERENCES `card_collection` (`id`) ON UPDATE NO ACTION ON DELETE CASCADE, FOREIGN KEY (`card_entity_id`) REFERENCES `card` (`id`) ON UPDATE NO ACTION ON DELETE CASCADE, PRIMARY KEY (`card_collection_id`, `card_entity_id`))');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `card_information` (`card_type` TEXT, `atk_points` INTEGER, `def_points` INTEGER, `card_price` REAL, `name` TEXT, `description` TEXT, `level` INTEGER, `race` TEXT, `attribute` TEXT, `banned` INTEGER, `staple` INTEGER, `id` INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, `create_time` TEXT NOT NULL)');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `card_information_card_entity` (`card_information_id` INTEGER, `card_entity_id` INTEGER, FOREIGN KEY (`card_information_id`) REFERENCES `card_information` (`id`) ON UPDATE NO ACTION ON DELETE RESTRICT, FOREIGN KEY (`card_entity_id`) REFERENCES `card` (`id`) ON UPDATE NO ACTION ON DELETE CASCADE, PRIMARY KEY (`card_information_id`, `card_entity_id`))');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `filter_settings` (`sort_by` INTEGER, `page_index` INTEGER, `id` INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, `create_time` TEXT NOT NULL)');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `set_code` (`set_code` TEXT, `image_id` INTEGER, `rarity` TEXT, `card_information_id` INTEGER, `set_price_id` INTEGER, `limited_edition` INTEGER, FOREIGN KEY (`card_information_id`) REFERENCES `card_information` (`id`) ON UPDATE NO ACTION ON DELETE CASCADE, FOREIGN KEY (`set_price_id`) REFERENCES `set_prices` (`id`) ON UPDATE NO ACTION ON DELETE CASCADE, FOREIGN KEY (`image_id`) REFERENCES `image` (`id`) ON UPDATE NO ACTION ON DELETE CASCADE, PRIMARY KEY (`set_code`))');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `set_prices` (`average_price` REAL, `highest_price` REAL, `lowest_price` REAL, `shift` REAL, `shift_3` REAL, `shift_7` REAL, `shift_30` REAL, `shift_90` REAL, `shift_180` REAL, `shift_365` REAL, `updated_at` TEXT, `notify_price_change` INTEGER, `notify_update_frequency` INTEGER, `notify_price_change_margin` REAL, `id` INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, `create_time` TEXT NOT NULL)');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `set_price_prices` (`set_price_id` INTEGER, `date_time` TEXT, `value` REAL, FOREIGN KEY (`set_price_id`) REFERENCES `set_prices` (`id`) ON UPDATE NO ACTION ON DELETE CASCADE, PRIMARY KEY (`set_price_id`, `date_time`))');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `image` (`base64Image` TEXT, `id` INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, `create_time` TEXT NOT NULL)');

        await database.execute(
            '''CREATE VIEW IF NOT EXISTS `card_favs WHERE fav = true` AS SELECT id AS cardId, favorite AS fav FROM card''');
        await database.execute(
            '''CREATE VIEW IF NOT EXISTS `collection_favs` AS SELECT id AS collectionId, favorite AS fav FROM card_collection WHERE fav = true''');

        await callback?.onCreate?.call(database, version);
      },
    );
    return sqfliteDatabaseFactory.openDatabase(path, options: databaseOptions);
  }

  @override
  CardEntityDao get cardEntityDao {
    return _cardEntityDaoInstance ??= _$CardEntityDao(database, changeListener);
  }

  @override
  CardCollectionDao get cardCollectionDao {
    return _cardCollectionDaoInstance ??=
        _$CardCollectionDao(database, changeListener);
  }

  @override
  CardCollectionCardsDao get cardCollectionCardsDao {
    return _cardCollectionCardsDaoInstance ??=
        _$CardCollectionCardsDao(database, changeListener);
  }

  @override
  CardInformationDao get cardInformationDao {
    return _cardInformationDaoInstance ??=
        _$CardInformationDao(database, changeListener);
  }

  @override
  CardInformationCardEntityDao get cardInformationCardEntityDao {
    return _cardInformationCardEntityDaoInstance ??=
        _$CardInformationCardEntityDao(database, changeListener);
  }

  @override
  FilterSettingsDao get filterSettingsDao {
    return _filterSettingsDaoInstance ??=
        _$FilterSettingsDao(database, changeListener);
  }

  @override
  SetCodeDao get setCodeDao {
    return _setCodeDaoInstance ??= _$SetCodeDao(database, changeListener);
  }

  @override
  SetPriceDao get setPriceDao {
    return _setPriceDaoInstance ??= _$SetPriceDao(database, changeListener);
  }

  @override
  SetPricePricesDao get setPricePricesDao {
    return _setPricePricesDaoInstance ??=
        _$SetPricePricesDao(database, changeListener);
  }

  @override
  ImageEntityDao get imageEntityDao {
    return _imageEntityDaoInstance ??=
        _$ImageEntityDao(database, changeListener);
  }
}

class _$CardEntityDao extends CardEntityDao {
  _$CardEntityDao(this.database, this.changeListener)
      : _queryAdapter = QueryAdapter(database),
        _cardEntityInsertionAdapter = InsertionAdapter(
            database,
            'card',
            (CardEntity item) => <String, dynamic>{
                  'set_code': item.setCode,
                  'favorite':
                      item.favorite == null ? null : (item.favorite ? 1 : 0),
                  'first_edition': item.firstEdition == null
                      ? null
                      : (item.firstEdition ? 1 : 0),
                  'condition': item.condition,
                  'id': item.id,
                  'create_time': item.createTime
                }),
        _cardEntityUpdateAdapter = UpdateAdapter(
            database,
            'card',
            ['id'],
            (CardEntity item) => <String, dynamic>{
                  'set_code': item.setCode,
                  'favorite':
                      item.favorite == null ? null : (item.favorite ? 1 : 0),
                  'first_edition': item.firstEdition == null
                      ? null
                      : (item.firstEdition ? 1 : 0),
                  'condition': item.condition,
                  'id': item.id,
                  'create_time': item.createTime
                }),
        _cardEntityDeletionAdapter = DeletionAdapter(
            database,
            'card',
            ['id'],
            (CardEntity item) => <String, dynamic>{
                  'set_code': item.setCode,
                  'favorite':
                      item.favorite == null ? null : (item.favorite ? 1 : 0),
                  'first_edition': item.firstEdition == null
                      ? null
                      : (item.firstEdition ? 1 : 0),
                  'condition': item.condition,
                  'id': item.id,
                  'create_time': item.createTime
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<CardEntity> _cardEntityInsertionAdapter;

  final UpdateAdapter<CardEntity> _cardEntityUpdateAdapter;

  final DeletionAdapter<CardEntity> _cardEntityDeletionAdapter;

  @override
  Future<List<CardEntity>> findAll() async {
    return _queryAdapter.queryList('SELECT * FROM card',
        mapper: (Map<String, dynamic> row) => CardEntity(
            id: row['id'] as int,
            setCode: row['set_code'] as String,
            favorite:
                row['favorite'] == null ? null : (row['favorite'] as int) != 0,
            condition: row['condition'] as String,
            firstEdition: row['first_edition'] == null
                ? null
                : (row['first_edition'] as int) != 0));
  }

  @override
  Future<List<CardEntity>> findAllFavorites() async {
    return _queryAdapter.queryList('SELECT * FROM card a WHERE a.favorite = 1',
        mapper: (Map<String, dynamic> row) => CardEntity(
            id: row['id'] as int,
            setCode: row['set_code'] as String,
            favorite:
                row['favorite'] == null ? null : (row['favorite'] as int) != 0,
            condition: row['condition'] as String,
            firstEdition: row['first_edition'] == null
                ? null
                : (row['first_edition'] as int) != 0));
  }

  @override
  Future<List<CardEntity>> findByCollectionId(int collectionId) async {
    return _queryAdapter.queryList(
        'SELECT * FROM card a INNER JOIN card_collection_cards b ON a.id = b.card_entity_id WHERE b.card_collection_id = ?',
        arguments: <dynamic>[collectionId],
        mapper: (Map<String, dynamic> row) => CardEntity(
            id: row['id'] as int,
            setCode: row['set_code'] as String,
            favorite:
                row['favorite'] == null ? null : (row['favorite'] as int) != 0,
            condition: row['condition'] as String,
            firstEdition: row['first_edition'] == null
                ? null
                : (row['first_edition'] as int) != 0));
  }

  @override
  Future<CardEntity> findById(int id) async {
    return _queryAdapter.query('SELECT * FROM card WHERE id = ?',
        arguments: <dynamic>[id],
        mapper: (Map<String, dynamic> row) => CardEntity(
            id: row['id'] as int,
            setCode: row['set_code'] as String,
            favorite:
                row['favorite'] == null ? null : (row['favorite'] as int) != 0,
            condition: row['condition'] as String,
            firstEdition: row['first_edition'] == null
                ? null
                : (row['first_edition'] as int) != 0));
  }

  @override
  Future<void> clearTable() async {
    await _queryAdapter.queryNoReturn('DELETE FROM card');
  }

  @override
  Future<CardEntity> deleteById(int id) async {
    return _queryAdapter.query('DELETE FROM card WHERE id = ?',
        arguments: <dynamic>[id],
        mapper: (Map<String, dynamic> row) => CardEntity(
            id: row['id'] as int,
            setCode: row['set_code'] as String,
            favorite:
                row['favorite'] == null ? null : (row['favorite'] as int) != 0,
            condition: row['condition'] as String,
            firstEdition: row['first_edition'] == null
                ? null
                : (row['first_edition'] as int) != 0));
  }

  @override
  Future<int> insertEntity(CardEntity entity) {
    return _cardEntityInsertionAdapter.insertAndReturnId(
        entity, OnConflictStrategy.abort);
  }

  @override
  Future<List<int>> insertEntities(List<CardEntity> entities) {
    return _cardEntityInsertionAdapter.insertListAndReturnIds(
        entities, OnConflictStrategy.abort);
  }

  @override
  Future<int> updateEntity(CardEntity entity) {
    return _cardEntityUpdateAdapter.updateAndReturnChangedRows(
        entity, OnConflictStrategy.abort);
  }

  @override
  Future<int> updateEntities(List<CardEntity> entities) {
    return _cardEntityUpdateAdapter.updateListAndReturnChangedRows(
        entities, OnConflictStrategy.abort);
  }

  @override
  Future<int> deleteEntity(CardEntity entity) {
    return _cardEntityDeletionAdapter.deleteAndReturnChangedRows(entity);
  }

  @override
  Future<int> deleteEntities(List<CardEntity> entities) {
    return _cardEntityDeletionAdapter.deleteListAndReturnChangedRows(entities);
  }
}

class _$CardCollectionDao extends CardCollectionDao {
  _$CardCollectionDao(this.database, this.changeListener)
      : _queryAdapter = QueryAdapter(database),
        _cardCollectionInsertionAdapter = InsertionAdapter(
            database,
            'card_collection',
            (CardCollection item) => <String, dynamic>{
                  'name': item.name,
                  'favorite': item.favorite ? 1 : 0,
                  'id': item.id,
                  'create_time': item.createTime
                }),
        _cardCollectionUpdateAdapter = UpdateAdapter(
            database,
            'card_collection',
            ['id'],
            (CardCollection item) => <String, dynamic>{
                  'name': item.name,
                  'favorite': item.favorite ? 1 : 0,
                  'id': item.id,
                  'create_time': item.createTime
                }),
        _cardCollectionDeletionAdapter = DeletionAdapter(
            database,
            'card_collection',
            ['id'],
            (CardCollection item) => <String, dynamic>{
                  'name': item.name,
                  'favorite': item.favorite ? 1 : 0,
                  'id': item.id,
                  'create_time': item.createTime
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<CardCollection> _cardCollectionInsertionAdapter;

  final UpdateAdapter<CardCollection> _cardCollectionUpdateAdapter;

  final DeletionAdapter<CardCollection> _cardCollectionDeletionAdapter;

  @override
  Future<List<CardCollection>> findAll() async {
    return _queryAdapter.queryList('SELECT * FROM card_collection',
        mapper: (Map<String, dynamic> row) => CardCollection(
            id: row['id'] as int,
            name: row['name'] as String,
            favorite: (row['favorite'] as int) != 0));
  }

  @override
  Future<List<CardCollection>> findAllFavorites() async {
    return _queryAdapter.queryList(
        'SELECT * FROM card_collection a WHERE a.favorite = 1',
        mapper: (Map<String, dynamic> row) => CardCollection(
            id: row['id'] as int,
            name: row['name'] as String,
            favorite: (row['favorite'] as int) != 0));
  }

  @override
  Future<CardCollection> findById(int id) async {
    return _queryAdapter.query('SELECT * FROM card_collection WHERE id = ?',
        arguments: <dynamic>[id],
        mapper: (Map<String, dynamic> row) => CardCollection(
            id: row['id'] as int,
            name: row['name'] as String,
            favorite: (row['favorite'] as int) != 0));
  }

  @override
  Future<void> clearTable() async {
    await _queryAdapter.queryNoReturn('DELETE FROM card_collection');
  }

  @override
  Future<CardCollection> deleteById(int id) async {
    return _queryAdapter.query('DELETE FROM card_collection WHERE id = ?',
        arguments: <dynamic>[id],
        mapper: (Map<String, dynamic> row) => CardCollection(
            id: row['id'] as int,
            name: row['name'] as String,
            favorite: (row['favorite'] as int) != 0));
  }

  @override
  Future<void> flipFavoriteStatus(int id) async {
    await _queryAdapter.queryNoReturn(
        'UPDATE card_collection SET favorite = ((favorite | 1) - (favorite & 1)) WHERE id = ?',
        arguments: <dynamic>[id]);
  }

  @override
  Future<int> insertEntity(CardCollection entity) {
    return _cardCollectionInsertionAdapter.insertAndReturnId(
        entity, OnConflictStrategy.abort);
  }

  @override
  Future<List<int>> insertEntities(List<CardCollection> entities) {
    return _cardCollectionInsertionAdapter.insertListAndReturnIds(
        entities, OnConflictStrategy.abort);
  }

  @override
  Future<int> updateEntity(CardCollection entity) {
    return _cardCollectionUpdateAdapter.updateAndReturnChangedRows(
        entity, OnConflictStrategy.abort);
  }

  @override
  Future<int> updateEntities(List<CardCollection> entities) {
    return _cardCollectionUpdateAdapter.updateListAndReturnChangedRows(
        entities, OnConflictStrategy.abort);
  }

  @override
  Future<int> deleteEntity(CardCollection entity) {
    return _cardCollectionDeletionAdapter.deleteAndReturnChangedRows(entity);
  }

  @override
  Future<int> deleteEntities(List<CardCollection> entities) {
    return _cardCollectionDeletionAdapter
        .deleteListAndReturnChangedRows(entities);
  }
}

class _$CardCollectionCardsDao extends CardCollectionCardsDao {
  _$CardCollectionCardsDao(this.database, this.changeListener)
      : _queryAdapter = QueryAdapter(database),
        _cardCollectionCardsInsertionAdapter = InsertionAdapter(
            database,
            'card_collection_cards',
            (CardCollectionCards item) => <String, dynamic>{
                  'card_collection_id': item.cardCollectionId,
                  'card_entity_id': item.cardEntityId
                }),
        _cardCollectionCardsUpdateAdapter = UpdateAdapter(
            database,
            'card_collection_cards',
            ['card_collection_id', 'card_entity_id'],
            (CardCollectionCards item) => <String, dynamic>{
                  'card_collection_id': item.cardCollectionId,
                  'card_entity_id': item.cardEntityId
                }),
        _cardCollectionCardsDeletionAdapter = DeletionAdapter(
            database,
            'card_collection_cards',
            ['card_collection_id', 'card_entity_id'],
            (CardCollectionCards item) => <String, dynamic>{
                  'card_collection_id': item.cardCollectionId,
                  'card_entity_id': item.cardEntityId
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<CardCollectionCards>
      _cardCollectionCardsInsertionAdapter;

  final UpdateAdapter<CardCollectionCards> _cardCollectionCardsUpdateAdapter;

  final DeletionAdapter<CardCollectionCards>
      _cardCollectionCardsDeletionAdapter;

  @override
  Future<List<CardCollectionCards>> findAll() async {
    return _queryAdapter.queryList('SELECT * FROM card_collection_cards',
        mapper: (Map<String, dynamic> row) => CardCollectionCards(
            cardCollectionId: row['card_collection_id'] as int,
            cardEntityId: row['card_entity_id'] as int));
  }

  @override
  Future<List<CardCollectionCards>> findByCollectionId(int id) async {
    return _queryAdapter.queryList(
        'SELECT * FROM card_collection_cards WHERE card_collection_id = ?',
        arguments: <dynamic>[id],
        mapper: (Map<String, dynamic> row) => CardCollectionCards(
            cardCollectionId: row['card_collection_id'] as int,
            cardEntityId: row['card_entity_id'] as int));
  }

  @override
  Future<CardCollectionCards> deleteByCollectionId(int id) async {
    return _queryAdapter.query(
        'DELETE FROM card_collection_cards WHERE card_collection_id = ?',
        arguments: <dynamic>[id],
        mapper: (Map<String, dynamic> row) => CardCollectionCards(
            cardCollectionId: row['card_collection_id'] as int,
            cardEntityId: row['card_entity_id'] as int));
  }

  @override
  Future<void> clearTable() async {
    await _queryAdapter.queryNoReturn('DELETE FROM card_collection_cards');
  }

  @override
  Future<int> insertEntity(CardCollectionCards entity) {
    return _cardCollectionCardsInsertionAdapter.insertAndReturnId(
        entity, OnConflictStrategy.abort);
  }

  @override
  Future<List<int>> insertEntities(List<CardCollectionCards> entities) {
    return _cardCollectionCardsInsertionAdapter.insertListAndReturnIds(
        entities, OnConflictStrategy.abort);
  }

  @override
  Future<int> updateEntity(CardCollectionCards entity) {
    return _cardCollectionCardsUpdateAdapter.updateAndReturnChangedRows(
        entity, OnConflictStrategy.abort);
  }

  @override
  Future<int> updateEntities(List<CardCollectionCards> entities) {
    return _cardCollectionCardsUpdateAdapter.updateListAndReturnChangedRows(
        entities, OnConflictStrategy.abort);
  }

  @override
  Future<int> deleteEntity(CardCollectionCards entity) {
    return _cardCollectionCardsDeletionAdapter
        .deleteAndReturnChangedRows(entity);
  }

  @override
  Future<int> deleteEntities(List<CardCollectionCards> entities) {
    return _cardCollectionCardsDeletionAdapter
        .deleteListAndReturnChangedRows(entities);
  }
}

class _$CardInformationDao extends CardInformationDao {
  _$CardInformationDao(this.database, this.changeListener)
      : _queryAdapter = QueryAdapter(database),
        _cardInformationInsertionAdapter = InsertionAdapter(
            database,
            'card_information',
            (CardInformation item) => <String, dynamic>{
                  'card_type': item.cardType,
                  'atk_points': item.atkPoints,
                  'def_points': item.defPoints,
                  'card_price': item.cardPrice,
                  'name': item.name,
                  'description': item.description,
                  'level': item.level,
                  'race': item.race,
                  'attribute': item.attribute,
                  'banned': item.banned == null ? null : (item.banned ? 1 : 0),
                  'staple': item.staple == null ? null : (item.staple ? 1 : 0),
                  'id': item.id,
                  'create_time': item.createTime
                }),
        _cardInformationUpdateAdapter = UpdateAdapter(
            database,
            'card_information',
            ['id'],
            (CardInformation item) => <String, dynamic>{
                  'card_type': item.cardType,
                  'atk_points': item.atkPoints,
                  'def_points': item.defPoints,
                  'card_price': item.cardPrice,
                  'name': item.name,
                  'description': item.description,
                  'level': item.level,
                  'race': item.race,
                  'attribute': item.attribute,
                  'banned': item.banned == null ? null : (item.banned ? 1 : 0),
                  'staple': item.staple == null ? null : (item.staple ? 1 : 0),
                  'id': item.id,
                  'create_time': item.createTime
                }),
        _cardInformationDeletionAdapter = DeletionAdapter(
            database,
            'card_information',
            ['id'],
            (CardInformation item) => <String, dynamic>{
                  'card_type': item.cardType,
                  'atk_points': item.atkPoints,
                  'def_points': item.defPoints,
                  'card_price': item.cardPrice,
                  'name': item.name,
                  'description': item.description,
                  'level': item.level,
                  'race': item.race,
                  'attribute': item.attribute,
                  'banned': item.banned == null ? null : (item.banned ? 1 : 0),
                  'staple': item.staple == null ? null : (item.staple ? 1 : 0),
                  'id': item.id,
                  'create_time': item.createTime
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<CardInformation> _cardInformationInsertionAdapter;

  final UpdateAdapter<CardInformation> _cardInformationUpdateAdapter;

  final DeletionAdapter<CardInformation> _cardInformationDeletionAdapter;

  @override
  Future<List<CardInformation>> findAll() async {
    return _queryAdapter.queryList('SELECT * FROM card_information',
        mapper: (Map<String, dynamic> row) => CardInformation(
            id: row['id'] as int,
            name: row['name'] as String,
            level: row['level'] as int,
            cardType: row['card_type'] as String,
            description: row['description'] as String,
            atkPoints: row['atk_points'] as int,
            defPoints: row['def_points'] as int,
            race: row['race'] as String,
            attribute: row['attribute'] as String,
            cardPrice: row['card_price'] as double,
            banned: row['banned'] == null ? null : (row['banned'] as int) != 0,
            staple:
                row['staple'] == null ? null : (row['staple'] as int) != 0));
  }

  @override
  Future<CardInformation> findById(int id) async {
    return _queryAdapter.query('SELECT * FROM card_information WHERE id = ?',
        arguments: <dynamic>[id],
        mapper: (Map<String, dynamic> row) => CardInformation(
            id: row['id'] as int,
            name: row['name'] as String,
            level: row['level'] as int,
            cardType: row['card_type'] as String,
            description: row['description'] as String,
            atkPoints: row['atk_points'] as int,
            defPoints: row['def_points'] as int,
            race: row['race'] as String,
            attribute: row['attribute'] as String,
            cardPrice: row['card_price'] as double,
            banned: row['banned'] == null ? null : (row['banned'] as int) != 0,
            staple:
                row['staple'] == null ? null : (row['staple'] as int) != 0));
  }

  @override
  Future<List<CardInformation>> findByIds(List<int> id) async {
    final valueList0 = id.map((value) => "'$value'").join(', ');
    return _queryAdapter.queryList(
        'SELECT * FROM card_information WHERE id IN ($valueList0)',
        mapper: (Map<String, dynamic> row) => CardInformation(
            id: row['id'] as int,
            name: row['name'] as String,
            level: row['level'] as int,
            cardType: row['card_type'] as String,
            description: row['description'] as String,
            atkPoints: row['atk_points'] as int,
            defPoints: row['def_points'] as int,
            race: row['race'] as String,
            attribute: row['attribute'] as String,
            cardPrice: row['card_price'] as double,
            banned: row['banned'] == null ? null : (row['banned'] as int) != 0,
            staple:
                row['staple'] == null ? null : (row['staple'] as int) != 0));
  }

  @override
  Future<List<CardInformation>> findByName(String name) async {
    return _queryAdapter.queryList(
        'SELECT * FROM card_information WHERE name = (?)',
        arguments: <dynamic>[name],
        mapper: (Map<String, dynamic> row) => CardInformation(
            id: row['id'] as int,
            name: row['name'] as String,
            level: row['level'] as int,
            cardType: row['card_type'] as String,
            description: row['description'] as String,
            atkPoints: row['atk_points'] as int,
            defPoints: row['def_points'] as int,
            race: row['race'] as String,
            attribute: row['attribute'] as String,
            cardPrice: row['card_price'] as double,
            banned: row['banned'] == null ? null : (row['banned'] as int) != 0,
            staple:
                row['staple'] == null ? null : (row['staple'] as int) != 0));
  }

  @override
  Future<CardInformation> findByCardEntityId(int cardEntityId) async {
    return _queryAdapter.query(
        'SELECT * FROM card_information a JOIN card_information_card_entity b ON a.id = b.card_information_id WHERE b.card_entity_id = ?',
        arguments: <dynamic>[cardEntityId],
        mapper: (Map<String, dynamic> row) => CardInformation(
            id: row['id'] as int,
            name: row['name'] as String,
            level: row['level'] as int,
            cardType: row['card_type'] as String,
            description: row['description'] as String,
            atkPoints: row['atk_points'] as int,
            defPoints: row['def_points'] as int,
            race: row['race'] as String,
            attribute: row['attribute'] as String,
            cardPrice: row['card_price'] as double,
            banned: row['banned'] == null ? null : (row['banned'] as int) != 0,
            staple:
                row['staple'] == null ? null : (row['staple'] as int) != 0));
  }

  @override
  Future<List<CardInformation>> findByCardEntityIds(
      List<int> cardEntityIds) async {
    final valueList0 = cardEntityIds.map((value) => "'$value'").join(', ');
    return _queryAdapter.queryList(
        'SELECT * FROM card_information a JOIN card_information_card_entity b ON a.id = b.card_information_id WHERE b.card_entity_id IN ($valueList0)',
        mapper: (Map<String, dynamic> row) => CardInformation(
            id: row['id'] as int,
            name: row['name'] as String,
            level: row['level'] as int,
            cardType: row['card_type'] as String,
            description: row['description'] as String,
            atkPoints: row['atk_points'] as int,
            defPoints: row['def_points'] as int,
            race: row['race'] as String,
            attribute: row['attribute'] as String,
            cardPrice: row['card_price'] as double,
            banned: row['banned'] == null ? null : (row['banned'] as int) != 0,
            staple:
                row['staple'] == null ? null : (row['staple'] as int) != 0));
  }

  @override
  Future<void> clearTable() async {
    await _queryAdapter.queryNoReturn('DELETE FROM card_information');
  }

  @override
  Future<CardInformation> deleteById(int id) async {
    return _queryAdapter.query('DELETE FROM card_information WHERE id = ?',
        arguments: <dynamic>[id],
        mapper: (Map<String, dynamic> row) => CardInformation(
            id: row['id'] as int,
            name: row['name'] as String,
            level: row['level'] as int,
            cardType: row['card_type'] as String,
            description: row['description'] as String,
            atkPoints: row['atk_points'] as int,
            defPoints: row['def_points'] as int,
            race: row['race'] as String,
            attribute: row['attribute'] as String,
            cardPrice: row['card_price'] as double,
            banned: row['banned'] == null ? null : (row['banned'] as int) != 0,
            staple:
                row['staple'] == null ? null : (row['staple'] as int) != 0));
  }

  @override
  Future<int> insertEntity(CardInformation entity) {
    return _cardInformationInsertionAdapter.insertAndReturnId(
        entity, OnConflictStrategy.abort);
  }

  @override
  Future<List<int>> insertEntities(List<CardInformation> entities) {
    return _cardInformationInsertionAdapter.insertListAndReturnIds(
        entities, OnConflictStrategy.abort);
  }

  @override
  Future<int> updateEntity(CardInformation entity) {
    return _cardInformationUpdateAdapter.updateAndReturnChangedRows(
        entity, OnConflictStrategy.abort);
  }

  @override
  Future<int> updateEntities(List<CardInformation> entities) {
    return _cardInformationUpdateAdapter.updateListAndReturnChangedRows(
        entities, OnConflictStrategy.abort);
  }

  @override
  Future<int> deleteEntity(CardInformation entity) {
    return _cardInformationDeletionAdapter.deleteAndReturnChangedRows(entity);
  }

  @override
  Future<int> deleteEntities(List<CardInformation> entities) {
    return _cardInformationDeletionAdapter
        .deleteListAndReturnChangedRows(entities);
  }
}

class _$CardInformationCardEntityDao extends CardInformationCardEntityDao {
  _$CardInformationCardEntityDao(this.database, this.changeListener)
      : _queryAdapter = QueryAdapter(database),
        _cardInformationCardEntityInsertionAdapter = InsertionAdapter(
            database,
            'card_information_card_entity',
            (CardInformationCardEntity item) => <String, dynamic>{
                  'card_information_id': item.cardInformationId,
                  'card_entity_id': item.cardEntityId
                }),
        _cardInformationCardEntityUpdateAdapter = UpdateAdapter(
            database,
            'card_information_card_entity',
            ['card_information_id', 'card_entity_id'],
            (CardInformationCardEntity item) => <String, dynamic>{
                  'card_information_id': item.cardInformationId,
                  'card_entity_id': item.cardEntityId
                }),
        _cardInformationCardEntityDeletionAdapter = DeletionAdapter(
            database,
            'card_information_card_entity',
            ['card_information_id', 'card_entity_id'],
            (CardInformationCardEntity item) => <String, dynamic>{
                  'card_information_id': item.cardInformationId,
                  'card_entity_id': item.cardEntityId
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<CardInformationCardEntity>
      _cardInformationCardEntityInsertionAdapter;

  final UpdateAdapter<CardInformationCardEntity>
      _cardInformationCardEntityUpdateAdapter;

  final DeletionAdapter<CardInformationCardEntity>
      _cardInformationCardEntityDeletionAdapter;

  @override
  Future<List<CardInformationCardEntity>> findAll() async {
    return _queryAdapter.queryList('SELECT * FROM card_information_card_entity',
        mapper: (Map<String, dynamic> row) => CardInformationCardEntity(
            cardEntityId: row['card_entity_id'] as int,
            cardInformationId: row['card_information_id'] as int));
  }

  @override
  Future<void> clearTable() async {
    await _queryAdapter
        .queryNoReturn('DELETE FROM card_information_card_entity');
  }

  @override
  Future<int> insertEntity(CardInformationCardEntity entity) {
    return _cardInformationCardEntityInsertionAdapter.insertAndReturnId(
        entity, OnConflictStrategy.abort);
  }

  @override
  Future<List<int>> insertEntities(List<CardInformationCardEntity> entities) {
    return _cardInformationCardEntityInsertionAdapter.insertListAndReturnIds(
        entities, OnConflictStrategy.abort);
  }

  @override
  Future<int> updateEntity(CardInformationCardEntity entity) {
    return _cardInformationCardEntityUpdateAdapter.updateAndReturnChangedRows(
        entity, OnConflictStrategy.abort);
  }

  @override
  Future<int> updateEntities(List<CardInformationCardEntity> entities) {
    return _cardInformationCardEntityUpdateAdapter
        .updateListAndReturnChangedRows(entities, OnConflictStrategy.abort);
  }

  @override
  Future<int> deleteEntity(CardInformationCardEntity entity) {
    return _cardInformationCardEntityDeletionAdapter
        .deleteAndReturnChangedRows(entity);
  }

  @override
  Future<int> deleteEntities(List<CardInformationCardEntity> entities) {
    return _cardInformationCardEntityDeletionAdapter
        .deleteListAndReturnChangedRows(entities);
  }
}

class _$FilterSettingsDao extends FilterSettingsDao {
  _$FilterSettingsDao(this.database, this.changeListener)
      : _queryAdapter = QueryAdapter(database),
        _filterSettingsInsertionAdapter = InsertionAdapter(
            database,
            'filter_settings',
            (FilterSettings item) => <String, dynamic>{
                  'sort_by': item.sortBy,
                  'page_index': item.pageIndex,
                  'id': item.id,
                  'create_time': item.createTime
                }),
        _filterSettingsUpdateAdapter = UpdateAdapter(
            database,
            'filter_settings',
            ['id'],
            (FilterSettings item) => <String, dynamic>{
                  'sort_by': item.sortBy,
                  'page_index': item.pageIndex,
                  'id': item.id,
                  'create_time': item.createTime
                }),
        _filterSettingsDeletionAdapter = DeletionAdapter(
            database,
            'filter_settings',
            ['id'],
            (FilterSettings item) => <String, dynamic>{
                  'sort_by': item.sortBy,
                  'page_index': item.pageIndex,
                  'id': item.id,
                  'create_time': item.createTime
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<FilterSettings> _filterSettingsInsertionAdapter;

  final UpdateAdapter<FilterSettings> _filterSettingsUpdateAdapter;

  final DeletionAdapter<FilterSettings> _filterSettingsDeletionAdapter;

  @override
  Future<List<FilterSettings>> findAll() async {
    return _queryAdapter.queryList('SELECT * FROM filter_settings',
        mapper: (Map<String, dynamic> row) => FilterSettings(
            id: row['id'] as int,
            sortBy: row['sort_by'] as int,
            pageIndex: row['page_index'] as int));
  }

  @override
  Future<FilterSettings> findById(int id) async {
    return _queryAdapter.query('SELECT * FROM filter_settings WHERE id = ?',
        arguments: <dynamic>[id],
        mapper: (Map<String, dynamic> row) => FilterSettings(
            id: row['id'] as int,
            sortBy: row['sort_by'] as int,
            pageIndex: row['page_index'] as int));
  }

  @override
  Future<FilterSettings> findByPageIndex(int pageIndex) async {
    return _queryAdapter.query(
        'SELECT * FROM filter_settings WHERE page_index = ?',
        arguments: <dynamic>[pageIndex],
        mapper: (Map<String, dynamic> row) => FilterSettings(
            id: row['id'] as int,
            sortBy: row['sort_by'] as int,
            pageIndex: row['page_index'] as int));
  }

  @override
  Future<void> clearTable() async {
    await _queryAdapter.queryNoReturn('DELETE FROM filter_settings');
  }

  @override
  Future<FilterSettings> deleteById(int id) async {
    return _queryAdapter.query('DELETE FROM filter_settings WHERE id = ?',
        arguments: <dynamic>[id],
        mapper: (Map<String, dynamic> row) => FilterSettings(
            id: row['id'] as int,
            sortBy: row['sort_by'] as int,
            pageIndex: row['page_index'] as int));
  }

  @override
  Future<void> updateSortSetting(int pageIndex, int sortBy) async {
    await _queryAdapter.queryNoReturn(
        'UPDATE filter_settings SET sort_by = ? WHERE page_index = ?',
        arguments: <dynamic>[pageIndex, sortBy]);
  }

  @override
  Future<int> insertEntity(FilterSettings entity) {
    return _filterSettingsInsertionAdapter.insertAndReturnId(
        entity, OnConflictStrategy.abort);
  }

  @override
  Future<List<int>> insertEntities(List<FilterSettings> entities) {
    return _filterSettingsInsertionAdapter.insertListAndReturnIds(
        entities, OnConflictStrategy.abort);
  }

  @override
  Future<int> updateEntity(FilterSettings entity) {
    return _filterSettingsUpdateAdapter.updateAndReturnChangedRows(
        entity, OnConflictStrategy.abort);
  }

  @override
  Future<int> updateEntities(List<FilterSettings> entities) {
    return _filterSettingsUpdateAdapter.updateListAndReturnChangedRows(
        entities, OnConflictStrategy.abort);
  }

  @override
  Future<int> deleteEntity(FilterSettings entity) {
    return _filterSettingsDeletionAdapter.deleteAndReturnChangedRows(entity);
  }

  @override
  Future<int> deleteEntities(List<FilterSettings> entities) {
    return _filterSettingsDeletionAdapter
        .deleteListAndReturnChangedRows(entities);
  }
}

class _$SetCodeDao extends SetCodeDao {
  _$SetCodeDao(this.database, this.changeListener)
      : _queryAdapter = QueryAdapter(database),
        _setCodeInsertionAdapter = InsertionAdapter(
            database,
            'set_code',
            (SetCode item) => <String, dynamic>{
                  'set_code': item.setCode,
                  'image_id': item.imageId,
                  'rarity': item.rarity,
                  'card_information_id': item.cardInformationId,
                  'set_price_id': item.setPriceId,
                  'limited_edition': item.limitedEdition == null
                      ? null
                      : (item.limitedEdition ? 1 : 0)
                }),
        _setCodeUpdateAdapter = UpdateAdapter(
            database,
            'set_code',
            ['set_code'],
            (SetCode item) => <String, dynamic>{
                  'set_code': item.setCode,
                  'image_id': item.imageId,
                  'rarity': item.rarity,
                  'card_information_id': item.cardInformationId,
                  'set_price_id': item.setPriceId,
                  'limited_edition': item.limitedEdition == null
                      ? null
                      : (item.limitedEdition ? 1 : 0)
                }),
        _setCodeDeletionAdapter = DeletionAdapter(
            database,
            'set_code',
            ['set_code'],
            (SetCode item) => <String, dynamic>{
                  'set_code': item.setCode,
                  'image_id': item.imageId,
                  'rarity': item.rarity,
                  'card_information_id': item.cardInformationId,
                  'set_price_id': item.setPriceId,
                  'limited_edition': item.limitedEdition == null
                      ? null
                      : (item.limitedEdition ? 1 : 0)
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<SetCode> _setCodeInsertionAdapter;

  final UpdateAdapter<SetCode> _setCodeUpdateAdapter;

  final DeletionAdapter<SetCode> _setCodeDeletionAdapter;

  @override
  Future<List<SetCode>> findAll() async {
    return _queryAdapter.queryList('SELECT * FROM set_code',
        mapper: (Map<String, dynamic> row) => SetCode(
            setCode: row['set_code'] as String,
            cardInformationId: row['card_information_id'] as int,
            setPriceId: row['set_price_id'] as int,
            rarity: row['rarity'] as String,
            limitedEdition: row['limited_edition'] == null
                ? null
                : (row['limited_edition'] as int) != 0,
            imageId: row['image_id'] as int));
  }

  @override
  Future<SetCode> findBySetCode(String setCode) async {
    return _queryAdapter.query('SELECT * FROM set_code WHERE set_code = ?',
        arguments: <dynamic>[setCode],
        mapper: (Map<String, dynamic> row) => SetCode(
            setCode: row['set_code'] as String,
            cardInformationId: row['card_information_id'] as int,
            setPriceId: row['set_price_id'] as int,
            rarity: row['rarity'] as String,
            limitedEdition: row['limited_edition'] == null
                ? null
                : (row['limited_edition'] as int) != 0,
            imageId: row['image_id'] as int));
  }

  @override
  Future<List<SetCode>> findBySetCodes(List<String> setCodes) async {
    final valueList0 = setCodes.map((value) => "'$value'").join(', ');
    return _queryAdapter.queryList(
        'SELECT * FROM set_code WHERE set_code IN ($valueList0)',
        mapper: (Map<String, dynamic> row) => SetCode(
            setCode: row['set_code'] as String,
            cardInformationId: row['card_information_id'] as int,
            setPriceId: row['set_price_id'] as int,
            rarity: row['rarity'] as String,
            limitedEdition: row['limited_edition'] == null
                ? null
                : (row['limited_edition'] as int) != 0,
            imageId: row['image_id'] as int));
  }

  @override
  Future<void> clearTable() async {
    await _queryAdapter.queryNoReturn('DELETE FROM set_code');
  }

  @override
  Future<SetCode> deleteBySetCode(String setCode) async {
    return _queryAdapter.query('DELETE FROM set_code WHERE set_code = ?',
        arguments: <dynamic>[setCode],
        mapper: (Map<String, dynamic> row) => SetCode(
            setCode: row['set_code'] as String,
            cardInformationId: row['card_information_id'] as int,
            setPriceId: row['set_price_id'] as int,
            rarity: row['rarity'] as String,
            limitedEdition: row['limited_edition'] == null
                ? null
                : (row['limited_edition'] as int) != 0,
            imageId: row['image_id'] as int));
  }

  @override
  Future<int> insertEntity(SetCode entity) {
    return _setCodeInsertionAdapter.insertAndReturnId(
        entity, OnConflictStrategy.abort);
  }

  @override
  Future<List<int>> insertEntities(List<SetCode> entities) {
    return _setCodeInsertionAdapter.insertListAndReturnIds(
        entities, OnConflictStrategy.abort);
  }

  @override
  Future<int> updateEntity(SetCode entity) {
    return _setCodeUpdateAdapter.updateAndReturnChangedRows(
        entity, OnConflictStrategy.abort);
  }

  @override
  Future<int> updateEntities(List<SetCode> entities) {
    return _setCodeUpdateAdapter.updateListAndReturnChangedRows(
        entities, OnConflictStrategy.abort);
  }

  @override
  Future<int> deleteEntity(SetCode entity) {
    return _setCodeDeletionAdapter.deleteAndReturnChangedRows(entity);
  }

  @override
  Future<int> deleteEntities(List<SetCode> entities) {
    return _setCodeDeletionAdapter.deleteListAndReturnChangedRows(entities);
  }
}

class _$SetPriceDao extends SetPriceDao {
  _$SetPriceDao(this.database, this.changeListener)
      : _queryAdapter = QueryAdapter(database),
        _setPriceInsertionAdapter = InsertionAdapter(
            database,
            'set_prices',
            (SetPrice item) => <String, dynamic>{
                  'average_price': item.averagePrice,
                  'highest_price': item.highestPrice,
                  'lowest_price': item.lowestPrice,
                  'shift': item.shift,
                  'shift_3': item.shift3,
                  'shift_7': item.shift7,
                  'shift_30': item.shift30,
                  'shift_90': item.shift90,
                  'shift_180': item.shift180,
                  'shift_365': item.shift365,
                  'updated_at': item.updatedAt,
                  'notify_price_change': item.notifyPriceChange == null
                      ? null
                      : (item.notifyPriceChange ? 1 : 0),
                  'notify_update_frequency': item.notifyUpdateFrequency,
                  'notify_price_change_margin': item.notifyPriceChangeMargin,
                  'id': item.id,
                  'create_time': item.createTime
                }),
        _setPriceUpdateAdapter = UpdateAdapter(
            database,
            'set_prices',
            ['id'],
            (SetPrice item) => <String, dynamic>{
                  'average_price': item.averagePrice,
                  'highest_price': item.highestPrice,
                  'lowest_price': item.lowestPrice,
                  'shift': item.shift,
                  'shift_3': item.shift3,
                  'shift_7': item.shift7,
                  'shift_30': item.shift30,
                  'shift_90': item.shift90,
                  'shift_180': item.shift180,
                  'shift_365': item.shift365,
                  'updated_at': item.updatedAt,
                  'notify_price_change': item.notifyPriceChange == null
                      ? null
                      : (item.notifyPriceChange ? 1 : 0),
                  'notify_update_frequency': item.notifyUpdateFrequency,
                  'notify_price_change_margin': item.notifyPriceChangeMargin,
                  'id': item.id,
                  'create_time': item.createTime
                }),
        _setPriceDeletionAdapter = DeletionAdapter(
            database,
            'set_prices',
            ['id'],
            (SetPrice item) => <String, dynamic>{
                  'average_price': item.averagePrice,
                  'highest_price': item.highestPrice,
                  'lowest_price': item.lowestPrice,
                  'shift': item.shift,
                  'shift_3': item.shift3,
                  'shift_7': item.shift7,
                  'shift_30': item.shift30,
                  'shift_90': item.shift90,
                  'shift_180': item.shift180,
                  'shift_365': item.shift365,
                  'updated_at': item.updatedAt,
                  'notify_price_change': item.notifyPriceChange == null
                      ? null
                      : (item.notifyPriceChange ? 1 : 0),
                  'notify_update_frequency': item.notifyUpdateFrequency,
                  'notify_price_change_margin': item.notifyPriceChangeMargin,
                  'id': item.id,
                  'create_time': item.createTime
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<SetPrice> _setPriceInsertionAdapter;

  final UpdateAdapter<SetPrice> _setPriceUpdateAdapter;

  final DeletionAdapter<SetPrice> _setPriceDeletionAdapter;

  @override
  Future<List<SetPrice>> findAll() async {
    return _queryAdapter.queryList('SELECT * FROM set_prices',
        mapper: (Map<String, dynamic> row) => SetPrice(
            id: row['id'] as int,
            averagePrice: row['average_price'] as double,
            highestPrice: row['highest_price'] as double,
            lowestPrice: row['lowest_price'] as double,
            notifyPriceChange: row['notify_price_change'] == null
                ? null
                : (row['notify_price_change'] as int) != 0,
            notifyPriceChangeMargin:
                row['notify_price_change_margin'] as double,
            notifyUpdateFrequency: row['notify_update_frequency'] as int,
            updatedAt: row['updated_at'] as String,
            shift: row['shift'] as double,
            shift3: row['shift_3'] as double,
            shift7: row['shift_7'] as double,
            shift30: row['shift_30'] as double,
            shift90: row['shift_90'] as double,
            shift180: row['shift_180'] as double,
            shift365: row['shift_365'] as double));
  }

  @override
  Future<SetPrice> findById(int id) async {
    return _queryAdapter.query('SELECT * FROM set_prices WHERE id = ?',
        arguments: <dynamic>[id],
        mapper: (Map<String, dynamic> row) => SetPrice(
            id: row['id'] as int,
            averagePrice: row['average_price'] as double,
            highestPrice: row['highest_price'] as double,
            lowestPrice: row['lowest_price'] as double,
            notifyPriceChange: row['notify_price_change'] == null
                ? null
                : (row['notify_price_change'] as int) != 0,
            notifyPriceChangeMargin:
                row['notify_price_change_margin'] as double,
            notifyUpdateFrequency: row['notify_update_frequency'] as int,
            updatedAt: row['updated_at'] as String,
            shift: row['shift'] as double,
            shift3: row['shift_3'] as double,
            shift7: row['shift_7'] as double,
            shift30: row['shift_30'] as double,
            shift90: row['shift_90'] as double,
            shift180: row['shift_180'] as double,
            shift365: row['shift_365'] as double));
  }

  @override
  Future<List<SetPrice>> findByIds(List<int> ids) async {
    final valueList0 = ids.map((value) => "'$value'").join(', ');
    return _queryAdapter.queryList(
        'SELECT * FROM set_prices WHERE id IN ($valueList0)',
        mapper: (Map<String, dynamic> row) => SetPrice(
            id: row['id'] as int,
            averagePrice: row['average_price'] as double,
            highestPrice: row['highest_price'] as double,
            lowestPrice: row['lowest_price'] as double,
            notifyPriceChange: row['notify_price_change'] == null
                ? null
                : (row['notify_price_change'] as int) != 0,
            notifyPriceChangeMargin:
                row['notify_price_change_margin'] as double,
            notifyUpdateFrequency: row['notify_update_frequency'] as int,
            updatedAt: row['updated_at'] as String,
            shift: row['shift'] as double,
            shift3: row['shift_3'] as double,
            shift7: row['shift_7'] as double,
            shift30: row['shift_30'] as double,
            shift90: row['shift_90'] as double,
            shift180: row['shift_180'] as double,
            shift365: row['shift_365'] as double));
  }

  @override
  Future<void> clearTable() async {
    await _queryAdapter.queryNoReturn('DELETE FROM set_prices');
  }

  @override
  Future<SetPrice> deleteById(int id) async {
    return _queryAdapter.query('DELETE FROM set_prices WHERE id = ?',
        arguments: <dynamic>[id],
        mapper: (Map<String, dynamic> row) => SetPrice(
            id: row['id'] as int,
            averagePrice: row['average_price'] as double,
            highestPrice: row['highest_price'] as double,
            lowestPrice: row['lowest_price'] as double,
            notifyPriceChange: row['notify_price_change'] == null
                ? null
                : (row['notify_price_change'] as int) != 0,
            notifyPriceChangeMargin:
                row['notify_price_change_margin'] as double,
            notifyUpdateFrequency: row['notify_update_frequency'] as int,
            updatedAt: row['updated_at'] as String,
            shift: row['shift'] as double,
            shift3: row['shift_3'] as double,
            shift7: row['shift_7'] as double,
            shift30: row['shift_30'] as double,
            shift90: row['shift_90'] as double,
            shift180: row['shift_180'] as double,
            shift365: row['shift_365'] as double));
  }

  @override
  Future<int> insertEntity(SetPrice entity) {
    return _setPriceInsertionAdapter.insertAndReturnId(
        entity, OnConflictStrategy.abort);
  }

  @override
  Future<List<int>> insertEntities(List<SetPrice> entities) {
    return _setPriceInsertionAdapter.insertListAndReturnIds(
        entities, OnConflictStrategy.abort);
  }

  @override
  Future<int> updateEntity(SetPrice entity) {
    return _setPriceUpdateAdapter.updateAndReturnChangedRows(
        entity, OnConflictStrategy.abort);
  }

  @override
  Future<int> updateEntities(List<SetPrice> entities) {
    return _setPriceUpdateAdapter.updateListAndReturnChangedRows(
        entities, OnConflictStrategy.abort);
  }

  @override
  Future<int> deleteEntity(SetPrice entity) {
    return _setPriceDeletionAdapter.deleteAndReturnChangedRows(entity);
  }

  @override
  Future<int> deleteEntities(List<SetPrice> entities) {
    return _setPriceDeletionAdapter.deleteListAndReturnChangedRows(entities);
  }
}

class _$SetPricePricesDao extends SetPricePricesDao {
  _$SetPricePricesDao(this.database, this.changeListener)
      : _queryAdapter = QueryAdapter(database),
        _setPricePricesInsertionAdapter = InsertionAdapter(
            database,
            'set_price_prices',
            (SetPricePrices item) => <String, dynamic>{
                  'set_price_id': item.setPriceId,
                  'date_time': item.dateTime,
                  'value': item.value
                }),
        _setPricePricesUpdateAdapter = UpdateAdapter(
            database,
            'set_price_prices',
            ['set_price_id', 'date_time'],
            (SetPricePrices item) => <String, dynamic>{
                  'set_price_id': item.setPriceId,
                  'date_time': item.dateTime,
                  'value': item.value
                }),
        _setPricePricesDeletionAdapter = DeletionAdapter(
            database,
            'set_price_prices',
            ['set_price_id', 'date_time'],
            (SetPricePrices item) => <String, dynamic>{
                  'set_price_id': item.setPriceId,
                  'date_time': item.dateTime,
                  'value': item.value
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<SetPricePrices> _setPricePricesInsertionAdapter;

  final UpdateAdapter<SetPricePrices> _setPricePricesUpdateAdapter;

  final DeletionAdapter<SetPricePrices> _setPricePricesDeletionAdapter;

  @override
  Future<List<SetPricePrices>> findAll() async {
    return _queryAdapter.queryList('SELECT * FROM set_price_prices',
        mapper: (Map<String, dynamic> row) => SetPricePrices(
            setPriceId: row['set_price_id'] as int,
            dateTime: row['date_time'] as String,
            value: row['value'] as double));
  }

  @override
  Future<void> clearTable() async {
    await _queryAdapter.queryNoReturn('DELETE FROM set_price_prices');
  }

  @override
  Future<int> insertEntity(SetPricePrices entity) {
    return _setPricePricesInsertionAdapter.insertAndReturnId(
        entity, OnConflictStrategy.abort);
  }

  @override
  Future<List<int>> insertEntities(List<SetPricePrices> entities) {
    return _setPricePricesInsertionAdapter.insertListAndReturnIds(
        entities, OnConflictStrategy.abort);
  }

  @override
  Future<int> updateEntity(SetPricePrices entity) {
    return _setPricePricesUpdateAdapter.updateAndReturnChangedRows(
        entity, OnConflictStrategy.abort);
  }

  @override
  Future<int> updateEntities(List<SetPricePrices> entities) {
    return _setPricePricesUpdateAdapter.updateListAndReturnChangedRows(
        entities, OnConflictStrategy.abort);
  }

  @override
  Future<int> deleteEntity(SetPricePrices entity) {
    return _setPricePricesDeletionAdapter.deleteAndReturnChangedRows(entity);
  }

  @override
  Future<int> deleteEntities(List<SetPricePrices> entities) {
    return _setPricePricesDeletionAdapter
        .deleteListAndReturnChangedRows(entities);
  }
}

class _$ImageEntityDao extends ImageEntityDao {
  _$ImageEntityDao(this.database, this.changeListener)
      : _queryAdapter = QueryAdapter(database),
        _imageEntityInsertionAdapter = InsertionAdapter(
            database,
            'image',
            (ImageEntity item) => <String, dynamic>{
                  'base64Image': item.base64Image,
                  'id': item.id,
                  'create_time': item.createTime
                }),
        _imageEntityUpdateAdapter = UpdateAdapter(
            database,
            'image',
            ['id'],
            (ImageEntity item) => <String, dynamic>{
                  'base64Image': item.base64Image,
                  'id': item.id,
                  'create_time': item.createTime
                }),
        _imageEntityDeletionAdapter = DeletionAdapter(
            database,
            'image',
            ['id'],
            (ImageEntity item) => <String, dynamic>{
                  'base64Image': item.base64Image,
                  'id': item.id,
                  'create_time': item.createTime
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<ImageEntity> _imageEntityInsertionAdapter;

  final UpdateAdapter<ImageEntity> _imageEntityUpdateAdapter;

  final DeletionAdapter<ImageEntity> _imageEntityDeletionAdapter;

  @override
  Future<List<ImageEntity>> findAll() async {
    return _queryAdapter.queryList('SELECT * FROM image',
        mapper: (Map<String, dynamic> row) => ImageEntity(
            id: row['id'] as int, base64Image: row['base64Image'] as String));
  }

  @override
  Future<ImageEntity> findById(int id) async {
    return _queryAdapter.query('SELECT * FROM image WHERE id = ?',
        arguments: <dynamic>[id],
        mapper: (Map<String, dynamic> row) => ImageEntity(
            id: row['id'] as int, base64Image: row['base64Image'] as String));
  }

  @override
  Future<void> clearTable() async {
    await _queryAdapter.queryNoReturn('DELETE FROM image');
  }

  @override
  Future<ImageEntity> deleteById(int id) async {
    return _queryAdapter.query('DELETE FROM image WHERE id = ?',
        arguments: <dynamic>[id],
        mapper: (Map<String, dynamic> row) => ImageEntity(
            id: row['id'] as int, base64Image: row['base64Image'] as String));
  }

  @override
  Future<List<ImageEntity>> findByIds(List<int> ids) async {
    final valueList0 = ids.map((value) => "'$value'").join(', ');
    return _queryAdapter.queryList(
        'SELECT * FROM image WHERE id IN ($valueList0)',
        mapper: (Map<String, dynamic> row) => ImageEntity(
            id: row['id'] as int, base64Image: row['base64Image'] as String));
  }

  @override
  Future<int> insertEntity(ImageEntity entity) {
    return _imageEntityInsertionAdapter.insertAndReturnId(
        entity, OnConflictStrategy.abort);
  }

  @override
  Future<List<int>> insertEntities(List<ImageEntity> entities) {
    return _imageEntityInsertionAdapter.insertListAndReturnIds(
        entities, OnConflictStrategy.abort);
  }

  @override
  Future<int> updateEntity(ImageEntity entity) {
    return _imageEntityUpdateAdapter.updateAndReturnChangedRows(
        entity, OnConflictStrategy.abort);
  }

  @override
  Future<int> updateEntities(List<ImageEntity> entities) {
    return _imageEntityUpdateAdapter.updateListAndReturnChangedRows(
        entities, OnConflictStrategy.abort);
  }

  @override
  Future<int> deleteEntity(ImageEntity entity) {
    return _imageEntityDeletionAdapter.deleteAndReturnChangedRows(entity);
  }

  @override
  Future<int> deleteEntities(List<ImageEntity> entities) {
    return _imageEntityDeletionAdapter.deleteListAndReturnChangedRows(entities);
  }
}
