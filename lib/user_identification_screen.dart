import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'main.dart';
import 'user_provider.dart';
import 'vin_input_screen.dart';

class UserIdentificationScreen extends StatefulWidget {
  const UserIdentificationScreen({super.key});

  @override
  UserIdentificationScreenState createState() => UserIdentificationScreenState();
}

class UserIdentificationScreenState extends State<UserIdentificationScreen> {
  final TextEditingController _userController = TextEditingController();
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _checkUser();
  }

  Future<void> _checkUser() async {
    // Capture the provider reference before awaiting.
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    await userProvider.loadUser();

    // Check if the widget is still mounted.
    if (!mounted) return;

    final userId = userProvider.userId;
    if (userId != null && userId.isNotEmpty) {
      navigatorKey.currentState?.push(
        MaterialPageRoute(builder: (_) => VinInputScreen(userId: userId)),
      );
    } else {
      if (!mounted) return;
      setState(() {
        _isLoading = false;
      });
    }
  }


  Future<void> _saveUser() async {
    final userId = _userController.text.trim();
    if (userId.isNotEmpty) {
      await Provider.of<UserProvider>(context, listen: false).setUser(userId);
      navigatorKey.currentState?.push(
        MaterialPageRoute(builder: (_) => VinInputScreen(userId: userId)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('User Identification')),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _userController,
              decoration: InputDecoration(labelText: 'Enter your unique User ID'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _saveUser,
              child: Text('Continue'),
            ),
          ],
        ),
      ),
    );
  }
}
