import 'package:flutter/material.dart';

import '../../services/auth.dart';
import '../../utils/utils.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(elevation: 0),
      body: ListView(
        shrinkWrap: true,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        children: [
          const CircleAvatar(radius: 50),
          ListTile(
            tileColor: Colors.grey.withOpacity(.2),
            minLeadingWidth: 0,
            leading:
                const Icon(Icons.person_outline, size: 20, color: Colors.grey),
            title: const Text('Profile'),
            trailing: const Icon(Icons.arrow_forward_ios_outlined, size: 18),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
          roundedSubmitButton('logout', AuthService().logout)
        ],
      ),
    );
  }
}
