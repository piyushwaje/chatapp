
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../chatui/chatui.dart';
import '../../main.dart';

class card extends StatefulWidget {
  final String uid;
  final String name;
  final  String gmail ;
  final String phone;
  final String Useruid;

  const card(this.Useruid,this.uid,this.name, this.gmail,this.phone, {super.key});

  @override
  State<card> createState() => _cardState();
}

class _cardState extends State<card> {
  late  String uid;
  late  String name;
  late  String gmail ;
  late  String phone;
  late  String Useruid;
  var count = 0;
  void initState(){
    uid=widget.uid;
    name = widget.name;
    gmail=widget.gmail;
    phone = widget.phone;
    Useruid=widget.Useruid;
    countTrueFlags(Useruid,uid);


  }
  Future<int> countTrueFlags(String userUid, String uid) async {
    final databaseRef = FirebaseDatabase.instance.ref();
    int trueCount = 0;

    try {
      // Reference to the specific path
      final snapshot = await databaseRef.child('d to d chat/$uid/$userUid').get();

      if (snapshot.exists) {
        final data = snapshot.value ;
        print("datat:$data");
        List messages = (data as List).where((item) => item != null).toList();
        print("List:$messages");
        for (var item in messages) {
          if (item is Map && item['flag'] == true) {
            trueCount++;
          }
        }

      }
    } catch (e) {
      print('Error fetching data: $e');
    }
    setState(() {
      count = trueCount;
      print('l');
    });
    return trueCount;

  }
  Future<void> resetFlagsAndCount() async {
    final databaseRef = FirebaseDatabase.instance.ref();
    try {
      // Reference to the specific path
      final snapshot = await databaseRef.child('d to d chat/$uid/$Useruid').get();

      if (snapshot.exists) {
        final data = snapshot.value;
        List messages = (data as List).where((item) => item != null).toList();

        // Loop through messages and set flag to false
        for (var item in messages) {
          if (item is Map) {
            item['flag'] = false;
            // Update the item in Firebase
            await databaseRef.child('d to d chat/$uid/$Useruid/${messages.indexOf(item)}').update({'flag': false});
          }
        }
      }
    } catch (e) {
      print('Error resetting flags: $e');
    }
    setState(() {
      count = 0;
    });
  }
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: width * .04, vertical: 4),
      elevation: 0.5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: InkWell(
        onTap: () async {
          await resetFlagsAndCount();
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => chatui(Useruid, uid, name, gmail, phone),
            ),
          ).then((_) => setState(() {}));
        },
        child: ListTile(
          leading: CircleAvatar(
              backgroundColor: Colors.white,
              child: Icon(
            CupertinoIcons.profile_circled,
            color: Colors.blue,
          )),
          title: Text(name ?? 'No Name'),
          subtitle: Text(
            count == 0 ? 'No message' : '$count message(s) pending',
            maxLines: 1,
            style: TextStyle(
              color: count == 0 ? Colors.grey : Colors.red,
              fontWeight: FontWeight.bold,
            ),
          ),
          trailing: Text(
            "12:00 PM",
            style: TextStyle(color: (Colors.black54)),
          ),
        ),
      ),
    );
  }
}
