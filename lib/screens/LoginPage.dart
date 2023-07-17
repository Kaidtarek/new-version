import 'package:flutter/material.dart';
import 'package:kafil/Services/Users.dart';
import 'package:kafil/screeen_emp/home_emp.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _obscureText = true;
  late Users u;
  late String _email, _pwd;
  final _formKey = GlobalKey<FormState>();

  Future<void> validate() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return Dialog(
            child: Container(
              padding: EdgeInsets.all(16.0),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(width: 16.0),
                  Text("انتظر ...."),
                ],
              ),
            ),
          );
        },
      );
      u = Users(_email, _pwd);
      await Future.delayed(Duration(seconds: 2));
      Navigator.of(context).pop();
      final msg = await u.login();

      if (msg != "success") {
        showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            title: const Text("Error"),
            content: Text(msg),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(ctx).pop();
                },
                child: Container(
                  color: Colors.green,
                  padding: const EdgeInsets.all(14),
                  child: const Text("OK"),
                ),
              ),
            ],
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Container(
                  height: 100,
                  width: MediaQuery.of(context).size.width,
                  child: Center(
                    child: Text(
                      "تسجيل الدخول",
                      style: TextStyle(fontSize: 48),
                    ),
                  ),
                ),
                Image.asset('assets/logo.png',height: 200,width: 200,),
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      Container(
                        padding: EdgeInsets.only(left: 20, bottom: 10),
                        width: MediaQuery.of(context).size.width * 0.8,
                        child: Text(
                          "البريد الالكتروني",
                          textAlign: TextAlign.start,
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        width: MediaQuery.of(context).size.width * 0.9,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10.0),
                          child: TextFormField(
                            onSaved: (val) {
                              _email = val.toString();
                            },
                            validator: (val) {
                              if (val!.isEmpty) {
                                return "This field can't be empty";
                              }
                              return null;
                            },
                            decoration: InputDecoration(
                              filled: true,
                              border: InputBorder.none,
                              fillColor: Color.fromARGB(125, 158, 158, 158),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 50),
                      Container(
                        padding: EdgeInsets.only(left: 20, bottom: 10),
                        width: MediaQuery.of(context).size.width * 0.8,
                        child: Text(
                          "كلمة السر",
                          textAlign: TextAlign.start,
                          style: TextStyle(fontFamily: "Poppins-Thin"),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        width: MediaQuery.of(context).size.width * 0.9,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10.0),
                          child: TextFormField(
                            obscureText: _obscureText,
                            onSaved: (val) {
                              _pwd = val.toString();
                            },
                            validator: (val) {
                              if (val!.isEmpty) {
                                return "This field can't be empty";
                              }
                              return null;
                            },
                            decoration: InputDecoration(
                              suffixIcon: GestureDetector(
                                onTap: () {
                                  setState(() {
                                    _obscureText = !_obscureText;
                                  });
                                },
                                child: Icon(
                                  _obscureText
                                      ? Icons.visibility_off
                                      : Icons.visibility,
                                ),
                              ),
                              filled: true,
                              border: InputBorder.none,
                              fillColor: Color.fromARGB(125, 158, 158, 158),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 50),
                      Container(
                        width: 150,
                        height: 50,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(90)),
                        ),
                        child: ElevatedButton(
                          style: ButtonStyle(
                            backgroundColor: MaterialStateColor.resolveWith(
                              (states) => Color(0XFFE464E4),
                            ),
                          ),
                          onPressed: () {
                            validate();
                          },
                          child: Text(
                            "الدخول",
                            style: TextStyle(fontSize: 15),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor: MaterialStateColor.resolveWith(
                          (states) => Color.fromARGB(255, 100, 228, 228),
                        ),
                      ),
                      onPressed: () {
                        Navigator.push(context, MaterialPageRoute(builder: (BuildContext context){
                          return welcom_emp();
                        }));
                      },
                      child: Text(
                        "الدخول بدون حساب",
                        style: TextStyle(fontSize: 15),
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              contentPadding: EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 4), 
                              title: Icon(
                                Icons.help,
                                size: 50,
                                color: Colors.green,
                              ),
                              content: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Center(
                                    child: Text(
                                      "تسجيل دخول بدون حساب",
                                      style: TextStyle(
                                        fontSize: 25,
                                        fontWeight: FontWeight.bold,
                                        color: Color.fromARGB(255, 51, 73, 70),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                      height:
                                          8), // تمت إضافة هذا العنصر لإضافة مساحة بين النصوص
                                  Text(
                                    "تسمح تسجيل الدخول بدون حساب للأشخاص الذين يريدون التطوع بايصال المساعدات الى عائلات اليتامى. من خلال هذه الخاصية تستطيع استعمال الخريطة للوصول الى منزل اليتيم  والاطلاع على المستودع والاتصال بزملائك فقط من خلال التطبيق",
                                    textAlign: TextAlign.right,
                                  ),
                                ],
                              ),
                              actions: [
                                ElevatedButton(
                                  child: Text("OK"),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                ),
                              ],
                            );
                          },
                        );
                      },
                      child: Text('مساعدة'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}