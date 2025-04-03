import 'package:car_on_sale_code_challenge/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'auction_provider.dart';
import 'auction_data_screen.dart';
import 'main.dart';
import 'vehicle_selection_screen.dart';

class VinInputScreen extends StatefulWidget {
  final String userId;
  const VinInputScreen({super.key, required this.userId});

  @override
  VinInputScreenState createState() => VinInputScreenState();
}

class VinInputScreenState extends State<VinInputScreen> {
  final TextEditingController _vinController = TextEditingController();
  bool _hasNavigated = false;
  late AuctionProvider _auctionProvider;

  @override
  void initState() {
    super.initState();
    // Get the AuctionProvider once.
    _auctionProvider = Provider.of<AuctionProvider>(context, listen: false);
    // Add a listener to react to state changes.
    _auctionProvider.addListener(_auctionListener);
  }

  void _auctionListener() {
    // Only navigate once and only after loading is finished.
    if (!_hasNavigated && !_auctionProvider.isLoading) {
      if (_auctionProvider.errorMessage == null) {
        if (_auctionProvider.multipleChoices) {
          _hasNavigated = true;
          navigatorKey.currentState?.push(
            MaterialPageRoute(
              builder: (_) => VehicleSelectionScreen(
                options: _auctionProvider.vehicleOptions,
              ),
            ),
          );
        } else {
          _hasNavigated = true;
          navigatorKey.currentState?.push(
            MaterialPageRoute(builder: (_) => const AuctionDataScreen()),
          );
        }
      } else if (_auctionProvider.errorMessage != null &&
          _auctionProvider.auctionData != null) {
        // If an error occurred but cached data exists, show a SnackBar and navigate.
        _hasNavigated = true;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text(
                  "${_auctionProvider.errorMessage}. Showing cached data")),
        );
        navigatorKey.currentState?.push(
          MaterialPageRoute(builder: (_) => const AuctionDataScreen()),
        );
      }
    }
  }

  void _fetchData() {
    // Prevent multiple fetches if one is already in progress.
    if (_auctionProvider.isLoading) return;
    final vin = _vinController.text.trim();
    _auctionProvider.fetchAuctionData(vin, widget.userId);
    // Reset navigation flag to allow navigation when new data arrives.
    _hasNavigated = false;
  }

  Future<void> signOut() async {
    final userId =
        Provider.of<UserProvider>(context, listen: false).userId ?? '';
    if (userId.isNotEmpty) {
      await Provider.of<UserProvider>(context, listen: false).clearUser();
      await _auctionProvider.clearAuctionData();
    }
    navigatorKey.currentState?.pop();
  }

  @override
  void dispose() {
    _auctionProvider.removeListener(_auctionListener);
    _vinController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final auctionProvider = Provider.of<AuctionProvider>(context);
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Enter VIN'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: signOut,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _vinController,
              decoration: const InputDecoration(
                  labelText: 'Enter VIN (17 characters)'),
            ),
            if (auctionProvider.errorMessage != null)
              Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: Text(
                  auctionProvider.errorMessage!,
                  style: const TextStyle(color: Colors.red),
                ),
              ),
            const SizedBox(height: 20),
            auctionProvider.isLoading
                ? const CircularProgressIndicator()
                : ElevatedButton(
              onPressed: _fetchData,
              child: const Text('Fetch Auction Data'),
            ),
          ],
        ),
      ),
    );
  }
}
