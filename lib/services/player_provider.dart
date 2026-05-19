import 'package:flutter/material.dart';
import 'player_repository.dart';
import 'models.dart';

enum PlayerStatus { initial, loading, loaded, error }

class PlayerProvider with ChangeNotifier {
  final PlayerRepository _playerRepository = PlayerRepository();

  PlayerStatus _status = PlayerStatus.initial;
  String _errorMessage = '';
  List<PlayerModel> _players = [];
  PlayerModel? _currentPlayer;

  PlayerStatus get status => _status;
  String get errorMessage => _errorMessage;
  bool get isLoading => _status == PlayerStatus.loading;
  List<PlayerModel> get players => _players;
  PlayerModel? get currentPlayer => _currentPlayer;

  // Fetch all players
  Future<void> fetchAllPlayers() async {
    _status = PlayerStatus.loading;
    _errorMessage = '';
    notifyListeners();

    try {
      final response = await _playerRepository.getAllPlayers();
      if (response.success && response.data != null) {
        _players = response.data!;
        _status = PlayerStatus.loaded;
      } else {
        _status = PlayerStatus.error;
        _errorMessage = response.message;
      }
    } catch (e) {
      _status = PlayerStatus.error;
      _errorMessage = e.toString();
    }
    notifyListeners();
  }

  // Fetch player by email
  Future<void> fetchPlayerByEmail(String email) async {
    _status = PlayerStatus.loading;
    _errorMessage = '';
    notifyListeners();

    try {
      final response = await _playerRepository.getPlayerByEmail(email);
      if (response.success && response.data != null) {
        _currentPlayer = response.data;
        _status = PlayerStatus.loaded;
      } else {
        _status = PlayerStatus.error;
        _errorMessage = response.message;
      }
    } catch (e) {
      _status = PlayerStatus.error;
      _errorMessage = e.toString();
    }
    notifyListeners();
  }

  // Create or update player
  Future<bool> savePlayer(PlayerModel player) async {
    _status = PlayerStatus.loading;
    _errorMessage = '';
    notifyListeners();

    try {
      final response = await _playerRepository.createOrUpdatePlayer(player);
      if (response.success && response.data != null) {
        _currentPlayer = response.data;
        _status = PlayerStatus.loaded;
        notifyListeners();
        return true;
      } else {
        _status = PlayerStatus.error;
        _errorMessage = response.message;
        notifyListeners();
        return false;
      }
    } catch (e) {
      _status = PlayerStatus.error;
      _errorMessage = e.toString();
      notifyListeners();
      return false;
    }
  }

  // Delete player
  Future<bool> deletePlayer(int id) async {
    _status = PlayerStatus.loading;
    notifyListeners();

    try {
      final response = await _playerRepository.deletePlayer(id);
      if (response.success) {
        _players.removeWhere((p) => p.id == id);
        _status = PlayerStatus.loaded;
        notifyListeners();
        return true;
      } else {
        _status = PlayerStatus.error;
        _errorMessage = response.message;
        notifyListeners();
        return false;
      }
    } catch (e) {
      _status = PlayerStatus.error;
      _errorMessage = e.toString();
      notifyListeners();
      return false;
    }
  }
}