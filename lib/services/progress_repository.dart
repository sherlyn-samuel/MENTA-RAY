import 'api_client.dart';
import 'models.dart';
import 'api_constants.dart';

class ProgressRepository {
  final ApiClient _apiClient = ApiClient();

  Future<ApiResponse<List<ProgressModel>>> getAllProgress() async {
    final response = await _apiClient.get(ApiConstants.progress);
    return ApiResponse.fromJson(
      response.data,
      (json) => (json as List)
          .map((e) => ProgressModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  Future<ApiResponse<ProgressModel>> getProgressById(int id) async {
    final response = await _apiClient.get('${ApiConstants.progress}/$id');
    return ApiResponse.fromJson(
      response.data,
      (json) => ProgressModel.fromJson(json as Map<String, dynamic>),
    );
  }

  Future<ApiResponse<List<ProgressModel>>> getProgressByPlayerId(
      int playerId) async {
    final response = await _apiClient
        .get('${ApiConstants.progress}/player/$playerId');
    return ApiResponse.fromJson(
      response.data,
      (json) => (json as List)
          .map((e) => ProgressModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  Future<ApiResponse<ProgressModel>> createOrUpdateProgress(
      int playerId, ProgressModel progress) async {
    final response = await _apiClient.post(
      '${ApiConstants.progress}/player/$playerId',
      data: progress.toJson(),
    );
    return ApiResponse.fromJson(
      response.data,
      (json) => ProgressModel.fromJson(json as Map<String, dynamic>),
    );
  }

  Future<ApiResponse<void>> deleteProgress(int id) async {
    final response =
        await _apiClient.delete('${ApiConstants.progress}/$id');
    return ApiResponse.fromJson(response.data, (_) {});
  }
}
