import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:arc_comics/core/viewmodels/addServerModel.dart';
import 'package:arc_comics/core/api/server.dart';
import 'package:arc_comics/ui/shared/globals.dart';
import 'package:arc_comics/ui/widgets/button_widget.dart';
import 'package:arc_comics/ui/widgets/textfield_widget.dart';
import 'package:arc_comics/ui/widgets/wave_widget.dart';

class AddServer extends StatefulWidget {
  final bool keyboardOpen;
  final VoidCallback callback;

  AddServer({required this.keyboardOpen, required this.callback});

  @override
  _AddServerState createState() => _AddServerState();
}

class _AddServerState extends State<AddServer> {
  final formKey = GlobalKey<FormState>();
  Server server = new Server(
    name: 'null',
    url: 'null',
    username: 'null',
    password: 'null',
    key: 'null',
  );

  @override
  Widget build(BuildContext context) {
    final model = Provider.of<AddServerModel>(context);
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Global.white,
      body: Stack(
        children: [
          AnimatedPositioned(
            duration: Duration(milliseconds: 500),
            curve: Curves.fastOutSlowIn,
            top: widget.keyboardOpen ? -size.height / 2.8 : 0.0,
            child: WaveWidget(
              size: size,
              yOffset: size.height / 2.4,
              color: Global.blue,
              height: 20.0,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 200.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Add Server',
                  style: TextStyle(
                    color: Global.white,
                    fontSize: 40.0,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(30.0),
            child: Form(
              key: formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextFieldWidget(
                    hintText: 'Server Label',
                    obscureText: false,
                    prefixIconData: Icons.book_outlined,
                    onSaved: (value) {
                      server.name = value!;
                    },
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter a server name';
                      }
                      return null;
                    },
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  TextFieldWidget(
                    hintText: 'Server Address',
                    obscureText: false,
                    prefixIconData: Icons.storage_outlined,
                    onSaved: (value) {
                      server.url = value!;
                    },
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter a url';
                      }
                      return null;
                    },
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  TextFieldWidget(
                    hintText: 'Username',
                    obscureText: false,
                    prefixIconData: Icons.mail_outline,
                    suffixIconData: model.isValid ? Icons.check : Icons.error,
                    onChanged: (value) {
                      model.isValidEmail(value!);
                    },
                    onSaved: (value) {
                      server.username = value!;
                    },
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter an email address';
                      } else if (!emailRegExp.hasMatch(value)) {
                        return 'Invalid email address!';
                      }
                      return null;
                    },
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  TextFieldWidget(
                    hintText: 'Password',
                    obscureText: model.isVisible ? false : true,
                    prefixIconData: Icons.lock_outline,
                    suffixIconData: model.isVisible
                        ? Icons.visibility
                        : Icons.visibility_off,
                    onSaved: (value) {
                      server.password = value!;
                    },
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter a password';
                      }
                      return null;
                    },
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  ButtonWidget(
                    title: 'Add Server',
                    hasBorder: false,
                    onTap: () {
                      if (formKey.currentState!.validate()) {
                        formKey.currentState!.save();

                        getAllServers().then((all) {
                          String key = all.length.toString();
                          server.key = key;
                          addServer(key: key, server: server);
                          widget.callback();
                        });
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
