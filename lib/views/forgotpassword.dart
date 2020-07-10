import 'package:chatup/services/auth.dart';
import 'package:chatup/widgets/widget.dart';
import 'package:flutter/material.dart';


class ForgotPassword extends StatefulWidget {
  @override
  _ForgotPasswordState createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {

  final _formKey = GlobalKey<FormState>();
  final AuthMethods _auth = AuthMethods();
  String _email;
  String error = 'Invalid Email';
  bool _result = false;
  bool success = true;
  bool isVisible = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Form(
        key: _formKey,
        child: Column(
          children: <Widget>[
            SizedBox(height: 50,),
            Text('Enter your account email', style: TextStyle(fontSize: 15),),
            SizedBox(height : 10),
            TextFormField(
              decoration: InputDecoration(
                  hintText: "Email",
                  hintStyle: TextStyle(
                      color: Colors.black26
                  ),
                  focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.black26)
                  ),
                  enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.blue)
                  )
              ),
              validator: (val) => val.isEmpty ? 'Enter email' : null,
              onChanged: (val) {setState(() => _email = val);},
            ),
            SizedBox(height: 10),
            RaisedButton(
                color: Colors.amber[800],
                child: Text(
                  'Send email',
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
                onPressed: () async {
                  if(_formKey.currentState.validate()){
                    _result = await _auth.resetPass(_email);
                    setState(() {
                      success = true;
                      isVisible = true;
                    });
                    if(!_result)
                      setState(() {
                        success = false;
                      });
                  }
                }
            ),
            SizedBox(height: 12.0),
            Visibility(
              visible: isVisible,
              child: Text(
                success ?  "An email was sent" : "invalid",
                style: TextStyle(color: success ? Colors.green : Colors.red),
              ),
            ),
          ],
        ),
      ),
    );
  }
}