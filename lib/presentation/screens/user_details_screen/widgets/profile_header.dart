import 'package:flutter/material.dart';

class ProfileHeader extends StatelessWidget {
  const ProfileHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CircleAvatar(radius: 50, backgroundImage: const AssetImage("assets/images/profile_placeholder.png")),
        TextButton.icon(onPressed: () {}, icon: const Icon(Icons.edit), label: const Text("Change Picture")),
      ],
    );
  }
}
