import 'package:bettermint/business_logic/providers/bottom_navigation_bar_provider.dart';
import 'package:bettermint/business_logic/providers/add_card_camera_provider.dart';
import 'package:bettermint/business_logic/providers/add_card_provider.dart';
import 'package:bettermint/business_logic/providers/collection_add_card_provider.dart';
import 'package:bettermint/business_logic/providers/collection_overview_provider.dart';
import 'package:bettermint/business_logic/providers/card_details_provider.dart';
import 'package:bettermint/business_logic/providers/card_overview_provider.dart';
import 'package:bettermint/business_logic/providers/dashboard_provider.dart';
import 'package:bettermint/business_logic/providers/duplicate_dialog_provider.dart';
import 'package:bettermint/business_logic/providers/main_scaffold_provider.dart';
import 'package:bettermint/business_logic/providers/selected_bottom_bar_provider.dart';
import 'package:bettermint/business_logic/services/api_services/dummy_data_service.dart';
import 'package:bettermint/business_logic/services/api_services/prodeck_api_service.dart';
import 'package:bettermint/business_logic/services/db_services/card_collection_service.dart';
import 'package:bettermint/business_logic/services/db_services/card_entity_service.dart';
import 'package:bettermint/business_logic/services/db_services/db.dart';
import 'package:bettermint/business_logic/services/db_services/fav_cards_service.dart';
import 'package:bettermint/business_logic/services/db_services/image_service.dart';
import 'package:bettermint/business_logic/utils/calculation_service.dart';
import 'package:bettermint/business_logic/utils/sort_service.dart';
import 'package:get_it/get_it.dart';

import 'db_services/card_entity_service.dart';
import 'api_services/yugioh_prices_api_serice.dart';

GetIt locator = GetIt.instance;

/// Register all services
void setupLocator({bool testing = false}) {
  /// Only need to be called once at the start of the app
  /// Afterwards an instance of the db can be retrieved via
  /// locator.getAsync<DB>() or for non async
  if (!testing) {
    locator.registerLazySingletonAsync<DB>(
        () async => await $FloorDB.databaseBuilder(databaseFileName).build());
  } else {
    locator.registerLazySingletonAsync<DB>(
        () async => await $FloorDB.inMemoryDatabaseBuilder().build());
  }

    /// Lazy Singletons
    locator.registerLazySingleton<ProdeckAPIService>(() => ProdeckAPIService());
    locator.registerLazySingleton<YugiohPricesAPIService>(() => YugiohPricesAPIService());
    locator.registerLazySingleton<DummyDataService>(() => DummyDataService());
    locator.registerLazySingleton<CalculationService>(() => CalculationService());
    locator.registerLazySingleton<CardCollectionService>(() => CardCollectionService());
    locator.registerLazySingleton<FavCardsService>(() => FavCardsService());
    locator.registerLazySingleton<CardEntityService>(() => CardEntityService());
    locator.registerLazySingleton<ImageService>(() => ImageService());
    locator.registerLazySingleton<SortService>(() => SortService());

    locator.registerFactory(() => DashboardProvider());
    locator.registerFactory(() => MainScaffoldProvider());
    locator.registerFactory(() => MainBottomNavigationBarProvider());
    locator.registerFactory(() => SelectedBottomBarProvider());
    locator.registerFactory(() => AddCardCameraProvider());
    locator.registerFactory(() => AddCardProvider());
    locator.registerFactory(() => CollectionOverviewProvider());
    locator.registerFactory(() => CardDetailsProvider());
    locator.registerFactory(() => CardOverviewProvider());
    locator.registerFactory(() => DuplicateDialogProvider());
    locator.registerFactory(() => CollectionAddCardProvider());
}

void unregisterLocator(){
    locator.unregister<DB>();
    locator.unregister<ProdeckAPIService>();
    locator.unregister<YugiohPricesAPIService>();
    locator.unregister<DummyDataService>();
    locator.unregister<CalculationService>();
    locator.unregister<CardCollectionService>();
    locator.unregister<FavCardsService>();
    locator.unregister<DashboardProvider>();
    locator.unregister<MainScaffoldProvider>();
    locator.unregister<MainBottomNavigationBarProvider>();
    locator.unregister<SelectedBottomBarProvider>();
    locator.unregister<AddCardCameraProvider>();
    locator.unregister<AddCardProvider>();
    locator.unregister<CardEntityService>();
    locator.unregister<CollectionOverviewProvider>();
    locator.unregister<CardDetailsProvider>();
    locator.unregister<CardOverviewProvider>();
    locator.unregister<ImageService>();
    locator.unregister<SortService>();
    locator.unregister<DuplicateDialogProvider>();
    locator.unregister<CollectionAddCardProvider>();
}

