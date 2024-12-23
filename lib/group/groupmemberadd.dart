import 'package:chatapplicationforprojects/group/groupname.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class groupmemberadd extends StatefulWidget {
  final String Useruid;
  const groupmemberadd({super.key, required this.Useruid});

  @override
  State<groupmemberadd> createState() => _groupmemberaddState();
}

class _groupmemberaddState extends State<groupmemberadd> {
  final Map<String, bool> selectedUsers = {};
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
      body: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance.collection("user").snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError) {
              return Center(child: Text("Error fetching data"));
            }
            if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
              return Center(child: Text("No users found"));
            }
            List<QueryDocumentSnapshot> documents = snapshot.data!.docs;

            return ListView.builder(
                itemCount: documents.length,
                physics: BouncingScrollPhysics(),
                itemBuilder: (context, index) {
                  var user = documents[index].data() as Map<String, dynamic>;
                  var uid = user['uid'];
                  var name= widget.Useruid==user['uid'] ? "My self" : user['name'];
                  return Card(
                    child: ListTile(
                      title: Text(name),
                      leading: Checkbox(value:  selectedUsers[uid] ?? false, onChanged: (bool? value){
                          setState(() {
                            if (value == true) {
                              selectedUsers[uid] = true; // Add user to selected list
                            } else {
                              selectedUsers.remove(uid); // Remove user from selected list
                            }
                            print(selectedUsers);
                          });
                      }),
                    ),
                  );
                });
          }),
      floatingActionButton: IconButton(onPressed: (){
        if(selectedUsers.isNotEmpty && selectedUsers != null && selectedUsers.length != 1){
          Navigator.push(context, MaterialPageRoute(builder: (context) => groupname(selectedUsers: selectedUsers, realuid: widget.Useruid,)));

        }
        else{

        }
      }, icon: Icon(Icons.arrow_circle_right,color: Colors.green,size: 50,)),
    );
  }
}
