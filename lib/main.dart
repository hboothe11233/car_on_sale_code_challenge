import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'user_provider.dart';
import 'auction_provider.dart';
import 'user_identification_screen.dart';
import 'vin_input_screen.dart';


// Define a global navigator key.
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UserProvider()..loadUser()),
        ChangeNotifierProvider(create: (_) => AuctionProvider()),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<UserProvider>(
      builder: (context, userProvider, child) {
        return MaterialApp(
          key: const Key('MaterialApp'),
          navigatorKey: navigatorKey,
          title: 'Flutter Challenge',
          theme: ThemeData(primarySwatch: Colors.blue),
          home: (userProvider.userId == null || userProvider.userId!.isEmpty)
              ? UserIdentificationScreen()
              : VinInputScreen(userId: userProvider.userId!),
        );
      },
    );
  }
}
