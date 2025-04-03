import 'dart:math';
import 'auction_data.dart';

class VehicleOption {
  final String make;
  final String model;
  final String containerName;
  final int similarity;
  final String externalId;

  VehicleOption({
    required this.make,
    required this.model,
    required this.containerName,
    required this.similarity,
    required this.externalId,
  });

  factory VehicleOption.fromJson(Map<String, dynamic> json) {
    return VehicleOption(
      make: json['make'] as String,
      model: json['model'] as String,
      containerName: json['containerName'] as String,
      similarity: json['similarity'] as int,
      externalId: json['externalId'] as String,
    );
  }

  AuctionData toAuctionData() {
    return AuctionData(
      id: Random().nextInt(1000000),
      feedback: '',
      make: make,
      model: model,
      price: 0,
      positiveCustomerFeedback: true,
      uuid: externalId,
    );
  }
}
