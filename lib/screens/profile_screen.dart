import 'package:flutter/material.dart';
import 'package:foodie_padi_apps/providers/profile_provider.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  void initState() {
    super.initState();
    // ✅ specify provider type
    Future.microtask(() =>
        Provider.of<ProfileProvider>(context, listen: false).fetchProfile());
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ProfileProvider>(
      builder: (context, profileProvider, child) {
        if (profileProvider.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        final user = profileProvider.user;
        if (user == null) {
          return const Center(child: Text('No user data'));
        }

        return Scaffold(
          appBar: AppBar(
            title: const Text("Profile"),
            actions: [
              IconButton(
                icon: const Icon(Icons.edit),
                onPressed: () {
                  // TODO: Navigate to Edit Profile Screen
                },
              )
            ],
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Avatar
                CircleAvatar(
                  radius: 50,
                  backgroundImage:
                      user.avatarUrl != null && user.avatarUrl!.isNotEmpty
                          ? NetworkImage(user.avatarUrl!)
                          : null,
                  child: (user.avatarUrl == null || user.avatarUrl!.isEmpty)
                      ? Text(user.name.isNotEmpty ? user.name[0] : "?",
                          style: const TextStyle(fontSize: 30))
                      : null,
                ),
                const SizedBox(height: 12),

                // Name + Username
                Text(user.name,
                    style: const TextStyle(
                        fontSize: 22, fontWeight: FontWeight.bold)),
                if (user.username != null)
                  Text("@${user.username}",
                      style: TextStyle(color: Colors.grey[600])),

                const SizedBox(height: 8),
                if (user.email != null) Text(user.email!),

                if (user.bio != null) ...[
                  const SizedBox(height: 12),
                  Text(user.bio!,
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontStyle: FontStyle.italic)),
                ],

                const SizedBox(height: 20),

                // Preferences
                Align(
                  alignment: Alignment.centerLeft,
                  child: const Text("Preferences",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                ),
                Wrap(
                  spacing: 8,
                  children: user.preferences
                      .map((pref) =>
                          Chip(label: Text(pref.toString()))) // ✅ safe cast
                      .toList(),
                ),

                const SizedBox(height: 20),

                // Address
                Align(
                  alignment: Alignment.centerLeft,
                  child: const Text("Address",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                ),
                Card(
                  child: ListTile(
                    leading: const Icon(Icons.location_on),
                    title: Text(user.address?.toString() ?? "No address"),
                  ),
                ),

                const SizedBox(height: 20),

                // Role
                ListTile(
                  leading: const Icon(Icons.person),
                  title: Text("Role: ${user.role ?? 'Unknown'}"),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
