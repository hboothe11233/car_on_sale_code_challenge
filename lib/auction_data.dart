class AuctionData {
  final int? id;
  final String? feedback;
  final String? make;
  final String? model;
  final int? price;
  final bool? positiveCustomerFeedback;
  final String? uuid;

  AuctionData({
    this.id,
    this.feedback,
    this.make,
    this.model,
    this.price,
    this.positiveCustomerFeedback,
    this.uuid,
  });

  factory AuctionData.fromJson(Map<String, dynamic> json) {
    return AuctionData(
      id: json['id'] as int?,
      feedback: json['feedback'] as String?,
      make: json['make'] as String?,
      model: json['model'] as String?,
      price: json['price'] as int?,
      positiveCustomerFeedback: json['positiveCustomerFeedback'] as bool?,
      uuid: json['_fk_uuid_auction'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'feedback': feedback,
      'make': make,
      'model': model,
      'price': price,
      'positiveCustomerFeedback': positiveCustomerFeedback,
      '_fk_uuid_auction': uuid,
    };
  }
}
