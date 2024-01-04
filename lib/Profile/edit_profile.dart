import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:weather_app/Profile/button_editProfile.dart';
import 'package:weather_app/login/text_fill.dart';
import 'package:weather_app/models/constants.dart';
import 'package:firebase_storage/firebase_storage.dart';

class EditProfile extends StatefulWidget {
  // const EditProfile({super.key});
  // ignore: non_constant_identifier_names
  final String Name;
  // ignore: non_constant_identifier_names
  final String Phone;
  // ignore: non_constant_identifier_names
  final String Email;
  // ignore: non_constant_identifier_names
  final String Address;
  // ignore: non_constant_identifier_names
  final String ImageGet;

  const EditProfile(
      {super.key,
      // ignore: non_constant_identifier_names
      required this.Name,
      // ignore: non_constant_identifier_names
      required this.Phone,
      // ignore: non_constant_identifier_names
      required this.Address,
      // ignore: non_constant_identifier_names
      required this.Email,
      // ignore: non_constant_identifier_names
      required this.ImageGet});
  @override
  State<EditProfile> createState() => _SignUpState();
}

class _SignUpState extends State<EditProfile> {
  final FirebaseStorage storage = FirebaseStorage.instance;
  Uint8List? _images;
  File? imageFile;
  XFile? file;
  ImagePicker? imagePicker;
  String imageURL = '';
  String? userMail = FirebaseAuth.instance.currentUser?.email.toString();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  // ignore: non_constant_identifier_names
  String Image_get_now = "";

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    _emailController.text = widget.Email;
    _nameController.text = widget.Name;
    _phoneController.text = widget.Phone;
    _addressController.text = widget.Address;
    if (widget.ImageGet == "") {
      Image_get_now = "";
    } else {
      Image_get_now = widget.ImageGet;
    }
    super.initState();
  }

  selectImages(ImageSource source) async {
    ImagePicker imagePicker = ImagePicker();
    file = await imagePicker.pickImage(source: source);
    if (file != null) {
      return await file?.readAsBytes();
    }
  }
  void selectimages() async {
    Uint8List image = await selectImages(ImageSource.gallery);
    setState(() {
      _images = image;
    });
  }

  @override
  Widget build(BuildContext context) {
    Constants myContants = Constants();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: myContants.primaryColor,
        title: const Text("Your Profile"),
      ),
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Center(
                child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const SizedBox(height: 20),
                Stack(children: [
                  Image_get_now == ""
                      ? (_images == null
                          ? CircleAvatar(
                              backgroundColor:
                                  myContants.secondaryColor.withOpacity(0.2),
                              radius: 70,
                              backgroundImage:
                                  const AssetImage('assets/profile.png'),
                            )
                          : CircleAvatar(
                              backgroundColor:
                                  myContants.secondaryColor.withOpacity(0.2),
                              radius: 70,
                              backgroundImage: MemoryImage(_images!),
                            ))
                      : CircleAvatar(
                          backgroundColor:
                              myContants.secondaryColor.withOpacity(0.2),
                          radius: 70,
                          backgroundImage: NetworkImage(Image_get_now),
                        ),
                  Positioned(
                    bottom: -15,
                    left: 90,
                    child: IconButton(
                      onPressed: selectimages,
                      icon: const Icon(Icons.add_a_photo),
                    ),
                  )
                ]),
                const SizedBox(height: 20),
                //Name
                MyTextField(
                  controller: _nameController,
                  hintText: 'Your name',
                  obscureText: false,
                  decoration: const InputDecoration(
                    labelText: 'Name',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 10),
                // email textfield
                MyTextField(
                  controller: _emailController,
                  hintText: 'E-Mail',
                  obscureText: false,
                  decoration: const InputDecoration(
                    labelText: 'Email',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 10),
                MyTextField(
                  controller: _phoneController,
                  hintText: 'Phone',
                  obscureText: false,
                  decoration: const InputDecoration(
                    labelText: 'Phone',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 10),
                //address
                MyTextField(
                  controller: _addressController,
                  hintText: 'Address',
                  obscureText: false,
                  decoration: const InputDecoration(
                    labelText: 'Address',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 10),
                const SizedBox(height: 10),
                button_editprofile(onTap: _editprofile),
                const SizedBox(height: 30),
              ],
            )),
          ),
        ),
      ),
    );
  }

  void _editprofile() async {
    // Lấy email của người dùng hiện tại
    String userMail = FirebaseAuth.instance.currentUser!.email.toString();

    // Tạo đối tượng Map chứa các giá trị cần cập nhật
    Map<String, dynamic> updatedData = {
      "name": _nameController.text,
      "phone": _phoneController.text,
      "address": _addressController.text,
    };
    // Gọi hàm để cập nhật dữ liệu lên Firestore
    try {
      await updateUserData(userMail, updatedData);
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Cập nhật thông tin thành công!"),
          backgroundColor: Colors.green,
        ),
      );
      Navigator.of(context).pop();
      // ignore: use_build_context_synchronously
      // await Navigator.pushAndRemoveUntil(
      //   context,
      //   MaterialPageRoute(builder: (context) => const Profile()),
      //   (Route<dynamic> route) => route.settings.name != '/profile',
      // );
    } catch (error) {
      // Thông báo lỗi cập nhật nếu có
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Lỗi cập nhật thông tin: $error"),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> updateUserData(
      String userMail, Map<String, dynamic> updatedData) async {
    try {
      if (file != null) {
        String uniqueFileName =
            DateTime.now().microsecondsSinceEpoch.toString();
        // ignore: non_constant_identifier_names
        Reference ReferenceRoof = FirebaseStorage.instance.ref();
        // ignore: non_constant_identifier_names
        Reference ReferenceDirImages = ReferenceRoof.child('images');
        //
        Reference referenceToUpLoad = ReferenceDirImages.child(uniqueFileName);
        try {
          await referenceToUpLoad.putFile(File(file!.path));
          imageURL = await referenceToUpLoad.getDownloadURL();
        } catch (error) {
          if (kDebugMode) {
            print(error);
          }
        }
      }

      if (imageURL.isEmpty) {
        // ignore: use_build_context_synchronously
        // ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        //   content: Text("plesse upload an images"),
        // ));
      } else {
        QuerySnapshot querySnapshot = await FirebaseFirestore.instance
            .collection("user")
            .where("username", isEqualTo: userMail)
            .get();
        if (querySnapshot.docs.isNotEmpty) {
          DocumentSnapshot randomDoc =
              querySnapshot.docs[0]; // Cập nhật tài liệu đầu tiên
          // Cập nhật các giá trị từ controllers
          updatedData["name"] = _nameController.text;
          updatedData["phone"] = _phoneController.text;
          updatedData["address"] = _addressController.text;
          updatedData['image'] = imageURL;
          await randomDoc.reference.update(updatedData);
          // print("Đã cập nhật dữ liệu thành công!");
        } else {
          //print("Không tìm thấy tài liệu phù hợp để cập nhật.");
        }
      }
    } catch (error) {
      // print("Lỗi cập nhật dữ liệu: $error");
    }
  }
}
