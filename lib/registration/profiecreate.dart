
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../mainscreen/mainscreen.dart';




class ProfileForm extends StatefulWidget {
  final String uid;
  final  String gmail ;
  final String pass;

  ProfileForm(this.uid, this.gmail,this.pass, {Key? key}) : super(key: key);
  @override
  _ProfileFormState createState() => _ProfileFormState();
}

class _ProfileFormState extends State<ProfileForm> {
  final _formKey = GlobalKey<FormState>();
  String _name = '';
  int? _age;
  String _gender = '';
  String _phoneNumber = '';
  String _uid = "";
  String _gmail = '';
  String _password = '';
  void initState() {
    super.initState();
    _uid = widget.uid;
    _gmail = widget.gmail;
    _password = widget.pass;

  }
  Future<void> _submitProfileData() async {
    try {
      await FirebaseFirestore.instance.collection('profiles').doc(_uid).set({
        'name': _name,
        'age': _age,
        'gender': _gender,
        'phoneNumber': _phoneNumber,
        'gmail': _gmail,
        'password': _password
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Profile information submitted')),

      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error submitting data: $e')),
      );
    }
  }
  Future<void> _userupdate()async {
    CollectionReference user = FirebaseFirestore.instance.collection("user");
    if (_uid!= null){
      user.doc(_uid).set({
        'uid':_uid,
        'name': _name,
        'gmail': _gmail,
        'phonenumber': _phoneNumber,

      }
      );
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('user Profile information submitted')),

      );

      Navigator.push(context, MaterialPageRoute(builder: (context) => mainscreen(_uid,_name,_gmail,_phoneNumber,_gender,_age!)));
    }

  }
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blue,
          centerTitle: true,
          title: const Text(
            'ConnectChat',
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child:  Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Name',
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (value) => _name = value,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your name';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16.0),
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Age',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                  onChanged: (value) => _age = int.tryParse(value),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your age';
                    }
                    if (int.tryParse(value) == null) {
                      return 'Please enter a valid number';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16.0),
                DropdownButtonFormField<String>(
                  decoration: InputDecoration(
                    labelText: 'Gender',
                    border: OutlineInputBorder(),
                  ),
                  items: ['Male', 'Female', 'Other']
                      .map((label) => DropdownMenuItem(
                    child: Text(label),
                    value: label,
                  ))
                      .toList(),
                  onChanged: (value) => _gender = value!,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please select your gender';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16.0),
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Phone Number',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.phone,
                  onChanged: (value) => _phoneNumber = value,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your phone number';
                    }
                    if (value.length != 10) {
                      return 'Phone number must be 10 digits';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 24.0),
                Center(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        foregroundColor: Colors.white
                    ),
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        // Process the data
                        _submitProfileData();
                        _userupdate();
                      }
                    },
                    child: Text('Submit'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
