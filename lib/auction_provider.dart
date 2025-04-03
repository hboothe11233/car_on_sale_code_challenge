import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'auction_data.dart';
import 'vehicle_option.dart';
import 'cos_challenge.dart';

class AuctionProvider with ChangeNotifier {
  AuctionData? _auctionData;
  String? _errorMessage;
  bool _isLoading = false;
  bool _multipleChoices = false;
  List<VehicleOption> _vehicleOptions = [];

  AuctionData? get auctionData => _auctionData;
  String? get errorMessage => _errorMessage;
  bool get isLoading => _isLoading;
  bool get multipleChoices => _multipleChoices;
  List<VehicleOption> get vehicleOptions => _vehicleOptions;

  Future<void> cacheAuctionData(AuctionData data) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('auctionData', jsonEncode(data.toJson()));
  }

  Future<AuctionData?> loadCachedAuctionData() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString('auctionData');
    if (jsonString != null) {
      return AuctionData.fromJson(jsonDecode(jsonString));
    }
    return null;
  }

  Future<void> fetchAuctionData(String vin, String userId) async {
    // Prevent multiple fetches
    if (_isLoading) return;

    // Validate VIN length using the provided constant.
    if (vin.length != CosChallenge.vinLength) {
      _errorMessage = 'VIN must be exactly ${CosChallenge.vinLength} characters.';
      notifyListeners();
      return;
    }
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final response = await CosChallenge.httpClient.get(
        Uri.https('anyUrl'),
        headers: {CosChallenge.user: userId},
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as Map<String, dynamic>;
        _auctionData = AuctionData.fromJson(data);
        await cacheAuctionData(_auctionData!);
      } else if (response.statusCode == 300) {
        // Multiple choices: parse options and let the user select.
        _multipleChoices = true;
        final options = jsonDecode(response.body) as List<dynamic>;
        _vehicleOptions = options.map((e) => VehicleOption.fromJson(e as Map<String, dynamic>)).toList();
      } else {
        // Error: display error details.
        final errorDetails = jsonDecode(response.body) as Map<String, dynamic>;
        _errorMessage = errorDetails['message'] ?? 'An unknown error occurred.';
      }
    } on ClientException catch (e) {
      _errorMessage =
      'Authentication error: ${e.message}. Please ensure your user ID is valid.';
    } on TimeoutException catch (e) {
      _errorMessage =
      'Request timed out: ${e.message}. Please check your internet connection.';
    } catch (e) {
      _errorMessage = 'Unexpected error: ${e.toString()}';
    } finally {
      if(_errorMessage?.isNotEmpty ?? false){
        //Load previously cached auction data if it exists
        _auctionData = await loadCachedAuctionData();
      }
      _isLoading = false;
      notifyListeners();
    }
  }

  void selectVehicleOption(VehicleOption option) {
    _auctionData = option.toAuctionData();
    _multipleChoices = false;
    cacheAuctionData(_auctionData!);
    notifyListeners();
  }

  /// Clears the current auction data state and any cached auction data.
  Future<void> clearAuctionData() async {
    _auctionData = null;
    _errorMessage = null;
    _multipleChoices = false;
    _vehicleOptions = [];
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('auctionData');
    notifyListeners();
  }
}
