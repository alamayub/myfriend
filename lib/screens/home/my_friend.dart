import 'package:flutter/material.dart';
import 'package:myfriend/screens/home/contacts.dart';
import 'package:myfriend/screens/home/home.dart';
import 'package:myfriend/screens/home/settings.dart';
import 'package:myfriend/utils/colors.dart';

import '../../models/bottom_bar.dart';

class MyFriend extends StatefulWidget {
  const MyFriend({Key? key}) : super(key: key);

  @override
  State<MyFriend> createState() => _MyFriendState();
}

class _MyFriendState extends State<MyFriend> {
  late final PageController pageController;
  final List<BootomAppBarModel> _bottomItems = [
    BootomAppBarModel(iconData: Icons.chat_outlined, text: 'Chats'),
    BootomAppBarModel(iconData: Icons.phone_outlined, text: 'Calls'),
    BootomAppBarModel(iconData: Icons.people_outline, text: 'Contacts'),
    BootomAppBarModel(iconData: Icons.settings_outlined, text: 'Settings')
  ];

  int _index = 0;

  final List<Widget> _items = [
    const HomeScreen(),
    Container(),
    const ContactsScreen(),
    const SettingsScreen()
  ];

  void _changeIndex(int i) {
    setState(() => _index = i);
    pageController.jumpToPage(i);
  }

  @override
  void initState() {
    pageController = PageController();
    super.initState();
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (_index != 0) {
          _changeIndex(0);
          return false;
        } else {
          Navigator.of(context).pop();
          return true;
        }
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: const Text('Chats',
              style: TextStyle(letterSpacing: .5, color: Colors.black)),
          backgroundColor: Colors.white,
          elevation: 0,
          actions: [
            Container(
              width: 40,
              clipBehavior: Clip.antiAlias,
              decoration: BoxDecoration(
                  color: secondaryColor,
                  borderRadius: BorderRadius.circular(8),
                  image: const DecorationImage(
                      image: NetworkImage(
                          'https://i.pinimg.com/236x/82/ab/35/82ab3533ee71daf256f23c1ccf20ad6f--avatar-maker.jpg'),
                      fit: BoxFit.cover)),
              margin: const EdgeInsets.only(right: 16, top: 8, bottom: 8),
            )
          ],
        ),
        body: PageView(
          children: _items,
          physics: const NeverScrollableScrollPhysics(),
          controller: pageController,
          onPageChanged: _changeIndex,
        ),
        bottomNavigationBar: BottomAppBar(
          elevation: 0,
          // shape: const AutomaticNotchedShape(RoundedRectangleBorder(
          //     borderRadius: BorderRadius.only(
          //         topLeft: Radius.circular(30), topRight: Radius.circular(30)))),
          child: SizedBox(
            height: 60,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: _bottomItems
                  .map((item) => GestureDetector(
                        onTap: () {
                          setState(() => _index = _bottomItems.indexOf(item));
                          _changeIndex(_index);
                        },
                        child: Container(
                          constraints: BoxConstraints(
                              minWidth:
                                  MediaQuery.of(context).size.width * .18),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(item.iconData,
                                  color: _bottomItems.indexOf(item) == _index
                                      ? primaryColor
                                      : secondaryColor,
                                  size: 20),
                              const SizedBox(height: 3),
                              Text(item.text,
                                  style: TextStyle(
                                      color:
                                          _bottomItems.indexOf(item) == _index
                                              ? primaryColor
                                              : secondaryColor,
                                      fontWeight: FontWeight.w500,
                                      letterSpacing: .5))
                            ],
                          ),
                        ),
                      ))
                  .toList(),
            ),
          ),
        ),
      ),
    );
  }
}
