import 'package:flutter/material.dart';

class ErrorMessage extends StatelessWidget {
  final String errorMessage;

  const ErrorMessage({super.key, required this.errorMessage});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(errorMessage),
    );
  }
}

class ErrorLandingPage extends StatelessWidget {
  final String errorMessage;

  const ErrorLandingPage({super.key, required this.errorMessage});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ErrorMessage(
        errorMessage: errorMessage,
      ),
    );
  }
}
