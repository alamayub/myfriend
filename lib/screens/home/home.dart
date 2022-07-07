import 'package:flutter/material.dart';
import 'package:myfriend/screens/home/profile.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _search = TextEditingController();
  final ScrollController _listScrollController = ScrollController();
  int _limit = 20;

  void scrollListener() {
    if (_listScrollController.offset >=
            _listScrollController.position.maxScrollExtent &&
        !_listScrollController.position.outOfRange) {
      setState(() => _limit += 20);
    }
  }

  @override
  void initState() {
    _listScrollController.addListener(scrollListener);
    super.initState();
  }

  @override
  void dispose() {
    _search.dispose();
    _listScrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      itemBuilder: (_, index) => ListTile(
        leading: const CircleAvatar(
          radius: 30,
        ),
        title: const Text('John Doe'),
        subtitle: const Text(
          'Last message will be pop here and will haunt you for the rest of ypour life...',
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        onTap: () => Navigator.push(context,
            MaterialPageRoute(builder: (context) => const ProfileScreen())),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: const [
            Text(
              '02:30PM',
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
            Icon(
              Icons.check_circle,
              color: Colors.green,
              size: 14,
            )
          ],
        ),
      ),
      itemCount: 15,
      controller: _listScrollController,
    );
    // User? user = FirebaseAuth.instance.currentUser;
    // return ListView(
    //   shrinkWrap: true,
    //   children: [
    //     Padding(
    //       padding: const EdgeInsets.symmetric(horizontal: 16),
    //       child: FormInput(
    //           controller: _search,
    //           textInputType: TextInputType.text,
    //           hint: 'Search...',
    //           prefixIcon: const Icon(Icons.search_outlined)),
    //     ),
    //     const SizedBox(height: 16),
    //     StreamBuilder(
    //         stream: DatabaseService().charUsersList(_limit, user!.uid),
    //         builder: (_, AsyncSnapshot<List<ChatUserListModel>> snapshot) {
    //           if (snapshot.hasData) {
    //             print('here');
    //             List<ChatUserListModel> _list = snapshot.data!;
    //             if (_list.isNotEmpty) {
    //               return ListView.builder(
    //                 shrinkWrap: true,
    //                 physics: const NeverScrollableScrollPhysics(),
    //                 itemBuilder: (_, index) => Text(_list[index].lastMessage),
    //                 itemCount: _list.length,
    //                 controller: _listScrollController,
    //               );
    //             } else {
    //               return const Center(child: Text("No users"));
    //             }
    //           }
    //           return const Center(child: CircularProgressIndicator());
    //         })
    //   ],
    // );
  }
}



// SizedBox(
        //   height: 85,
        //   child: ListView.separated(
        //       shrinkWrap: true,
        //       scrollDirection: Axis.horizontal,
        //       padding: const EdgeInsets.symmetric(horizontal: 16),
        //       itemCount: 10,
        //       separatorBuilder: (_, i) => const SizedBox(width: 16),
        //       itemBuilder: (_, index) => Column(
        //             children: const [
        //               CircleAvatar(
        //                   radius: 34,
        //                   backgroundColor: secondaryColor,
        //                   backgroundImage: NetworkImage(
        //                       'https://mymodernmet.com/wp/wp-content/uploads/archive/zvY94dFUiqKwu1PMVsw5_thatnordicguyredo.jpg')),
        //               SizedBox(height: 4),
        //               Text('Taylor',
        //                   style: TextStyle(fontWeight: FontWeight.w500))
        //             ],
        //           )),
        // ),
        // const SizedBox(height: 10),
        // const Padding(
        //   padding: EdgeInsets.symmetric(horizontal: 16),
        //   child: Divider(),
        // ),