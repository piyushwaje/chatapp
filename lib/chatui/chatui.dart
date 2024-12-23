
import 'package:firebase_database/firebase_database.dart';


import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class chatui extends StatefulWidget {
  final String Useruid;
  final String uid;
  final String name;
  final String gmail;
  final String phone;
  const chatui(this.Useruid, this.uid, this.name, this.gmail, this.phone,
      {super.key});

  @override
  State<chatui> createState() => _chatuiState();
}

class _chatuiState extends State<chatui> {
  final FocusNode _focusNode = FocusNode();
  late String uid;
  late String name;
  late String gmail;
  late String phone;
  late String Useruid;
  late int length1 =0;
  late int length2 = 0;
  late int count  = 0;
  bool isCurrentUser = false;

  TextEditingController _messageController = TextEditingController();
  final DatabaseReference _databaseload = FirebaseDatabase.instance.ref();
  @override
  void initState() {
    uid = widget.uid;
    name = widget.name;
    gmail = widget.gmail;
    phone = widget.phone;
    Useruid = widget.Useruid;
    super.initState();
    // Request focus when the widget is first built


    WidgetsBinding.instance.addPostFrameCallback((_) {
      FocusScope.of(context).requestFocus(_focusNode);
    });
  }

  final ScrollController _scrollController = ScrollController();

  // void _scrollDown() {
  //   _scrollController.animateTo(
  //     _scrollController.position.maxScrollExtent, // Scroll to the bottom
  //     duration: Duration(seconds: 1), // Animation duration
  //     curve: Curves.easeInOut, // Animation curve
  //   );
  // }

  @override
  void dispose() {
    // Dispose the FocusNode when the widget is disposed
    _focusNode.dispose();
    super.dispose();
  }

  Future<void> _Sendmsg() async {
    final DatabaseReference _database = FirebaseDatabase.instance.ref();


    try {

      final ref1 = FirebaseDatabase.instance.ref();

      final snapshot1 = await ref1.child('d to d chat/$Useruid/$uid').get();

      final ref2 = FirebaseDatabase.instance.ref();
      final snapshot2 = await ref2.child('d to d chat/$uid/$Useruid').get();
      if (snapshot1.exists) {
        if (snapshot1.value is List) {
          length1 = (snapshot1.value as List).length;

        } else if (snapshot1.value is Map) {
          length1 = (snapshot1.value as Map).length;


        } else {
          print('Data is neither a List nor a Map');
          length1 = 0;
        }

      }else {

        print(_messageController.text);
        String m = _messageController.text;


        _database.child('d to d chat/$Useruid/$uid/1').set({
          '$Useruid':"$m",
          'flag': true,
          'status': ''
        });


        print('No data available.');
      }
      if (snapshot2.exists) {
        if (snapshot2.value is List) {
          length2 = (snapshot2.value as List).length;
          print(length2);
        } else if (snapshot2.value is Map) {
          length2 = (snapshot2.value as Map).length;
          print(length2);
        } else {
          print('Data is neither a List nor a Map');
          length2 = 0;
        }
        print(length2);
      }else {
        String m = _messageController.text;
        _database.child('d to d chat/$uid/$Useruid/1').set({
          '$Useruid':"$m",
          'flag': false,
        });
        print('No data available.');
      }
    } catch (e) {
      print(e);
    }

  ////first time
  //   if(length1==0){
  //     _database.child('d to d chat/$Useruid/$uid').set({
  //       'Count': 0,
  //       'flag': false,
  //     });
  //
  //     _database.child('d to d chat/$uid/$Useruid').set({
  //       'Count': 0,
  //       'flag': false,
  //     });
  //   }
    ////// send this msg
    int le= length1 ;
    if(le>=0){
      _database.child('d to d chat/$Useruid/$uid/$le').set({
        '$Useruid':_messageController.text,
        'flag': true,
      });


      _database.child('d to d chat/$uid/$Useruid/$le').set({
        '$Useruid':_messageController.text,
        'flag': false,
      });

    }


  }


  Future<void> _makePhoneCall(String phoneNumber) async {
    final Uri phoneUri = Uri(scheme: 'tel', path: phoneNumber);
    if (await canLaunchUrl(phoneUri)) {
      await launchUrl(phoneUri);
    } else {
      throw 'Could not launch $phoneNumber';
    }
  }



  // Future<void> uploadFile() async {
  //   try {
  //     // Pick a file (PDF or image)
  //     FilePickerResult? result = await FilePicker.platform.pickFiles(
  //       type: FileType.custom,
  //       allowedExtensions: ['pdf', 'jpg', 'jpeg', 'png'],
  //     );
  //
  //     if (result != null) {
  //       File file = File(result.files.single.path!);
  //       String fileName = result.files.single.name;
  //
  //       // Get a reference to Firebase Storage
  //       final storageRef = FirebaseStorage.instance.ref();
  //
  //       // Create a reference for the file
  //       final fileRef = storageRef.child('uploads/$fileName');
  //
  //       // Upload the file
  //       UploadTask uploadTask = fileRef.putFile(file);
  //
  //       // Wait for the upload to complete
  //       TaskSnapshot snapshot = await uploadTask;
  //
  //       // Get the file URL
  //       String downloadUrl = await snapshot.ref.getDownloadURL();
  //       print('File uploaded successfully. URL: $downloadUrl');
  //     } else {
  //       print('No file selected.');
  //     }
  //   } catch (e) {
  //     print('Error uploading file: $e');
  //   }
  // }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Text(
          name,
          style: TextStyle(color: Colors.white),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.call),
            onPressed: () {
              // Handle call action

              _makePhoneCall(phone);
            },
          ),

        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<DatabaseEvent>(
              stream: _databaseload.child('d to d chat/${widget.Useruid}/${widget.uid}').onValue,
                builder: (context, snapshot){
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  }

                  if (snapshot.hasError) {
                    return Center(child: Text("Error: ${snapshot.error}"));
                  }

                  if (!snapshot.hasData || snapshot.data?.snapshot.value == null) {
                    return Center(child: Text("No messages yet."));
                  }
                  Object? data = snapshot.data!.snapshot.value;
                  print("Data : ${data}");
                  List messages = (data as List).where((item) => item != null).toList();

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
                      bool isCurrentUser = senderUid == widget.Useruid;

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
                    },
                  );

                  // return Center();
                }
            )



            // child: ListView(
            //   padding: EdgeInsets.all(8.0),
            //   children: [
            //     Align(
            //       alignment: Alignment.centerLeft,
            //       child: Container(
            //         margin: EdgeInsets.symmetric(vertical: 5),
            //         padding: EdgeInsets.all(10),
            //         decoration: BoxDecoration(
            //           color: Colors.grey[300],
            //           borderRadius: BorderRadius.circular(10),
            //         ),
            //         child: Text('Hello! How are you?'),
            //       ),
            //     ),
            //     Align(
            //       alignment: Alignment.centerRight,
            //       child: Container(
            //         margin: EdgeInsets.symmetric(vertical: 5),
            //         padding: EdgeInsets.all(10),
            //         decoration: BoxDecoration(
            //           color: Colors.blue[100],
            //           borderRadius: BorderRadius.circular(10),
            //         ),
            //         child: Text('I am good, thank you!'),
            //       ),
            //     ),
            //   ],
            // ),
          ),
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
                  prefixIcon: IconButton(onPressed: () async {

                  }, icon: Icon(Icons.link_rounded)),
                  suffixIcon: IconButton(
                    onPressed: () {
                      if(_messageController.text!=null){
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
