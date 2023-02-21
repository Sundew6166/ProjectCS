import 'package:flutter/material.dart';
// import 'package:thought_factory/utils/colors.dart';

class RegisterScreen extends StatefulWidget {
@override
_RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
static var _keyValidationForm = GlobalKey<FormState>();
TextEditingController _textEditConName = TextEditingController();
TextEditingController _textEditConEmail = TextEditingController();
TextEditingController _textEditConPassword = TextEditingController();
TextEditingController _textEditConConfirmPassword = TextEditingController();
bool isPasswordVisible = false;
bool isConfirmPasswordVisible = false;

@override
void initState() {
isPasswordVisible = false;
isConfirmPasswordVisible = false;
super.initState();
}

@override
Widget build(BuildContext context) {
return Scaffold(
  // backgroundColor: AppColors.colorGrey,
  body: SingleChildScrollView(
    child: Padding(
        padding: EdgeInsets.only(top: 32.0),
        child: Column(
          children: <Widget>[
            getWidgetImageLogo(),
            getWidgetRegistrationCard(),
          ],
        )),
  ),
);
}

Widget getWidgetImageLogo() {
return Container(
    alignment: Alignment.center,
    child: Padding(
      padding: const EdgeInsets.only(top: 32, bottom: 32),
      child: Icon(Icons.ac_unit),
    ));
 }

Widget getWidgetRegistrationCard() {
final FocusNode _passwordEmail = FocusNode();
final FocusNode _passwordFocus = FocusNode();
final FocusNode _passwordConfirmFocus = FocusNode();

return Padding(
  padding: const EdgeInsets.only(left: 16.0, right: 16.0),
  child: Card(
    color: Colors.white,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12.0),
    ),
    elevation: 10.0,
    child: Padding(
      padding: const EdgeInsets.all(16.0),
      child: Form(
        key: _keyValidationForm,
        child: Column(
          children: <Widget>[
            Container(
              alignment: Alignment.center,
              width: double.infinity,
              child: Text(
                'Register',
                // style: TextStyle(
                //     fontSize: 18.0, color: AppColors.colorBlack),
              ),
            ), // title: login
            Container(
              child: TextFormField(
                controller: _textEditConName,
                keyboardType: TextInputType.text,
                textInputAction: TextInputAction.next,
                // validator: _validateUserName,
                onFieldSubmitted: (String value) {
                  FocusScope.of(context).requestFocus(_passwordEmail);
                },
                decoration: InputDecoration(
                    labelText: 'Full name',
                    //prefixIcon: Icon(Icons.email),
                    icon: Icon(Icons.perm_identity)),
              ),
            ), //text field : user name
            Container(
              child: TextFormField(
                controller: _textEditConEmail,
                focusNode: _passwordEmail,
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.next,
                // validator: _validateEmail,
                onFieldSubmitted: (String value) {
                  FocusScope.of(context).requestFocus(_passwordFocus);
                },
                decoration: InputDecoration(
                    labelText: 'Email',
                    //prefixIcon: Icon(Icons.email),
                    icon: Icon(Icons.email)),
              ),
            ), //text field: email
            Container(
              child: TextFormField(
                controller: _textEditConPassword,
                focusNode: _passwordFocus,
                keyboardType: TextInputType.text,
                textInputAction: TextInputAction.next,
                // validator: _validatePassword,
                onFieldSubmitted: (String value) {
                  FocusScope.of(context)
                      .requestFocus(_passwordConfirmFocus);
                },
                obscureText: !isPasswordVisible,
                decoration: InputDecoration(
                    labelText: 'Password',
                    suffixIcon: IconButton(
                      icon: Icon(isPasswordVisible
                          ? Icons.visibility
                          : Icons.visibility_off),
                      onPressed: () {
                        setState(() {
                          isPasswordVisible = !isPasswordVisible;
                        });
                      },
                    ),
                    icon: Icon(Icons.vpn_key)),
              ),
            ), //text field: password
            Container(
              child: TextFormField(
                  controller: _textEditConConfirmPassword,
                  focusNode: _passwordConfirmFocus,
                  keyboardType: TextInputType.text,
                  textInputAction: TextInputAction.done,
                  // validator: _validateConfirmPassword,
                  obscureText: !isConfirmPasswordVisible,
                  decoration: InputDecoration(
                      labelText: 'Confirm Password',
                      suffixIcon: IconButton(
                        icon: Icon(isConfirmPasswordVisible
                            ? Icons.visibility
                            : Icons.visibility_off),
                        onPressed: () {
                          setState(() {
                            isConfirmPasswordVisible =
                                !isConfirmPasswordVisible;
                          });
                        },
                      ),
                      icon: Icon(Icons.vpn_key))),
            ),
            Container(
              margin: EdgeInsets.only(top: 32.0),
              width: double.infinity,
              // child: RaisedButton(
              //   color: AppColors.colorAccent,
              //   textColor: Colors.white,
              //   elevation: 5.0,
              //   padding: EdgeInsets.only(top: 16.0, bottom: 16.0),
              //   child: Text(
              //     'Register',
              //     style: TextStyle(fontSize: 16.0),
              //   ),
              //   onPressed: () {
              //     if (_keyValidationForm.currentState.validate()) {
              //       _onTappedButtonRegister();
              //     }
              //   },
              //   shape: RoundedRectangleBorder(
              //       borderRadius: BorderRadius.circular(25.0)),
              // ),
            ), //button: login
            Container(
                margin: EdgeInsets.only(top: 16.0, bottom: 16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      'Already Register? ',
                    ),
                    InkWell(
                      // splashColor: AppColors.colorAccent.withOpacity(0.5),
                      onTap: () {
                        _onTappedTextlogin();
                      },
                      child: Text(
                        ' Login',
                        style: TextStyle(
                            // color: AppColors.colorAccent,
                            fontWeight: FontWeight.bold),
                      ),
                    )
                  ],
                ))
          ],
        ),
      ),
    ),
  ),
);
}

// String _validateUserName(String value) {
// return value.trim().isEmpty ? "Name can't be empty" : null;
// }

// String _validateEmail(String value) {
// Pattern pattern =
//     r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
// RegExp regex = new RegExp(pattern);
// if (!regex.hasMatch(value)) {
//   return 'Invalid Email';
// } else {
//   return null;
// }
// }

// String _validatePassword(String value) {
// return value.length < 5 ? 'Min 5 char required' : null;
// }

// String _validateConfirmPassword(String value) {
// return value.length < 5 ? 'Min 5 char required' : null;
// }

void _onTappedButtonRegister() {}

void _onTappedTextlogin() {}
}
 