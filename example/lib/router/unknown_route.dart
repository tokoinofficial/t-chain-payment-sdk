import 'package:flutter/material.dart';

Route<dynamic> unknownRoute(RouteSettings settings) {
  var unknownRouteText = "No such screen for ${settings.name}";

  return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) {
    return Container(
      color: Colors.white,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            unknownRouteText,
            style: const TextStyle(color: Colors.black),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text("Back"),
          ),
        ],
      ),
    );
  });
}
