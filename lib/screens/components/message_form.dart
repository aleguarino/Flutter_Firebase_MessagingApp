import 'package:flutter/material.dart';

class MessageForm extends StatefulWidget {
  final ValueChanged<String> onSubmit;

  const MessageForm({
    Key key,
    @required this.onSubmit,
  }) : super(key: key);
  @override
  _MessageFormState createState() => _MessageFormState();
}

class _MessageFormState extends State<MessageForm> {
  final _controller = TextEditingController();
  String _message;

  void _onSend() {
    widget.onSubmit(_message);
    _message = '';
    _controller.clear();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(5),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Expanded(
            child: TextField(
              controller: _controller,
              decoration: InputDecoration(
                hintText: 'Type a message',
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.all(10),
              ),
              minLines: 1,
              maxLines: 5,
              onChanged: (value) => setState(() => _message = value),
            ),
          ),
          SizedBox(width: 5),
          RawMaterialButton(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5),
            ),
            onPressed:
                _message == null || _message.trim().isEmpty ? null : _onSend,
            fillColor: _message == null || _message.trim().isEmpty
                ? Colors.blueGrey
                : Theme.of(context).primaryColor,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                'SEND',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
