import 'package:flutter/material.dart';
import 'progress_repository.dart';
import 'models.dart';

enum ProgressStatus { initial, loading, loaded, error }

class ProgressProvider with ChangeNotifier {
  final ProgressRepository _progressRepository = ProgressRepository();

  ProgressStatus _status = ProgressStatus.initial;
  String _errorMessage = '';
  List<ProgressModel> _progressList = [];
  ProgressModel? _currentProgress;

  ProgressStatus get status => _status;
  String get errorMessage => _errorMessage;
  bool get isLoading => _status == ProgressStatus.loading;
  List<ProgressModel> get progressList => _progressList;
  ProgressModel? get currentProgress => _currentProgress;

  // Fetch progress by player ID
  Future<void> fetchProgressByPlayerId(int playerId) async {
    _status = ProgressStatus.loading;
    _errorMessage = '';
    notifyListeners();

    try {
      final response =
          await _progressRepository.getProgressByPlayerId(playerId);
      if (response.success && response.data != null) {
        _progressList = response.data!;
        _status = ProgressStatus.loaded;
      } else {
        _status = ProgressStatus.error;
        _errorMessage = response.message;
      }
    } catch (e) {
      _status = ProgressStatus.error;
      _errorMessage = e.toString();
    }
    notifyListeners();
  }

  // Save progress
  Future<bool> saveProgress(int playerId, ProgressModel progress) async {
    _status = ProgressStatus.loading;
    _errorMessage = '';
    notifyListeners();

    try {
      final response =
          await _progressRepository.createOrUpdateProgress(playerId, progress);
      if (response.success && response.data != null) {
        _currentProgress = response.data;
        _status = ProgressStatus.loaded;
        notifyListeners();
        return true;
      } else {
        _status = ProgressStatus.error;
        _errorMessage = response.message;
        notifyListeners();
        return false;
      }
    } catch (e) {
      _status = ProgressStatus.error;
      _errorMessage = e.toString();
      notifyListeners();
      return false;
    }
  }

  // Delete progress
  Future<bool> deleteProgress(int id) async {
    _status = ProgressStatus.loading;
    notifyListeners();

    try {
      final response = await _progressRepository.deleteProgress(id);
      if (response.success) {
        _progressList.removeWhere((p) => p.id == id);
        _status = ProgressStatus.loaded;
        notifyListeners();
        return true;
      } else {
        _status = ProgressStatus.error;
        _errorMessage = response.message;
        notifyListeners();
        return false;
      }
    } catch (e) {
      _status = ProgressStatus.error;
      _errorMessage = e.toString();
      notifyListeners();
      return false;
    }
  }
}