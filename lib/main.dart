import 'package:flutter/material.dart';
import 'package:string_encryption/string_encryption.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  TextEditingController controller = TextEditingController();
  String encryptedtext = 'Encrypted Text';
  String decreptedtext = 'Decrypted Text';
  String final_key = '';

  void encrypt() async {
    try {
      final cryptor = StringEncryption();
      final salt = await cryptor.generateSalt();
      print('salt: $salt');
      final key = await cryptor.generateKeyFromPassword(controller.text, salt!);
      print('key: $key');
      String? encrypted = await cryptor.encrypt(controller.text, key!);

      await cryptor
          .encrypt(controller.text, key)
          .then((value) => print('done'));
      setState(() {
        final_key = key;
        encryptedtext = encrypted!;
      });
    } catch (e) {
      print(e);
    }
  }

  void decrypt() async {
    try {
      final cryptor = StringEncryption();
      // final  salt = await cryptor.generateSalt();
      // String? key = await cryptor.generateKeyFromPassword(controller.text, salt!);
      //
      // await cryptor.encrypt(controller.text, key!).then((value) => print('done'));
      String? decrypted = await cryptor.decrypt(encryptedtext, final_key);
      setState(() {
        decreptedtext = decrypted!;
      });
    } on MacMismatchException catch (e) {
      print(e.message);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Flutter Encription'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              TextField(
                controller: controller,
              ),
              const SizedBox(
                height: 20,
              ),
              RaisedButton(
                color: Colors.blue,
                onPressed: () => encrypt(),
                child: const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Text('Encrypt'),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Text(encryptedtext),
              const SizedBox(
                height: 20,
              ),
              RaisedButton(
                color: Colors.blue,
                onPressed: () =>decrypt(),
                child: const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Text('Decrypt'),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Text(decreptedtext),
              const SizedBox(
                height: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
