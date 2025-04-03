import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'auction_provider.dart';
import 'main.dart';

class AuctionDataScreen extends StatelessWidget {
  const AuctionDataScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final auctionProvider = Provider.of<AuctionProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Auction Data'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            // Navigate back to the VIN Input screen.
            navigatorKey.currentState?.pop();
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: auctionProvider.isLoading
            ? const Center(child: CircularProgressIndicator())
            : auctionProvider.auctionData == null
            ? const Center(child: Text('No auction data available.'))
            : Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Model: ${auctionProvider.auctionData?.model}',
                style: const TextStyle(fontSize: 20)),
            Text('Price: \$${auctionProvider.auctionData?.price}',
                style: const TextStyle(fontSize: 20)),
            Text('UUID: ${auctionProvider.auctionData?.uuid}',
                style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 20),
            Text('Feedback: ${auctionProvider.auctionData?.feedback}',
                style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 10),
            auctionProvider.auctionData?.positiveCustomerFeedback ?? true
                ? Row(
              children: const [
                Icon(Icons.thumb_up, color: Colors.green),
                SizedBox(width: 8),
                Text('Positive Feedback'),
              ],
            )
                : Row(
              children: const [
                Icon(Icons.thumb_down, color: Colors.red),
                SizedBox(width: 8),
                Text('Negative Feedback'),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
