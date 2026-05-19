import 'api_client.dart';
import 'models.dart';
import 'api_constants.dart';

class PlayerRepository {
  final ApiClient _apiClient = ApiClient();

  Future<ApiResponse<List<PlayerModel>>> getAllPlayers() async {
    final response = await _apiClient.get(ApiConstants.players);
    return ApiResponse.fromJson(
      response.data,
      (json) => (json as List)
          .map((e) => PlayerModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  Future<ApiResponse<PlayerModel>> getPlayerById(int id) async {
    final response = await _apiClient.get('${ApiConstants.players}/$id');
    return ApiResponse.fromJson(
      response.data,
      (json) => PlayerModel.fromJson(json as Map<String, dynamic>),
    );
  }

  Future<ApiResponse<PlayerModel>> getPlayerByEmail(String email) async {
    final response =
        await _apiClient.get('${ApiConstants.players}/email/$email');
    return ApiResponse.fromJson(
      response.data,
      (json) => PlayerModel.fromJson(json as Map<String, dynamic>),
    );
  }

  Future<ApiResponse<PlayerModel>> createOrUpdatePlayer(
      PlayerModel player) async {
    final response = await _apiClient.post(
      ApiConstants.players,
      data: player.toJson(),
    );
    return ApiResponse.fromJson(
      response.data,
      (json) => PlayerModel.fromJson(json as Map<String, dynamic>),
    );
  }

  Future<ApiResponse<void>> deletePlayer(int id) async {
    final response =
        await _apiClient.delete('${ApiConstants.players}/$id');
    return ApiResponse.fromJson(response.data, (_) {});
  }
}