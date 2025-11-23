import 'package:flutter/material.dart';

class SongsTab extends StatelessWidget {
  const SongsTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        "Songs",
        style: TextStyle(color: Colors.white, fontSize: 22),
      ),
    );
  }
}
