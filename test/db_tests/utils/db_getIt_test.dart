import 'package:bettermint/business_logic/models/card_entity.dart';
import 'package:bettermint/business_logic/services/db_services/db.dart';
import 'package:bettermint/business_logic/services/service_locator.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';

void main() {
  group('database card entity dao tests', () {
    setUp(() async {
      setupLocator(testing: true);
    });

    tearDown(() async {
      await (await GetIt.I.getAsync<DB>()).close();
    });

    test('get db instance and insert card', () async {
      final db = await locator.getAsync<DB>();
      final card = CardEntity();

      await db.cardEntityDao.insertEntity(card);
      final cards = await db.cardEntityDao.findAll();

      expect(cards.length, equals(1));
    });
  });
}
