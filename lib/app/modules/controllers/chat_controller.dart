import 'package:get/get.dart';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class ChatController extends GetxController {
  final WebSocketChannel channel = IOWebSocketChannel.connect('ws://your-websocket-url');
  var messages = <Map<String, dynamic>>[].obs;

  @override
  void onInit() {
    super.onInit();
    channel.stream.listen((message) {
      messages.add({'text': message, 'isMe': false, 'sender': 'User', 'time': '12:00 PM', 'avatar': 'https://cdn-icons-png.flaticon.com/512/219/219988.png'});
    });

    // Dummy messages
    messages.addAll([
      {'text': 'Hey! How have you been?', 'isMe': false, 'sender': 'Jenny', 'time': '12:15 PM', 'avatar': 'https://cdn-icons-png.flaticon.com/512/219/219988.png'},
      {'text': 'Wanna catch up for a beer?', 'isMe': false, 'sender': 'Jenny', 'time': '12:15 PM', 'avatar': 'https://cdn-icons-png.flaticon.com/512/219/219988.png'},
      {'text': 'Awesome! Let’s meet up', 'isMe': true, 'sender': 'Me', 'time': '12:18 PM', 'avatar': 'https://cdn-icons-png.flaticon.com/512/219/219988.png'},
      {'text': 'Can I also get my cousin along? Will that be okay?', 'isMe': true, 'sender': 'Me', 'time': '12:19 PM', 'avatar': 'https://cdn-icons-png.flaticon.com/512/219/219988.png'},
      {'text': 'Yeah sure! get him too.', 'isMe': false, 'sender': 'Esther', 'time': '12:22 PM', 'avatar': 'https://cdn-icons-png.flaticon.com/512/219/219988.png'},
      {'text': 'Alright! See you soon!', 'isMe': true, 'sender': 'Me', 'time': '12:25 PM', 'avatar': 'https://cdn-icons-png.flaticon.com/512/219/219988.png'},
    ]);
  }

  void sendMessage(String text) {
    if (text.isNotEmpty) {
      messages.add({'text': text, 'isMe': true, 'sender': 'Me', 'time': 'Now', 'avatar': 'https://cdn-icons-png.flaticon.com/512/219/219988.png'});
      channel.sink.add(text);
    }
  }

  @override
  void onClose() {
    channel.sink.close();
    super.onClose();
  }
}
