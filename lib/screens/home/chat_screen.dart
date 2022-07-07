import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:myfriend/utils/colors.dart';

import '../../utils/utils.dart';

class ChatScreen extends StatefulWidget {
  final String peerId;
  final String name;
  final String image;

  const ChatScreen(
      {Key? key, required this.peerId, required this.name, required this.image})
      : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  User? user = FirebaseAuth.instance.currentUser;

  List<QueryDocumentSnapshot> listMessage = [];
  int _limit = 20;
  String groupChatId = '';

  final TextEditingController textEditingController = TextEditingController();
  final ScrollController _listScrollController = ScrollController();
  final FocusNode focusNode = FocusNode();
  bool? _isLoading;

  _createRoom() async {
    setState(() => _isLoading = true);
    await FirebaseFirestore.instance
        .collection('messages')
        .doc(groupChatId)
        .get()
        .then((val) async {
      if (!val.exists) {
        await FirebaseFirestore.instance
            .collection('messages')
            .doc(groupChatId)
            .set({
          'last_message_date': null,
          'last_message': null,
          'group_id': groupChatId,
          'group_name': 'group name',
          'people': [user!.uid, widget.peerId]
        });
      }
    });
    setState(() => _isLoading = false);
  }

  @override
  void initState() {
    _listScrollController.addListener(_scrollListener);
    if (user!.uid.hashCode <= widget.peerId.hashCode) {
      groupChatId = '${user!.uid}-${widget.peerId}';
    } else {
      groupChatId = '${widget.peerId}-${user!.uid}';
    }
    _createRoom();
    super.initState();
  }

  _scrollListener() {
    if (_listScrollController.offset >=
            _listScrollController.position.maxScrollExtent &&
        !_listScrollController.position.outOfRange &&
        _limit <= listMessage.length) {
      setState(() => _limit += 20);
    }
  }

  void onSendMessage(String content, int type) async {
    if (content.trim() != '') {
      textEditingController.clear();

      var documentReference = FirebaseFirestore.instance
          .collection('messages')
          .doc(groupChatId)
          .collection('messages')
          .doc(DateTime.now().millisecondsSinceEpoch.toString());

      await FirebaseFirestore.instance.runTransaction((transaction) async {
        transaction.set(
          documentReference,
          {
            'idFrom': user!.uid,
            'idTo': widget.peerId,
            'timestamp': DateTime.now().millisecondsSinceEpoch,
            'content': content,
            'type': type
          },
        );
      }).then((val) async {
        await FirebaseFirestore.instance
            .collection('messages')
            .doc(groupChatId)
            .update({
          'last_message_by': user!.uid,
          'last_message': content,
          'message_type': type,
          'timestamp': DateTime.now().millisecondsSinceEpoch
        });
      });
      _listScrollController.animateTo(0.0,
          duration: const Duration(milliseconds: 300), curve: Curves.easeOut);
    }
  }

  @override
  void dispose() {
    _listScrollController.dispose();
    textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.name),
        titleSpacing: 0,
      ),
      body: _isLoading == true
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Expanded(
                    child: StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection('messages')
                      .doc(groupChatId)
                      .collection('messages')
                      .orderBy('timestamp', descending: true)
                      .limit(_limit)
                      .snapshots(),
                  builder: (context,
                      AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>>
                          snapshot) {
                    if (!snapshot.hasData) {
                      return const Center(child: CircularProgressIndicator());
                    } else {
                      listMessage = snapshot.data!.docs;
                      return ListView.separated(
                        reverse: true,
                        shrinkWrap: true,
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        itemBuilder: (_, index) {
                          var data = snapshot.data!.docs[index].data();
                          return Row(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: data['idFrom'] == user!.uid
                                ? MainAxisAlignment.end
                                : MainAxisAlignment.start,
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 8, horizontal: 16),
                                decoration: BoxDecoration(
                                    color: lightColor,
                                    borderRadius: BorderRadius.circular(20)),
                                child: Text('${data['content']}'),
                              ),
                              const Text('2:30 PM',
                                  style: TextStyle(
                                      color: secondaryColor,
                                      fontSize: 12,
                                      letterSpacing: .5))
                            ],
                          );
                        },
                        itemCount: snapshot.data!.docs.length,
                        separatorBuilder: (_, index) =>
                            const SizedBox(height: 6),
                        controller: _listScrollController,
                      );
                    }
                  },
                )),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  width: double.infinity,
                  height: 60,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      roundedIconButton(Icons.image, () {}),
                      const SizedBox(width: 8),
                      Expanded(
                        child: TextField(
                          controller: textEditingController,
                          focusNode: focusNode,
                          keyboardType: TextInputType.text,
                          textCapitalization: TextCapitalization.sentences,
                          onSubmitted: (val) => onSendMessage(
                              textEditingController.text.trim(), 1),
                          decoration: InputDecoration(
                              hintText: 'Type Message',
                              isDense: true,
                              filled: true,
                              fillColor: lightColor,
                              contentPadding:
                                  const EdgeInsets.symmetric(horizontal: 16),
                              suffixIcon: GestureDetector(
                                  onTap: () => onSendMessage(
                                      textEditingController.text.trim(), 1),
                                  child: const Icon(Icons.send)),
                              border: formInputBorder(),
                              focusedBorder: formInputBorder(),
                              enabledBorder: formInputBorder(),
                              disabledBorder: formInputBorder(),
                              errorBorder: formInputBorder(),
                              focusedErrorBorder: formInputBorder()),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
    );
  }
}
