import 'package:get_it/get_it.dart';
import 'package:pocketbase/pocketbase.dart';
import 'server/pocketbase_controller.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

final getIt = GetIt.instance;

Future setupServiceLocators() async {
  //getIt.registerSingleton<PocketbaseController>(PocketbaseController());
  getIt.registerSingleton<FlutterSecureStorage>(const FlutterSecureStorage());

  getIt.registerSingletonAsync<PocketbaseController>(
    () async => PocketbaseController(),
  );

  getIt.registerSingletonAsync<PocketBase>(
    () async => getIt<PocketbaseController>().pb,
    dependsOn: [PocketbaseController],
  );

  //  getIt.registerSingletonWithDependencies<ListRequestCacher>(
  //    () => ListRequestCacher(),
  //    dependsOn: [PocketBaseController],
  //  );
}
