import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class groupname extends StatefulWidget {
  final Map<String, bool> selectedUsers;
  final String realuid;
  const groupname({super.key, required this.selectedUsers, required this.realuid});

  @override
  State<groupname> createState() => _groupnameState();
}

class _groupnameState extends State<groupname> {
  final TextEditingController _nameController = TextEditingController();
  bool _isLoading = false;

  Future<void> uploadDataToFirebase(
      String groupName, List<String> uidList) async {
    setState(() {
      _isLoading = true; // Stop loading when done
    });
    for (String uid in uidList) {
      try {
        DocumentSnapshot snapshot = await FirebaseFirestore.instance
            .collection('profiles')
            .doc(uid)
            .get();
        if (snapshot.exists) {
          var profileData = snapshot.data() as Map<String, dynamic>;
          var name = profileData['name'] ?? '';
          var age = profileData['age'] ?? 0;
          var gender = profileData['gender'] ?? '';
          var phoneNumber = profileData['phoneNumber'] ?? '';
          var gmail = profileData['gmail'] ?? '';

          try{
            await FirebaseFirestore.instance.collection("groupsmember").doc("groupsmember").collection(groupName).doc(uid).set({

                "name" : name,
                "phoneNumber" : phoneNumber


            });
            await FirebaseFirestore.instance.collection("groupsname").doc(uid).set({
              groupName : groupName

            }, SetOptions(merge: true));
          }catch (e){
            print(e);
          }
        }
      } catch (e) {
        print(e);
      }
    }
    setState(() {
      _isLoading = false; // Stop loading when done
    });
    Navigator.pop(context); // Pop the current screen
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Text(
          'ConnectChat',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body:
      Center(
        child: _isLoading // Check if data is being uploaded
            ? CircularProgressIndicator() // Show loader if loading
            :Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Enter Group Name',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 20),
            Padding(
              padding: EdgeInsets.only(left: 10, right: 10),
              child: TextField(
                controller: _nameController,
                decoration: InputDecoration(
                  hintText: 'Group Name',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                String groupName = _nameController.text;
                List<String> uidList = widget.selectedUsers.keys.toList();
                uploadDataToFirebase(groupName,uidList);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue, // Blue button
                padding: EdgeInsets.symmetric(vertical: 10.0),
              ),
              child: Padding(
                padding: const EdgeInsets.only(left: 20, right: 20),
                child: Text(
                  'Create',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.white,
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
