import 'package:get/get.dart';

import '../../domain/interfaces/search.repository.interface.dart';
import '../../infrastructure/constant.dart';
import '../../infrastructure/services/api.service.dart';
import '../dto/search_user.response.dart';

class SearchRepository implements ISearchRepository {
  final ApiService _apiservice = Get.find<ApiService>();

  @override
  Future<SearchUserResponse> searchUser(String name) async {
    try {
      final response = await _apiservice.get(
        AppUrl.users,
        queryParameters: {
          'name': name,
        },
      );

      return SearchUserResponse.fromJson(response.data);
    } catch (e) {
      rethrow;
    }
  }
}
