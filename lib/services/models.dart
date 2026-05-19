class ApiResponse<T> {
  final bool success;
  final String message;
  final T? data;
  final int statusCode;

  ApiResponse({
    required this.success,
    required this.message,
    this.data,
    required this.statusCode,
  });

  factory ApiResponse.fromJson(
    Map<String, dynamic> json,
    T? Function(Object? json) fromJsonT,
  ) {
    return ApiResponse<T>(
      success: json['success'] as bool,
      message: json['message'] as String,
      statusCode: json['statusCode'] as int,
      data: json['data'] == null ? null : fromJsonT(json['data']),
    );
  }

  Map<String, dynamic> toJson(Object? Function(T? value) toJsonT) {
    return {
      'success': success,
      'message': message,
      'statusCode': statusCode,
      'data': toJsonT(data),
    };
  }
}

class PlayerModel {
  final int? id;
  final String email;
  final int progress;
  final int leaderboardRank;
  final int pearlCount;

  PlayerModel({
    this.id,
    required this.email,
    required this.progress,
    required this.leaderboardRank,
    required this.pearlCount,
  });

  factory PlayerModel.fromJson(Map<String, dynamic> json) {
    return PlayerModel(
      id: json['id'] as int?,
      email: json['email'] as String,
      progress: json['progress'] as int,
      leaderboardRank: json['leaderboardRank'] as int,
      pearlCount: json['pearlCount'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'progress': progress,
      'leaderboardRank': leaderboardRank,
      'pearlCount': pearlCount,
    };
  }
}

class ProgressModel {
  final int? id;
  final int? playerId;
  final int lives;
  final int mathProgress;
  final String mathDifficulty;
  final int coins;

  ProgressModel({
    this.id,
    this.playerId,
    required this.lives,
    required this.mathProgress,
    required this.mathDifficulty,
    required this.coins,
  });

  factory ProgressModel.fromJson(Map<String, dynamic> json) {
    return ProgressModel(
      id: json['id'] as int?,
      playerId: json['player']?['id'] as int?,
      lives: json['lives'] as int,
      mathProgress: json['mathProgress'] as int,
      mathDifficulty: json['mathDifficulty'] as String,
      coins: json['coins'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'lives': lives,
      'mathProgress': mathProgress,
      'mathDifficulty': mathDifficulty,
      'coins': coins,
    };
  }
}