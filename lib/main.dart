import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const LoginPage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        padding: EdgeInsets.symmetric(horizontal: 8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              decoration: InputDecoration(
                  border: OutlineInputBorder(), labelText: "Username"),
            ),
            SizedBox(
              height: 10,
            ),
            TextFormField(
              decoration: InputDecoration(
                  border: OutlineInputBorder(), labelText: "Email"),
            ),
            SizedBox(
              height: 10,
            ),
            TextFormField(
              decoration: InputDecoration(
                  border: OutlineInputBorder(), labelText: "Password"),
            ),
            SizedBox(
              height: 10,
            ),
            ElevatedButton(onPressed: () {}, child: Text("Select Image")),
          ],
        ),
      ),
    );
  }
}

class SignupPage extends StatefulWidget {
  const SignupPage({Key? key}) : super(key: key);

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  Dio dio = Dio();
  XFile? image;
  TextEditingController username = TextEditingController();
  TextEditingController email = TextEditingController();

  Future signUp() async {
    print('here');
    var img = await MultipartFile.fromFile(image!.path);
    FormData formData = FormData.fromMap({"user_image": img});
    final val = await dio.post(
        "https://37cf-2405-201-f003-68f0-3775-436c-bd6-f75.in.ngrok.io/api/adduser",
        data: FormData.fromMap(
            {"user_image": await MultipartFile.fromFile(image!.path)}),
        queryParameters: {
          "password": "pass",
          "user_name": username,
          "email": email,
        });
    if (val.statusCode == 200 || val.statusCode == 201) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(val.data.toString())));
    }
  }

  Future getImage() async {
    XFile? pickedImage = await ImagePicker().pickImage(
      source: ImageSource.camera,
      maxWidth: 1800,
      maxHeight: 1800,
    );
    if (pickedImage != null) {
      setState(() {
        image = pickedImage;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
            child: Padding(
          padding: EdgeInsets.all(8),
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: username,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(), labelText: "Username"),
                ),
                TextFormField(
                  controller: email,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(), labelText: "Email"),
                ),
                SizedBox(
                  height: 10,
                ),
                image != null
                    ? const Text("Image Captured")
                    : const Text("No image"),
                SizedBox(
                  height: 10,
                ),
                ElevatedButton(
                    onPressed: () {
                      getImage();
                    },
                    child: Text("Select Image")),
                SizedBox(
                  height: 10,
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    ElevatedButton(
                        onPressed: () {
                          signUp();
                        },
                        child: Text("Add User")),
                    // ElevatedButton(onPressed: () {}, child: Text("Select Image")),
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                Center(
                    child: TextButton(
                        onPressed: () {
                          Navigator.of(context).pushReplacement(
                              MaterialPageRoute(
                                  builder: (builder) => LoginPage()));
                        },
                        child: Text('Go to Login')))
              ]),
        )),
      ),
    );
  }
}

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  Dio dio = Dio();
  XFile? image;
  TextEditingController username = TextEditingController();
  // TextEditingController email = TextEditingController();

  Future login() async {
    print('here');
    var img = await MultipartFile.fromFile(image!.path);
    FormData formData = FormData.fromMap({"user_image": img});
    final val = await dio.post(
        "https://37cf-2405-201-f003-68f0-3775-436c-bd6-f75.in.ngrok.io/api/verify",
        data: FormData.fromMap(
            {"user_image": await MultipartFile.fromFile(image!.path)}),
        queryParameters: {
          "password": "pass",
          "user_name": username,
        });
    if (val.statusCode == 200 || val.statusCode == 201) {
      showDialog(
          context: context,
          builder: (builder) => AlertDialog(
                content: Text(
                  val.data["result"].toString(),
                  style: const TextStyle(fontSize: 20),
                ),
              ));
    }
  }

  Future getImage() async {
    XFile? pickedImage = await ImagePicker().pickImage(
      source: ImageSource.camera,
      maxWidth: 1800,
      maxHeight: 1800,
      imageQuality: 30,
    );
    if (pickedImage != null) {
      setState(() {
        image = pickedImage;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
            child: Padding(
          padding: EdgeInsets.all(8),
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: username,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(), labelText: "Username"),
                ),
                // TextFormField(
                //   controller: email,
                //   decoration: InputDecoration(
                //       border: OutlineInputBorder(), labelText: "Email"),
                // ),
                SizedBox(
                  height: 10,
                ),
                image != null
                    ? const Text("Image Captured")
                    : const Text("No image"),
                SizedBox(
                  height: 10,
                ),
                ElevatedButton(
                    onPressed: () {
                      getImage();
                    },
                    child: Text("Select Image")),
                SizedBox(
                  height: 10,
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    ElevatedButton(
                        onPressed: () {
                          if (image != null) {
                            login();
                          } else {
                            showDialog(
                                context: context,
                                builder: (builder) => AlertDialog(
                                      content: Text('Please Select Image'),
                                    ));
                          }
                        },
                        child: Text("Verify")),
                    // ElevatedButton(onPressed: () {}, child: Text("Select Image")),
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                Center(
                    child: TextButton(
                        onPressed: () {
                          Navigator.of(context).pushReplacement(
                              MaterialPageRoute(
                                  builder: (builder) => SignupPage()));
                        },
                        child: Text('New user?')))
              ]),
        )),
      ),
    );
  }
}
