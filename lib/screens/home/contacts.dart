import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:myfriend/screens/home/chat_screen.dart';
import 'package:myfriend/utils/colors.dart';

class ContactsScreen extends StatefulWidget {
  const ContactsScreen({Key? key}) : super(key: key);

  @override
  State<ContactsScreen> createState() => _ContactsScreenState();
}

class _ContactsScreenState extends State<ContactsScreen> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('users')
            .orderBy('createdAt', descending: true)
            .snapshots(),
        builder: (_, AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snap) {
          if (snap.connectionState == ConnectionState.active) {
            if (snap.hasData) {
              return ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (_, index) => ListTile(
                        contentPadding:
                            const EdgeInsets.symmetric(horizontal: 16),
                        minVerticalPadding: 0,
                        horizontalTitleGap: 10,
                        leading: const CircleAvatar(
                          radius: 28,
                          backgroundColor: secondaryColor,
                          backgroundImage: NetworkImage(
                              'https://mymodernmet.com/wp/wp-content/uploads/archive/zvY94dFUiqKwu1PMVsw5_thatnordicguyredo.jpg'),
                        ),
                        title: Text(snap.data!.docs[index].data()['name']),
                        // subtitle: const Text('Last Message'),
                        onTap: () => Navigator.of(context).push(
                            MaterialPageRoute(
                                builder: (context) => ChatScreen(
                                    peerId: snap.data!.docs[index].id,
                                    name: snap.data!.docs[index].data()['name'],
                                    image: ''))),
                      ),
                  separatorBuilder: (_, i) => const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      child: Divider()),
                  itemCount: snap.data!.docs.length);
            }
          }
          return const Center(child: CircularProgressIndicator());
        });
  }
}

/*
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
                        ),*/