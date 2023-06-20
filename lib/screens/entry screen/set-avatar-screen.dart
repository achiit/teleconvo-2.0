import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:teleconvo/screens/search_screen.dart';
import 'package:teleconvo/services/navigation_management.dart';
import '../../widgets/Button_properties.dart';
import 'package:flutter_profile_picture/flutter_profile_picture.dart';

class SetAvatarScreen extends StatefulWidget {
 const SetAvatarScreen({super.key});
  static const id='set_avatar_screen';
  @override
  State<SetAvatarScreen> createState() => _SetAvatarScreenState();
}

class _SetAvatarScreenState extends State<SetAvatarScreen> {

  final _firebase =FirebaseFirestore.instance;
  File? profileImg;
  late String downloadUrl;
  bool spinner=false;
  bool imagepicked=false;

  Future imagePicker({required ImageSource source}) async {
    try {
      Navigation.remove(context);
      final image = await ImagePicker().pickImage(source: source);
      if (image == null) return;
      final temp = File(image.path);
      profileImg=temp;
      setState(() {});
    } on PlatformException catch (e) {
      print('Failed to pick image: $e');
    }
  }
  Future uploadImage()async{
    final userId=FirebaseAuth.instance.currentUser?.uid;
    print(userId);
    final path = 'user_$userId/image_files/profileImg';
    print(path);
    final ref = FirebaseStorage.instance.ref().child(path);
    final uploadTask = ref.putFile(profileImg!);
    final snapshot = await uploadTask.whenComplete(() => () {});
    downloadUrl = await snapshot.ref.getDownloadURL();
    print(downloadUrl);
  }

  void bottomSheet() {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return (Container(
            height: 150,
            color: Colors.white,
            child: Column(
              children: [
                ListTile(
                  onTap: () async {
                    await imagePicker(source: ImageSource.camera);
                  },
                  leading: const Icon(Icons.camera_alt_outlined),
                  title: const Text("Select from Camera"),

                ),
                ListTile(
                  onTap: () async {
                    await imagePicker(source: ImageSource.gallery);
                  },
                  leading: const Icon(Icons.photo_size_select_actual_outlined),
                  title: const Text("Pick from gallery"),
                )
              ],
            ),
          ));
        });
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ModalProgressHUD(
        inAsyncCall: spinner,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              GestureDetector(
                onTap: () {
                  bottomSheet();
                },
                child: CircleAvatar(
                  backgroundImage: profileImg != null
                      ? Image.file(profileImg!).image
                      : null,
                  backgroundColor: Colors.grey.shade200,
                  radius: 100,
                  child: profileImg != null
                      ? const ProfilePicture(
                    name: '',
                    role: '',
                    radius: 31,
                    fontsize: 21,
                    tooltip: true,
                    img: 'https://png.pngitem.com/pimgs/s/649-6490124_katie-notopoulos-katienotopoulos-i-write-about-tech-round.png',
                  ): const Icon(
                    Icons.person,
                    color:Colors.grey,
                    size: 40,
                  ),
                ),
              ),
              const SizedBox(
                height: 24.0,
              ),
              ButtonProperties(
                  colour: Colors.blueAccent,
                  onpressed: () async {
                    await uploadImage();
                    print(downloadUrl);
                    try {
                        final CollectionReference collectionReference = _firebase
                            .collection("users");

                        final docId=FirebaseAuth.instance.currentUser!.uid;

                        collectionReference.doc(docId)
                            .update({"profileImg": downloadUrl})
                            .whenComplete((){
                          print("Completed");
                        }).catchError((e) => print(e));
                    }catch(e){
                      print(e);
                    }
                    Navigation.intentStraightNamed(context, SearchScreen.id);
                  },
                  label: 'Upload'
              ),
              ButtonProperties(
                  colour: Colors.blueAccent,
                  onpressed: ()async {
                Navigation.intentStraightNamed(context, SearchScreen.id);
                }, label: 'Skip'
              )
            ]
          ),
        ),
      )
    );
  }
}
