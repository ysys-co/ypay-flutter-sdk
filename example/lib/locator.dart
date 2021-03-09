import 'package:get_it/get_it.dart';
import 'package:ypay/ypay.dart';

final locator = GetIt.instance;

void initialize() {
  locator.registerLazySingleton(() => YPay(baseUrl: 'http://10.0.2.2:8000'));
}
