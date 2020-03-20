import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // for Clipboard
import 'package:http/http.dart' as http;
import 'dart:async';  // for TimeoutException
import 'dart:io'; // for SocketException

class HttpTestBody extends StatefulWidget {
  @override
  _HttpTestBodyState createState() => _HttpTestBodyState();
}

class _HttpTestBodyState extends State<HttpTestBody> {
  String _content = "(Empty)";
  Color _contentClr = Colors.grey;
  TextEditingController _txtEditingController = TextEditingController();

  Future<String> _getResponse(String url) async {
    try {
      final resp = await http.get(url);
      return resp.body;
    } on TimeoutException catch (e) {
      print('[GA-Dbg] TIMEOUT!\nException: $e');
      throw Exception('TIMEOUT!\nException: $e');
    } on SocketException catch (e) {
      print('[GA-Dbg] Socket error\nException: $e');
      throw Exception('Socket error\nException: $e');
    } catch (e, s) {
      print('[GA-Dbg] ERROR\nException: $e\nStack trace: $s');
      throw Exception('ERROR\nException: $e\nStack trace: $s');
    }
  }

  void _doTest(String url) {
    Clipboard.setData(ClipboardData(text: url));
    _getResponse(url)
        .then((body) {
          setState(() {
            _txtEditingController.text = url;
            _content = 'GET $url\nSuccess ^^\nBody:\n\n' + body;
            _contentClr = Colors.blue[700];
          });
        })
        .catchError((e) {
          setState(() {
            _txtEditingController.text = url;
            _content = 'GET $url\nError:\n\n$e';
            _contentClr = Colors.red;
          });
        });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints.expand(),
      color: Colors.deepOrange,
      child:
        Column(
          children: <Widget>[
            _txtEditingController.text.length == 0 ? Container(height: 0.0,) :
            Padding(
              padding: const EdgeInsets.only(
                left: 12.0,
                right: 12.0,
              ),
              child: Row(
                children: [
                  Expanded(
                    child:
                      TextField(
                        controller: _txtEditingController,
                        onChanged: (text) {

                          print("[GA-Dbg] textField onChanged");
                        },
                        onEditingComplete: () {
                          print("[GA-Dbg] editing completed.");
                        },
                        maxLines: null,
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.white,
                        ),
                      ),
                  ),
                  IconButton(
                    icon: Icon(Icons.refresh),
                    color: Colors.white,
                    highlightColor: Colors.limeAccent,
                    padding: const EdgeInsets.all(6.0),
                    onPressed: () {
                      _doTest(_txtEditingController.text);
                    },
                  )
                ],
              ),
            ),
            Expanded(
              child:
                Container(
                  constraints: BoxConstraints.expand(),
                  margin: const EdgeInsets.fromLTRB(12.0, 12.0, 12.0, 6.0),
                  padding: const EdgeInsets.all(12.0),
                  color: Colors.limeAccent,
                  child:
                    SingleChildScrollView(
                      child:
                        Text( _content,
                        style: TextStyle(
                          fontSize: 16,
                          color: _contentClr,
                        ),
                      ),
                    ),
                ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(12.0, 6.0, 12.0, 12.0),
              child:
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [

                    BottomBarButton(
                      title: 'http',
                      onPressed: () {
                        _doTest('http://220.128.199.129:3000/api/v1/sensor/list');
                      },
                    ),
                    BottomBarButton(
                      title: 'https',
                      onPressed: () {
                        _doTest('https://qccm.hopto.org/api/v1/sensor/list');
                      },
                    ),
                    BottomBarButton(
                      title: '👍',
                      onPressed: () {
                        _doTest('https://jsonplaceholder.typicode.com/posts/1');
                      },
                    ),

                  ],
                ),
            ),
          ],
        ),
    );
  }
}

class BottomBarButton extends StatelessWidget {
  BottomBarButton({Key key, String title, dynamic onPressed}) :
        this._title = title,
        this._onPressed_handler = onPressed,
        super(key: key);

  final String _title;
  dynamic _onPressed_handler;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8.0),
      child:
        FlatButton(
          color: Colors.blueGrey,
          highlightColor: Colors.cyan,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(6.0),
            side: BorderSide(color: Colors.blueGrey[800]),
          ),
          onPressed: _onPressed_handler,
          child: Text( _title,
            style: TextStyle(
              fontSize: 16,
              color: Colors.white,
            ),
          ),
        ),
    );
  }
}
