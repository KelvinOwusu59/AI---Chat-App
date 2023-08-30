import 'package:flutter/material.dart';
import 'package:kchat/models/chatselect.dart';
import 'package:kchat/models/messages.dart';
import 'package:kchat/models/user.dart';
import 'package:kchat/pages/chatWindow.dart';
import 'package:kchat/pages/newChatScreen.dart';
import 'package:kchat/services/api.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  ChatSelectFunction chatselect = ChatSelectFunction(
      title: 'Create a new chat', chatHistory: []); // Store the chat_id here

  dynamic data_from_api = {};

  // Callback function to update chatId
  void updateChatId(ChatSelectFunction chatselects) {
    setState(() {
      chatselect = chatselects;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
     getData();
  }

  void getData() async {
    Future<Map<String, dynamic>> response = ApiService.get('user/20');
    response.then((value) {
      List chat_to_list = [];
      setState(() {
        // user ,model
        User user = User(
          user_id: value['user_id'],
          firstName: value['firstname'],
          lastName: value['lastname'],
          openAiApi: value['api_key'],
        );
        // create chatmodel
        for (var element in value['chathistory_set']) {
          String chat_id = element['chat_id'];
          String date = element['date'];
          String chat_name = element['chat_name'];
          String filename = element['filename'];
          List<Messages> messages = [];
          for (var element2 in element['messages_set']) {
            Messages message = Messages(
                message: element2['message'], sender: element2['sender']);
          messages.add(message);
          }
          ChatSelectFunction chathistory = ChatSelectFunction(title: chat_name, chatHistory: messages);
        chat_to_list.add(chathistory);
        }
        // chat_history model
        // print(chat_to_list);
        // ChatSelectFunction chatHistory = ChatSelectFunction(
        //     title: value['chathistory_set']['chat_name'],
        //     chatHistory: value['chathistory_set']['messages_set']);

        data_from_api = {'user': user, 'chatHistory': chat_to_list};
      });
    });
  }

  @override
  Widget build(BuildContext context) {
   
    print(chatselect.chatHistory);
    // print(data_from_api);
    main_drawer drawer =
        main_drawer(updateChatId: updateChatId, data: data_from_api);
    final titleWidgetNewchat = Text(chatselect.title);

    final titleWidgetOldChat =
        Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
      Text(chatselect.title),
      IconButton(onPressed: () {}, icon: const Icon(Icons.add))
    ]);

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: chatselect.title == 'Create a new chat'
            ? titleWidgetNewchat
            : titleWidgetOldChat, // Display chatId in the AppBar
        backgroundColor: const Color.fromARGB(255, 27, 69, 88),
      ),
      drawer: drawer,
      body: chatselect.title == 'Create a new chat'
          ? NewChatUpload()
          : ChatWindow(chatselect.chatHistory),
      backgroundColor: const Color.fromARGB(255, 89, 120, 150),
    );
  }
}

class main_drawer extends StatefulWidget {
  final Function(ChatSelectFunction) updateChatId; // Callback function
  dynamic data;

  main_drawer({Key? key, required this.updateChatId, required this.data})
      : super(key: key);

  @override
  State<main_drawer> createState() => _main_drawerState();
}

// ignore: camel_case_types
class _main_drawerState extends State<main_drawer> {
  ChatSelectFunction chatSelectFunction =
      ChatSelectFunction(title: '', chatHistory: []);

  @override
  Widget build(BuildContext context) {
    print(widget.data);
    TextStyle _style1 = const TextStyle(color: Colors.white, fontSize: 14);
    return Drawer(
      backgroundColor: Color.fromARGB(255, 4, 14, 19),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          ListTile(
            title: Text(
              'Chat History',
              style: _style1,
            ),
          ),
          const Divider(),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.55,
            child: ListView.builder(
              itemCount: widget.data['chatHistory'].length,
              itemBuilder: (BuildContext context, int index) {
                return ListTile(
                  title: Text(
                   widget.data['chatHistory'][index].title,
                    style: _style1,
                  ),
                  onTap: () {
                    setState(() {
                      chatSelectFunction.title = widget.data['chatHistory'][index].title;
                      chatSelectFunction.chatHistory = widget.data['chatHistory'][index].chatHistory;
                    });

                    widget.updateChatId(
                        chatSelectFunction); // Notify parent widget
                    Navigator.pop(context);
                  },
                );
              },
            ),
          ),
          Container(
            // height: MediaQuery.of(context).size.height * 0.5,
            color: Color.fromARGB(255, 12, 20, 24),
            child: Column(children: [
              ListTile(
                onTap: () {},
                title: Text(
                  'Create a new chat',
                  style: _style1,
                ),
                trailing: const Icon(Icons.add_box_rounded),
              ),
              const Divider(),
              ListTile(
                onTap: () {},
                leading: const Icon(Icons.person),
                title: Text(
                  widget.data['user'].firstName,
                  style: _style1,
                ),
              ),
              const Divider(),
              ListTile(
                onTap: () {},
                leading: Icon(Icons.api_sharp),
                title: Text(
                  'Enter your open ai api key',
                  style: _style1,
                ),
              ),
              Divider(),
              // ... (other ListTile items)
              ListTile(
                onTap: () {},
                title: Text(
                  'logout',
                  style: _style1,
                ),
              )
            ]),
          ),
        ],
      ),
    );
  }
}
