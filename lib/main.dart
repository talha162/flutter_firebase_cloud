import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:fluttertoast/fluttertoast.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MainPage());
}

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: StreamBuilder(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return FirebaseStoreAddUser();
            } else {
              return Login();
            }
          },
        ),
      ),
    );
  }
}




//
// class LoginPage extends StatelessWidget {
//   const LoginPage({Key? key}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: Login()
//     );
//   }
// }

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final name_controller = TextEditingController();
  final email_controller = TextEditingController();
  final password_controller = TextEditingController();

  Future<void> signin(email, password) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        print('Wrong password provided for that user.');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      SizedBox(height: 50),
      Text("Login",
          style: TextStyle(
              color: Colors.blue, fontSize: 30, fontWeight: FontWeight.bold)),
      SizedBox(height: 20),
      Padding(
        padding: EdgeInsets.symmetric(horizontal: 10),
        child: TextFormField(
            controller: email_controller,
            decoration: InputDecoration(
              hintText: "Enter email",
            )),
      ),
      Padding(
        padding: EdgeInsets.symmetric(horizontal: 10),
        child: TextFormField(
            controller: password_controller,
            decoration: InputDecoration(
              hintText: "Enter password",
            )),
      ),
      SizedBox(height: 40),
      ElevatedButton(
          onPressed: () async {
            signin(email_controller.text, password_controller.text);
          },
          child: Text("Login")),
      SizedBox(height: 0),
      TextButton(
          onPressed: () {
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => Signup()));
          },
          child: Text("Sign up"))
    ]);
  }
}

class SignupPage extends StatelessWidget {
  const SignupPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Signup(),
    );
  }
}

class Signup extends StatefulWidget {
  const Signup({Key? key}) : super(key: key);

  @override
  State<Signup> createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  final name_controller = TextEditingController();
  final email_controller = TextEditingController();
  final password_controller = TextEditingController();

  Future<void> signup(email, password) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
      FirebaseAuth.instance.signOut();
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Signup")),
      body: Column(children: [
        SizedBox(height: 50),
        Text("Signup",
            style: TextStyle(
                color: Colors.blue, fontSize: 30, fontWeight: FontWeight.bold)),
        SizedBox(height: 20),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 10),
          child: TextFormField(
              controller: name_controller,
              decoration: InputDecoration(
                hintText: "Enter name",
              )),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 10),
          child: TextFormField(
              controller: email_controller,
              decoration: InputDecoration(
                hintText: "Enter email",
              )),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 10),
          child: TextFormField(
              controller: password_controller,
              decoration: InputDecoration(
                hintText: "Enter password",
              )),
        ),
        SizedBox(height: 40),
        ElevatedButton(
            onPressed: () async {
              signup(email_controller.text, password_controller.text);
            },
            child: Text("Signup")),
        SizedBox(height: 0),
        TextButton(
            onPressed: () {
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => MainPage()));
            },
            child: Text("Login"))
      ]),
    );
  }
}

final CollectionReference _users =
    FirebaseFirestore.instance.collection('users');

class AddUserPage extends StatelessWidget {
  const AddUserPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: FirebaseStoreAddUser(),
    );
  }
}

class DeleteUserPage extends StatelessWidget {
  const DeleteUserPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: FirebaseStoreDeleteUser(),
    );
  }
}

class UpdateUserPage extends StatelessWidget {
  const UpdateUserPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: FirebaseStoreUpdateUser(),
    );
  }
}

class SearchUserPage extends StatelessWidget {
  const SearchUserPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: FirebaseStoreSearchUser(),
    );
  }
}

class FirebaseStoreAddUser extends StatefulWidget {
  FirebaseStoreAddUser({Key? key}) : super(key: key);

  @override
  State<FirebaseStoreAddUser> createState() => _FirebaseStoreAddUserState();
}

class _FirebaseStoreAddUserState extends State<FirebaseStoreAddUser> {
  final _namecontroller = TextEditingController();
  final _emailcontroller = TextEditingController();
  final _passwordcontroller = TextEditingController();

  /*

  await _users.update({"email":email,"name":name,"password":password});

  */
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(children: [
        SizedBox(height: 60,),
        Container(
            padding: EdgeInsets.symmetric(vertical: 1.0, horizontal: 16.0),
            child: TextFormField(
                controller: _namecontroller,
                decoration: InputDecoration(
                  hintText: "Enter Name",
                ))),
        Container(
            padding: EdgeInsets.symmetric(vertical: 1.0, horizontal: 16.0),
            child: TextFormField(
              controller: _emailcontroller,
              decoration: InputDecoration(hintText: "Enter Email"),
            )),
        Container(
            padding: EdgeInsets.symmetric(vertical: 1.0, horizontal: 16.0),
            child: TextFormField(
              controller: _passwordcontroller,
              obscureText: true,
              decoration: InputDecoration(hintText: "Enter Password"),
            )),
        SizedBox(
          height: 10,
        ),
        ElevatedButton(
            onPressed: () async {
              final name = _namecontroller.text;
              final email = _emailcontroller.text;
              final password = _passwordcontroller.text;
              await _users.add({
                "email": email,
                "name": name,
                "password": password
              }).then((value) {
                _namecontroller.text = "";
                _emailcontroller.text = "";
                _passwordcontroller.text = "";
                Fluttertoast.showToast(
                    msg: "Added",
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.CENTER,
                    timeInSecForIosWeb: 1,
                    backgroundColor: Colors.red,
                    textColor: Colors.white,
                    fontSize: 16.0);
              });
            },
            child: Text("Add User")),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ElevatedButton(
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => AddUserPage()));
                },
                child: Text("Add")),
            ElevatedButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => SearchUserPage()));
                },
                child: Text("Search")),
            ElevatedButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => UpdateUserPage()));
                },
                child: Text("Update")),
            ElevatedButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => DeleteUserPage()));
                },
                child: Text("Delete")),
          ],
        ),
        ElevatedButton(
            onPressed: () {
              FirebaseAuth.instance.signOut();
            },
            child: Text("Logout")),
        StreamBuilder(
          stream: _users.snapshots() //build connection
          ,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return ListView.builder(
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (context, index) {
                  final DocumentSnapshot documentsnapshot =
                      snapshot.data!.docs[index];
                  return Card(
                    child: ListTile(
                      title: Text(documentsnapshot['name']),
                      subtitle: Text(documentsnapshot['email']),
                    ),
                  );
                },
              );
            }
            return const Center(
              child: CircularProgressIndicator(),
            );
          },
        )
      ]),
    );
  }
}

class FirebaseStoreDeleteUser extends StatefulWidget {
  const FirebaseStoreDeleteUser({Key? key}) : super(key: key);

  @override
  State<FirebaseStoreDeleteUser> createState() =>
      _FirebaseStoreDeleteUserState();
}

class _FirebaseStoreDeleteUserState extends State<FirebaseStoreDeleteUser> {
  final _email_controller = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(children: [
        Container(
            padding: EdgeInsets.symmetric(vertical: 1.0, horizontal: 12.0),
            child: TextFormField(
              controller: _email_controller,
              decoration: InputDecoration(hintText: "Enter Email"),
            )),
        SizedBox(
          height: 10,
        ),
        Container(
          child: ElevatedButton(
              onPressed: () async {
                final email = _email_controller.text;
                var collection = FirebaseFirestore.instance.collection('users');
                var snapshot =
                    await collection.where('email', isEqualTo: email).get();
                for (var doc in snapshot.docs) {
                  await doc.reference.delete().then((value) {
                    Fluttertoast.showToast(
                        msg: "Deleted",
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.CENTER,
                        timeInSecForIosWeb: 1,
                        backgroundColor: Colors.red,
                        textColor: Colors.white,
                        fontSize: 16.0);
                  });
                }
              },
              child: Text("Delete User")),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ElevatedButton(
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => AddUserPage()));
                },
                child: Text("Add")),
            ElevatedButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => SearchUserPage()));
                },
                child: Text("Search")),
            ElevatedButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => UpdateUserPage()));
                },
                child: Text("Update")),
            ElevatedButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => DeleteUserPage()));
                },
                child: Text("Delete")),
          ],
        ),
        StreamBuilder(
          stream: _users.snapshots() //build connection
          ,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return ListView.builder(
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (context, index) {
                  final DocumentSnapshot documentsnapshot =
                      snapshot.data!.docs[index];
                  return Card(
                    child: ListTile(
                      title: Text(documentsnapshot['name']),
                      subtitle: Text(documentsnapshot['email']),
                    ),
                  );
                },
              );
            }
            return const Center(
              child: CircularProgressIndicator(),
            );
          },
        )
      ]),
      appBar: AppBar(title: Text("Delete Users")),
    );
  }
}

class FirebaseStoreSearchUser extends StatefulWidget {
  const FirebaseStoreSearchUser({Key? key}) : super(key: key);

  @override
  State<FirebaseStoreSearchUser> createState() =>
      _FirebaseStoreSearchUserState();
}

class _FirebaseStoreSearchUserState extends State<FirebaseStoreSearchUser> {
  @override
  void initState() {
    super.initState();
  }

  List searchResult = [];

  void searchResultFromFirebase(query) async {
    final result = await _users.where('email', isEqualTo: query).get();
    searchResult = result.docs.map((e) => e.data()).toList();
  }

  var email_controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(children: [
        Container(
            padding: EdgeInsets.symmetric(vertical: 1.0, horizontal: 16.0),
            child: TextFormField(
              controller: email_controller,
              decoration: InputDecoration(hintText: "Enter Email"),
              onChanged: (value) {
                setState(() {
                  searchResultFromFirebase(value);
                });
              },
            )),
        Expanded(
            child: ListView.builder(
          itemCount: searchResult.length,
          itemBuilder: (context, index) {
            return ListTile(
              title: Text(searchResult[index]['email']),
              subtitle: Text(searchResult[index]['name']),
            );
          },
        )),
        SizedBox(
          height: 10,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ElevatedButton(
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => AddUserPage()));
                },
                child: Text("Add")),
            ElevatedButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => SearchUserPage()));
                },
                child: Text("Search")),
            ElevatedButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => UpdateUserPage()));
                },
                child: Text("Update")),
            ElevatedButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => DeleteUserPage()));
                },
                child: Text("Delete")),
          ],
        ),
      ]),
      appBar: AppBar(title: Text("Search Users")),
    );
  }
}

class FirebaseStoreUpdateUser extends StatefulWidget {
  const FirebaseStoreUpdateUser({Key? key}) : super(key: key);

  @override
  State<FirebaseStoreUpdateUser> createState() =>
      _FirebaseStoreUpdateUserState();
}

class _FirebaseStoreUpdateUserState extends State<FirebaseStoreUpdateUser> {
  final _email_search_controller = TextEditingController();
  final _email_controller = TextEditingController();
  final _name_controller = TextEditingController();
  final _password_controller = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(children: [
          Container(
              padding: EdgeInsets.symmetric(vertical: 1.0, horizontal: 16.0),
              child: TextFormField(
                controller: _email_search_controller,
                decoration: InputDecoration(hintText: "Enter Email"),
                onChanged: (value) async {
                  var collection =
                      FirebaseFirestore.instance.collection('users');
                  var snapshot =
                      await collection.where('email', isEqualTo: value).get();
                  _name_controller.text = "";
                  _email_controller.text = "";
                  _password_controller.text = "";
                  for (var doc in snapshot.docs) {
                    _name_controller.text = doc['name'].toString();
                    _email_controller.text = doc['email'].toString();
                    _password_controller.text = doc['password'].toString();
                  }
                },
              )),
          Container(
              padding: EdgeInsets.symmetric(vertical: 1.0, horizontal: 16.0),
              child: TextFormField(
                  controller: _name_controller,
                  decoration: InputDecoration(
                    hintText: "Enter Name",
                  ))),
          Container(
              padding: EdgeInsets.symmetric(vertical: 1.0, horizontal: 16.0),
              child: TextFormField(
                controller: _email_controller,
                decoration: InputDecoration(hintText: "Enter Email"),
              )),
          Container(
              padding: EdgeInsets.symmetric(vertical: 1.0, horizontal: 16.0),
              child: TextFormField(
                controller: _password_controller,
                obscureText: true,
                decoration: InputDecoration(hintText: "Enter Password"),
              )),
          SizedBox(
            height: 10,
          ),
          Container(
            child: ElevatedButton(
                onPressed: () async {
                  final name = _name_controller.text;
                  final email = _email_controller.text;
                  final password = _password_controller.text;
                  var collection =
                      FirebaseFirestore.instance.collection('users');
                  await collection
                      .where('email', isEqualTo: _email_search_controller.text)
                      .get()
                      .then((QuerySnapshot snapshot) {
                    snapshot.docs.forEach((document) {
                      collection.doc(document.id).update({
                        "email": email,
                        "name": name,
                        "password": password
                      }).then((value) {
                        Fluttertoast.showToast(
                            msg: "Updated",
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.CENTER,
                            timeInSecForIosWeb: 1,
                            backgroundColor: Colors.red,
                            textColor: Colors.white,
                            fontSize: 16.0);
                        _name_controller.text = "";
                        _email_controller.text = "";
                        _password_controller.text = "";
                      });
                    });
                  });
                },
                child: Text("Update User")),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => AddUserPage()));
                  },
                  child: Text("Add")),
              ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => SearchUserPage()));
                  },
                  child: Text("Search")),
              ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => UpdateUserPage()));
                  },
                  child: Text("Update")),
              ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => DeleteUserPage()));
                  },
                  child: Text("Delete")),
            ],
          ),
          StreamBuilder(
            stream: _users.snapshots() //build connection
            ,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return ListView.builder(
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    final DocumentSnapshot documentsnapshot =
                        snapshot.data!.docs[index];
                    return Card(
                      child: ListTile(
                        title: Text(documentsnapshot['name']),
                        subtitle: Text(documentsnapshot['email']),
                      ),
                    );
                  },
                );
              }
              return const Center(
                child: CircularProgressIndicator(),
              );
            },
          )
        ]),
      ),
      appBar: AppBar(title: Text("Update Users")),
    );
  }
}
