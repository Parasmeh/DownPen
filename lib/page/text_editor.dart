import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart' hide Text;

import 'package:shared_preferences/shared_preferences.dart';

class TextEditor extends StatefulWidget {
  static String id = '/text_editor';

  String text;
  int index;
  bool isSaved;
  TextEditor({@required this.text, this.index, this.isSaved = false});
  @override
  _TextWidgetState createState() => _TextWidgetState();
}

class _TextWidgetState extends State<TextEditor> {
  QuillController _controller = QuillController.basic();
  var savedList = [];
  void getSavedData(String convertedTextJson) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    // String data = prefs.getString('saved_data') ?? '';
    // List list = json.decode(data).toList();
    savedList.add(convertedTextJson);
    await prefs.setString('saved_data', json.encode(savedList));
    print(savedList);
  }

  void getSaved() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String data = prefs.getString('saved_data') ?? '';
    if (data != '' && data != null) {
      savedList = json.decode(data).toList();
    } else {
      print("null returned");
    }

    initializeScreenWithScannedText();
    setState(() {});
  }

  void initializeScreenWithScannedText() {
    if (!widget.isSaved) {
      _controller = QuillController(
          document: Document.fromJson([
            {"insert": "${widget.text}\n"}
          ]),
          selection: TextSelection.collapsed(offset: 0));
    } else {
      _controller = QuillController(
          document: Document.fromJson(jsonDecode(savedList[widget.index])),
          selection: TextSelection.collapsed(offset: 0));
    }
  }

  //
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print(widget.text);
    // initializeScreenWithScannedText();
    getSaved();
  }

  @override
  Widget build(BuildContext context) {
    // setState(() {
    //   widget.text = ModalRoute.of(context)!.settings.arguments as String;
    // });
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.black,
          title: Text.rich(
            TextSpan(
              children: [
                TextSpan(
                  text: 'Down',
                  style: TextStyle(
                    fontSize: 25.0,
                    color: Colors.blueAccent,
                  ),
                ),
                TextSpan(
                  text: 'Pen',
                  style: TextStyle(
                    fontSize: 25.0,
                    color: Colors.redAccent,
                  ),
                ),
              ],
            ),
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 15.0),
              child: GestureDetector(
                onTap: () async {
                  // if (Platform.isIOS ||
                  //     Platform.isAndroid ||
                  //     Platform.isMacOS) {
                  //   bool status = await Permission.storage.isGranted;
                  //
                  //   if (!status) await Permission.storage.request();
                  // }
                  // // final List<int> codeUnits =
                  // //     _controller.document.toPlainText().codeUnits;
                  // // final Uint8List bytes = Uint8List.fromList(codeUnits);
                  // // String path = await FileSaver.instance
                  // //     .saveAs('your_ocr', bytes, 'docx', MimeType.OTHER);
                  // // print(_controller.document.toDelta().toString());
                  // // print(_controller.document.toPlainText());
                  // print(jsonEncode(_controller.document.toDelta().toJson()));
                  // // // print(bytes);
                  // // print('Tapped');
                  // var encoded = base64.encode(utf8.encode(_controller.document
                  //     .toDelta()
                  //     .toString())); // dXNlcm5hbWU6cGFzc3dvcmQ=
                  // String decoded = utf8.decode(base64.decode(encoded));
                  // print(encoded);
                  // print(decoded);
                  var json =
                      jsonEncode(_controller.document.toDelta().toJson());
                  print(json);
                  setState(() {
                    getSavedData(json);
                  });
                  print("Document Saved Successfully\n");
                  Navigator.pop(context);
                },
                child: Icon(
                  Icons.arrow_right_alt,
                  size: 30.0,
                ),
              ),
            ),
          ],
        ),
        body: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(top: 18.0),
              child: QuillToolbar.basic(controller: _controller),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  decoration: BoxDecoration(boxShadow: [
                    BoxShadow(
                      color: Colors.lightBlueAccent,
                      offset: const Offset(5.0, 5.0),
                      blurRadius: 10.0,
                      spreadRadius: 2.0,
                    ),
                    BoxShadow(
                      color: Colors.white,
                      offset: const Offset(5.0, 5.0),
                      blurRadius: 10.0,
                      spreadRadius: 2.0,
                    ),
                  ]),
                  child: Padding(
                    padding: const EdgeInsets.only(
                      top: 20.0,
                      left: 20.0,
                    ),
                    child: QuillEditor.basic(
                        controller: _controller, readOnly: false),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}