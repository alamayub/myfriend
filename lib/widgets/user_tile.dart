import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../utils/colors.dart';

class UserTile extends StatefulWidget {
  final String uid;
  const UserTile({Key? key, required this.uid}) : super(key: key);

  @override
  State<UserTile> createState() => _UserTileState();
}

class _UserTileState extends State<UserTile> {
  bool? _isLoading;

  _get() async {
    setState(() => _isLoading = true);
    await FirebaseFirestore.instance
        .collection('users')
        .doc(widget.uid)
        .get()
        .then((val) {
      print(val);
      print(val.data()!['name']);
    });
    setState(() => _isLoading = false);
  }

  @override
  void initState() {
    // _get();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16),
      minVerticalPadding: 0,
      horizontalTitleGap: 10,
      leading: const CircleAvatar(
        radius: 28,
        backgroundColor: secondaryColor,
        backgroundImage: NetworkImage(
            'https://mymodernmet.com/wp/wp-content/uploads/archive/zvY94dFUiqKwu1PMVsw5_thatnordicguyredo.jpg'),
      ),
      title: const Text('Name'),
      subtitle: const Text('Last Message'),
      // onTap: () => Navigator.of(context).push(MaterialPageRoute(
      //     builder: (context) => ChatScreen(
      //           peerId: snap.data!.docs[index].id,
      //           name: snap.data!.docs[index].data()['name'],
      //         ))),
      trailing: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: const [
          Text(
            '5:30 PM',
            style: TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 12,
                color: secondaryColor),
          ),
          Icon(Icons.check_circle, size: 12)
        ],
      ),
    );
  }
}
