import 'package:get_it/get_it.dart';
import 'package:proveedores_manuelita/services/navigator_service.dart';
import 'package:proveedores_manuelita/utiles/Notificaciones.dart';

final locator = GetIt.instance;
void setupLocator()
{
  locator.registerLazySingleton(() => NavigatorService());
  locator.registerLazySingleton(() => Notificaciones());
}