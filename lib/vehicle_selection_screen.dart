import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'auction_provider.dart';
import 'main.dart';
import 'vehicle_option.dart';
import 'auction_data_screen.dart';

class VehicleSelectionScreen extends StatelessWidget {
  final List<VehicleOption> options;
  const VehicleSelectionScreen({super.key, required this.options});

  @override
  Widget build(BuildContext context) {
    // Sort options by similarity in descending order.
    final sortedOptions = List<VehicleOption>.from(options)
      ..sort((a, b) => b.similarity.compareTo(a.similarity));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Select Your Vehicle'),
      ),
      body: ListView.builder(
        itemCount: sortedOptions.length,
        itemBuilder: (context, index) {
          final option = sortedOptions[index];
          return ListTile(
            title: Text('${option.make} ${option.model}'),
            subtitle: Text('Similarity: ${option.similarity}%'),
            onTap: () {
              Provider.of<AuctionProvider>(context, listen: false)
                  .selectVehicleOption(option);
              navigatorKey.currentState?.push(
                MaterialPageRoute(builder: (_) => const AuctionDataScreen()),
              );
            },
          );
        },
      ),
    );
  }
}
