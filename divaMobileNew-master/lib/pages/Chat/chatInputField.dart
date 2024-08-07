import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import 'message_bubble.dart';

class ChatInputField extends StatefulWidget {
  final Function(String, MessageType) onSendMessage;

  ChatInputField({required this.onSendMessage});

  @override
  _ChatInputFieldState createState() => _ChatInputFieldState();
}

class _ChatInputFieldState extends State<ChatInputField> {
  final TextEditingController _controller = TextEditingController();
  bool _showEmoji = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                offset: Offset(0, -2),
                blurRadius: 6,
                color: Colors.black.withOpacity(0.08),
              ),
            ],
          ),
          child: SafeArea(
            child: Row(
              children: [
                IconButton(
                  icon: Icon(Icons.mic, color: Colors.blue),
                  onPressed: _handleVoiceInput,
                ),
                SizedBox(width: 8),
                Expanded(
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    height: 48,
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: Row(
                      children: [
                        IconButton(
                          icon: Icon(Icons.sentiment_satisfied_alt_outlined, color: Colors.grey[600]),
                          onPressed: _toggleEmojiPicker,
                        ),
                        Expanded(
                          child: TextField(
                            controller: _controller,
                            decoration: InputDecoration(
                              hintText: "Type a message",
                              border: InputBorder.none,
                              hintStyle: TextStyle(color: Colors.grey[600]),
                            ),
                          ),
                        ),
                        IconButton(
                          icon: Icon(Icons.attach_file, color: Colors.grey[600]),
                          onPressed: _handleFileAttachment,
                        ),
                        IconButton(
                          icon: Icon(Icons.camera_alt_outlined, color: Colors.grey[600]),
                          onPressed: _handleImagePicker,
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(width: 8),
                IconButton(
                  icon: Icon(Icons.send, color: Colors.blue),
                  onPressed: _handleSendMessage,
                ),
              ],
            ),
          ),
        ),
        if (_showEmoji) _buildEmojiPicker(),
      ],
    );
  }

  Widget _buildEmojiPicker() {
    return SizedBox(
      height: 250,
      child: EmojiPicker(
        onEmojiSelected: (category, emoji) {
          setState(() {
            _controller.text += emoji.emoji;
          });
        },
      ),
    );
  }

  void _toggleEmojiPicker() {
    setState(() {
      _showEmoji = !_showEmoji;
    });
  }

  void _handleVoiceInput() {
    _showFeedback("Voice recording not implemented yet");
  }

  void _handleFileAttachment() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles();
      if (result != null) {
        widget.onSendMessage(result.files.single.name, MessageType.file);
        _showFeedback("File selected: ${result.files.single.name}");
      }
    } catch (e) {
      _showFeedback("Error picking file: $e");
    }
  }

  void _handleImagePicker() async {
    try {
      final ImagePicker _picker = ImagePicker();
      final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        widget.onSendMessage(image.path, MessageType.image);
        _showFeedback("Image selected: ${image.path}");
      }
    } catch (e) {
      _showFeedback("Error picking image: $e");
    }
  }

  void _handleSendMessage() {
    if (_controller.text.isNotEmpty) {
      widget.onSendMessage(_controller.text, MessageType.text);
      _controller.clear();
    }
  }

  void _showFeedback(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }
}
