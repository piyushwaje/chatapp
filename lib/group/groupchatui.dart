import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class groupchatui extends StatefulWidget {
  final String name;
  final String uid;
  const groupchatui({super.key, required this.name, required this.uid});

  @override
  State<groupchatui> createState() => _groupchatuiState();
}

class _groupchatuiState extends State<groupchatui> {
  final DatabaseReference _databaseload = FirebaseDatabase.instance.ref();
  final FocusNode _focusNode = FocusNode();
  late int length1 = 0;
  TextEditingController _messageController = TextEditingController();
  String name = "";
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    name = widget.name;
  }

  Future<void> _Sendmsg() async {
    final DatabaseReference _database = FirebaseDatabase.instance.ref();
    try {
      final ref1 = FirebaseDatabase.instance.ref();
      final snapshot1 = await ref1.child('group to group chat/$name').get();
      if (snapshot1.exists) {
        if (snapshot1.value is List) {
          length1 = (snapshot1.value as List).length;
        } else if (snapshot1.value is Map) {
          length1 = (snapshot1.value as Map).length;
        } else {
          print('Data is neither a List nor a Map');
          length1 = 0;
        }
      } else {
        String m = _messageController.text;

        _database.child('group to group chat/$name/1').set({
          widget.uid: "$m",
          'flag': true,
        });
      }
      /////////

      int le = length1;
      if (le >= 0) {
        _database.child('group to group chat/group/$le').set({
          widget.uid: _messageController.text,
          'flag': true,
          
        });
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Text(
          widget.name,
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Column(
        children: [
          Expanded(
              child: StreamBuilder<DatabaseEvent>(
                  stream: _databaseload
                      .child('group to group chat/${widget.name}')
                      .onValue,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    }

                    if (snapshot.hasError) {
                      return Center(child: Text("Error: ${snapshot.error}"));
                    }

                    if (!snapshot.hasData ||
                        snapshot.data?.snapshot.value == null) {
                      return Center(child: Text("No messages yet."));
                    }
                    Object? data = snapshot.data!.snapshot.value;
                    print("Data : ${data}");
                    List messages =
                        (data as List).where((item) => item != null).toList();
                    print(messages);
                    return ListView.builder(
                        itemCount: messages.length,
                        itemBuilder: (context, index) {
                          var entry = messages[index];

                          print("entry:$entry");
                          print(entry.runtimeType);
                          // Assuming that each entry is a Map with a 'senderUid' key and a 'message' key.
                          List<MapEntry<Object?, Object?>> entries = entry.entries.toList();
                          String senderUid = entries[1].key as String; // Replace with actual key if different
                          String message = entries[1].value as String; // Replace with actual key if different
                          bool isRead =entries[0].value as bool;
                          bool isCurrentUser = senderUid == widget.uid;
                          return Align(
                            alignment: isCurrentUser ? Alignment.centerRight : Alignment.centerLeft,
                            child: Container(
                              margin: EdgeInsets.symmetric(vertical: 5),
                              padding: EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: isCurrentUser ? Colors.blue[100] : Colors.grey[300],
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  // Message Text
                                  Text(message),
                                  // Tail Icon (sent or read status)
                                  SizedBox(width: 10), // Adds space between the message and the icon
                                  Icon(
                                    isCurrentUser ? Icons.done_all : null,
                                    color:  Colors.grey,
                                    size: 20,
                                  ),
                                ],
                              ),
                            ),
                          );
                        });
                  }))
        ],
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: TextField(
                focusNode: _focusNode,
                controller: _messageController,
                decoration: InputDecoration(
                  hintText: 'Type your message...',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  contentPadding: EdgeInsets.symmetric(horizontal: 20),
                  prefixIcon: IconButton(onPressed: (){}, icon: Icon(Icons.link_rounded)),
                  suffixIcon: IconButton(
                    onPressed: () {
                      if (_messageController.text != null) {
                        _Sendmsg();
                      }
                    },
                    icon: Icon(Icons.send_rounded, color: Colors.blue),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
