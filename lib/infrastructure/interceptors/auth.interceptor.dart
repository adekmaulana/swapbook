import 'package:dio/dio.dart';
import 'package:get/get.dart' hide Response;

import '../../data/repositories/local.repository.dart';
import '../constant.dart';

class AuthInterceptor extends InterceptorsWrapper {
  final LocalRepository localRepository = Get.find<LocalRepository>();

  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final String token = await localRepository.get(
      LocalRepositoryKey.TOKEN,
      '',
    );

    if (token.isNotEmpty && options.baseUrl == AppUrl.baseUrl) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    return handler.next(options);
  }
}
