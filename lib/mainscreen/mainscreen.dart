import 'dart:convert';

import 'package:chatapplicationforprojects/group/groupchatui.dart';
import 'package:chatapplicationforprojects/group/groupmemberadd.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../registration/registration.dart';
import 'card/card.dart';
import 'package:http/http.dart' as http;

class mainscreen extends StatefulWidget {
  String uid, name, email, phone, gender;
  int age;
  mainscreen(this.uid, this.name, this.email, this.phone, this.gender, this.age,
      {Key? key})
      : super(key: key);

  @override
  State<mainscreen> createState() => _mainscreenState();
}

class _mainscreenState extends State<mainscreen> {
  bool _isSearching = false;
  bool ischat = false;
  TextEditingController _searchController = TextEditingController();
int count = 0;
var s;
  String Useruid="";
  void initState(){
    fetchData();
    Useruid=widget.uid;
  }








  List<dynamic> valuesList = [];

  void fetchData() async {
    FirebaseFirestore.instance
        .collection('groupsname')
        .doc(widget.uid)
        .get()
        .then((snapshot) {
      if (snapshot.exists) {
        var data = snapshot.data() as Map<String, dynamic>;

        // Print the fetched data to understand its structure
        print('Fetched Data: $data');
        setState(() {
          valuesList = data.values.toList();
        });


        print('Fetched Data: $valuesList');


      }
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.blue,
        centerTitle: true,
        title: _isSearching
            ? Container(
                padding: EdgeInsets.symmetric(horizontal: 8.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(25.0), // Rounded corners
                  color: Colors.white, // Background color of the search bar
                ),
                child: TextField(
                  controller: _searchController,
                  autofocus: true,
                  decoration: InputDecoration(
                    hintText: 'Search...',
                    hintStyle: TextStyle(color: Colors.blueGrey),
                    border: InputBorder.none, // Removes the default border
                    prefixIcon: Icon(
                      Icons.search,
                      color: Colors.blue,
                    ),
                    contentPadding: EdgeInsets.symmetric(vertical: 15.0),
                  ),
                ),
              )
            : const Text(
                'ConnectChat',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
        actions: [
          IconButton(
            icon: Icon(
              _isSearching ? Icons.cancel : Icons.search,
              color: Colors.white,
            ),
            onPressed: () {
              setState(() {
                if (_isSearching) {
                  _isSearching = false;
                  _searchController.clear();
                } else {
                  _isSearching = true;
                }
              });
            },
          ),
          PopupMenuButton(
            itemBuilder: (context) => [
              PopupMenuItem(
                child: TextButton(onPressed: (){
                  }, child: const Text('Profile')),
              ),
              PopupMenuItem(
                child: TextButton(onPressed: (){
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => RegistrationPage()),
                        (route) => false,  // Removes all previous routes
                  );

                }, child: const Text('Sign Out')),
              ),
            ],
            icon: const Icon(
              Icons.more_vert,
              color: Colors.white,
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => groupmemberadd( Useruid: Useruid,)));
        },
        child: Icon(Icons.add_circle),
      ),
      body: ischat ?
      WillPopScope(
        onWillPop: () async => false,
        child: valuesList.isEmpty
            ? Center(child: Text('No group has been created'))
            : ListView.builder(
            itemCount: valuesList.length,
            itemBuilder: (context, index){
              return InkWell(
                onTap: (){
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => groupchatui(name: valuesList[index], uid: widget.uid,)),
                  );
                },
                child: Card(
                  margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),

                  child: ListTile(
                    leading: CircleAvatar(
                        backgroundColor: Colors.white,
                        child: Icon(
                          CupertinoIcons.group_solid,
                          color: Colors.blue,)),
                    title: Text(valuesList[index]),
                  ),
                ),
              );
            }
        ),
      ) : WillPopScope(
        onWillPop: () async => false,
        child: StreamBuilder<QuerySnapshot>(
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
                    var name= Useruid==user['uid'] ? "My self" : user['name'];

                    return card(Useruid,user['uid'],name,user['gmail'],user['phonenumber']);
                  });
            }),
      ),
      bottomNavigationBar: Container(color: Colors.blue,height: 100,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            IconButton(onPressed: (){

              setState(() {
                ischat = false;
              });

            }, icon: Icon(CupertinoIcons.chat_bubble_text_fill,color: Colors.white,size: 40,)),
            IconButton(onPressed: (){
              setState(() {
                ischat= true;
              });
            }, icon: Icon(Icons.group,color: Colors.white,size: 40,)),


          ],
        ),
      ),
    );
  }
}
