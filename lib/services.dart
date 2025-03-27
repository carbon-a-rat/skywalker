import 'package:get_it/get_it.dart';
import 'server/pocketbase_controller.dart';

final getIt = GetIt.instance;

Future setupServiceLocators() async {
  //getIt.registerSingleton<PocketbaseController>(PocketbaseController());

  getIt.registerSingletonAsync<PocketbaseController>(
    () async => PocketbaseController(),
  );

  //  getIt.registerSingletonWithDependencies<ListRequestCacher>(
  //    () => ListRequestCacher(),
  //    dependsOn: [PocketBaseController],
  //  );
}
