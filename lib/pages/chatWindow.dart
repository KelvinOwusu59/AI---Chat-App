import 'package:flutter/material.dart';
import 'package:kchat/models/messages.dart';
import 'package:kchat/pages/home.dart';

class ChatWindow extends StatefulWidget {
  List<Messages> chatHistory;
  ChatWindow(this.chatHistory, {super.key});

  @override
  State<ChatWindow> createState() => _ChatWindowState();
}

class _ChatWindowState extends State<ChatWindow> {
  TextEditingController _textEditingController = TextEditingController();

  @override
  void dispose() {
    _textEditingController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // load chat history
  }

  @override
  Widget build(BuildContext context) {
    print(widget.chatHistory);
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 0, right: 0, left: 0),
          child: Container(
            height: MediaQuery.of(context).size.height * 0.8,
            decoration: const BoxDecoration(
              color: Colors.black,
              borderRadius:BorderRadius.only(
                                  bottomLeft: Radius.circular(15),
                                  bottomRight: Radius.circular(15),
              ),),
            child: ListView.builder(
              itemCount: widget.chatHistory
                  .length, // Provide the number of items in your list
              itemBuilder: (BuildContext context, int index) {
                // Replace this with your actual itemBuilder logic
                dynamic message = widget.chatHistory[index];

                return Padding(
                  padding: const EdgeInsets.all(15),
                  child: Row(
                    mainAxisAlignment: message.sender == 'me'
                        ? MainAxisAlignment.end
                        : MainAxisAlignment.start,
                    children: [
                      Flexible(
                        flex: 2,
                        child: Container(
                          decoration: BoxDecoration(
                              color: message.sender == 'me'
                                  ? const Color.fromARGB(255, 152, 200, 240)
                                  : const Color.fromARGB(255, 158, 157, 155),
                              borderRadius: const BorderRadius.only()),
                          child: Padding(
                            padding: const EdgeInsets.all(10),
                            child: Text(message.message),
                          ),
                        ),
                      )
                    ],
                  ),
                );
              },
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 10, right: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Container(
                height: MediaQuery.of(context).size.height * 0.05,
                width: MediaQuery.of(context).size.width * 0.8,
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 173, 197, 221),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: TextField(
                      controller: _textEditingController,
                      onSubmitted: (value) {
                        setState(() {
                          widget.chatHistory
                              .add(Messages(message: value, sender: 'me'));
                          _textEditingController.clear();
                        });
                      },
                      decoration: const InputDecoration(
                        hintText: 'Type your message...',
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ),
              ),
              InkWell(
                onTap: () {},
                child: Container(
                  height: MediaQuery.of(context).size.height * 0.06,
                  width: MediaQuery.of(context).size.width * 0.1,
                  decoration:
                      BoxDecoration(borderRadius: BorderRadius.circular(10)),
                  child: const Icon(
                    Icons.send_rounded,
                    color: Color.fromARGB(255, 45, 73, 102),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(
          height: 10,
        )
      ],
    );
  }
}


